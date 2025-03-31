import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthManager {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<dynamic> signInWithGoogle() async {
    try {
      print("🔍 Google 로그인 시작");

      final String webClientId =
          kDebugMode
              ? ''
              : 'WEB_CLIENT_ID_RELEASE';

      final String iosClientId =
          kDebugMode
              ? ''
              : 'IOS_CLIENT_ID_RELEASE';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: Platform.isIOS ? iosClientId : null,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("사용자가 로그인 취소함");
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        throw Exception("Google 로그인 토큰이 없습니다.");
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      print("Google 로그인 성공: ${response.user?.id}");
      return response.user;
    } catch (error) {
      print("❌ Google 로그인 오류: $error");
      rethrow;
    }
  }

  Future<dynamic> signInWithApple() async {
    try {
      print("Apple 로그인 시작");

      final rawNonce = _supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      if (credential.identityToken == null) {
        throw Exception("Apple ID 토큰이 없습니다.");
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: credential.identityToken!,
        nonce: rawNonce,
      );

      print("✅ Apple 로그인 성공: ${response.user?.id}");
      return response.user;
    } catch (error) {
      print("❌ Apple 로그인 오류: $error");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      print("👋 로그아웃 성공");
    } catch (error) {
      print("❌ 로그아웃 오류: $error");
      rethrow;
    }
  }
}
