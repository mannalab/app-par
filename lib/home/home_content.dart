import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BeraPAR/home/sincronizacao.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _doRequest() async {
    // String token = await storage.read(key: 'token');
    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString('token');
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _doRequest());
  }

  // _dateTimeRangePicker() async {
  // DateTimeRange picked = await showDateRangePicker(
  //     context: context,
  //     firstDate: DateTime(DateTime.now().year - 5),
  //     lastDate: DateTime(DateTime.now().year + 5),
  //     initialDateRange: DateTimeRange(
  //     end: DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day + 13),
  //         start: DateTime.now(),
  //     ),
  // );
  // print(picked);
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //   TextFormField (
          //     decoration: new InputDecoration(hintText: "Busca por local", suffixIcon: new Icon(Icons.search)),
          //     ),
          //     RaisedButton(
          //         onPressed: () {
          //         _dateTimeRangePicker();
          //         },
          //         child: Text("Busca por data"),
          //     ),
          Sincronizacao()
        ],
      ),
    ));
  }
}

// import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//         child: Column(children: [
//       FlatButton(
//         color: Colors.grey[400],
//         child: Text("Formulário Arenito Caiuá"),
//         onPressed: () {
//           // cancel();
//         },
//       ),
//       FlatButton(
//         color: Colors.grey[400],
//         child: Text("Formulário 2"),
//         onPressed: () {
//           // cancel();
//         },
//       ),
//     ]));
//   }
// }
