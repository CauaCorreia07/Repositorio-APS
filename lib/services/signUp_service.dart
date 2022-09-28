import 'dart:convert';

import '../constants.dart';
import 'package:http/http.dart' as http;

class SignUpService {
  signUp(String name, String email, String password) async {
    http.Response response = await http.post(
      Uri.parse(Routes.signUp),
      body: json.encode(
        {
          "name": name,
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );
    print(response.body);
  }
}
