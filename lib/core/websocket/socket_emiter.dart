import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:waterbus_sdk/constants/socket_events.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_emiter_interface.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';

@Injectable(as: SocketEmiter)
class SocketEmiterImpl extends SocketEmiter {
  // MARK: emit functions
  @override
  void establishBroadcast({
    required String sdp,
    required String roomId,
    required String participantId,
    required ParticipantSFU participant,
  }) {
    _socket?.emit(SocketEvent.publishCSS, {
      "roomId": roomId,
      "sdp": sdp,
      "participantId": participantId,
      "isVideoEnabled": participant.isVideoEnabled,
      "isAudioEnabled": participant.isAudioEnabled,
      "isE2eeEnabled": participant.isE2eeEnabled,
    });
  }

  @override
  void leaveRoom(String roomId) {
    _socket?.emit(SocketEvent.sendLeaveRoomCSS, {"roomId": roomId});
  }

  @override
  void sendBroadcastCandidate(RTCIceCandidate candidate) {
    _socket?.emit(
      SocketEvent.publisherCandidateCSS,
      candidate.toMap(),
    );
  }

  @override
  void sendReceiverCandidate({
    required RTCIceCandidate candidate,
    required targetId,
  }) {
    _socket?.emit(SocketEvent.subscriberCandidateCSS, {
      'targetId': targetId,
      'candidate': candidate.toMap(),
    });
  }

  @override
  void answerEstablishSubscriber({
    required String targetId,
    required String sdp,
  }) {
    _socket?.emit(SocketEvent.answerSubscriberCSS, {
      "targetId": targetId,
      "sdp": sdp,
    });
  }

  @override
  void requestEstablishSubscriber({
    required String roomId,
    required String participantId,
    required String targetId,
  }) {
    _socket?.emit(SocketEvent.subscribeCSS, {
      "roomId": roomId,
      "targetId": targetId,
      "participantId": participantId,
    });
  }

  @override
  void setE2eeEnabled(bool isEnabled) {
    _socket?.emit(SocketEvent.setE2eeEnabledCSS, {'isEnabled': isEnabled});
  }

  @override
  void setAudioEnabled(bool isEnabled) {
    _socket?.emit(SocketEvent.setAudioEnabledCSS, {'isEnabled': isEnabled});
  }

  @override
  void setVideoEnabled(bool isEnabled) {
    _socket?.emit(SocketEvent.setVideoEnabledCSS, {'isEnabled': isEnabled});
  }

  @override
  void setCameraType(CameraType cameraType) {
    _socket?.emit(SocketEvent.setCameraTypeCSS, {'type': cameraType.type});
  }

  @override
  void setScreenSharing(bool isSharing) {
    _socket?.emit(SocketEvent.setScreenSharingCSS, {'isSharing': isSharing});
  }

  @override
  void sendNewSdp(String sdp) {
    _socket?.emit(SocketEvent.publisherRenegotiationCSS, {'sdp': sdp});
  }

  Socket? get _socket => getIt<SocketHandler>().socket;
}
