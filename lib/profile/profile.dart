import 'package:BeraPAR/constants.dart';
import 'package:flutter/material.dart';
import 'package:BeraPAR/auth/login_page.dart';
import 'package:BeraPAR/custom_toast_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final storage = new FlutterSecureStorage();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String token;
  int userId;

  TextEditingController _nomeController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  ButtonState _updateUserInformationButtonState = ButtonState.idle;

  TextEditingController _senhaAtualController = new TextEditingController();
  TextEditingController _novaSenhaController = new TextEditingController();
  TextEditingController _confirmarNovaSenhaController =
      new TextEditingController();

  void _logout() async {
    // await storage.deleteAll();
    final SharedPreferences prefs = await _prefs;
    prefs.remove('token');
    prefs.remove('userId');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void resetUpdateUserInformationButtonState() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    setState(() {
      _updateUserInformationButtonState = ButtonState.idle;
    });
  }

  void _updateUserInformation() {
    setState(() {
      _updateUserInformationButtonState = ButtonState.loading;
    });

    http.patch(
        'https://apipar.manna.team/api/Usuarios/$userId?access_token=$token',
        body: {
          'nome': _nomeController.text,
        }).then((response) async {
      if (response.statusCode == 200) {
        setState(() {
          _updateUserInformationButtonState = ButtonState.success;
        });
        resetUpdateUserInformationButtonState();
        var jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse != null) {
          print("RESPONSE $jsonResponse");
          final SharedPreferences prefs = await _prefs;
          prefs.setString('nome', jsonResponse['nome']);
        } else {
          print("HOUVE UM ERRO - 1");
        }
      } else {
        var errorMessage = json.decode(response.body)['error']['message'];
        print(errorMessage);
        // ?? esse showToastWidgetDefault que vai exibir o popup de erro
        showToastWidgetDefault(
            BannerToastWidget.fail(msg: errorMessage), context);
        setState(() {
          _updateUserInformationButtonState = ButtonState.fail;
        });
        resetUpdateUserInformationButtonState();
      }
    });
  }

  void _changePassword() {
    print(token);
    if (_senhaAtualController.text == "") {
      showToastWidgetDefault(
          BannerToastWidget.fail(
            msg: "Informe a senha atual",
          ),
          context);
    } else if (_novaSenhaController.text ==
        _confirmarNovaSenhaController.text) {
      http.post(
          'https://apipar.manna.team/api/Usuarios/change-password?access_token=$token',
          body: {
            'oldPassword': _senhaAtualController.text,
            'newPassword': _novaSenhaController.text
          }).then((response) {
        print(response.statusCode);
        if (response.statusCode == 200 || response.statusCode == 204) {
          // Se chegou at?? aqui ent??o deu tudo certo na nossa requisi????o
          // Mas como ?? uma altera????o de senha, ?? preciso chamar um logout
          // N??O PRECISA COPIAR O C??DIGO DO LOGOUT, ?? S?? CHAMAR A FUN????O
          _logout();
        } else {
          var errorMessage = json.decode(response.body)['error']['message'];
          print(errorMessage);
          showToastWidgetDefault(
              BannerToastWidget.fail(
                msg: errorMessage,
              ),
              context);
        }
      });
    } else {
      print('Erro!, senhas diferentes');
      showToastWidgetDefault(
          BannerToastWidget.fail(
              msg: "Nova senha e Confirmar nova senha n??o s??o iguais"),
          context);
    }
    // N??o esquece de come??ar j?? associando essa fun????o ?? a????o do bot??o de mudar senha

    // primeiro precisa verificar se a senha nova e a confirma????o da senha nova s??o iguais

    // se elas forem iguais, vamos ent??o atualizar. Pra isso precisa usar o m??todo
    // POST /Usuarios/change-password
    // Eu deixei o body dele vazio, mas se voc?? entrar no apipar.manna.team/explorer
    // e procurar pelo POST /Usuarios/change-password vai ver que precisa passar 2 par??metros no body
  }

  void initializeValues() async {
    final SharedPreferences prefs = await _prefs;
    String _token = prefs.getString('token');
    int _userId = prefs.getInt('userId');
    String _nome = prefs.getString('nome');
    String _email = prefs.getString('email');
    setState(() {
      token = _token;
      userId = _userId;
    });
    _nomeController.text = _nome;
    _emailController.text = _email;
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initializeValues());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.all(20),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Informa????es do usu??rio",
            style: Theme.of(context).textTheme.headline6,
          ),
          TextFormField(
            controller: _nomeController,
            decoration: InputDecoration(labelText: 'Nome: '),
          ),
          TextFormField(
            readOnly: true,
            controller: _emailController,
            decoration: InputDecoration(labelText: 'E-mail: '),
          ),
          //   FlatButton(
          //       onPressed: _updateUserInformation,
          //       child: Text('Salvar altera????es')),
          Container(
            padding: EdgeInsets.only(top: 5),
            alignment: Alignment.bottomRight,
            child: ProgressButton.icon(
                iconedButtons: {
                  ButtonState.idle: IconedButton(
                      text: "Salvar Altera????es",
                      icon: Icon(Icons.save, color: Colors.white),
                      color: kPrimaryLightColor),
                  ButtonState.loading: IconedButton(
                      text: "Salvando...", color: kPrimaryLightColor),
                  ButtonState.fail: IconedButton(
                      text: "Erro",
                      icon: Icon(Icons.cancel, color: Colors.white),
                      color: Colors.red.shade300),
                  ButtonState.success: IconedButton(
                      text: "Altera????es Salvas!",
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      color: Colors.green.shade400)
                },
                onPressed: _updateUserInformation,
                state: _updateUserInformationButtonState),
          ),

          Container(
            padding: EdgeInsets.all(20),
          ),
          Text(
            "Altera????o de senha",
            style: Theme.of(context).textTheme.headline6,
          ),
          TextFormField(
            controller: _senhaAtualController,
            decoration: InputDecoration(labelText: 'Senha atual: '),
            obscureText: true,
          ),
          TextFormField(
            controller: _novaSenhaController,
            decoration: InputDecoration(labelText: 'Nova senha: '),
            obscureText: true,
          ),
          TextFormField(
            controller: _confirmarNovaSenhaController,
            decoration: InputDecoration(labelText: 'Confirmar nova senha: '),
            obscureText: true,
          ),
          FlatButton(
              onPressed: _changePassword, child: Text('Atualizar senha')),
          FlatButton(
            onPressed: _logout,
            child: Text('Sair (logout)'),
            padding: EdgeInsets.only(top: 30),
          )
        ],
      )),
    ));
  }
}
