import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../profile/user.dart';
import '../storage/storage.dart';

class Authentication {
  const Authentication({required this.url});
  final String url;

  Future<AuthenticationResponse> authenticate() async {
    final publicKeyPath = join(Storage().credentials.path, 'master.pub');
    final publicKey = File(publicKeyPath);
    if (!publicKey.existsSync()) {
      return const AuthenticationResponse(error: "missing master key");
    }

    final dio = Dio();
    try {
      final response = await dio.post(
          url, data: {"public_key": publicKey.readAsStringSync()});
      if (response.statusCode != null && response.statusCode! > 299) {
        return const AuthenticationResponse(
            error: 'There was an error with the requested server. Please try again.');
      }
      Map<String, dynamic> data = response.data ?? {};
      return AuthenticationResponse(
          error: data['error'], user: User.fromMap(data['user']));
    } catch (_) {
      return const AuthenticationResponse(
          error: 'There was an error with the requested server. Please try again.');
    }
  }
}

class AuthenticationResponse {
  const AuthenticationResponse({this.error, this.user});
  final String? error;
  final User? user;
}

