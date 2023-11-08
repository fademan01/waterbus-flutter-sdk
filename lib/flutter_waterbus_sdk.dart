library waterbus_sdk;

// Project imports:
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/interfaces/socket_handler_interface.dart';
import 'package:waterbus_sdk/models/index.dart';
import 'package:waterbus_sdk/sdk_core.dart';
import 'package:waterbus_sdk/services/callkit/callkit_listener.dart';

export './models/index.dart';
export 'package:flutter_webrtc/flutter_webrtc.dart';

class WaterbusSdk {
  static String recordBenchmarkPath = '';
  static String waterbusUrl = '';
  static Function(CallbackPayload)? onEventChanged;

  // ignore: use_setters_to_change_properties
  void onEventChangedRegister(Function(CallbackPayload) onEventChanged) {
    WaterbusSdk.onEventChanged = onEventChanged;
  }

  void initial({
    required String waterbusUrl,
    String recordBenchmarkPath = '',
  }) {
    // Init dependency injection
    configureDependencies();

    WaterbusSdk.waterbusUrl = waterbusUrl;
    WaterbusSdk.recordBenchmarkPath = recordBenchmarkPath;
    _callKitListener.listenerEvents();
    _socketHandler.establishConnection();
  }

  Future<void> joinRoom({
    required String roomId,
    required int participantId,
  }) async {
    await _sdk.joinRoom(
      roomId: roomId,
      participantId: participantId,
    );
  }

  Future<void> leaveRoom() async {
    await _sdk.leaveRoom();
  }

  // Related to local media
  Future<void> prepareMedia() async {
    await _sdk.prepareMedia();
  }

  Future<void> startScreenSharing() async {
    await _sdk.startScreenSharing();
  }

  Future<void> stopScreenSharing() async {
    await _sdk.stopScreenSharing();
  }

  Future<void> toggleVideo() async {
    await _sdk.toggleVideo();
  }

  Future<void> toggleAudio() async {
    await _sdk.toggleAudio();
  }

  Future<void> changeCallSetting(CallSetting setting) async {
    await _sdk.changeCallSettings(setting);
  }

  Future<List<WebRTCCodec>> filterSupportedCodecs() async {
    final List<WebRTCCodec> supportedCodecs = [];

    for (final codec in WebRTCCodec.values) {
      if (await codec.isPlatformSupported()) {
        supportedCodecs.add(codec);
      }
    }

    return supportedCodecs;
  }

  CallState get callState => _sdk.callState;

  // Private
  SdkCore get _sdk => getIt<SdkCore>();
  SocketHandler get _socketHandler => getIt<SocketHandler>();
  CallKitListener get _callKitListener => getIt<CallKitListener>();

  ///Singleton factory
  static final WaterbusSdk instance = WaterbusSdk._internal();

  factory WaterbusSdk() {
    return instance;
  }

  WaterbusSdk._internal();
}
