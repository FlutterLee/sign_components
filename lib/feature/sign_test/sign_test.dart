import 'package:flutter/material.dart';
import 'package:onestep/feature/sign_test/manager.dart';

class SignTestScreen extends StatefulWidget {
  const SignTestScreen({super.key});

  @override
  State<SignTestScreen> createState() => _SignTestScreenState();
}

class _SignTestScreenState extends State<SignTestScreen> {
  final AuthManager _authManager = AuthManager();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authManager.signInWithGoogle();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('구글 로그인 성공: ${user.id}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authManager.signInWithApple();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('애플 로그인 성공: ${user.id}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSignOut() async {
    setState(() => _isLoading = true);
    try {
      await _authManager.signOut();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('로그아웃 성공')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그아웃 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인 테스트')),
      body: Center(
        child:
            _isLoading
                ? const CircularProgressIndicator()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _handleGoogleSignIn,
                      child: const Text('구글 로그인'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _handleAppleSignIn,
                      child: const Text('애플 로그인'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _handleSignOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        '로그아웃',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
