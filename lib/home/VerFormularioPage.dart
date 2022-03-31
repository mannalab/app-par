import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:BeraPAR/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BeraPAR/custom_toast_widget.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'dart:html' as html;

class DetailScreen extends StatelessWidget {
  DetailScreen(this.path);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              'https://apipar.manna.team/api/containers/pars/download/$path',
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class VerFormularioPage extends StatefulWidget {
  final dynamic formulario;

  VerFormularioPage({Key key, @required this.formulario}) : super(key: key);

  @override
  _VerFormularioPageState createState() => _VerFormularioPageState(formulario);
}

class _VerFormularioPageState extends State<VerFormularioPage> {
  dynamic formulario;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String token;

  int _current = 0;

  void _logout() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('token');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => VerFormularioPage()));
  }

  void _delete() {
    //   showDialog(
    //       context: context,
    //
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Gostaria de excluir este formulário?'),
            actions: <Widget>[
              RaisedButton(
                color: kPrimaryLightColor,
                child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                  //   Navigator.of(context).pushReplace('/')
                },
              ),
              RaisedButton(
                color: Colors.redAccent,
                child: Text('Excluir', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  http
                      .delete(
                          "https://apipar.manna.team/api/Formularios/${formulario['id']}?access_token=$token")
                      .then((response) async {
                    if (response.statusCode == 200 ||
                        response.statusCode == 204) {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/home');
                    } else {
                      print('Erro!');
                      showToastWidgetDefault(
                          BannerToastWidget.fail(
                              msg: "Tente excluir novamente"),
                          context);
                    }
                  });
                },
              ),
            ],
          );
        },
        fullscreenDialog: false));
  }

  void _download() async {
    List<List<dynamic>> linhas = [];
    List<dynamic> cabecalho = [];
    cabecalho.add('id');
    cabecalho.add('local de coleta');
    cabecalho.add('latitude e longitude');
    cabecalho.add('tempo');
    cabecalho.add('choveu');
    cabecalho.add('dataHora');
    cabecalho.add('parametro1');
    cabecalho.add('parametro2');
    cabecalho.add('parametro3');
    cabecalho.add('parametro4');
    cabecalho.add('parametro5a');
    cabecalho.add('parametro5b');
    cabecalho.add('parametro6');
    cabecalho.add('parametro7me');
    cabecalho.add('parametro7md');
    cabecalho.add('parametro8me');
    cabecalho.add('parametro8md');
    cabecalho.add('parametro9me');
    cabecalho.add('parametro9md');
    cabecalho.add('soma');
    cabecalho.add('observacoes');
    linhas.add(cabecalho);
    List<dynamic> par = [];
    par.add(formulario['id']);
    par.add(formulario['local']['nome']);
    par.add(
        '${formulario["local"]["latitude"]},${formulario["local"]["longitude"]}');
    par.add(formulario['tempo']);
    par.add(formulario['choveu']);
    par.add(formulario['dataHora']);
    par.add(formulario['parametro1']);
    par.add(formulario['parametro2']);
    par.add(formulario['parametro3']);
    par.add(formulario['parametro4']);
    par.add(formulario['parametro5a']);
    par.add(formulario['parametro5b']);
    par.add(formulario['parametro6']);
    par.add(formulario['parametro7me']);
    par.add(formulario['parametro7md']);
    par.add(formulario['parametro8me']);
    par.add(formulario['parametro8md']);
    par.add(formulario['parametro9me']);
    par.add(formulario['parametro9md']);
    par.add(formulario['soma']);
    par.add(formulario['observacoes']);
    linhas.add(par);

    String csvData = ListToCsvConverter().convert(linhas);
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/csv-${DateTime.now()}.csv";
    print(path);
    final File file = File(path);
    await file.writeAsString(csvData);

    Share.shareFile(file);

    print(
        "PAR #${formulario['id']}; Local da coleta: ${formulario['local']['nome']}; Latitude e Longitude: ${formulario['local']['latitude']}, ${formulario['local']['longitude']}; Descrição: ${formulario['local']['descricao']}; Data da coleta: ${formulario['dataHora']}; Avaliador: ${formulario['nomeAvaliador']}; Tempo: ${formulario['tempo']}, Choveu?: ${formulario['choveu']};");
  }

  void initializeValues() async {
    final SharedPreferences prefs = await _prefs;
    String _token = prefs.getString('token');
    setState(() {
      token = _token;
    });
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initializeValues());
  }

  _VerFormularioPageState(this.formulario);

  @override
  Widget build(BuildContext context) {
    var _fabMiniMenuItemList = [
      new FabMiniMenuItem.withText(
          new Icon(Icons.share),
          Colors.blue,
          4.0,
          "Button menu",
          _download,
          "Exportar",
          Colors.blue,
          Colors.white,
          true),
      new FabMiniMenuItem.withText(new Icon(Icons.delete), Colors.red, 4.0,
          "Button menu", _delete, "Deletar", Colors.red, Colors.white, true),
    ];
    return new Scaffold(
        appBar: AppBar(title: Text("PAR #${formulario['id']}")),
        body: Stack(children: [
          SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.all(20),
            child: Center(
                child: Column(children: [
              //Text(formulario.toString()),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Html(
                      data:
                          "<b>Local da coleta:</b> ${formulario['local']['nome']}")),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Html(
                      data:
                          "<b>Latitude:</b> ${formulario['local']['latitude']}")),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Html(
                      data:
                          "<b>Longitude:</b> ${formulario['local']['longitude']}")),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Html(
                    data:
                        "<b>Descrição:</b> ${formulario['local']['descricao']}",
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Html(
                    data: "<b>Data da coleta:</b> ${formulario['dataHora']}",
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Html(
                    data: "<b>Avaliador:</b> ${formulario['nomeAvaliador']}",
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Html(
                    data: "<b>Tempo:</b> ${formulario['tempo']}",
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Html(
                    data:
                        "<b>Choveu:</b> ${formulario['choveu'] == 1 ? 'Sim' : 'Não'}",
                  )),
              DataTable(
                columns: [
                  DataColumn(label: Text("Parâmetro")),
                  DataColumn(label: Text("Notas")),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text("P1")),
                      DataCell(Text("${formulario['parametro1']}"))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("P2")),
                      DataCell(Text("${formulario['parametro2']}"))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("P3")),
                      DataCell(Text("${formulario['parametro3']}"))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("P4")),
                      DataCell(Text("${formulario['parametro4']}"))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("P5A")),
                      DataCell(Text("${formulario['parametro5a']}"))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("P5B")),
                      DataCell(Text("${formulario['parametro5b']}"))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("P6")),
                      DataCell(Text("${formulario['parametro6']}"))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("P7-ME")),
                      DataCell(Text("${formulario['parametro7me']}"))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("P7-MD")),
                      DataCell(Text("${formulario['parametro7md']}"))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("P8-ME")),
                      DataCell(Text("${formulario['parametro8me']}"))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("P8-MD")),
                      DataCell(Text("${formulario['parametro8md']}"))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("P9-ME")),
                      DataCell(Text("${formulario['parametro9me']}"))
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("P9-MD")),
                      DataCell(Text("${formulario['parametro9md']}"))
                    ],
                  ),
                  DataRow(
                    color: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => Colors.grey[200]),
                    cells: [
                      DataCell(Text("SOMA",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text("${formulario['soma']}",
                          style: TextStyle(fontWeight: FontWeight.bold)))
                    ],
                  ),
                  DataRow(
                    color: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => Colors.grey[200]),
                    cells: [
                      DataCell(Text("CONDIÇÃO DE CONSERVAÇÃO",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(
                        Text(
                            formulario['soma'] >= 124 &&
                                    formulario['soma'] <= 200
                                ? "Ótima"
                                : formulario['soma'] >= 81 &&
                                        formulario['soma'] <= 123
                                    ? "Boa"
                                    : formulario['soma'] >= 38 &&
                                            formulario['soma'] <= 80
                                        ? "Regular"
                                        : "Péssima",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ],
              ),
              formulario['images'] != null
                  ? Column(children: <Widget>[
                      CarouselSlider(
                        items: formulario['images']
                            .map<Widget>((item) => Container(
                                  child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        child: Stack(
                                          children: <Widget>[
                                            Image.network(
                                                'https://apipar.manna.team/api/containers/pars/download/$item',
                                                fit: BoxFit.cover,
                                                width: 1000.0),
                                            Positioned(
                                                top: 0.0,
                                                right: 0.0,
                                                child: FlatButton(
                                                  color: Colors.grey,
                                                  textColor: Colors.white,
                                                  shape: CircleBorder(),
                                                  child: Icon(Icons.fullscreen),
                                                  onPressed: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (_) {
                                                      return DetailScreen(item);
                                                    }));
                                                  },
                                                )),
                                            Positioned(
                                              bottom: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          200, 0, 0, 0),
                                                      Color.fromARGB(0, 0, 0, 0)
                                                    ],
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                  ),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 20.0),
                                                child: Text(
                                                  formulario['image_captions'][
                                                      formulario['images']
                                                          .indexOf(item)],
                                                  style: TextStyle(
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ))
                            .toList(),
                        options: CarouselOptions(
                            height: 250,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            aspectRatio: 2.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: formulario['images'].map<Widget>((url) {
                          int index = formulario['images'].indexOf(url);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }).toList(),
                      )
                    ])
                  : Container(),
              // FabDialer(_fabMiniMenuItemList, kPrimaryLightColor,
              //     new Icon(Icons.more_vert)),
              // SizedBox(
              //   height: 20,
              // ),
              // Stack(
              //   children: [
              //     FloatingActionButton(
              //       child: Icon(Icons.delete),
              //       backgroundColor: Colors.red,
              //       foregroundColor: Colors.white,
              //       onPressed: () {
              //         showDialog(
              //           context: context,
              //           builder: (ctx) => AlertDialog(
              //             title: Text("Excluir Protocolo?"),
              //             content: Text(
              //                 "Este protocolo será excluido! Deseja continuar com o procedimento?"),
              //             actions: <Widget>[
              //               FlatButton(
              //                 onPressed: () {},
              //                 child: Text('Não'),
              //                 //onPressed: () => Navigator.of(context).pop(false),
              //               ),
              //               FlatButton(
              //                 onPressed: () {},
              //                 child: Text('Sim'),
              //                 //onPressed: () => Navigator.of(context).pop(true),
              //               ),
              //             ],
              //           ),
              //         );
              //       },
              //     ),
              //     FloatingActionButton(
              //       child: Icon(Icons.mail),
              //       backgroundColor: Colors.blue,
              //       foregroundColor: Colors.white,
              //       onPressed: () {},
              //     ),
              //   ],
              // ),
            ])),
          )),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: FabDialer(_fabMiniMenuItemList, kPrimaryLightColor,
                new Icon(Icons.more_vert)),
          )
        ]));
  }
}
