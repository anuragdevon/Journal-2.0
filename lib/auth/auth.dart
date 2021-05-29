import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './login.dart';
import './profile.dart';

final FlutterAppAuth appAuth = FlutterAppAuth(); // 1
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

late String? name;
late String? picture;
late String? email;
// username = name;
// email = emailID;

/// -----------------------------------
///           Auth0 Variables
/// -----------------------------------
const AUTH0_DOMAIN = 'noobcoders.us.auth0.com';
const AUTH0_CLIENT_ID = 'VBYcnOPMY6pnZ4celMG2EVYd58Vsl8HD';

const AUTH0_REDIRECT_URI = 'com.example.journal://login-callback';
const AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

class JournalApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<JournalApp> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String? errorMessage;
  // late String? name;
  // late String? picture;
  // late String? email;

  @override
  Widget build(BuildContext context) {
    print('auth');
    return Scaffold(
      body: Center(
        child: isBusy
            ? CircularProgressIndicator()
            : isLoggedIn
                ? Profile(logoutAction, name, picture, email)
                : Login(loginAction, errorMessage),
      ),
    );
  }

  Map<String, dynamic>? parseIdToken(String? idToken) {
    if (idToken != null) {
      final parts = idToken.split(r'.');
      assert(parts.length == 3);

      return jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    }
  }

  Future<Map?> getUserDetails(String? accessToken) async {
    if (accessToken != null) {
      final url = Uri.parse('https://$AUTH0_DOMAIN/userinfo');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      print(response);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get user details');
      }
    }
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI,
            issuer: 'https://$AUTH0_DOMAIN',
            scopes: ['openid', 'profile', 'offline_access', 'email'],
            promptValues: ['login']),
      );

      if (result != null) {
        final idToken = parseIdToken(result.idToken);
        final profile = await getUserDetails(result.accessToken);

        await secureStorage.write(
            key: 'refresh_token', value: result.refreshToken);

        if (idToken != null && profile != null) {
          setState(() {
            isBusy = false;
            isLoggedIn = true;
            name = idToken['name'];
            picture = profile['picture'];
            email = profile['email'];
          });
          // JournalDataState.syncUserData();
        }
      }
    } catch (e, _) {
      // print('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }

  void logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  @override
  void initState() {
    initAction();
    super.initState();
  }

  void initAction() async {
    final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    setState(() {
      isBusy = true;
    });

    try {
      final response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      if (response != null) {
        final idToken = parseIdToken(response.idToken);
        final profile = await getUserDetails(response.accessToken);

        secureStorage.write(key: 'refresh_token', value: response.refreshToken);

        if (idToken != null && profile != null) {
          setState(() {
            isBusy = false;
            isLoggedIn = true;
            name = idToken['name'];
            picture = profile['picture'];
            email = idToken['email'];
          });
        }
      }
    } catch (e, _) {
      // print('error on refresh token: $e - stack: $s');
      {
        logoutAction();
      }
    }
  }
}
