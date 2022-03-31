import 'dart:convert';
import 'package:BeraPAR/formulario/selecionar_ficha.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:BeraPAR/constants.dart';
import 'package:BeraPAR/formulario/ficha_latitude_longitude.dart';
import 'package:BeraPAR/formulario/ficha_local.dart';
import 'package:BeraPAR/map/arbitrary_suggestion_type.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:BeraPAR/store/models/map_model.dart';
import 'package:BeraPAR/store/actions/map_actions.dart';
// import 'package:BeraPAR/formulario/ficha.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController mapController = new MapController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List temporary_locals = [];
  List cached_locals = [];
  String dir = '';

  List<ArbitrarySuggestionType> suggestions = [];
  String currentSearch = "";
  ArbitrarySuggestionType selected;
  GlobalKey key =
      new GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>>();
  var textField;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void _initializeDir() async {
    var _dir = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      dir:
      _dir;
    });
  }

  void _initializeLocals() async {
    final SharedPreferences prefs = await _prefs;
    // prefs.remove("temporary_locals");
    // prefs.remove("temporary_pars");
    // prefs.remove("temporary_basalto_pars");
    setState(() {
      temporary_locals = prefs.containsKey("temporary_locals")
          ? json.decode(prefs.getString("temporary_locals"))
          : [];
      cached_locals = prefs.containsKey("cached_locals")
          ? json.decode(prefs.getString("cached_locals"))
          : [];
      suggestions = [
        ...cached_locals?.map((cl) {
          return new ArbitrarySuggestionType(
              cl['id'], cl['nome'], '${cl['latitude']},${cl['longitude']}');
        }),
        ...temporary_locals?.map((tl) {
          return new ArbitrarySuggestionType(int.parse(tl['tmp_id']),
              tl['nome_local'], '${tl['latitude']},${tl['longitude']}');
        })
      ];
    });

    textField.updateSuggestions(suggestions);

    List<Marker> newStatePoints = [];
    for (var tl in temporary_locals) {
      newStatePoints.add(Marker(
        width: 50.0,
        height: 50.0,
        point:
            LatLng(double.parse(tl['latitude']), double.parse(tl['longitude'])),
        builder: (ctx) => Container(
            child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) {
                  return new SelecionarFicha(
                    lat_long: LatLng(double.parse(tl['latitude']),
                        double.parse(tl['longitude'])),
                    nome_local: tl['nome_local'],
                    id_local: tl['tmp_id'],
                  );
                  // new FormularioPage(
                  //   lat_long: LatLng(double.parse(tl['latitude']),
                  //       double.parse(tl['longitude'])),
                  //   nome_local: tl['nome_local'],
                  //   id_local: tl['tmp_id'],
                  // );
                },
                fullscreenDialog: true));
            // print(StoreProvider.of<AppMapState>(context).state.points);
          },
          child: Image.asset("assets/images/map_marker_2.png"),
        )),
      ));
    }

    for (var tl in cached_locals) {
      newStatePoints.add(Marker(
        width: 50.0,
        height: 50.0,
        point:
            LatLng(double.parse(tl['latitude']), double.parse(tl['longitude'])),
        builder: (ctx) => Container(
            child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) {
                  return new SelecionarFicha(
                    lat_long: LatLng(double.parse(tl['latitude']),
                        double.parse(tl['longitude'])),
                    nome_local: tl['nome'],
                    id_local: tl['id'].toString(),
                  );
                  // new FormularioPage(
                  //   lat_long: LatLng(double.parse(tl['latitude']),
                  //       double.parse(tl['longitude'])),
                  //   nome_local: tl['nome'],
                  //   id_local: tl['id'].toString(),
                  // );
                },
                fullscreenDialog: true));
            // print(StoreProvider.of<AppMapState>(context).state.points);
          },
          child: Image.asset("assets/images/map_marker_2.png"),
        )),
      ));
    }
    StoreProvider.of<AppMapState>(context).dispatch(Points(newStatePoints));
  }

  void _newLocalLatLong() {
    Navigator.of(context)
        .push(new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new FormularioLatitudeLongitudeWidget();
            },
            fullscreenDialog: true))
        .then((_) async {
      final SharedPreferences prefs = await _prefs;
      var temporary_lat_long = prefs.containsKey("temporary_lat_long")
          ? json.decode(prefs.getString("temporary_lat_long"))
          : [];
      var point = new LatLng(double.tryParse(temporary_lat_long['latitude']),
          double.tryParse(temporary_lat_long['longitude']));
      mapController.move(point, 18);
      _handleOnTap(point);
      prefs.remove("temporary_lat_long");
    });
  }

  void initState() {
    super.initState();

    _initializeDir();
    _initializeLocals();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var currentPosition = await _determinePosition();
      // mapController.move(
      //     new LatLng(currentPosition.latitude, currentPosition.longitude), 18);
    });

    textField = AutoCompleteTextField<ArbitrarySuggestionType>(
      decoration: new InputDecoration(
          hintText: "Busca por nome do local",
          suffixIcon: new Icon(Icons.search)),
      itemSubmitted: (item) {
        mapController.move(
            new LatLng(double.tryParse(item.lat_long.split(',')[0]),
                double.tryParse(item.lat_long.split(',')[1])),
            18);
        setState(() => selected = item);
      },
      key: key,
      suggestions: suggestions,
      itemBuilder: (context, suggestion) {
        return new Padding(
            child: new ListTile(
                title: new Text(suggestion.name),
                trailing: new Text(
                    "(${double.tryParse(suggestion.lat_long.split(',')[0]).toStringAsFixed(2)},${double.tryParse(suggestion.lat_long.split(',')[1]).toStringAsFixed(2)})")),
            padding: EdgeInsets.all(8.0));
      },
      itemSorter: (a, b) => a.name.compareTo(b.name),
      itemFilter: (suggestion, input) =>
          suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
    );
  }

  void _createNewPAR() {
    print('Redirecionar para criação de novo PAR');
  }

  void _centerMap() async {
    var currentPosition = await _determinePosition();
    mapController.move(
        new LatLng(currentPosition.latitude, currentPosition.longitude), 15);
  }

  void _handleOnTap(LatLng point) {
    Navigator.of(context)
        .push(new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new FormularioLocalWidget(
                lat_long: point,
              );
            },
            fullscreenDialog: true))
        .then((_) {
      _initializeLocals();
    });
  }

  @override
  Widget build(BuildContext context) {
    var _fabMiniMenuItemList = [
      new FabMiniMenuItem.withText(
          new Icon(Icons.gps_fixed),
          kPrimaryLightColor,
          4.0,
          "Criar local por latitude e longitude",
          _newLocalLatLong,
          "Criar local por latitude e longitude",
          kPrimaryLightColor,
          Colors.white,
          true),
      new FabMiniMenuItem.withText(
          new Icon(Icons.gps_fixed),
          kPrimaryLightColor,
          4.0,
          "Centralizar minha localização",
          _centerMap,
          "Centralizar minha localização",
          kPrimaryLightColor,
          Colors.white,
          true),
    ];
    return StoreConnector<AppMapState, AppMapState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Stack(
            children: <Widget>[
              FlutterMap(
                mapController: mapController,
                options: new MapOptions(
                  center: new LatLng(-23.408079, -51.936448),
                  // swPanBoundary:
                  //     LatLng(-23.618844727933105, -52.220880272500274),
                  // nePanBoundary:
                  //     LatLng(-23.242683971317575, -51.66269763581587),
                  zoom: 15.0,
                  // center: LatLng(56.704173, 11.543808),
                  // zoom: 13.0,
                  // swPanBoundary: LatLng(56.6877, 11.5089),
                  // nePanBoundary: LatLng(56.7378, 11.6644),
                  onTap: _handleOnTap,
                  minZoom: 7,
                  maxZoom: 15,
                ),
                layers: [
                  new TileLayerOptions(
                    // urlTemplate:
                    //     "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    tileProvider: FileTileProvider(),
                    urlTemplate:
                        "/data/user/0/com.example.bera_par/app_flutter/parana-tiles/{z}/{x}/{y}.jpg",
                    // tileProvider: AssetTileProvider(),
                    // urlTemplate: "assets/images/18838-7.jpg",
                    subdomains: ['a', 'b', 'c'],
                    // offlineMode: true,
                    // fromAssets: false
                  ),
                  new MarkerLayerOptions(
                    markers: [
                      ...state.points,
                    ],
                  ),
                ],
              ),
              FabDialer(_fabMiniMenuItemList, kPrimaryLightColor,
                  new Icon(Icons.add)),
              Container(
                color: Colors.white,
                height: 60,
                margin: EdgeInsets.only(top: 15, left: 5, right: 5),
                padding: EdgeInsets.all(4),
                child: textField,
              )
            ],
          );
        });
  }
}
