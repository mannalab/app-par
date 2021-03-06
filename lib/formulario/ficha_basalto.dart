import 'dart:convert';
import 'dart:io';
import 'package:BeraPAR/constants.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:BeraPAR/formulario/take_picture_page.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
            child: Image.file(File(path)),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class FormularioPageBasalto extends StatefulWidget {
  final String id_local;
  final LatLng lat_long;
  final String nome_local;

  FormularioPageBasalto(
      {Key key, this.id_local, @required this.lat_long, this.nome_local})
      : super(key: key);

  @override
  _FormularioPageBasaltoState createState() =>
      new _FormularioPageBasaltoState(id_local, lat_long, nome_local);
}

class _FormularioPageBasaltoState extends State<FormularioPageBasalto> {
  String id_local;
  String nome_local;
  LatLng lat_long;
  _FormularioPageBasaltoState(this.id_local, this.lat_long, this.nome_local);

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController nome_avaliador_controller = TextEditingController();
  TextEditingController local_controller = TextEditingController();
  TextEditingController tempo_controller = TextEditingController();
  TextEditingController observacoes_controller = TextEditingController();
  bool choveu = null;

  String _img_path = null;
  List<String> imgList = [];
  List<TextEditingController> imgCaptionList = [];
  int _current = 0;

  final List<String> lista_de_qualidade_1 = [
    "P??ssimo: O solo das proximidades do riacho (cerca de 50 metros ao redor do mesmo) ?? ocupado por resid??ncias, com??rcios, ind??strias e vias p??blicas.",
    "Regular: O solo das proximidades do riacho (cerca de 50 metros ao redor do mesmo) ?? ocupado por cultivo de monocultura e/ou pastagens.",
    "Bom: O solo das proximidades do riacho ?? ocupado por vegeta????o alterada (cerca de 50 metros ao redor do mesmo), por exemplo: presen??a de trilhas para adentrar ao riacho, descontinuidades na vegeta????o.",
    "??timo: O solo das proximidades do riacho ?? ocupado por vegeta????o natural* (cerca de 50 metros ao redor do mesmo). N??o h?? ??reas de cultivo e pastagem nas proximidades do riacho.",
  ];

  var slider_1_value = 0.0;
  String slider_1_text =
      "P??ssimo: O solo das proximidades do riacho (cerca de 50 metros ao redor do mesmo) ?? ocupado por resid??ncias, com??rcios, ind??strias e vias p??blicas.";

  final List<String> lista_de_qualidade_2 = [
    "P??ssimo: Altera????es de origem industrial/urbana, como despejo de efluentes dom??sticos e/ou industriais. Podem ocorrer abundantes res??duos pl??sticos no canal e margens do riacho.",
    "Regular: Altera????es de origem dom??stica, como presen??a de lixo (alguns res??duos pl??sticos), entulhos de constru????o, descarte de m??veis usados e outros.",
    "Bom: Poucas altera????es antr??picas pr??ximas ao riacho. Pode haver cercas ao redor do mesmo e/ou presen??a de animais dom??sticos (gado, cavalos, etc).",
    "??timo: Altera????es de origem antr??picas ausentes.",
  ];

  var slider_2_value = 0.0;
  String slider_2_text =
      "P??ssimo: Altera????es de origem industrial/urbana, como despejo de efluentes dom??sticos e/ou industriais. Podem ocorrer abundantes res??duos pl??sticos no canal e margens do riacho.";

  final List<String> lista_de_qualidade_3 = [
    "P??ssimo: Margens inst??veis, com muitas ??reas erodida. Mais de 60% do trecho avaliado erodido. Pode n??o ocorrer vegeta????o nos barrancos. Pode haver evid??ncias de quedas de ??rvores e arbustos devido ?? eros??o.",
    "Regular: Margens moderadamente inst??veis; de 30% a 60% de trecho avaliado erodido. Pouca vegeta????o estabilizando os barrancos. Pode haver ra??zes expostas da vegeta????o.",
    "Bom: Margens moderadamente est??veis, de 11% a 30% do trecho avaliado erodido. Presen??a moderada de vegeta????o estabilizando os barrancos.",
    "??timo: Margens est??veis, com aus??ncia ou m??nima evid??ncia de eros??o nos barrancos; menos de 10% do trecho avaliado erodido. Presen??a moderada de vegeta????o estabilizando os barrancos.",
  ];

  var slider_3md_value = 0.0;
  String slider_3md_text =
      "P??ssimo: Margens inst??veis, com muitas ??reas erodida. Mais de 60% do trecho avaliado erodido. Pode n??o ocorrer vegeta????o nos barrancos. Pode haver evid??ncias de quedas de ??rvores e arbustos devido ?? eros??o.";

  var slider_3me_value = 0.0;
  String slider_3me_text =
      "P??ssimo: Margens inst??veis, com muitas ??reas erodida. Mais de 60% do trecho avaliado erodido. Pode n??o ocorrer vegeta????o nos barrancos. Pode haver evid??ncias de quedas de ??rvores e arbustos devido ?? eros??o.";

  final List<String> lista_de_qualidade_4 = [
    "P??ssimo: Menos de 30% das margens com vegeta????o natural* ou esta ?? inexistente.",
    "Regular: De 60% a 30% das margens com vegeta????o natural*. H?? mistura de trechos com e sem vegeta????o (descontinuidade na vegeta????o das margens).",
    "Bom: De 90% a 60% das margens com vegeta????o natural*aus??ncia de grandes descontinuidades na vegeta????o.",
    "??timo: Mais de 90% das margens com vegeta????o natural*.",
  ];

  var slider_4md_value = 0.0;
  String slider_4md_text =
      "P??ssimo: Menos de 30% das margens com vegeta????o natural* ou esta ?? inexistente.";

  var slider_4me_value = 0.0;
  String slider_4me_text =
      "P??ssimo: Menos de 30% das margens com vegeta????o natural* ou esta ?? inexistente.";

  final List<String> lista_de_qualidade_5 = [
    "P??ssimo: Forte odor de despejos industriais (odor de ??leos, tintas industriais, etc.).",
    "Regular: Forte odor de esgoto dom??stico no corpo aqu??tico (odor de ovo podre).",
    "Bom: Fracos odores provenientes do corpo aqu??tico.",
    "??timo: Nenhum odor proveniente do corpo aqu??tico.",
  ];

  var slider_5_value = 5.0;
  String slider_5_text =
      "P??ssimo: Forte odor de despejos industriais (odor de ??leos, tintas industriais, etc.).";

  final List<String> lista_de_qualidade_6 = [
    "P??ssimo: Abundante oleosidade e/ou espumas no riacho.",
    "Regular: Oleosidade e/ou presen??a de espumas moderada no riacho.",
    "Bom: Aus??ncia ou m??nima evid??ncia de ??leo e/ou espumas no riacho.",
    "??timo: Aus??ncia de ??leo e/ou espumas e/ou espumas no riacho.",
  ];

  var slider_6_value = 5.0;
  String slider_6_text = "P??ssimo: Abundante oleosidade e/ou espumas no riacho";

  final List<String> lista_de_qualidade_7 = [
    "P??ssimo: ??gua opaca* ou colorida* (provavelmente devido a despejos de res??duos industriais. N??o ?? poss??vel visualizar estruturas do fundo do riacho (substratos).",
    "Regular: ??gua turva. N??os ?? poss??vel visualizar estruturas do fundo do riacho (substratos).",
    "Bom: ??gua semitransparente; Ainda ?? poss??vel visualiza????o de estruturas do fundo do riacho (substratos).",
    "??timo: ??gua transparente. ?? poss??vel visualizar estruturas do fundo do riacho (substratos).",
  ];

  var slider_7_value = 5.0;
  String slider_7_text =
      "P??ssimo: ??gua opaca* ou colorida* (provavelmente devido a despejos de res??duos industriais. N??o ?? poss??vel visualizar estruturas do fundo do riacho (substratos).";

  final List<String> lista_de_qualidade_8 = [
    "P??ssimo: Margens do riacho revestida por gabi??es ou cimento. Acima de 70% do trecho avaliado canalizado.",
    "Regular: Presen??a de diques, terraplanagens, canaliza????es extensas, aterros, barragens e estruturas de escoramento presente em ambas as margens; de 30% a 70% do trecho avaliado canalizado.",
    "Bom: Presen??a de poucas altera????es no canal do riacho ( de 1% a 30% do trecho avaliado com modifica????es) como ??reas de apoio para pontes, canaliza????o e dragagens. N??o h?? altera????es recentes.",
    "??timo: Aus??ncia de altera????es no canal do riacho. Curso d?????gua mant??m padr??o de fluxo natural.",
  ];

  var slider_8_value = 0.0;
  String slider_8_text =
      "P??ssimo: Margens do riacho revestida por gabi??es ou cimento. Acima de 70% do trecho avaliado canalizado.";

  final List<String> lista_de_qualidade_9 = [
    "P??ssimo: O trecho avaliado ?? retil??neo. Se este for canalizado, atribuir pontua????o menor.",
    "Regular: Ocorrem pouqu??ssimas curvas no trecho avaliado; curvas pouco evidentes.",
    "Bom: Ocorrem curvas suaves e n??o muito pr??ximas entre si no trecho avaliado.",
    "??timo: Ocorrem curvas evidentes e acentuadas ao longo do trecho avaliado.",
  ];

  var slider_9_value = 0.0;
  String slider_9_text =
      "P??ssimo: O trecho avaliado ?? retil??neo. Se este for canalizado, atribuir pontua????o menor.";

  final List<String> lista_de_qualidade_10 = [
    "P??ssimo: Ocorre predom??nio de lama e/ou argila no fundo do riacho; folhas e galhos ausentes no trecho avaliado.",
    "Regular: Ocorrem misturas de lama e/ou argila e/ou areia no trecho avaliado, com m??nima quantidade de folhas e galhos presentes no leito do riacho.",
    "Bom: Ocorre predom??nio de blocos e cascalhos no trecho avaliado, com poucas folhas e galhos ca??dos na ??gua.",
    "??timo: Ocorre a presen??a de diferentes tipos e tamanhos de substratos. Pode haver mistura de lajes, blocos cascalhos, folhas e galhos ca??dos na ??gua. Pode n??o ocorrer todos os itens sublinhados.",
  ];

  var slider_10_value = 0.0;
  String slider_10_text =
      "P??ssimo: Ocorre predom??nio de lama e/ou argila no fundo do riacho; folhas e galhos ausentes no trecho avaliado.";

  final List<String> lista_de_qualidade_11 = [
    "P??ssimo: Presen??a de galhos, folhas e troncos submersos em menos de 10% do trecho avaliado. N??o h?? presen??a de quedas d?????gua, remansos, margens escavadas e vegeta????o aqu??tica.",
    "Regular: De 30% a 10% do trecho avaliado com folhas, galhos e troncos submersos. Presen??a de quedas d?????gua, margens escavadas e remansos, ou estes itens podem ainda estarem ausentes. Aus??ncia de vegeta????o aqu??tica.",
    "Bom: De 30 a 50% do trecho avaliado com folhas, galhos e troncos submersos; presen??a de margens escavadas, quedas d?????gua e alguns remansos. M??nima presen??a de vegeta????o aqu??tica ou aus??ncia desta.",
    "??timo: Mais de 50% do trecho avaliado apresenta folhas, galhos, vegeta????o aqu??tica, tronco submersos, margens escavadas, presen??a de quedas d?????gua e remansos, fornecendo habitats est??veis para a biota aqu??tica. Pode n??o ocorrer todos os itens sublinhados.",
  ];

  var slider_11_value = 0.0;
  String slider_11_text =
      "P??ssimo: Presen??a de galhos, folhas e troncos submersos em menos de 10% do trecho avaliado. N??o h?? presen??a de quedas d?????gua, remansos, margens escavadas e vegeta????o aqu??tica.";

  final List<String> lista_de_qualidade_12 = [
    "P??ssimo: Substratos do canal do riacho apresenta mais de 75% de suas superf??cies cobertas por sedimentos finos.",
    "Regular: Substratos do canal do riacho apresenta cerca de 50% a 75% de suas superf??cies cobertas por sedimentos finos.",
    "Bom: Substrato do canal do riacho apresenta cerca de 25% a 50% de suas superf??cies cobertas por sedimentos finos.",
    "??timo: Substrato do canal do riacho apresenta menos de 25% de suas superf??cies cobertas por sedimentos finos. Grande disponibilidade de habitats para a biota aqu??tica.",
  ];

  var slider_12_value = 0.0;
  String slider_12_text =
      "P??ssimo: Substratos do canal do riacho apresenta mais de 75% de suas superf??cies cobertas por sedimentos finos.";

  var soma = 0.0;

  int currentStep = 0;
  bool complete = false;
  var steps_status = [
    StepState.editing,
    StepState.editing,
    StepState.editing,
    StepState.editing,
    StepState.editing,
    StepState.editing,
    StepState.editing,
    StepState.editing,
    StepState.editing,
    StepState.editing,
    StepState.editing,
    StepState.editing,
    StepState.editing,
    StepState.editing,
  ];
  var steps_active = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  final int stepperLenght = 14;
  bool stepEnded(step) {
    switch (step) {
      case 0:
        if (nome_avaliador_controller.text != "" &&
            local_controller.text != "" &&
            tempo_controller.text != "" &&
            choveu != null) {
          return true;
        }
        return false;
      default:
        return true;
    }
  }

  void _salvarPAR() async {
    final SharedPreferences prefs = await _prefs;
    var temporary_basalto_pars = prefs.containsKey("temporary_basalto_pars")
        ? json.decode(prefs.getString("temporary_basalto_pars"))
        : [];
    var images = [];
    var newPAR = {
      "id_avaliador": prefs.getInt('userId'),
      "nome_avaliador": nome_avaliador_controller.text,
      "id_local": id_local,
      "tempo": tempo_controller.text,
      "choveu": choveu,
      "data_hora": DateTime.now().millisecondsSinceEpoch,
      "parametro_1": slider_1_value,
      "parametro_2": slider_2_value,
      "parametro_3me": slider_3me_value,
      "parametro_3md": slider_3md_value,
      "parametro_4me": slider_4me_value,
      "parametro_4md": slider_4md_value,
      "parametro_5": slider_5_value,
      "parametro_6": slider_6_value,
      "parametro_7": slider_7_value,
      "parametro_8": slider_8_value,
      "parametro_9": slider_9_value,
      "parametro_10": slider_10_value,
      "parametro_11": slider_11_value,
      "parametro_12": slider_12_value,
      "soma": ((slider_1_value +
              slider_2_value +
              slider_3md_value +
              slider_3me_value +
              slider_4md_value +
              slider_4me_value +
              slider_5_value +
              slider_6_value +
              slider_7_value +
              slider_8_value +
              slider_9_value +
              slider_10_value +
              slider_11_value +
              slider_12_value))
          .toStringAsFixed(2),
      "observacoes": observacoes_controller.text,
      "images": imgList,
      "image_captions": imgCaptionList.map((e) => e.text).toList(),
    };
    print(newPAR);
    temporary_basalto_pars.add(newPAR);
    prefs.setString(
        "temporary_basalto_pars", json.encode(temporary_basalto_pars));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  next() {
    var _stepEnded = stepEnded(currentStep);
    print(currentStep.toString() +
        ' ' +
        _stepEnded.toString() +
        ' ' +
        stepperLenght.toString());
    if (currentStep + 1 != stepperLenght && _stepEnded) {
      setState(() {
        steps_active[currentStep] = false;
        steps_status[currentStep] = StepState.complete;
        steps_active[currentStep + 1] = true;
      });
      goTo(currentStep + 1);
    } else if (currentStep + 1 == stepperLenght) {
      _salvarPAR();
      setState(() {
        complete = true;
        steps_active[currentStep] = false;
        steps_status[currentStep] = StepState.complete;
      });
    } else {
      setState(() {
        steps_status[currentStep] = StepState.error;
      });
    }
  }

  cancel() {
    if (currentStep > 0) {
      setState(() {
        steps_active[currentStep] = false;
        steps_active[currentStep - 1] = true;
      });
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  @override
  void initState() {
    super.initState();
    local_controller.text = nome_local;
  }

  @override
  Widget build(BuildContext context) {
    // return new AlertDialog(
    return new Scaffold(
        appBar: AppBar(
            title: Text("PAR Basalto"),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10),
          ),
          Text("Latitude: ${lat_long.latitude}"),
          Text("Longitude: ${lat_long.longitude}"),
          Container(
            padding: EdgeInsets.only(top: 10),
          ),
          Expanded(
            child: Stepper(
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Column(
                  children: <Widget>[
                    // SizedBox(height: AppSize.smallMedium,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: currentStep == 0
                                ? Container()
                                : FlatButton(
                                    color: Colors.grey[400],
                                    child: Text("Anterior"),
                                    onPressed: () {
                                      cancel();
                                    },
                                  )),
                        Expanded(
                          child: FlatButton(
                            color: kPrimaryLightColor,
                            textColor: Colors.white,
                            child: currentStep == 13
                                ? Text("Salvar")
                                : Text("Pr??ximo"),
                            onPressed: () {
                              next();
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
              steps: [
                Step(
                  title: Text('Dados Gerais'),
                  isActive: steps_active[0],
                  state: steps_status[0],
                  content: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: nome_avaliador_controller,
                        decoration:
                            InputDecoration(labelText: 'Nome do Avaliador: '),
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: local_controller,
                        decoration: InputDecoration(labelText: 'Local:'),
                      ),
                      TextFormField(
                        controller: tempo_controller,
                        decoration: InputDecoration(
                            labelText: 'Tempo (situa????o do dia): '),
                      ),
                      Container(padding: EdgeInsets.only(top: 10)),
                      Text("Choveu na ??ltima semana?"),
                      RadioButtonGroup(
                        labels: [
                          "Sim",
                          "N??o",
                        ],
                        // onChange: (String label, int index) {},
                        onSelected: (String label) {
                          setState(() {
                            choveu = label == "Sim" ? true : false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[1],
                  state: steps_status[1],
                  title: Text('Par??metro 1'),
                  subtitle: Text(
                      "Principal atividade no uso e ocupa????o do solo nos 50m ao redor do riacho"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "P??ssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - ??tima: 16 a 20"),
                      Text(
                          "*Vegeta????o natural ??? vegeta????o que cresce naturalmente nas margens do riacho, incluindo neste par??metro, esp??cies nativas e ex??ticas."),
                      Text(slider_1_text),
                      Slider(
                        value: slider_1_value,
                        min: 0,
                        max: 20,
                        divisions: 20,
                        label: slider_1_value.round().toString(),
                        onChanged: (double newValue) {
                          setState(() {
                            slider_1_value = newValue;
                            if (slider_1_value >= 0.0 &&
                                slider_1_value <= 5.0) {
                              slider_1_text = lista_de_qualidade_1[0];
                            } else if (slider_1_value >= 5.1 &&
                                slider_1_value <= 10.0) {
                              slider_1_text = lista_de_qualidade_1[1];
                            } else if (slider_1_value >= 10.1 &&
                                slider_1_value <= 15.0) {
                              slider_1_text = lista_de_qualidade_1[2];
                            } else if (slider_1_value >= 15.1 &&
                                slider_1_value <= 20.0) {
                              slider_1_text = lista_de_qualidade_1[3];
                            }
                            soma = (slider_1_value +
                                slider_2_value +
                                slider_3md_value +
                                slider_3me_value +
                                slider_4md_value +
                                slider_4me_value +
                                slider_5_value +
                                slider_6_value +
                                slider_7_value +
                                slider_8_value +
                                slider_9_value +
                                slider_10_value +
                                slider_11_value +
                                slider_12_value);
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_1_value.toString()),
                          Text("20.0"),
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[2],
                  state: steps_status[2],
                  title: Text('Par??metro 2'),
                  subtitle: Text(
                      "Altera????es antr??picas pr??ximas*e/ou no canal do riacho"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "P??ssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - ??tima: 16 a 20"),
                      Text(
                          "*Considerar altera????es antr??picas de aproximadamente 10 metros ao redor do riacho."),
                      Text(slider_2_text),
                      Slider(
                        value: slider_2_value,
                        min: 0,
                        max: 20,
                        divisions: 20,
                        label: slider_2_value.round().toString(),
                        onChanged: (double newValue) {
                          setState(() {
                            slider_2_value = newValue;

                            if (slider_2_value >= 0.0 &&
                                slider_2_value <= 5.0) {
                              slider_2_text = lista_de_qualidade_2[0];
                            } else if (slider_2_value >= 5.1 &&
                                slider_2_value <= 10.0) {
                              slider_2_text = lista_de_qualidade_2[1];
                            } else if (slider_2_value >= 10.1 &&
                                slider_2_value <= 15.0) {
                              slider_2_text = lista_de_qualidade_2[2];
                            } else if (slider_2_value >= 15.1 &&
                                slider_2_value <= 20.0) {
                              slider_2_text = lista_de_qualidade_2[3];
                            }
                            soma = (slider_1_value +
                                slider_2_value +
                                slider_3md_value +
                                slider_3me_value +
                                slider_4md_value +
                                slider_4me_value +
                                slider_5_value +
                                slider_6_value +
                                slider_7_value +
                                slider_8_value +
                                slider_9_value +
                                slider_10_value +
                                slider_11_value +
                                slider_12_value);
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_2_value.toString()),
                          Text("20.0")
                        ],
                      ),
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[3],
                  state: steps_status[3],
                  title: Text('Par??metro 3'),
                  subtitle: Text("Estabilidade dos barrancos"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "P??ssimo: 0 a 2 - Regular: 3 a 5 - Boa: 6 a 8 - ??tima: 9 a 10"),
                      Text("Margem Esquerda"),
                      Text(slider_3me_text),
                      Slider(
                          value: slider_3me_value,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: slider_3me_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_3me_value = newValue;
                              // print(slider_3me_value);
                              if (slider_3me_value >= 0.0 &&
                                  slider_3me_value <= 2.0) {
                                slider_3me_text = lista_de_qualidade_3[0];
                              } else if (slider_3me_value >= 2.1 &&
                                  slider_3me_value <= 5.0) {
                                slider_3me_text = lista_de_qualidade_3[1];
                              } else if (slider_3me_value >= 5.1 &&
                                  slider_3me_value <= 8.0) {
                                slider_3me_text = lista_de_qualidade_3[2];
                              } else if (slider_3me_value >= 8.1 &&
                                  slider_3me_value <= 10.0) {
                                slider_3me_text = lista_de_qualidade_3[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3md_value +
                                  slider_3me_value +
                                  slider_4md_value +
                                  slider_4me_value +
                                  slider_5_value +
                                  slider_6_value +
                                  slider_7_value +
                                  slider_8_value +
                                  slider_9_value +
                                  slider_10_value +
                                  slider_11_value +
                                  slider_12_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_3me_value.toString()),
                          Text("10.0")
                        ],
                      ),
                      Text("Margem Direita"),
                      Text(slider_3md_text),
                      Slider(
                          value: slider_3md_value,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: slider_3md_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_3md_value = newValue;
                              // print(slider_3md_value);
                              if (slider_3md_value >= 0.0 &&
                                  slider_3md_value <= 2.0) {
                                slider_3md_text = lista_de_qualidade_3[0];
                              } else if (slider_3md_value >= 2.1 &&
                                  slider_3md_value <= 5.0) {
                                slider_3md_text = lista_de_qualidade_3[1];
                              } else if (slider_3md_value >= 5.1 &&
                                  slider_3md_value <= 8.0) {
                                slider_3md_text = lista_de_qualidade_3[2];
                              } else if (slider_3md_value >= 8.1 &&
                                  slider_3md_value <= 10.0) {
                                slider_3md_text = lista_de_qualidade_3[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3md_value +
                                  slider_3me_value +
                                  slider_4md_value +
                                  slider_4me_value +
                                  slider_5_value +
                                  slider_6_value +
                                  slider_7_value +
                                  slider_8_value +
                                  slider_9_value +
                                  slider_10_value +
                                  slider_11_value +
                                  slider_12_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_3md_value.toString()),
                          Text("10.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[4],
                  state: steps_status[4],
                  title: Text('Par??metro 4'),
                  subtitle: Text("Prote????o vegetal das margens"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "P??ssimo: 0 a 2 - Regular: 3 a 5 - Boa: 6 a 8 - ??tima: 9 a 10"),
                      Text("Margem Esquerda"),
                      Text(slider_4me_text),
                      Slider(
                          value: slider_4me_value,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: slider_4me_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_4me_value = newValue;
                              // print(slider_4me_value);
                              if (slider_4me_value >= 0.0 &&
                                  slider_4me_value <= 2.0) {
                                slider_4me_text = lista_de_qualidade_4[0];
                              } else if (slider_4me_value >= 2.1 &&
                                  slider_4me_value <= 5.0) {
                                slider_4me_text = lista_de_qualidade_4[1];
                              } else if (slider_4me_value >= 5.1 &&
                                  slider_4me_value <= 8.0) {
                                slider_4me_text = lista_de_qualidade_4[2];
                              } else if (slider_4me_value >= 8.1 &&
                                  slider_4me_value <= 10.0) {
                                slider_4me_text = lista_de_qualidade_4[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3md_value +
                                  slider_3me_value +
                                  slider_4md_value +
                                  slider_4me_value +
                                  slider_5_value +
                                  slider_6_value +
                                  slider_7_value +
                                  slider_8_value +
                                  slider_9_value +
                                  slider_10_value +
                                  slider_11_value +
                                  slider_12_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_4me_value.toString()),
                          Text("10.0")
                        ],
                      ),
                      Text("Margem Direita"),
                      Text(slider_4md_text),
                      Slider(
                          value: slider_4md_value,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: slider_4md_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_4md_value = newValue;
                              // print(slider_4md_value);
                              if (slider_4md_value >= 0.0 &&
                                  slider_4md_value <= 2.0) {
                                slider_4md_text = lista_de_qualidade_4[0];
                              } else if (slider_4md_value >= 2.1 &&
                                  slider_4md_value <= 5.0) {
                                slider_4md_text = lista_de_qualidade_4[1];
                              } else if (slider_4md_value >= 5.1 &&
                                  slider_4md_value <= 8.0) {
                                slider_4md_text = lista_de_qualidade_4[2];
                              } else if (slider_4md_value >= 8.1 &&
                                  slider_4md_value <= 10.0) {
                                slider_4md_text = lista_de_qualidade_4[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3md_value +
                                  slider_3me_value +
                                  slider_4md_value +
                                  slider_4me_value +
                                  slider_5_value +
                                  slider_6_value +
                                  slider_7_value +
                                  slider_8_value +
                                  slider_9_value +
                                  slider_10_value +
                                  slider_11_value +
                                  slider_12_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_4md_value.toString()),
                          Text("10.0")
                        ],
                      ),
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[5],
                  state: steps_status[5],
                  title: Text('Par??metro 5'),
                  subtitle: Text("Odor da ??gua"),
                  content: Column(
                    children: <Widget>[
                      Text("P??ssimo: 5 - Regular: 10 - Boa: 15 - ??tima: 20"),
                      Text(slider_5_text),
                      Slider(
                        value: slider_5_value,
                        min: 5,
                        max: 20,
                        divisions: 4,
                        label: slider_5_value.round().toString(),
                        onChanged: (double newValue) {
                          setState(() {
                            slider_5_value = newValue >= 0 && newValue < 7
                                ? 5
                                : newValue >= 7 && newValue < 13
                                    ? 10
                                    : newValue >= 13 && newValue < 17
                                        ? 15
                                        : newValue >= 17 ? 20 : newValue;
                            // print(slider_5_value);
                            if (slider_5_value == 5) {
                              slider_5_text = lista_de_qualidade_5[0];
                            } else if (slider_5_value == 10.0) {
                              slider_5_text = lista_de_qualidade_5[1];
                            } else if (slider_5_value == 15.0) {
                              slider_5_text = lista_de_qualidade_5[2];
                            } else if (slider_5_value == 20.0) {
                              slider_5_text = lista_de_qualidade_5[3];
                            }
                            soma = (slider_1_value +
                                slider_2_value +
                                slider_3md_value +
                                slider_3me_value +
                                slider_4md_value +
                                slider_4me_value +
                                slider_5_value +
                                slider_6_value +
                                slider_7_value +
                                slider_8_value +
                                slider_9_value +
                                slider_10_value +
                                slider_11_value +
                                slider_12_value);
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("5.0"),
                          Text(slider_5_value.toString()),
                          Text("20.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[6],
                  state: steps_status[6],
                  title: Text('Par??metro 6'),
                  subtitle: Text("Presen??a de ??leo e/ou espuma na ??gua"),
                  content: Column(
                    children: <Widget>[
                      Text("P??ssimo: 5 - Regular: 10 - Boa: 15 - ??tima: 20"),
                      Text(slider_6_text),
                      Slider(
                        value: slider_6_value,
                        min: 5,
                        max: 20,
                        divisions: 4,
                        label: slider_6_value.round().toString(),
                        onChanged: (double newValue) {
                          setState(() {
                            slider_6_value = newValue >= 0 && newValue < 7
                                ? 5
                                : newValue >= 7 && newValue < 13
                                    ? 10
                                    : newValue >= 13 && newValue < 17
                                        ? 15
                                        : newValue >= 17 ? 20 : newValue;
                            // print(slider_6_value);
                            if (slider_6_value == 5) {
                              slider_6_text = lista_de_qualidade_5[0];
                            } else if (slider_6_value == 10.0) {
                              slider_6_text = lista_de_qualidade_6[1];
                            } else if (slider_6_value == 15.0) {
                              slider_6_text = lista_de_qualidade_6[2];
                            } else if (slider_6_value == 20.0) {
                              slider_6_text = lista_de_qualidade_6[3];
                            }
                            soma = (slider_1_value +
                                slider_2_value +
                                slider_3md_value +
                                slider_3me_value +
                                slider_4md_value +
                                slider_4me_value +
                                slider_5_value +
                                slider_6_value +
                                slider_7_value +
                                slider_8_value +
                                slider_9_value +
                                slider_10_value +
                                slider_11_value +
                                slider_12_value);
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("5.0"),
                          Text(slider_6_value.toString()),
                          Text("20.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[7],
                  state: steps_status[7],
                  title: Text('Par??metro 7'),
                  subtitle: Text("Transpar??ncia/Colora????o da ??gua"),
                  content: Column(
                    children: <Widget>[
                      Text("P??ssimo: 5 - Regular: 10 - Boa: 15 - ??tima: 20"),
                      Text(
                          "*Mediante a estas condi????es, os par??metros 10, 11 e 12 n??o dever?? ser avaliado."),
                      Text(slider_7_text),
                      Slider(
                        value: slider_7_value,
                        min: 5,
                        max: 20,
                        divisions: 4,
                        label: slider_7_value.round().toString(),
                        onChanged: (double newValue) {
                          setState(() {
                            slider_7_value = newValue >= 0 && newValue < 7
                                ? 5
                                : newValue >= 7 && newValue < 13
                                    ? 10
                                    : newValue >= 13 && newValue < 17
                                        ? 15
                                        : newValue >= 17 ? 20 : newValue;
                            // print(slider_7_value);
                            if (slider_7_value == 5) {
                              slider_7_text = lista_de_qualidade_7[0];
                            } else if (slider_7_value == 10.0) {
                              slider_7_text = lista_de_qualidade_7[1];
                            } else if (slider_7_value == 15.0) {
                              slider_7_text = lista_de_qualidade_7[2];
                            } else if (slider_7_value == 20.0) {
                              slider_7_text = lista_de_qualidade_7[3];
                            }
                            soma = (slider_1_value +
                                slider_2_value +
                                slider_3md_value +
                                slider_3me_value +
                                slider_4md_value +
                                slider_4me_value +
                                slider_5_value +
                                slider_6_value +
                                slider_7_value +
                                slider_8_value +
                                slider_9_value +
                                slider_10_value +
                                slider_11_value +
                                slider_12_value);
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("5.0"),
                          Text(slider_7_value.toString()),
                          Text("20.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[8],
                  state: steps_status[8],
                  title: Text('Par??metro 8'),
                  subtitle: Text("Altera????es estruturais no canal do riacho"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "P??ssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - ??tima: 16 a 20"),
                      Text(slider_8_text),
                      Slider(
                          value: slider_8_value,
                          min: 0,
                          max: 20,
                          divisions: 20,
                          label: slider_8_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_8_value = newValue;
                              // print(slider_6_value);
                              if (slider_8_value >= 0.0 &&
                                  slider_8_value <= 5.0) {
                                slider_8_text = lista_de_qualidade_8[0];
                              } else if (slider_8_value >= 5.1 &&
                                  slider_8_value <= 10.0) {
                                slider_8_text = lista_de_qualidade_8[1];
                              } else if (slider_8_value >= 10.1 &&
                                  slider_8_value <= 15.0) {
                                slider_8_text = lista_de_qualidade_8[2];
                              } else if (slider_8_value >= 15.1 &&
                                  slider_8_value <= 20.0) {
                                slider_8_text = lista_de_qualidade_8[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3md_value +
                                  slider_3me_value +
                                  slider_4md_value +
                                  slider_4me_value +
                                  slider_5_value +
                                  slider_6_value +
                                  slider_7_value +
                                  slider_8_value +
                                  slider_9_value +
                                  slider_10_value +
                                  slider_11_value +
                                  slider_12_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_8_value.toString()),
                          Text("20.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[9],
                  state: steps_status[9],
                  title: Text('Par??metro 9'),
                  subtitle: Text("Sinuosidade do canal"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "P??ssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - ??tima: 16 a 20"),
                      Text(slider_9_text),
                      Slider(
                          value: slider_9_value,
                          min: 0,
                          max: 20,
                          divisions: 20,
                          label: slider_9_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_9_value = newValue;
                              // print(slider_9_value);
                              if (slider_9_value >= 0.0 &&
                                  slider_9_value <= 5.0) {
                                slider_9_text = lista_de_qualidade_9[0];
                              } else if (slider_9_value >= 5.1 &&
                                  slider_9_value <= 10.0) {
                                slider_9_text = lista_de_qualidade_9[1];
                              } else if (slider_9_value >= 10.1 &&
                                  slider_9_value <= 15.0) {
                                slider_9_text = lista_de_qualidade_9[2];
                              } else if (slider_9_value >= 15.1 &&
                                  slider_9_value <= 20.0) {
                                slider_9_text = lista_de_qualidade_9[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3md_value +
                                  slider_3me_value +
                                  slider_4md_value +
                                  slider_4me_value +
                                  slider_5_value +
                                  slider_6_value +
                                  slider_7_value +
                                  slider_8_value +
                                  slider_9_value +
                                  slider_10_value +
                                  slider_11_value +
                                  slider_12_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_9_value.toString()),
                          Text("20.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[10],
                  state: steps_status[10],
                  title: Text('Par??metro 10'),
                  subtitle: Text("Tipos de substrato de fundo"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "P??ssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - ??tima: 16 a 20"),
                      Text(slider_10_text),
                      Slider(
                          value: slider_10_value,
                          min: 0,
                          max: 20,
                          divisions: 20,
                          label: slider_10_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_10_value = newValue;
                              // print(slider_10_value);
                              if (slider_10_value >= 0.0 &&
                                  slider_10_value <= 5.0) {
                                slider_10_text = lista_de_qualidade_10[0];
                              } else if (slider_10_value >= 5.1 &&
                                  slider_10_value <= 10.0) {
                                slider_10_text = lista_de_qualidade_10[1];
                              } else if (slider_10_value >= 10.1 &&
                                  slider_10_value <= 15.0) {
                                slider_10_text = lista_de_qualidade_10[2];
                              } else if (slider_10_value >= 15.1 &&
                                  slider_10_value <= 20.0) {
                                slider_10_text = lista_de_qualidade_10[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3md_value +
                                  slider_3me_value +
                                  slider_4md_value +
                                  slider_4me_value +
                                  slider_5_value +
                                  slider_6_value +
                                  slider_7_value +
                                  slider_8_value +
                                  slider_9_value +
                                  slider_10_value +
                                  slider_11_value +
                                  slider_12_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_10_value.toString()),
                          Text("20.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[11],
                  state: steps_status[11],
                  title: Text('Par??metro 11'),
                  subtitle: Text("Complexidade do habitat submerso"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "P??ssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - ??tima: 16 a 20"),
                      Text(slider_11_text),
                      Slider(
                          value: slider_11_value,
                          min: 0,
                          max: 20,
                          divisions: 20,
                          label: slider_11_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_11_value = newValue;
                              // print(slider_11_value);
                              if (slider_11_value >= 0.0 &&
                                  slider_11_value <= 5.0) {
                                slider_11_text = lista_de_qualidade_11[0];
                              } else if (slider_11_value >= 5.1 &&
                                  slider_11_value <= 10.0) {
                                slider_11_text = lista_de_qualidade_11[1];
                              } else if (slider_11_value >= 10.1 &&
                                  slider_11_value <= 15.0) {
                                slider_11_text = lista_de_qualidade_11[2];
                              } else if (slider_11_value >= 15.1 &&
                                  slider_11_value <= 20.0) {
                                slider_11_text = lista_de_qualidade_11[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3md_value +
                                  slider_3me_value +
                                  slider_4md_value +
                                  slider_4me_value +
                                  slider_5_value +
                                  slider_6_value +
                                  slider_7_value +
                                  slider_8_value +
                                  slider_9_value +
                                  slider_10_value +
                                  slider_11_value +
                                  slider_12_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_11_value.toString()),
                          Text("20.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[12],
                  state: steps_status[12],
                  title: Text('Par??metro 12'),
                  subtitle: Text("Dep??sitos sedimentares"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "P??ssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - ??tima: 16 a 20"),
                      Text(slider_12_text),
                      Slider(
                          value: slider_12_value,
                          min: 0,
                          max: 20,
                          divisions: 20,
                          label: slider_12_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_12_value = newValue;
                              // print(slider_12_value);
                              if (slider_12_value >= 0.0 &&
                                  slider_12_value <= 5.0) {
                                slider_12_text = lista_de_qualidade_12[0];
                              } else if (slider_12_value >= 5.1 &&
                                  slider_12_value <= 10.0) {
                                slider_12_text = lista_de_qualidade_12[1];
                              } else if (slider_12_value >= 10.1 &&
                                  slider_12_value <= 15.0) {
                                slider_12_text = lista_de_qualidade_12[2];
                              } else if (slider_12_value >= 15.1 &&
                                  slider_12_value <= 20.0) {
                                slider_12_text = lista_de_qualidade_12[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3md_value +
                                  slider_3me_value +
                                  slider_4md_value +
                                  slider_4me_value +
                                  slider_5_value +
                                  slider_6_value +
                                  slider_7_value +
                                  slider_8_value +
                                  slider_9_value +
                                  slider_10_value +
                                  slider_11_value +
                                  slider_12_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_12_value.toString()),
                          Text("20.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                    isActive: steps_active[13],
                    state: steps_status[13],
                    title: Text('Avalia????o do trecho analisado'),
                    subtitle: Text("Resultado da avalia????o"),
                    content: Column(children: <Widget>[
                      // https://api.flutter.dev/flutter/material/DataTable-class.html
                      DataTable(
                        columns: [
                          DataColumn(label: Text("Par??metro")),
                          DataColumn(label: Text("Notas")),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(Text("P1")),
                              DataCell(Text(slider_1_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P2")),
                              DataCell(Text(slider_2_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P3-ME")),
                              DataCell(Text(slider_3me_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P3-MD")),
                              DataCell(Text(slider_3md_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P4-ME")),
                              DataCell(Text(slider_4me_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P4-MD")),
                              DataCell(Text(slider_4md_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P5")),
                              DataCell(Text(slider_5_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P6")),
                              DataCell(Text(slider_6_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P7")),
                              DataCell(Text(slider_7_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P8")),
                              DataCell(Text(slider_8_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P9")),
                              DataCell(Text(slider_9_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P10")),
                              DataCell(Text(slider_10_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P11")),
                              DataCell(Text(slider_11_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P12")),
                              DataCell(Text(slider_12_value.toString()))
                            ],
                          ),
                          DataRow(
                            color: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) =>
                                    Colors.grey[200]),
                            cells: [
                              DataCell(Text("SOMA",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(
                                Text((soma.toString()),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          DataRow(
                            color: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) =>
                                    Colors.grey[200]),
                            cells: [
                              DataCell(Text("CONDI????O DE CONSERVA????O",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(
                                Text(
                                    soma >= 181 && soma <= 240
                                        ? "??tima"
                                        : soma >= 121 && soma <= 180
                                            ? "Boa"
                                            : soma >= 61 && soma <= 120
                                                ? "Regular"
                                                : "P??ssima",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(children: <Widget>[
                        // _img_path == null
                        //     ? Container()
                        //     : Image.file(File(_img_path)),
                        CarouselSlider(
                          items: imgList
                              .map((item) => Container(
                                    child: Container(
                                      margin: EdgeInsets.all(5.0),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          child: Stack(
                                            children: <Widget>[
                                              Image.file(File(item),
                                                  fit: BoxFit.cover,
                                                  width: 1000.0),
                                              Positioned(
                                                  top: 0.0,
                                                  right: 0.0,
                                                  child: FlatButton(
                                                    color: Colors.grey,
                                                    textColor: Colors.white,
                                                    shape: CircleBorder(),
                                                    child:
                                                        Icon(Icons.fullscreen),
                                                    onPressed: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (_) {
                                                        return DetailScreen(
                                                            item);
                                                      }));
                                                    },
                                                  )),
                                              Positioned(
                                                  top: 0.0,
                                                  left: 0.0,
                                                  child: FlatButton(
                                                      color: Colors.grey,
                                                      textColor: Colors.white,
                                                      shape: CircleBorder(),
                                                      child: Icon(Icons.delete),
                                                      onPressed: () {
                                                        var index = imgList
                                                            .indexOf(item);
                                                        setState(() {
                                                          imgList
                                                              .removeAt(index);
                                                          imgCaptionList
                                                              .removeAt(index);
                                                        });
                                                      })),
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
                                                        Color.fromARGB(
                                                            0, 0, 0, 0)
                                                      ],
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end: Alignment.topCenter,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                                  child: TextFormField(
                                                    controller: imgCaptionList[
                                                        imgList.indexOf(item)],
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        labelText: 'Legenda:'),
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
                          children: imgList.map((url) {
                            int index = imgList.indexOf(url);
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
                        ),
                        imgList.length < 5
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Expanded(
                                        child: FlatButton(
                                      color: kPrimaryLightColor,
                                      textColor: Colors.white,
                                      child: Text("Adicionar Foto"),
                                      onPressed: () async {
                                        final cameras =
                                            await availableCameras();
                                        final camera = cameras.first;

                                        final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TakePicturePage(
                                                        camera: camera)));
                                        setState(() {
                                          // _img_path = result;
                                          if (result != null) {
                                            imgList.add(result);
                                            imgCaptionList
                                                .add(TextEditingController());
                                          }
                                        });
                                      },
                                    ))
                                  ])
                            : Container()
                      ]),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Text("Observa????es"),
                      TextField(
                        controller: observacoes_controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                      )
                      // InkWell(
                      //   child: Text('OK   '),
                      //   onTap: () {
                      //     // if (_formKey.currentState.validate()) {
                      //     // Do something like updating SharedPreferences or User Settings etc.
                      //     Navigator.of(context).pop();
                      //     // }
                      //   },
                      // ),
                    ]))
              ],
              currentStep: currentStep,
              onStepContinue: next,
              // onStepTapped: (step) => goTo(step),
              onStepCancel: cancel,
            ),
          ),
        ]));
    //   actions: <Widget>[
    //     InkWell(
    //       child: Text('OK   '),
    //       onTap: () {
    //         // if (_formKey.currentState.validate()) {
    //         // Do something like updating SharedPreferences or User Settings etc.
    //         Navigator.of(context).pop();
    //         // }
    //       },
    //     ),
    //   ],
    // );
  }
}
