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
    "Péssimo: O solo das proximidades do riacho (cerca de 50 metros ao redor do mesmo) é ocupado por residências, comércios, indústrias e vias públicas.",
    "Regular: O solo das proximidades do riacho (cerca de 50 metros ao redor do mesmo) é ocupado por cultivo de monocultura e/ou pastagens.",
    "Bom: O solo das proximidades do riacho é ocupado por vegetação alterada (cerca de 50 metros ao redor do mesmo), por exemplo: presença de trilhas para adentrar ao riacho, descontinuidades na vegetação.",
    "Ótimo: O solo das proximidades do riacho é ocupado por vegetação natural* (cerca de 50 metros ao redor do mesmo). Não há áreas de cultivo e pastagem nas proximidades do riacho.",
  ];

  var slider_1_value = 0.0;
  String slider_1_text =
      "Péssimo: O solo das proximidades do riacho (cerca de 50 metros ao redor do mesmo) é ocupado por residências, comércios, indústrias e vias públicas.";

  final List<String> lista_de_qualidade_2 = [
    "Péssimo: Alterações de origem industrial/urbana, como despejo de efluentes domésticos e/ou industriais. Podem ocorrer abundantes resíduos plásticos no canal e margens do riacho.",
    "Regular: Alterações de origem doméstica, como presença de lixo (alguns resíduos plásticos), entulhos de construção, descarte de móveis usados e outros.",
    "Bom: Poucas alterações antrópicas próximas ao riacho. Pode haver cercas ao redor do mesmo e/ou presença de animais domésticos (gado, cavalos, etc).",
    "Ótimo: Alterações de origem antrópicas ausentes.",
  ];

  var slider_2_value = 0.0;
  String slider_2_text =
      "Péssimo: Alterações de origem industrial/urbana, como despejo de efluentes domésticos e/ou industriais. Podem ocorrer abundantes resíduos plásticos no canal e margens do riacho.";

  final List<String> lista_de_qualidade_3 = [
    "Péssimo: Margens instáveis, com muitas áreas erodida. Mais de 60% do trecho avaliado erodido. Pode não ocorrer vegetação nos barrancos. Pode haver evidências de quedas de árvores e arbustos devido à erosão.",
    "Regular: Margens moderadamente instáveis; de 30% a 60% de trecho avaliado erodido. Pouca vegetação estabilizando os barrancos. Pode haver raízes expostas da vegetação.",
    "Bom: Margens moderadamente estáveis, de 11% a 30% do trecho avaliado erodido. Presença moderada de vegetação estabilizando os barrancos.",
    "Ótimo: Margens estáveis, com ausência ou mínima evidência de erosão nos barrancos; menos de 10% do trecho avaliado erodido. Presença moderada de vegetação estabilizando os barrancos.",
  ];

  var slider_3md_value = 0.0;
  String slider_3md_text =
      "Péssimo: Margens instáveis, com muitas áreas erodida. Mais de 60% do trecho avaliado erodido. Pode não ocorrer vegetação nos barrancos. Pode haver evidências de quedas de árvores e arbustos devido à erosão.";

  var slider_3me_value = 0.0;
  String slider_3me_text =
      "Péssimo: Margens instáveis, com muitas áreas erodida. Mais de 60% do trecho avaliado erodido. Pode não ocorrer vegetação nos barrancos. Pode haver evidências de quedas de árvores e arbustos devido à erosão.";

  final List<String> lista_de_qualidade_4 = [
    "Péssimo: Menos de 30% das margens com vegetação natural* ou esta é inexistente.",
    "Regular: De 60% a 30% das margens com vegetação natural*. Há mistura de trechos com e sem vegetação (descontinuidade na vegetação das margens).",
    "Bom: De 90% a 60% das margens com vegetação natural*ausência de grandes descontinuidades na vegetação.",
    "Ótimo: Mais de 90% das margens com vegetação natural*.",
  ];

  var slider_4md_value = 0.0;
  String slider_4md_text =
      "Péssimo: Menos de 30% das margens com vegetação natural* ou esta é inexistente.";

  var slider_4me_value = 0.0;
  String slider_4me_text =
      "Péssimo: Menos de 30% das margens com vegetação natural* ou esta é inexistente.";

  final List<String> lista_de_qualidade_5 = [
    "Péssimo: Forte odor de despejos industriais (odor de óleos, tintas industriais, etc.).",
    "Regular: Forte odor de esgoto doméstico no corpo aquático (odor de ovo podre).",
    "Bom: Fracos odores provenientes do corpo aquático.",
    "Ótimo: Nenhum odor proveniente do corpo aquático.",
  ];

  var slider_5_value = 5.0;
  String slider_5_text =
      "Péssimo: Forte odor de despejos industriais (odor de óleos, tintas industriais, etc.).";

  final List<String> lista_de_qualidade_6 = [
    "Péssimo: Abundante oleosidade e/ou espumas no riacho.",
    "Regular: Oleosidade e/ou presença de espumas moderada no riacho.",
    "Bom: Ausência ou mínima evidência de óleo e/ou espumas no riacho.",
    "Ótimo: Ausência de óleo e/ou espumas e/ou espumas no riacho.",
  ];

  var slider_6_value = 5.0;
  String slider_6_text = "Péssimo: Abundante oleosidade e/ou espumas no riacho";

  final List<String> lista_de_qualidade_7 = [
    "Péssimo: Água opaca* ou colorida* (provavelmente devido a despejos de resíduos industriais. Não é possível visualizar estruturas do fundo do riacho (substratos).",
    "Regular: Água turva. Nãos é possível visualizar estruturas do fundo do riacho (substratos).",
    "Bom: Água semitransparente; Ainda é possível visualização de estruturas do fundo do riacho (substratos).",
    "Ótimo: Água transparente. É possível visualizar estruturas do fundo do riacho (substratos).",
  ];

  var slider_7_value = 5.0;
  String slider_7_text =
      "Péssimo: Água opaca* ou colorida* (provavelmente devido a despejos de resíduos industriais. Não é possível visualizar estruturas do fundo do riacho (substratos).";

  final List<String> lista_de_qualidade_8 = [
    "Péssimo: Margens do riacho revestida por gabiões ou cimento. Acima de 70% do trecho avaliado canalizado.",
    "Regular: Presença de diques, terraplanagens, canalizações extensas, aterros, barragens e estruturas de escoramento presente em ambas as margens; de 30% a 70% do trecho avaliado canalizado.",
    "Bom: Presença de poucas alterações no canal do riacho ( de 1% a 30% do trecho avaliado com modificações) como áreas de apoio para pontes, canalização e dragagens. Não há alterações recentes.",
    "Ótimo: Ausência de alterações no canal do riacho. Curso d’água mantém padrão de fluxo natural.",
  ];

  var slider_8_value = 0.0;
  String slider_8_text =
      "Péssimo: Margens do riacho revestida por gabiões ou cimento. Acima de 70% do trecho avaliado canalizado.";

  final List<String> lista_de_qualidade_9 = [
    "Péssimo: O trecho avaliado é retilíneo. Se este for canalizado, atribuir pontuação menor.",
    "Regular: Ocorrem pouquíssimas curvas no trecho avaliado; curvas pouco evidentes.",
    "Bom: Ocorrem curvas suaves e não muito próximas entre si no trecho avaliado.",
    "Ótimo: Ocorrem curvas evidentes e acentuadas ao longo do trecho avaliado.",
  ];

  var slider_9_value = 0.0;
  String slider_9_text =
      "Péssimo: O trecho avaliado é retilíneo. Se este for canalizado, atribuir pontuação menor.";

  final List<String> lista_de_qualidade_10 = [
    "Péssimo: Ocorre predomínio de lama e/ou argila no fundo do riacho; folhas e galhos ausentes no trecho avaliado.",
    "Regular: Ocorrem misturas de lama e/ou argila e/ou areia no trecho avaliado, com mínima quantidade de folhas e galhos presentes no leito do riacho.",
    "Bom: Ocorre predomínio de blocos e cascalhos no trecho avaliado, com poucas folhas e galhos caídos na água.",
    "Ótimo: Ocorre a presença de diferentes tipos e tamanhos de substratos. Pode haver mistura de lajes, blocos cascalhos, folhas e galhos caídos na água. Pode não ocorrer todos os itens sublinhados.",
  ];

  var slider_10_value = 0.0;
  String slider_10_text =
      "Péssimo: Ocorre predomínio de lama e/ou argila no fundo do riacho; folhas e galhos ausentes no trecho avaliado.";

  final List<String> lista_de_qualidade_11 = [
    "Péssimo: Presença de galhos, folhas e troncos submersos em menos de 10% do trecho avaliado. Não há presença de quedas d’água, remansos, margens escavadas e vegetação aquática.",
    "Regular: De 30% a 10% do trecho avaliado com folhas, galhos e troncos submersos. Presença de quedas d’água, margens escavadas e remansos, ou estes itens podem ainda estarem ausentes. Ausência de vegetação aquática.",
    "Bom: De 30 a 50% do trecho avaliado com folhas, galhos e troncos submersos; presença de margens escavadas, quedas d’água e alguns remansos. Mínima presença de vegetação aquática ou ausência desta.",
    "Ótimo: Mais de 50% do trecho avaliado apresenta folhas, galhos, vegetação aquática, tronco submersos, margens escavadas, presença de quedas d’água e remansos, fornecendo habitats estáveis para a biota aquática. Pode não ocorrer todos os itens sublinhados.",
  ];

  var slider_11_value = 0.0;
  String slider_11_text =
      "Péssimo: Presença de galhos, folhas e troncos submersos em menos de 10% do trecho avaliado. Não há presença de quedas d’água, remansos, margens escavadas e vegetação aquática.";

  final List<String> lista_de_qualidade_12 = [
    "Péssimo: Substratos do canal do riacho apresenta mais de 75% de suas superfícies cobertas por sedimentos finos.",
    "Regular: Substratos do canal do riacho apresenta cerca de 50% a 75% de suas superfícies cobertas por sedimentos finos.",
    "Bom: Substrato do canal do riacho apresenta cerca de 25% a 50% de suas superfícies cobertas por sedimentos finos.",
    "Ótimo: Substrato do canal do riacho apresenta menos de 25% de suas superfícies cobertas por sedimentos finos. Grande disponibilidade de habitats para a biota aquática.",
  ];

  var slider_12_value = 0.0;
  String slider_12_text =
      "Péssimo: Substratos do canal do riacho apresenta mais de 75% de suas superfícies cobertas por sedimentos finos.";

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
                                : Text("Próximo"),
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
                            labelText: 'Tempo (situação do dia): '),
                      ),
                      Container(padding: EdgeInsets.only(top: 10)),
                      Text("Choveu na última semana?"),
                      RadioButtonGroup(
                        labels: [
                          "Sim",
                          "Não",
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
                  title: Text('Parâmetro 1'),
                  subtitle: Text(
                      "Principal atividade no uso e ocupação do solo nos 50m ao redor do riacho"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
                      Text(
                          "*Vegetação natural – vegetação que cresce naturalmente nas margens do riacho, incluindo neste parâmetro, espécies nativas e exóticas."),
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
                  title: Text('Parâmetro 2'),
                  subtitle: Text(
                      "Alterações antrópicas próximas*e/ou no canal do riacho"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
                      Text(
                          "*Considerar alterações antrópicas de aproximadamente 10 metros ao redor do riacho."),
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
                  title: Text('Parâmetro 3'),
                  subtitle: Text("Estabilidade dos barrancos"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 2 - Regular: 3 a 5 - Boa: 6 a 8 - Ótima: 9 a 10"),
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
                  title: Text('Parâmetro 4'),
                  subtitle: Text("Proteção vegetal das margens"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 2 - Regular: 3 a 5 - Boa: 6 a 8 - Ótima: 9 a 10"),
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
                  title: Text('Parâmetro 5'),
                  subtitle: Text("Odor da água"),
                  content: Column(
                    children: <Widget>[
                      Text("Péssimo: 5 - Regular: 10 - Boa: 15 - Ótima: 20"),
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
                  title: Text('Parâmetro 6'),
                  subtitle: Text("Presença de óleo e/ou espuma na água"),
                  content: Column(
                    children: <Widget>[
                      Text("Péssimo: 5 - Regular: 10 - Boa: 15 - Ótima: 20"),
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
                  title: Text('Parâmetro 7'),
                  subtitle: Text("Transparência/Coloração da água"),
                  content: Column(
                    children: <Widget>[
                      Text("Péssimo: 5 - Regular: 10 - Boa: 15 - Ótima: 20"),
                      Text(
                          "*Mediante a estas condições, os parâmetros 10, 11 e 12 não deverá ser avaliado."),
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
                  title: Text('Parâmetro 8'),
                  subtitle: Text("Alterações estruturais no canal do riacho"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
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
                  title: Text('Parâmetro 9'),
                  subtitle: Text("Sinuosidade do canal"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
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
                  title: Text('Parâmetro 10'),
                  subtitle: Text("Tipos de substrato de fundo"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
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
                  title: Text('Parâmetro 11'),
                  subtitle: Text("Complexidade do habitat submerso"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
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
                  title: Text('Parâmetro 12'),
                  subtitle: Text("Depósitos sedimentares"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
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
                    title: Text('Avaliação do trecho analisado'),
                    subtitle: Text("Resultado da avaliação"),
                    content: Column(children: <Widget>[
                      // https://api.flutter.dev/flutter/material/DataTable-class.html
                      DataTable(
                        columns: [
                          DataColumn(label: Text("Parâmetro")),
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
                              DataCell(Text("CONDIÇÃO DE CONSERVAÇÃO",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(
                                Text(
                                    soma >= 181 && soma <= 240
                                        ? "Ótima"
                                        : soma >= 121 && soma <= 180
                                            ? "Boa"
                                            : soma >= 61 && soma <= 120
                                                ? "Regular"
                                                : "Péssima",
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
                      Text("Observações"),
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
