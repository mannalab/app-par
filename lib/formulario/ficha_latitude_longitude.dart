import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:BeraPAR/custom_toast_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormularioLatitudeLongitudeWidget extends StatefulWidget {
  @override
  _FormularioLatitudeLongitudeWidgetState createState() =>
      new _FormularioLatitudeLongitudeWidgetState();
}

class _FormularioLatitudeLongitudeWidgetState
    extends State<FormularioLatitudeLongitudeWidget> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();

  // Verificar o que é obrigatório
  bool showErrorMessage() {
    var lat = latitude.text;
    var long = longitude.text;

    if (lat == "") {
      showToastWidgetDefault(
          BannerToastWidget.fail(
            msg: "Insira a latitude",
          ),
          context);
      return false;
    }
    if (double.tryParse(lat) != null &&
        (double.tryParse(lat) <= -90 || double.tryParse(lat) >= 90)) {
      showToastWidgetDefault(
          BannerToastWidget.fail(
            msg: "A latitude deve ser um número entre -90 e 90",
          ),
          context);
      return false;
    }
    if (long == "") {
      showToastWidgetDefault(
          BannerToastWidget.fail(
            msg: "Insira a longitude",
          ),
          context);
      return false;
    }
    if (double.tryParse(long) != null &&
        (double.tryParse(long) <= -180 || double.tryParse(long) >= 180)) {
      showToastWidgetDefault(
          BannerToastWidget.fail(
            msg: "A longitude deve ser um número entre -180 e 180",
          ),
          context);
      return false;
    }
    return true;
  }

  void _salvarLocalidade() async {
    if (showErrorMessage()) {
      final SharedPreferences prefs = await _prefs;
      var temporary_lat_long = prefs.containsKey("temporary_lat_long")
          ? json.decode(prefs.getString("temporary_lat_long"))
          : [];
      var newLatLong = {"latitude": latitude.text, "longitude": longitude.text};
      temporary_lat_long = newLatLong;
      prefs.setString("temporary_lat_long", json.encode(temporary_lat_long));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text("Insira Latitude e Longitude")),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.-]+'))
                  ],
                  controller: latitude,
                  decoration: InputDecoration(labelText: 'Latitude: '),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.-]+'))
                  ],
                  controller: longitude,
                  decoration: InputDecoration(labelText: 'Longitude: '),
                ),
                FlatButton(
                  child: Text("Continuar"),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: _salvarLocalidade,
                )
              ],
            )));
  }
}
