// Mocks generated by Mockito 5.4.1 from annotations
// in grpc/test/keepalive_test.dart.
// Do not manually edit this file.

// @dart=2.19

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i9;

import 'package:grpc/src/client/call.dart' as _i10;
import 'package:grpc/src/client/connection.dart' as _i7;
import 'package:grpc/src/client/http2_connection.dart' as _i6;
import 'package:grpc/src/client/options.dart' as _i2;
import 'package:grpc/src/client/transport/http2_credentials.dart' as _i3;
import 'package:grpc/src/client/transport/transport.dart' as _i5;
import 'package:grpc/src/shared/keepalive.dart' as _i8;
import 'package:http2/transport.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeChannelOptions_0 extends _i1.SmartFake
    implements _i2.ChannelOptions {
  _FakeChannelOptions_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeChannelCredentials_1 extends _i1.SmartFake
    implements _i3.ChannelCredentials {
  _FakeChannelCredentials_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeClientTransportConnection_2 extends _i1.SmartFake
    implements _i4.ClientTransportConnection {
  _FakeClientTransportConnection_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGrpcTransportStream_3 extends _i1.SmartFake
    implements _i5.GrpcTransportStream {
  _FakeGrpcTransportStream_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Http2ClientConnection].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttp2ClientConnection extends _i1.Mock
    implements _i6.Http2ClientConnection {
  @override
  _i2.ChannelOptions get options => (super.noSuchMethod(
        Invocation.getter(#options),
        returnValue: _FakeChannelOptions_0(
          this,
          Invocation.getter(#options),
        ),
        returnValueForMissingStub: _FakeChannelOptions_0(
          this,
          Invocation.getter(#options),
        ),
      ) as _i2.ChannelOptions);
  @override
  set onStateChanged(void Function(_i7.ConnectionState)? _onStateChanged) =>
      super.noSuchMethod(
        Invocation.setter(
          #onStateChanged,
          _onStateChanged,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set keepAliveManager(_i8.ClientKeepAlive? _keepAliveManager) =>
      super.noSuchMethod(
        Invocation.setter(
          #keepAliveManager,
          _keepAliveManager,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.ChannelCredentials get credentials => (super.noSuchMethod(
        Invocation.getter(#credentials),
        returnValue: _FakeChannelCredentials_1(
          this,
          Invocation.getter(#credentials),
        ),
        returnValueForMissingStub: _FakeChannelCredentials_1(
          this,
          Invocation.getter(#credentials),
        ),
      ) as _i3.ChannelCredentials);
  @override
  String get authority => (super.noSuchMethod(
        Invocation.getter(#authority),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  String get scheme => (super.noSuchMethod(
        Invocation.getter(#scheme),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  _i7.ConnectionState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i7.ConnectionState.connecting,
        returnValueForMissingStub: _i7.ConnectionState.connecting,
      ) as _i7.ConnectionState);
  @override
  _i9.Future<_i4.ClientTransportConnection> connectTransport() =>
      (super.noSuchMethod(
        Invocation.method(
          #connectTransport,
          [],
        ),
        returnValue: _i9.Future<_i4.ClientTransportConnection>.value(
            _FakeClientTransportConnection_2(
          this,
          Invocation.method(
            #connectTransport,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i9.Future<_i4.ClientTransportConnection>.value(
                _FakeClientTransportConnection_2(
          this,
          Invocation.method(
            #connectTransport,
            [],
          ),
        )),
      ) as _i9.Future<_i4.ClientTransportConnection>);
  @override
  void dispatchCall(_i10.ClientCall<dynamic, dynamic>? call) =>
      super.noSuchMethod(
        Invocation.method(
          #dispatchCall,
          [call],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i5.GrpcTransportStream makeRequest(
    String? path,
    Duration? timeout,
    Map<String, String>? metadata,
    _i5.ErrorHandler? onRequestFailure, {
    _i10.CallOptions? callOptions,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #makeRequest,
          [
            path,
            timeout,
            metadata,
            onRequestFailure,
          ],
          {#callOptions: callOptions},
        ),
        returnValue: _FakeGrpcTransportStream_3(
          this,
          Invocation.method(
            #makeRequest,
            [
              path,
              timeout,
              metadata,
              onRequestFailure,
            ],
            {#callOptions: callOptions},
          ),
        ),
        returnValueForMissingStub: _FakeGrpcTransportStream_3(
          this,
          Invocation.method(
            #makeRequest,
            [
              path,
              timeout,
              metadata,
              onRequestFailure,
            ],
            {#callOptions: callOptions},
          ),
        ),
      ) as _i5.GrpcTransportStream);
  @override
  _i9.Future<void> shutdown() => (super.noSuchMethod(
        Invocation.method(
          #shutdown,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> terminate() => (super.noSuchMethod(
        Invocation.method(
          #terminate,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
}
