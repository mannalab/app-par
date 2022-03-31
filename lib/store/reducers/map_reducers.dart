import 'package:BeraPAR/store/models/map_model.dart';
import 'package:BeraPAR/store/actions/map_actions.dart';

AppMapState reducer(AppMapState prevState, dynamic action) {
  AppMapState newState = AppMapState.fromAppMapState(prevState);

  if (action is Points) {
    newState.points = action.payload;
  } else if (action is Selected) {
    newState.selected = action.payload;
  } else if (action is Locais) {
    newState.locais = action.payload;
  } else if (action is PARs) {
    newState.pars = action.payload;
  } else if (action is BasaltoPARs) {
    newState.basalto_pars = action.payload;
  }
  return newState;
}
