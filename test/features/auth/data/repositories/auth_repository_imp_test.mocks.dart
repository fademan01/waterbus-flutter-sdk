// Mocks generated by Mockito 5.4.4 from annotations
// in waterbus_sdk/test/features/auth/data/repositories/auth_repository_imp_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes

// Dart imports:
import 'dart:async' as _i4;

// Package imports:
import 'package:mockito/mockito.dart' as _i1;

// Project imports:
import 'package:waterbus_sdk/types/models/auth_payload_model.dart' as _i6;
import 'package:waterbus_sdk/types/models/user_model.dart' as _i5;

import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart'
    as _i2;
import 'package:waterbus_sdk/core/api/auth/datasources/auth_remote_datasource.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [AuthLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthLocalDataSource extends _i1.Mock
    implements _i2.AuthLocalDataSource {
  @override
  void saveTokens({
    required String? accessToken,
    required String? refreshToken,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #saveTokens,
          [],
          {
            #accessToken: accessToken,
            #refreshToken: refreshToken,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  void clearToken() => super.noSuchMethod(
        Invocation.method(
          #clearToken,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [AuthRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthRemoteDataSource extends _i1.Mock
    implements _i3.AuthRemoteDataSource {
  @override
  _i4.Future<(String?, String?)> refreshToken() => (super.noSuchMethod(
        Invocation.method(
          #refreshToken,
          [],
        ),
        returnValue: _i4.Future<(String?, String?)>.value((null, null)),
        returnValueForMissingStub:
            _i4.Future<(String?, String?)>.value((null, null)),
      ) as _i4.Future<(String?, String?)>);

  @override
  _i4.Future<_i5.User?> signInWithSocial(_i6.AuthPayloadModel? authPayload) =>
      (super.noSuchMethod(
        Invocation.method(
          #signInWithSocial,
          [authPayload],
        ),
        returnValue: _i4.Future<_i5.User?>.value(),
        returnValueForMissingStub: _i4.Future<_i5.User?>.value(),
      ) as _i4.Future<_i5.User?>);

  @override
  _i4.Future<bool> logOut() => (super.noSuchMethod(
        Invocation.method(
          #logOut,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}
