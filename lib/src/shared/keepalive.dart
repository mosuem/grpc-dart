import 'dart:async';

import 'package:clock/clock.dart';
import 'package:http2/http2.dart';

class KeepAliveOptions {
  final int? _keepaliveTimeMs;
  final int _keepaliveTimeoutMs;
  final bool keepalivePermitWithoutCalls;
  final int _http2MaxPingsWithoutData;
  final int? _http2MinRecvPingIntervalWithoutDataMs;
  final int? _http2MaxPingStrikes;

  Duration? get keepaliveTime => _keepaliveTimeMs != null
      ? Duration(milliseconds: _keepaliveTimeMs!)
      : null;

  Duration get keepaliveTimeout => Duration(milliseconds: _keepaliveTimeoutMs);

  const KeepAliveOptions._({
    int? keepaliveTimeMs,
    int keepaliveTimeoutMs = 20000,
    this.keepalivePermitWithoutCalls = false,
    int http2MaxPingsWithoutData = 2,
    int? http2MinRecvPingIntervalWithoutDataMs,
    int? http2MaxPingStrikes,
  })  : _http2MaxPingStrikes = http2MaxPingStrikes,
        _http2MinRecvPingIntervalWithoutDataMs =
            http2MinRecvPingIntervalWithoutDataMs,
        _http2MaxPingsWithoutData = http2MaxPingsWithoutData,
        _keepaliveTimeoutMs = keepaliveTimeoutMs,
        _keepaliveTimeMs = keepaliveTimeMs != null
            ? (keepaliveTimeMs < 10 ? 10 : keepaliveTimeMs)
            : null;

  const KeepAliveOptions.client({
    int? keepaliveTimeMs,
    int keepaliveTimeoutMs = 20000,
    bool keepalivePermitWithoutCalls = false,
    int http2MaxPingsWithoutData = 2,
    int? http2MinRecvPingIntervalWithoutDataMs,
    int? http2MaxPingStrikes,
  }) : this._(
          keepaliveTimeMs: keepaliveTimeMs,
          keepaliveTimeoutMs: keepaliveTimeoutMs,
          keepalivePermitWithoutCalls: keepalivePermitWithoutCalls,
          http2MaxPingsWithoutData: http2MaxPingsWithoutData,
          http2MinRecvPingIntervalWithoutDataMs:
              http2MinRecvPingIntervalWithoutDataMs,
          http2MaxPingStrikes: http2MaxPingStrikes,
        );

  const KeepAliveOptions.server({
    int? keepaliveTimeMs = 7200000,
    int keepaliveTimeoutMs = 20000,
    bool keepalivePermitWithoutCalls = false,
    int http2MaxPingsWithoutData = 2,
    int? http2MinRecvPingIntervalWithoutDataMs = 300000,
    int? http2MaxPingStrikes = 2,
  }) : this._(
          keepaliveTimeMs: keepaliveTimeMs,
          keepaliveTimeoutMs: keepaliveTimeoutMs,
          keepalivePermitWithoutCalls: keepalivePermitWithoutCalls,
          http2MaxPingsWithoutData: http2MaxPingsWithoutData,
          http2MinRecvPingIntervalWithoutDataMs:
              http2MinRecvPingIntervalWithoutDataMs,
          http2MaxPingStrikes: http2MaxPingStrikes,
        );

  bool get sendPings => keepaliveTime != null;
}

enum KeepAliveState {
  /// Transport has no active rpcs. We don't need to do any keepalives.
  idle,

  /// We have scheduled a ping to be sent in the future. We may decide to delay
  /// it if we receive some data.
  pingScheduled,

  /// We need to delay the scheduled keepalive ping.
  pingDelayed,

  /// The ping has been sent out. Waiting for a ping response.
  pingSent,

  /// Transport goes idle after ping has been sent.
  idleAndPingSent,

  /// The transport has been disconnected. We won't do keepalives any more.
  disconnected;
}

class KeepAliveManager {
  KeepAliveState _state;

  final KeepAliveOptions _options;

  final Stopwatch _stopwatch;

  Timer? shutdownFuture;
  Timer? pingFuture;

  bool get _keepAliveDuringTransportIdle =>
      _options.keepalivePermitWithoutCalls;

  Duration get _keepAliveTime => _options.keepaliveTime!;
  final void Function() onPingTimeout;
  final void Function() ping;

  KeepAliveManager({
    required KeepAliveOptions options,
    required this.ping,
    required this.onPingTimeout,
  })  : _options = options,
        _stopwatch = clock.stopwatch()..start(),
        _state = KeepAliveState.idle;

  void onTransportStarted() {
    if (_keepAliveDuringTransportIdle) {
      onTransportActive();
    }
  }

  void onDataReceived() {
    _stopwatch.reset();
    _stopwatch.start();
    // We do not cancel the ping future here. This avoids constantly scheduling and cancellation in
    // a busy transport. Instead, we update the status here and reschedule later. So we actually
    // keep one sendPing task always in flight when there're active rpcs.
    if (_state == KeepAliveState.pingScheduled) {
      _state = KeepAliveState.pingDelayed;
    } else if (_state == KeepAliveState.pingSent ||
        _state == KeepAliveState.idleAndPingSent) {
      // Ping acked or effectively ping acked. Cancel shutdown, and then if not idle,
      // schedule a new keep-alive ping.
      shutdownFuture?.cancel();
      if (_state == KeepAliveState.idleAndPingSent) {
        // not to schedule new pings until onTransportActive
        _state = KeepAliveState.idle;
        return;
      }
      // schedule a new ping
      _state = KeepAliveState.pingScheduled;
      assert(pingFuture == null);
      pingFuture = Timer(_keepAliveTime, sendPing);
    }
  }

  void shutdown() {
    if (_state != KeepAliveState.disconnected) {
      // We haven't received a ping response within the timeout. The connection is likely gone
      // already. Shutdown the transport and fail all existing rpcs.
      _state = KeepAliveState.disconnected;
      onPingTimeout();
    }
  }

  void sendPing() {
    pingFuture = null;
    if (_state == KeepAliveState.pingScheduled) {
      _state = KeepAliveState.pingSent;
      // Schedule a shutdown. It fires if we don't receive the ping response within the timeout.
      shutdownFuture = Timer(_options.keepaliveTimeout, shutdown);
      ping();
    } else if (_state == KeepAliveState.pingDelayed) {
      // We have received some data. Reschedule the ping with the new time.
      pingFuture = Timer(_keepAliveTime - _stopwatch.elapsed, sendPing);
      _state = KeepAliveState.pingScheduled;
    }
  }

  void onTransportActive() {
    if (_state == KeepAliveState.idle) {
      // When the transport goes active, we do not reset the nextKeepaliveTime. This allows us to
      // quickly check whether the connection is still working.
      _state = KeepAliveState.pingScheduled;
      pingFuture ??= Timer(_keepAliveTime - _stopwatch.elapsed, sendPing);
    } else if (_state == KeepAliveState.idleAndPingSent) {
      _state = KeepAliveState.pingSent;
    } // Other states are possible when keepAliveDuringTransportIdle == true
  }

  void onTransportIdle() {
    if (_keepAliveDuringTransportIdle) {
      return;
    }
    if (_state == KeepAliveState.pingScheduled ||
        _state == KeepAliveState.pingDelayed) {
      _state = KeepAliveState.idle;
    }
    if (_state == KeepAliveState.pingSent) {
      _state = KeepAliveState.idleAndPingSent;
    }
  }

  void onTransportTermination() {
    if (_state != KeepAliveState.disconnected) {
      _state = KeepAliveState.disconnected;
      shutdownFuture?.cancel();
      pingFuture?.cancel();
      pingFuture = null;
    }
  }
}
