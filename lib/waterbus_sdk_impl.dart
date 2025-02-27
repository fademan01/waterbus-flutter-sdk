import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:waterbus_sdk/core/api/auth/repositories/auth_repository.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/core/api/meetings/repositories/meeting_repository.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/native/picture-in-picture/index.dart';
import 'package:waterbus_sdk/native/replaykit.dart';
import 'package:waterbus_sdk/types/models/create_meeting_params.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';
import 'package:waterbus_sdk/utils/replaykit/replaykit_helper.dart';
import 'package:waterbus_sdk/waterbus_sdk_interface.dart';

@Singleton(as: WaterbusSdkInterface)
class SdkCore extends WaterbusSdkInterface {
  final SocketHandler _webSocket;
  final WaterbusWebRTCManager _rtcManager;
  final ReplayKitChannel _replayKitChannel;

  final BaseRemoteData _baseRepository;
  final AuthRepository _authRepository;
  final MeetingRepository _meetingRepository;
  final UserRepository _userRepository;
  final WaterbusLogger _logger;
  SdkCore(
    this._webSocket,
    this._rtcManager,
    this._replayKitChannel,
    this._baseRepository,
    this._authRepository,
    this._meetingRepository,
    this._userRepository,
    this._logger,
  );

  @override
  Future<void> initializeApp() async {
    await _baseRepository.initialize();

    _webSocket.establishConnection(forceConnection: true);

    _rtcManager.notifyChanged.listen((event) {
      WaterbusSdk.onEventChanged?.call(event);
    });
  }

  // Meeting
  @override
  Future<Meeting?> createRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _meetingRepository.createMeeting(
      CreateMeetingParams(
        meeting: meeting,
        password: password,
        userId: userId,
      ),
    );
  }

  @override
  Future<Meeting?> joinRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    if (!_webSocket.isConnected) return null;

    late final Meeting? room;

    if (password.isEmpty) {
      room = await _meetingRepository.joinMeetingWithoutPassword(
        CreateMeetingParams(
          meeting: meeting,
          password: password,
          userId: userId,
        ),
      );
    } else {
      room = await _meetingRepository.joinMeetingWithPassword(
        CreateMeetingParams(
          meeting: meeting,
          password: password,
          userId: userId,
        ),
      );
    }

    if (room != null) {
      final int mParticipantIndex = room.participants.lastIndexWhere(
        (participant) => participant.isMe,
      );

      if (mParticipantIndex < 0) return null;

      await _joinRoom(
        roomId: room.code.toString(),
        participantId: room.participants[mParticipantIndex].id,
      );

      final List<String> targetIds = room.participants
          .where((participant) => !participant.isMe)
          .map((participant) => participant.id.toString())
          .toList();

      _subscribe(targetIds);
    }

    return room;
  }

  @override
  Future<Meeting?> updateRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _meetingRepository.updateMeeting(
      CreateMeetingParams(
        meeting: meeting,
        password: password,
        userId: userId,
      ),
    );
  }

  @override
  Future<Meeting?> getRoomInfo(int code) async {
    return await _meetingRepository.getInfoMeeting(code);
  }

  @override
  Future<void> leaveRoom() async {
    try {
      await _rtcManager.dispose();
      WakelockPlus.disable();
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  @override
  Future<void> prepareMedia() async {
    await _rtcManager.prepareMedia();
  }

  @override
  Future<void> changeCallSettings(CallSetting setting) async {
    await _rtcManager.applyCallSettings(setting);
  }

  @override
  Future<void> switchCamera() async {
    await _rtcManager.switchCamera();
  }

  @override
  Future<void> toggleVideo() async {
    await _rtcManager.toggleVideo();
  }

  @override
  Future<void> toggleAudio() async {
    await _rtcManager.toggleAudio();
  }

  @override
  Future<void> toggleSpeakerPhone() async {
    await _rtcManager.toggleSpeakerPhone();
  }

  @override
  Future<void> startScreenSharing({DesktopCapturerSource? source}) async {
    if (WebRTC.platformIsIOS) {
      ReplayKitHelper().openReplayKit();
      _replayKitChannel.startReplayKit();
      _replayKitChannel.listenEvents(_rtcManager);
    } else {
      await _rtcManager.startScreenSharing(source: source);
    }
  }

  @override
  Future<void> stopScreenSharing() async {
    try {
      if (WebRTC.platformIsIOS) {
        ReplayKitHelper().openReplayKit();
      } else {
        await _rtcManager.stopScreenSharing();
      }
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  @override
  Future<void> enableVirtualBackground({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  }) async {
    await _rtcManager.enableVirtualBackground(
      backgroundImage: backgroundImage,
      thresholdConfidence: thresholdConfidence,
    );
  }

  @override
  Future<void> disableVirtualBackground() async {
    await _rtcManager.disableVirtualBackground();
  }

  @override
  Future<void> setPiPEnabled({
    required String textureId,
    bool enabled = true,
  }) async {
    await setPictureInPictureEnabled(textureId: textureId);
  }

  // User

  @override
  Future<User?> getProfile() async {
    return await _userRepository.getUserProfile();
  }

  @override
  Future<User?> updateProfile({required User user}) async {
    return await _userRepository.updateUserProfile(user);
  }

  @override
  Future<bool> updateUsername({
    required String username,
  }) async {
    return await _userRepository.updateUsername(username);
  }

  @override
  Future<bool> checkUsername({
    required String username,
  }) async {
    return await _userRepository.checkUsername(username);
  }

  @override
  Future<String?> getPresignedUrl() async {
    return await _userRepository.getPresignedUrl();
  }

  @override
  Future<String?> uploadAvatar({
    required Uint8List image,
    required String uploadUrl,
  }) async {
    return await _userRepository.uploadImageToS3(
      image: image,
      uploadUrl: uploadUrl,
    );
  }

  // Auth

  @override
  Future<User?> createToken({required AuthPayloadModel payload}) async {
    final User? user = await _authRepository.loginWithSocial(payload);

    if (user != null) {
      _webSocket.establishConnection(forceConnection: true);
    }

    return user;
  }

  @override
  Future<bool> deleteToken() async {
    _webSocket.disconnection();

    return await _authRepository.logOut();
  }

  @override
  Future<bool> refreshToken() async {
    return await _authRepository.refreshToken();
  }

  // MARK: Private
  Future<void> _joinRoom({
    required String roomId,
    required int participantId,
  }) async {
    try {
      WakelockPlus.enable();

      await _rtcManager.joinRoom(
        roomId: roomId,
        participantId: participantId,
      );
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  Future<void> _subscribe(List<String> targetIds) async {
    try {
      _rtcManager.subscribe(targetIds);
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  @override
  CallState get callState => _rtcManager.callState();
}
