// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus_sdk/helpers/extensions/peer_extensions.dart';

class ParticipantSFU extends Equatable {
  final RTCPeerConnection peerConnection;
  RTCVideoRenderer? renderer;
  bool isVideoEnabled;
  bool isAudioEnabled;
  bool isSharingScreen;
  bool hasFirstFrameRendered;
  bool isE2eeEnabled;
  final WebRTCCodec videoCodec;
  final Function() onChanged;
  ParticipantSFU({
    this.isVideoEnabled = true,
    this.isAudioEnabled = true,
    this.isSharingScreen = false,
    this.hasFirstFrameRendered = false,
    this.isE2eeEnabled = false,
    this.renderer,
    required this.peerConnection,
    required this.onChanged,
    required this.videoCodec,
    bool enableStats = false,
  }) {
    _initialRenderer();

    if (enableStats) {
      peerConnection.statistics();
    }
  }

  ParticipantSFU copyWith({
    String? participantId,
    bool? isAudioEnabled,
    bool? isVideoEnabled,
    bool? isSharingScreen,
    bool? isE2eeEnabled,
    RTCPeerConnection? peerConnection,
    RTCVideoRenderer? renderer,
    WebRTCCodec? videoCodec,
  }) {
    return ParticipantSFU(
      isVideoEnabled: isAudioEnabled ?? this.isVideoEnabled,
      isAudioEnabled: isVideoEnabled ?? this.isAudioEnabled,
      isSharingScreen: isSharingScreen ?? this.isSharingScreen,
      peerConnection: peerConnection ?? this.peerConnection,
      renderer: renderer ?? this.renderer,
      onChanged: onChanged,
      videoCodec: videoCodec ?? this.videoCodec,
      isE2eeEnabled: isE2eeEnabled ?? this.isE2eeEnabled,
    );
  }

  @override
  String toString() {
    return 'ParticipantSFU(isMicEnabled: $isVideoEnabled, isCamEnabled: $isAudioEnabled, isSharingScreen: $isSharingScreen, peerConnection: $peerConnection, renderer: $renderer)';
  }

  @override
  bool operator ==(covariant ParticipantSFU other) {
    if (identical(this, other)) return true;

    return other.isVideoEnabled == isVideoEnabled &&
        other.isAudioEnabled == isAudioEnabled &&
        other.isSharingScreen == isSharingScreen &&
        other.peerConnection == peerConnection &&
        other.hasFirstFrameRendered == hasFirstFrameRendered &&
        other.renderer == renderer;
  }

  @override
  int get hashCode {
    return isVideoEnabled.hashCode ^
        isAudioEnabled.hashCode ^
        isSharingScreen.hashCode ^
        hasFirstFrameRendered.hashCode ^
        peerConnection.hashCode ^
        renderer.hashCode;
  }

  @override
  List<Object> get props {
    return [
      isVideoEnabled,
      isAudioEnabled,
      isSharingScreen,
      hasFirstFrameRendered,
      onChanged,
    ];
  }
}

extension ParticipantSFUX on ParticipantSFU {
  Future<void> dispose() async {
    renderer?.dispose();
    peerConnection.close();
  }

  Future<void> addCandidate(RTCIceCandidate candidate) async {
    await peerConnection.addCandidate(candidate);
  }

  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    await peerConnection.setRemoteDescription(description);
  }

  // ignore: use_setters_to_change_properties
  void setSrcObject(MediaStream stream) {
    renderer?.srcObject = stream;
  }

  Future<void> _initialRenderer() async {
    if (renderer != null) return;

    renderer = RTCVideoRenderer();
    await renderer?.initialize();

    renderer?.onFirstFrameRendered = () {
      hasFirstFrameRendered = true;

      onChanged.call();
    };
  }
}
