// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:waterbus/flutter_waterbus_sdk.dart';

abstract class WaterbusWebRTCManager {
  Future<void> prepareMedia();
  Future<void> joinRoom({required String roomId, required int participantId});
  Future<void> subscribe(List<String> targetIds);
  Future<void> setPublisherRemoteSdp(String sdp);
  Future<void> setSubscriberRemoteSdp(
    String targetId,
    String sdp,
    bool videoEnabled,
    bool audioEnabled,
  );
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
  Future<void> toggleAudio();
  Future<void> toggleVideo();
  void setVideoEnabled({required String targetId, required bool isEnabled});
  void setAudioEnabled({required String targetId, required bool isEnabled});

  CallState callState();
  Stream<CallbackPayload> get notifyChanged;
}
