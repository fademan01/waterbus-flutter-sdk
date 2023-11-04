// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

abstract class WaterbusWebRTCManager {
  Future<void> joinRoom({required String roomId, required int participantId});
  Future<void> subscribe(List<String> targetIds);
  Future<void> setPublisherRemoteSdp(String sdp);
  Future<void> setSubscriberRemoteSdp({
    required String targetId,
    required String sdp,
    required bool videoEnabled,
    required bool audioEnabled,
    required bool isScreenSharing,
    required bool isE2eeEnabled,
    required WebRTCCodec codec,
  });
  Future<void> addPublisherCandidate(RTCIceCandidate candidate);
  Future<void> addSubscriberCandidate(
    String targetId,
    RTCIceCandidate candidate,
  );
  Future<void> newParticipant(String targetId);
  Future<void> participantHasLeft(String targetId);
  Future<void> dispose();

  // MARK: control
  Future<void> applyCallSettings(CallSetting setting);
  Future<void> prepareMedia();
  Future<void> startScreenSharing();
  Future<void> stopScreenSharing({bool stayInRoom = true});
  Future<void> toggleAudio();
  Future<void> toggleVideo();
  void setE2eeEnabled({required String targetId, required bool isEnabled});
  void setVideoEnabled({required String targetId, required bool isEnabled});
  void setAudioEnabled({required String targetId, required bool isEnabled});
  void setScreenSharing({required String targetId, required bool isSharing});

  CallState callState();
  Stream<CallbackPayload> get notifyChanged;
}
