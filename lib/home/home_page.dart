import 'package:flutter/material.dart';
import 'package:BeraPAR/constants.dart';
import 'package:BeraPAR/help/help.dart';
import 'package:BeraPAR/home/home_content.dart';
import 'package:BeraPAR/map/map_page2.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:BeraPAR/profile/profile.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int selectedPage = 1;
  final _pageOptions = [MapPage(), HomeContent(), ProfilePage(), HelpPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BêraPAR'),
      ),
      body: _pageOptions[selectedPage],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.flip,
        backgroundColor: kPrimaryColor,
        items: [
          TabItem(icon: Icons.map, title: 'Mapa'),
          TabItem(icon: Icons.home, title: 'Início'),
          TabItem(icon: Icons.person, title: 'Perfil'),
          TabItem(icon: Icons.help, title: 'Ajuda'),
        ],
        initialActiveIndex: selectedPage /*optional*/,
        onTap: (int i) {
          print('click index=$i');
          setState(() {
            selectedPage = i;
          });
        },
      ),
    );
  }
}
