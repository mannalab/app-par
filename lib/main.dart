import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:BeraPAR/home/home_page.dart';
import 'package:BeraPAR/splash_screen/splash_page.dart';
import 'package:BeraPAR/constants.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:BeraPAR/store/models/map_model.dart';
import 'package:BeraPAR/store/reducers/map_reducers.dart';

void main() {
  final _initialState = AppMapState(points: []);

  final Store<AppMapState> _store =
      Store<AppMapState>(reducer, initialState: _initialState);

  runApp(AppPAR(store: _store));
}

class AppPAR extends StatelessWidget {
  final Store<AppMapState> store;

  AppPAR({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppMapState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: kPrimaryColor,
            primarySwatch: kPrimaryColor,
            accentColor: kPrimaryColor,
            buttonColor: kPrimaryColor),
        color: kPrimaryColor,
        home: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                  color: kPrimaryLightColor,
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 200,
                      child: Column(children: [
                        Image.asset("assets/images/logo2.png"),
                        Text("BêraPAR",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  )),
              SplashPage(
                color: kPrimaryColor,
              ),
            ],
          ),
        ),
        routes: <String, WidgetBuilder>{'/home': (context) => HomePage()},
      ),
    );
  }
}
