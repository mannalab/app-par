import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:BeraPAR/fade_router.dart';
import 'package:BeraPAR/home/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final storage = new FlutterSecureStorage();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> _authUser(LoginData data) {
    print('SignIn -> Name: ${data.name}, Password: ${data.password}');
    return http.post(
        'https://apipar.manna.team/api/Usuarios/login?include=User',
        body: {
          'email': data.name,
          'password': data.password
        }).then((response) async {
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse != null) {
          final SharedPreferences prefs = await _prefs;
          prefs.setString('token', jsonResponse['id']);
          prefs.setString('nome', jsonResponse['user']['nome']);
          prefs.setString('email', jsonResponse['user']['email']);
          prefs.setInt('userId', jsonResponse['userId']);
          // storage.write(key: 'token', value: jsonResponse['id']);
          // storage.write(
          //     key: 'userId', value: jsonResponse['userId'].toString());
          return null;
        } else {
          return "Houve um erro de conexão. Por favor tente novamente em instantes ou entre em contato com o suporte.";
        }
      } else {
        return "Usuário ou senha inválidos";
      }
    });
  }

  Future<String> _createUser(LoginData data) {
    print('Sign Up -> Name: ${data.name}, Password: ${data.password}');
    return http.post('https://apipar.manna.team/api/Usuarios', body: {
      'nome': data.name,
      'email': data.name,
      'password': data.password
    }).then((response) async {
      if (response.statusCode == 200) {
        var login_response = await http.post(
            'https://apipar.manna.team/api/Usuarios/login?include=User',
            body: {'email': data.name, 'password': data.password});
        if (login_response.statusCode == 200) {
          var loginJsonResponse = json.decode(login_response.body);
          print(loginJsonResponse);
          if (loginJsonResponse != null) {
            final SharedPreferences prefs = await _prefs;
            prefs.setString('token', loginJsonResponse['id']);
            prefs.setString('nome', loginJsonResponse['user']['nome']);
            prefs.setString('email', loginJsonResponse['user']['email']);
            prefs.setInt('userId', loginJsonResponse['userId']);
            // storage.write(key: 'token', value: loginJsonResponse['id']);
            // storage.write(
            //     key: 'userId', value: loginJsonResponse['userId'].toString());
            return null;
          } else {
            return "Conta criada com sucesso, mas com erro ao entrar. Tente fazer login em alguns instantes.";
          }
        } else {
          return "Conta criada com sucesso, mas com erro ao entrar. Tente fazer login em alguns instantes.";
        }
      } else {
        var errorMessage = json.decode(response.body)['error']['message'];
        return errorMessage;
      }
    });
  }

  Future<String> _recoverPassword(String email) {
    print('RecoverPassword -> Email: ${email}');
    return http
        .get(
      // 'https://apipar.manna.team/api/Usuarios/login?include=User',
      'https://apipar.manna.team/request-password-reset?email=$email',
    )
        .then((response) async {
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse != null) {
          // final SharedPreferences prefs = await _prefs;
          // prefs.setString('token', jsonResponse['id']);
          // prefs.setString('nome', jsonResponse['user']['nome']);
          // prefs.setString('email', jsonResponse['user']['email']);
          // prefs.setInt('userId', jsonResponse['userId']);
          // storage.write(key: 'token', value: jsonResponse['id']);
          // storage.write(
          //     key: 'userId', value: jsonResponse['userId'].toString());
          return null;
        } else {
          return "Houve um erro de conexão. Por favor tente novamente em instantes ou entre em contato com o suporte.";
        }
      } else {
        return "Usuário ou senha inválidos";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: '',
      logo: 'assets/images/logo.png',
      emailValidator: (value) {
        if (!value.contains('@') || !value.endsWith('.com')) {
          return "Formato de e-mail inválido!";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty || value.length < 6) {
          return 'Sua senha deve conter ao menos 6 caracteres!';
        }
        return null;
      },
      onLogin: _authUser,
      onSignup: _createUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => HomePage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
        usernameHint: 'E-mail',
        passwordHint: 'Senha',
        confirmPasswordHint: 'Repetir senha',
        loginButton: 'Entrar',
        signupButton: 'Nova Conta',
        forgotPasswordButton: 'Esqueci minha senha',
        recoverPasswordButton: 'Recuperar senha',
        goBackButton: 'Voltar',
        confirmPasswordError: 'Senhas não coincidem!',
        recoverPasswordIntro: 'Recupere sua senha',
        recoverPasswordDescription:
            'Enviaremos instruções para o e-mail cadastrado na sua conta',
        recoverPasswordSuccess:
            'Em breve você receberá um e-mail com as instruções de recuperação',
      ),
    );
  }
}
