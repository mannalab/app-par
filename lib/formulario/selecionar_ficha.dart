import 'package:flutter/material.dart';
import 'package:BeraPAR/formulario/ficha.dart';
import 'package:latlong/latlong.dart';
import 'package:BeraPAR/fade_router.dart';
import 'package:BeraPAR/constants.dart';
import 'package:BeraPAR/formulario/ficha_basalto.dart';

class SelecionarFicha extends StatefulWidget {
  final String id_local;
  final LatLng lat_long;
  final String nome_local;

  SelecionarFicha(
      {Key key, this.id_local, @required this.lat_long, this.nome_local})
      : super(key: key);

  @override
  _SelecionarFichaState createState() =>
      new _SelecionarFichaState(id_local, lat_long, nome_local);

  // @override
  // _SelecionarFichaState createState() => _SelecionarFichaState();
}

class _SelecionarFichaState extends State<SelecionarFicha> {
  String id_local;
  String nome_local;
  LatLng lat_long;
  _SelecionarFichaState(this.id_local, this.lat_long, this.nome_local);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Selecione um PAR'),
        ),
        body: Container(
            color: kPrimaryLightColor,
            child: Center(
                child: Container(
                    width: 200,
                    height: 200,
                    child: Column(children: [
                      Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: FlatButton(
                            color: Colors.white,
                            child: Text("PAR Arenito Caiuá"),
                            onPressed: () {
                              Navigator.of(context).push(FadePageRoute(
                                builder: (context) => FormularioPage(
                                    lat_long: lat_long,
                                    nome_local: nome_local,
                                    id_local: id_local),
                              ));
                            },
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: FlatButton(
                            color: Colors.white,
                            child: Text("PAR Região Basáltica"),
                            onPressed: () {
                              Navigator.of(context).push(FadePageRoute(
                                builder: (context) => FormularioPageBasalto(
                                    lat_long: lat_long,
                                    nome_local: nome_local,
                                    id_local: id_local),
                              ));
                            },
                          )),
                    ])))));
  }
}
