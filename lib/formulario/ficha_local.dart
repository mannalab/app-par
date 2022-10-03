import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:BeraPAR/custom_toast_widget.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormularioLocalWidget extends StatefulWidget {
  final LatLng lat_long;

  FormularioLocalWidget({Key key, @required this.lat_long}) : super(key: key);

  @override
  _FormularioLocalWidgetState createState() =>
      new _FormularioLocalWidgetState(lat_long);
}

class _FormularioLocalWidgetState extends State<FormularioLocalWidget> {
  LatLng lat_long;
  _FormularioLocalWidgetState(this.lat_long);

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController nome_local = TextEditingController();
  TextEditingController descricao_local = TextEditingController();
  TextEditingController nome_instituicao = TextEditingController();
  String tipo_instituicao = null;

  // Verificar o que mais é obrigatório
  void showErrorMessage() {
    if (nome_local.text == "") {
      showToastWidgetDefault(
          BannerToastWidget.fail(
            msg: "Insira o nome do local",
          ),
          context);
    }
  }

  void _salvarLocalidade() async {
    if (nome_local.text == "") {
      showErrorMessage();
    } else {
      final SharedPreferences prefs = await _prefs;
      var temporary_locals = prefs.containsKey("temporary_locals")
          ? json.decode(prefs.getString("temporary_locals"))
          : [];
      var newLocal = {
        "tmp_id":
            '${prefs.getInt("userId").toString()}${DateTime.now().millisecondsSinceEpoch.toString()}',
        "latitude": lat_long.latitude.toString(),
        "longitude": lat_long.longitude.toString(),
        "nome_local": nome_local.text,
        "descricao_local": descricao_local.text,
        "nome_instituicao": nome_instituicao.text,
        "tipo_instituicao": tipo_instituicao,
      };
      temporary_locals.add(newLocal);
      prefs.setString("temporary_locals", json.encode(temporary_locals));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text("Nova localidade")),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Text("Latitude: ${lat_long.latitude}"),
                Text("Longitude: ${lat_long.longitude}"),
                TextFormField(
                  controller: nome_local,
                  decoration: InputDecoration(labelText: 'Nome do Local: '),
                ),
                TextFormField(
                  controller: descricao_local,
                  decoration: InputDecoration(labelText: 'Descrição:'),
                ),
                // Container(padding: EdgeInsets.only(top: 10)),
                // Text("Objetivo da Utilização"),
                // RadioButtonGroup(
                //   labels: [
                //     "Pesquisa",
                //     "Ensino",
                //     "Extensão",
                //   ],
                //   // onChange: (String label, int index) =>
                //   //     print("label: $label index: $index"),
                //   onSelected: (String label) {
                //     setState(() {
                //       tipo_instituicao = label;
                //     });
                //   },
                // ),
                TextFormField(
                  controller: nome_instituicao,
                  decoration:
                      InputDecoration(labelText: 'Nome da Instituição '),
                ),
                FlatButton(
                  child: Text("Salvar"),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: _salvarLocalidade,
                )
              ],
            )));
  }
}
