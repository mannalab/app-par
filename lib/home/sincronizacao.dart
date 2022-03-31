import 'dart:convert';
import 'package:BeraPAR/home/VerFormularioBasaltoPage.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:BeraPAR/constants.dart';
import 'package:BeraPAR/custom_toast_widget.dart';
import 'package:BeraPAR/map/arbitrary_suggestion_type.dart';
import 'package:BeraPAR/store/actions/map_actions.dart';
import 'package:BeraPAR/store/models/map_model.dart';
import 'package:BeraPAR/home/VerFormularioPage.dart';
import 'package:intl/intl.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Sincronizacao extends StatefulWidget {
  @override
  _SincronizacaoState createState() => _SincronizacaoState();
}

class _SincronizacaoState extends State<Sincronizacao> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String token;
  int userId;

  List locais = [];
  List pars = [];
  List basalto_pars = [];

  SharedPreferences prefs;

  ButtonState _uploadCachedContentButtonState = ButtonState.idle;

  List<ArbitrarySuggestionType> suggestions = [];
  String currentSearch = "";
  ArbitrarySuggestionType selected;
  GlobalKey key =
      new GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>>();
  var textField;

  DateTimeRange datePicked;
  bool loading = true;
  bool loading_basalto = true;

  void _initVars() async {
    final SharedPreferences prefs = await _prefs;
    dynamic temporary_locals = prefs.getString("temporary_locals");
    dynamic temporary_pars = prefs.getString("temporary_pars");
    dynamic temporary_basalto_pars = prefs.getString("temporary_basalto_pars");
    setState(() {
      token = prefs.getString("token");
      userId = prefs.getInt("userId");
      locais = temporary_locals != null ? json.decode(temporary_locals) : [];
      pars = temporary_pars != null ? json.decode(temporary_pars) : [];
      basalto_pars = temporary_basalto_pars != null
          ? json.decode(temporary_basalto_pars)
          : [];
    });

    refreshPARsRedux();
    refreshLocalsRedux();

    dynamic cached_locals = prefs.containsKey("cached_locals")
        ? json.decode(prefs.getString("cached_locals"))
        : [];

    setState(() {
      suggestions = [
        ...cached_locals?.map((cl) {
          return new ArbitrarySuggestionType(cl['id'], cl['nome'], '');
        })
      ];
    });

    textField = AutoCompleteTextField<ArbitrarySuggestionType>(
      decoration: new InputDecoration(
          hintText: "Filtrar por local", suffixIcon: new Icon(Icons.search)),
      itemSubmitted: (item) {
        // mapController.move(
        //     new LatLng(double.tryParse(item.lat_long.split(',')[0]),
        //         double.tryParse(item.lat_long.split(',')[1])),
        //     18);
        setState(() => selected = item);
        refreshPARsRedux();
      },
      key: key,
      suggestions: suggestions,
      itemBuilder: (context, suggestion) {
        return new Padding(
            child: new ListTile(title: new Text(suggestion.name)),
            padding: EdgeInsets.all(8.0));
      },
      itemSorter: (a, b) => a.name.compareTo(b.name),
      itemFilter: (suggestion, input) =>
          suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
    );
  }

  void resetUploadCachedContentButtonState() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    setState(() {
      _uploadCachedContentButtonState = ButtonState.idle;
    });
  }

  void refreshLocalsRedux() async {
    final SharedPreferences prefs = await _prefs;
    http
        .get('https://apipar.manna.team/api/Locais?access_token=$token')
        .then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        StoreProvider.of<AppMapState>(context).dispatch(Locais(jsonResponse));
        prefs.setString("cached_locals", json.encode(jsonResponse));
      }
    }).catchError(print);
    // print(StoreProvider.of<AppMapState>(context).state.locais);
  }

  void refreshPARsRedux() {
    setState(() {
      loading = true;
      loading_basalto = true;
    });
    var where_filter = {};
    where_filter['"idAvaliador"'] = userId;
    if (selected != null) {
      where_filter['"idLocal"'] = selected.id;
    }

    if (datePicked != null) {
      where_filter['"and"'] = [
        {
          '"dataHora"': {'"gte"': '"${datePicked.start.toIso8601String()}Z"'}
        },
        {
          '"dataHora"': {'"lte"': '"${datePicked.end.toIso8601String()}Z"'}
        },
      ];
    }

    print(
        'https://apipar.manna.team/api/Formularios?filter={"include":"local","where":${where_filter.toString()}}&access_token=$token');
    http
        .get(
            'https://apipar.manna.team/api/Formularios?filter={"include":"local","where":${where_filter.toString()}}&access_token=$token')
        .then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        // print(jsonResponse);
        StoreProvider.of<AppMapState>(context).dispatch(PARs(jsonResponse));
        setState(() {
          loading = false;
        });
      }
    }).catchError(print);

    print(
        'https://apipar.manna.team/api/FormulariosBasalto?filter={"include":"local","where":${where_filter.toString()}}&access_token=$token');
    http
        .get(
            'https://apipar.manna.team/api/FormulariosBasalto?filter={"include":"local","where":${where_filter.toString()}}&access_token=$token')
        .then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print(jsonResponse);
        StoreProvider.of<AppMapState>(context)
            .dispatch(BasaltoPARs(jsonResponse));
        setState(() {
          loading_basalto = false;
        });
      }
    }).catchError(print);
    // print(StoreProvider.of<AppMapState>(context).state.pars);
  }

  void updatePars(_pars) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("temporary_pars", json.encode(_pars));
    setState(() {
      pars = _pars;
    });
  }

  void updateBasaltoPars(_pars) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("temporary_basalto_pars", json.encode(_pars));
    setState(() {
      basalto_pars = _pars;
    });
  }

  void updateLocais(_locais) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("temporary_locals", json.encode(_locais));
    setState(() {
      locais = _locais;
    });
  }

  void _uploadCachedContentInformation() async {
    setState(() {
      _uploadCachedContentButtonState = ButtonState.loading;
    });
    var _locais = []..addAll(locais);
    var _pars = []..addAll(pars);
    var _basalto_pars = []..addAll(basalto_pars);

    // cria na nuvem todos os locais e atualiza o id_local nos pars locais
    while (_locais.length > 0) {
      var local = _locais.removeLast();
      await http.post(
          'https://apipar.manna.team/api/Locais?access_token=$token',
          body: {
            'nome': local['nome_local'],
            'descricao': local['descricao_local'],
            'latitude': local['latitude'],
            'longitude': local['longitude'],
          }).then((response) {
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          for (var i = 0; i < _pars.length; i++) {
            if (_pars[i]['id_local'] == local['tmp_id']) {
              _pars[i]['id_local'] = jsonResponse['id'];
            }
          }
          updatePars(_pars);
          for (var i = 0; i < _basalto_pars.length; i++) {
            if (_basalto_pars[i]['id_local'] == local['tmp_id']) {
              _basalto_pars[i]['id_local'] = jsonResponse['id'];
            }
          }
          updateBasaltoPars(_basalto_pars);
          updateLocais(_locais);
        } else {
          var errorMessage = json.decode(response.body)['error']['message'];
          showToastWidgetDefault(
              BannerToastWidget.fail(msg: errorMessage), context);
          _locais.add(local);
          updateLocais(_locais);
        }
      }).catchError((error) {
        showToastWidgetDefault(BannerToastWidget.fail(msg: error), context);
        _locais.add(local);
        updateLocais(_locais);
      });
    }

    refreshLocalsRedux();

    // cria na nuvem todos os formularios

    while (_pars.length > 0) {
      var par = _pars.removeLast();

      var request = http.MultipartRequest('POST',
          Uri.parse('https://apipar.manna.team/api/containers/pars/upload'));

      if (par['images'] != null) {
        for (var i = 0; i < par['images'].length; i++) {
          request.files.add(
              await http.MultipartFile.fromPath('files', par['images'][i]));
        }
        var res = await request.send();
        print(res.statusCode);
        for (var i = 0; i < par['images'].length; i++) {
          var img_name = par['images'][i].split('/').last;
          par['images'][i] = img_name;
        }
      }

      print(par);

      await http
          .post('https://apipar.manna.team/api/Formularios?access_token=$token',
              body: json.encode({
                'idAvaliador': par['id_avaliador'],
                'nomeAvaliador': par['nome_avaliador'],
                'idLocal': par['id_local'],
                'tempo': par['tempo'],
                'choveu': par['choveu'],
                'dataHora': par['data_hora'],
                'parametro1': par['parametro_1'],
                'parametro2': par['parametro_2'],
                'parametro3': par['parametro_3'],
                'parametro4': par['parametro_4'],
                'parametro5a': par['parametro_5a'],
                'parametro5b': par['parametro_5b'],
                'parametro6': par['parametro_6'],
                'parametro7me': par['parametro_7me'],
                'parametro7md': par['parametro_7md'],
                'parametro8me': par['parametro_8me'],
                'parametro8md': par['parametro_8md'],
                'parametro9me': par['parametro_9me'],
                'parametro9md': par['parametro_9md'],
                'soma': par['soma'],
                'observacoes': par['observacoes'],
                'images': par['images'],
                'image_captions': par['image_captions'],
              }),
              headers: {"content-type": "application/json"}).then((response) {
        if (response.statusCode == 200) {
          updatePars(_pars);
        } else {
          var errorMessage = json.decode(response.body)['error']['message'];
          showToastWidgetDefault(
              BannerToastWidget.fail(msg: errorMessage), context);
          _pars.add(par);
          updatePars(_pars);
        }
      }).catchError((error) {
        showToastWidgetDefault(BannerToastWidget.fail(msg: error), context);
        _pars.add(par);
        updatePars(_pars);
      });
    }

    // cria na nuvem todos os formularios do basalto

    while (_basalto_pars.length > 0) {
      var basalto_par = _basalto_pars.removeLast();

      var request = http.MultipartRequest('POST',
          Uri.parse('https://apipar.manna.team/api/containers/pars/upload'));

      if (basalto_par['images'] != null) {
        for (var i = 0; i < basalto_par['images'].length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'files', basalto_par['images'][i]));
        }
        var res = await request.send();
        print(res.statusCode);
        for (var i = 0; i < basalto_par['images'].length; i++) {
          var img_name = basalto_par['images'][i].split('/').last;
          basalto_par['images'][i] = img_name;
        }
      }

      print(basalto_par);

      await http.post(
          'https://apipar.manna.team/api/FormulariosBasalto?access_token=$token',
          body: json.encode({
            'idAvaliador': basalto_par['id_avaliador'],
            'nomeAvaliador': basalto_par['nome_avaliador'],
            'idLocal': basalto_par['id_local'],
            'tempo': basalto_par['tempo'],
            'choveu': basalto_par['choveu'],
            'dataHora': basalto_par['data_hora'],
            'parametro1': basalto_par['parametro_1'],
            'parametro2': basalto_par['parametro_2'],
            'parametro3me': basalto_par['parametro_3me'],
            'parametro3md': basalto_par['parametro_3md'],
            'parametro4me': basalto_par['parametro_4me'],
            'parametro4md': basalto_par['parametro_4md'],
            'parametro5': basalto_par['parametro_5'],
            'parametro6': basalto_par['parametro_6'],
            'parametro7': basalto_par['parametro_7'],
            'parametro8': basalto_par['parametro_8'],
            'parametro9': basalto_par['parametro_9'],
            'parametro10': basalto_par['parametro_10'],
            'parametro11': basalto_par['parametro_11'],
            'parametro12': basalto_par['parametro_12'],
            'soma': basalto_par['soma'],
            'observacoes': basalto_par['observacoes'],
            'images': basalto_par['images'],
            'image_captions': basalto_par['image_captions'],
          }),
          headers: {"content-type": "application/json"}).then((response) {
        if (response.statusCode == 200) {
          updateBasaltoPars(_basalto_pars);
        } else {
          var errorMessage = json.decode(response.body)['error']['message'];
          if (response.statusCode == 500 &&
              errorMessage.startsWith('ER_WARN_DATA_OUT_OF_RANGE')) {
            showToastWidgetDefault(
                BannerToastWidget.fail(
                    msg: "id_local desconhecido... removendo par temporário"),
                context);
            updateBasaltoPars(_basalto_pars);
          } else {
            showToastWidgetDefault(
                BannerToastWidget.fail(msg: errorMessage), context);
            _basalto_pars.add(basalto_par);
            updateBasaltoPars(_basalto_pars);
          }
        }
      }).catchError((error) {
        showToastWidgetDefault(BannerToastWidget.fail(msg: error), context);
        _basalto_pars.add(basalto_par);
        updateBasaltoPars(_basalto_pars);
      });
    }

    refreshPARsRedux();

    resetUploadCachedContentButtonState();
  }

  _dateTimeRangePicker() async {
    DateTimeRange picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: DateTimeRange(
        end: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 13),
        start: DateTime.now(),
      ),
    );
    print(picked);
    setState(() {
      datePicked = picked;
    });
    refreshPARsRedux();
  }

  @override
  void initState() {
    super.initState();
    _initVars();
  }

  @override
  Widget build(BuildContext context) {
    print("locais " +
        locais?.length.toString() +
        " pars " +
        pars?.length.toString() +
        ' basalto ' +
        basalto_pars?.length.toString());
    return StoreConnector<AppMapState, AppMapState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Column(
            children: [
              locais?.length + pars?.length + basalto_pars?.length != 0
                  ? Html(data: "<b>Registros Temporários</b>")
                  : Container(),
              locais?.length + pars?.length + basalto_pars?.length != 0
                  ? Container(
                      height: 130.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            locais.length + pars.length + basalto_pars?.length,
                        itemBuilder: (BuildContext context, int i) {
                          if (i < locais.length) {
                            return Card(
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 4, left: 2),
                                    alignment: Alignment.topLeft,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.blue[500],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width: 160.0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(locais[i]['tmp_id'].toString()),
                                        Text(
                                            'Nome: ${locais[i]['nome_local']}'),
                                        Text(
                                            'Lat,Lng: ${double.parse(locais[i]['latitude']).toStringAsFixed(2)},${double.parse(locais[i]['longitude']).toStringAsFixed(2)}'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          } else if (i >= locais.length &&
                              i < (locais.length + pars.length)) {
                            return Card(
                                child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 4, left: 2),
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.assignment,
                                        color: Colors.blue[500],
                                      ),
                                      Text("PAR Arenito Caiuá")
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  width: 160.0,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(pars[i - locais.length]
                                                  ['id_local'] !=
                                              null
                                          ? pars[i - locais.length]['id_local']
                                              .toString()
                                          : ""),
                                      Text(DateFormat('dd/MM/yyy HH:mm').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              pars[i - locais.length]
                                                  ['data_hora']))),
                                      Text(
                                          'Soma: ${pars[i - locais.length]['soma'].toString()}')
                                    ],
                                  ),
                                ),
                              ],
                            ));
                          } else {
                            return Card(
                                child: Stack(
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 4, left: 2),
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.assignment,
                                          color: Colors.blue[500],
                                        ),
                                        Text("PAR Reg. Basáltica")
                                      ],
                                    )),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  width: 160.0,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(basalto_pars[i -
                                                  locais.length -
                                                  pars.length]['id_local'] !=
                                              null
                                          ? basalto_pars[i -
                                                  locais.length -
                                                  pars.length]['id_local']
                                              .toString()
                                          : ""),
                                      Text(DateFormat('dd/MM/yyy HH:mm').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              basalto_pars[i -
                                                  locais.length -
                                                  pars.length]['data_hora']))),
                                      Text(
                                          'Soma: ${basalto_pars[i - locais.length - pars.length]['soma'].toString()}')
                                    ],
                                  ),
                                ),
                              ],
                            ));
                          }
                        },
                      ))
                  : Container(),
              locais?.length + pars?.length + basalto_pars?.length != 0
                  ? Container(
                      padding: EdgeInsets.only(top: 5),
                      alignment: Alignment.bottomRight,
                      child: ProgressButton.icon(
                          iconedButtons: {
                            ButtonState.idle: IconedButton(
                                text: "Sincronizar",
                                icon: Icon(Icons.save, color: Colors.white),
                                color: kPrimaryLightColor),
                            ButtonState.loading: IconedButton(
                                text: "Sincronizando...",
                                color: kPrimaryLightColor),
                            ButtonState.fail: IconedButton(
                                text: "Erro",
                                icon: Icon(Icons.cancel, color: Colors.white),
                                color: Colors.red.shade300),
                            ButtonState.success: IconedButton(
                                text: "Sincronização realizada!",
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                color: Colors.green.shade400),
                          },
                          onPressed: _uploadCachedContentInformation,
                          state: _uploadCachedContentButtonState),
                    )
                  : Container(),
              Row(
                children: [
                  Expanded(child: Container(child: textField)),
                  Expanded(
                      child: RaisedButton(
                    onPressed: () {
                      _dateTimeRangePicker();
                    },
                    child: Text("Filtrar por Data",
                        style: TextStyle(color: Colors.white)),
                  )),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      selected = null;
                      datePicked = null;
                    });
                    refreshPARsRedux();
                  },
                  child: Text("Limpar Filtros",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            child: TabBar(
                                unselectedLabelColor: kPrimaryLightColor,
                                labelColor: kPrimaryColor,
                                indicatorWeight: 2,
                                indicatorColor: kPrimaryColor,
                                tabs: [
                                  Tab(text: "PAR Arenito Caiuá"),
                                  Tab(text: "PAR Reg. Basáltica"),
                                ]),
                          ),
                          Container(
                            //Add this to give height
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(children: [
                              Container(
                                child: (state.pars != null &&
                                        state.pars.length > 0)
                                    ? DataTable(
                                        columnSpacing: 10,
                                        columns: [
                                          // DataColumn(label: Text("#")),
                                          DataColumn(label: Text("Local")),
                                          DataColumn(label: Text("Data")),
                                          DataColumn(label: Text("Soma")),
                                          DataColumn(label: Text("")),
                                        ],
                                        rows: state.pars != null
                                            ? state.pars
                                                .map((par) => DataRow(
                                                      cells: [
                                                        // DataCell(Text(par['id'].toString())),
                                                        DataCell(Text(
                                                            par['local']
                                                                ['nome'])),
                                                        DataCell(Text(new DateFormat(
                                                                "dd/MM/yyyy")
                                                            .format(DateTime
                                                                .parse(par[
                                                                    'dataHora']))
                                                            .toString())),
                                                        DataCell(Container(
                                                            width: 25,
                                                            child: Text(par[
                                                                    'soma']
                                                                .toString()))),
                                                        DataCell(
                                                          Container(
                                                              width: 25,
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  print(
                                                                      "CLICOU NA ROW DO PAR ${par}");
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(new MaterialPageRoute<
                                                                              Null>(
                                                                          builder: (BuildContext
                                                                              context) {
                                                                            return new VerFormularioPage(
                                                                              formulario: par,
                                                                            );
                                                                          },
                                                                          fullscreenDialog:
                                                                              true))
                                                                      .then(
                                                                          (_) {
                                                                    //_initializeLocals();
                                                                  });
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .arrow_forward,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                iconSize: 20.0,
                                                              )),
                                                        ),
                                                      ],
                                                    ))
                                                .toList()
                                            : [],
                                      )
                                    : Container(
                                        child: Text(
                                            "Nenhum PAR preenchido ou salvo remotamente")),
                              ),
                              Container(
                                child: (state.basalto_pars != null &&
                                        state.basalto_pars.length > 0)
                                    ? DataTable(
                                        columnSpacing: 10,
                                        columns: [
                                          // DataColumn(label: Text("#")),
                                          DataColumn(label: Text("Local")),
                                          DataColumn(label: Text("Data")),
                                          DataColumn(label: Text("Soma")),
                                          DataColumn(label: Text("")),
                                        ],
                                        rows: state.basalto_pars != null
                                            ? state.basalto_pars
                                                .map((par) => DataRow(
                                                      cells: [
                                                        // DataCell(Text(par['id'].toString())),
                                                        DataCell(Text(
                                                            par['local']
                                                                ['nome'])),
                                                        DataCell(Text(new DateFormat(
                                                                "dd/MM/yyyy")
                                                            .format(DateTime
                                                                .parse(par[
                                                                    'dataHora']))
                                                            .toString())),
                                                        DataCell(Container(
                                                            width: 25,
                                                            child: Text(par[
                                                                    'soma']
                                                                .toString()))),
                                                        DataCell(
                                                          Container(
                                                              width: 25,
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  print(
                                                                      "CLICOU NA ROW DO PAR ${par}");
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(new MaterialPageRoute<
                                                                              Null>(
                                                                          builder: (BuildContext
                                                                              context) {
                                                                            return new VerFormularioBasaltoPage(
                                                                              formulario: par,
                                                                            );
                                                                          },
                                                                          fullscreenDialog:
                                                                              true))
                                                                      .then(
                                                                          (_) {
                                                                    //_initializeLocals();
                                                                  });
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .arrow_forward,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                iconSize: 20.0,
                                                              )),
                                                        ),
                                                      ],
                                                    ))
                                                .toList()
                                            : [],
                                      )
                                    : Container(
                                        child: Text(
                                            "Nenhum PAR preenchido ou salvo remotamente")),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  loading || loading_basalto
                      ? Positioned(
                          top: 0.0,
                          right: 0.0,
                          left: 0.0,
                          child: SpinKitRing(
                            color: kPrimaryColor,
                            size: 50.0,
                          ))
                      : Container()
                ],
              ),
            ],
          );
        });
  }
}
