import 'dart:io';

import 'package:BeraPAR/constants.dart';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:BeraPAR/auth/login_page.dart';
import 'package:BeraPAR/home/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wave_progress_widget/wave_progress.dart';

class VerifyDataPage extends StatefulWidget {
  @override
  _VerifyDataPageState createState() => _VerifyDataPageState();
}

class _VerifyDataPageState extends State<VerifyDataPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _alertText = "";
  String _infoText = "";
  double _progress = 0;
  String _file_progress = "";

  void writeFiles(_dir, i, archive) async {
    for (var j = 0; j < archive.length; j++) {
      // começa a escrita dos arquivos
      setState(() {
        _file_progress =
            "${(((j + 1) / archive.length) * 100).toStringAsFixed(2)}% das imagens verificadas para o zoom $i";
      });
      var uri = '$_dir/parana-tiles/${archive[j].name}';
      if (archive[j].isFile) {
        var outFile = File(uri);
        outFile = await outFile.create(recursive: true);
        outFile.writeAsBytes(archive[j].content);
      } else if (!Directory(uri).existsSync()) {
        Directory(uri).createSync();
      }
    }
  }

  void verifyData() async {
    setState(() {
      _infoText = "Verificando dados....";
    });

    var _dir = (await getApplicationDocumentsDirectory()).path;
    final int zoom_levels = 15;

    print("A $_dir");
    // Verifica se a pasta de tiles não existe existe
    if (!Directory('$_dir/parana-tiles').existsSync()) {
      print("Não existe /parana-tiles.... criando....");
      // em caso de não existir mesmo, cria a pasta
      Directory('$_dir/parana-tiles').createSync();
    }

    // itera sob cada nível de zoom para verificar se já foi extraído
    for (var i = 0; i <= zoom_levels; i++) {
      print('LEVEL $i');
      setState(() {
        _alertText =
            "Essa verificação pode levar algum tempo, mas não se preocupe, pois ela será feita apenas uma vez";
      });
      // await Future.delayed(const Duration(seconds: 1), () {});
      // se a pasta do zoom não existe, significa que ela ainda nem começou a ser extraída
      if (!Directory('$_dir/parana-tiles/$i').existsSync()) {
        if (i == 15 || i == 16) {
          print('VOU CRIAR $i');
          var max = i == 15 ? 3 : 9;
          for (var p = 1; p <= max; p++) {
            dynamic bytes = await rootBundle
                .load('assets/tiles/$i-parte-$p.zip'); //copia dos assets
            final buffer = bytes.buffer;
            var file = await File('$_dir/$i-parte-$p.zip').writeAsBytes(
                //escreve no root sistema de dados
                buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

            bytes = file.readAsBytesSync(); //lê os bites dos dados
            var archive = ZipDecoder().decodeBytes(bytes);

            await writeFiles(_dir, i, archive);

            File('$_dir/$i-parte-$p.zip').deleteSync(); //deleta o zip
          }
        } else {
          dynamic bytes =
              await rootBundle.load('assets/tiles/$i.zip'); //copia dos assets
          final buffer = bytes.buffer;
          var file = await File('$_dir/$i.zip')
              .writeAsBytes(//escreve no root sistema de dados
                  buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

          bytes = file.readAsBytesSync(); //lê os bites dos dados
          var archive = ZipDecoder().decodeBytes(bytes);

          await writeFiles(_dir, i, archive);

          File('$_dir/$i.zip').deleteSync(); //deleta o zip
        }
        // se ela já existe precisamos verificar se o .zip ainda existe, pois isso quer dizer que nao terminamos de extrair
      } else {
        if (i == 15 || i == 16) {
          print('JÁ EXISTE $i ?');
          var max = i == 15 ? 3 : 9;
          var exists = null;
          for (var p = 1; p <= max; p++) {
            if (File('$_dir/$i-parte-$p.zip').existsSync()) {
              exists = p;
              break;
            }
          }
          if (exists != null) {
            for (var p = exists; p <= max; p++) {
              print('VOU CONTINUAR CRIANDO $i - p$p');
              dynamic bytes = await rootBundle
                  .load('assets/tiles/$i-parte-$p.zip'); //copia dos assets
              final buffer = bytes.buffer;
              var file = await File('$_dir/$i-parte-$p.zip').writeAsBytes(
                  //escreve no root sistema de dados
                  buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

              bytes = file.readAsBytesSync(); //lê os bites dos dados
              var archive = ZipDecoder().decodeBytes(bytes);

              await writeFiles(_dir, i, archive);

              File('$_dir/$i-parte-$p.zip').deleteSync(); //deleta o zip
            }
          }
        } else if (File('$_dir/$i.zip').existsSync()) {
          dynamic bytes =
              File('$_dir/$i.zip').readAsBytesSync(); //lê os bites dos dados
          var archive = ZipDecoder().decodeBytes(bytes);

          for (var j = 0; j < archive.length; j++) {
            setState(() {
              _file_progress =
                  "${(((j + 1) / archive.length) * 100).toStringAsFixed(2)}% das imagens verificadas para o zoom $i";
            });
            // começa a escrita dos arquivos
            var uri = '$_dir/parana-tiles/${archive[j].name}';
            if (archive[j].isFile) {
              var outFile = File(uri);
              outFile = await outFile.create(recursive: true);
              outFile.writeAsBytes(archive[j].content);
            } else if (!Directory(uri).existsSync()) {
              Directory(uri).createSync();
            }
          }
          File('$_dir/$i.zip').deleteSync(); //deleta o zip
        }
      }

      setState(() {
        _progress = (i / zoom_levels) * 100;
      });
    }

    // var filesL = (Directory('$_dir/parana-tiles'))
    //     .list(recursive: false, followLinks: false)
    //     .listen((FileSystemEntity entity) {
    //   print(entity);
    // });

    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString('token');
    if (token != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => verifyData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
                child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _alertText,
          textAlign: TextAlign.center,
        ),
        Container(
          padding: EdgeInsets.only(bottom: 30),
        ),
        Text(_infoText),
        WaveProgress(180.0, kPrimaryColor, kPrimaryLightColor, _progress),
        Text('$_progress%'),
        Container(
          padding: EdgeInsets.only(bottom: 30),
        ),
        Text('$_file_progress'),
      ],
    ))));
  }
}
