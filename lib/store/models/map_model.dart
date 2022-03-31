import 'package:flutter_map/flutter_map.dart';

class AppMapState {
  List<Marker> points;
  int selected;
  List<dynamic> locais;
  List<dynamic> pars;
  List<dynamic> basalto_pars;
  AppMapState(
      {this.points,
      this.selected = null,
      this.locais,
      this.pars,
      this.basalto_pars});

  AppMapState.fromAppMapState(AppMapState another) {
    points = another.points;
    selected = another.selected;
    locais = another.locais;
    pars = another.pars;
    basalto_pars = another.basalto_pars;
  }

  List<Marker> get viewPoints => points;
  int get viewSelected => selected;
  List<dynamic> get viewLocais => locais;
  List<dynamic> get viewPARs => pars;
  List<dynamic> get viewBasaltoPARs => basalto_pars;
}
