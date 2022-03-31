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

class FormularioPage extends StatefulWidget {
  final String id_local;
  final LatLng lat_long;
  final String nome_local;

  FormularioPage(
      {Key key, this.id_local, @required this.lat_long, this.nome_local})
      : super(key: key);

  @override
  _FormularioPageState createState() =>
      new _FormularioPageState(id_local, lat_long, nome_local);
}

class _FormularioPageState extends State<FormularioPage> {
  String id_local;
  String nome_local;
  LatLng lat_long;
  _FormularioPageState(this.id_local, this.lat_long, this.nome_local);

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
    "Péssimo: Trechos com dominância clara de areia, velocidade da água promovendo o carreamento de estruturas e limitando fortemente o estabelecimento de vegetação aquática submersa e material orgânico em decomposição. Menos de 25% do trecho com troncos, galhos e folhas.",
    "Regular: De 26% a 50% do trecho com ausência ou presença mínima de material orgânico e/ou vegetação aquática submersa, prevalece a presença de areia, com troncos, galhos e folhas caídos na água.",
    "Bom: O trecho avaliado apresenta de 51% a 75% de substratos em potencial, como areia, troncos, galhos e folhas caídos na água; bem como de vegetação aquática submersa e/ou material orgânico em decomposição.",
    "Ótimo: O trecho apresenta areia, deposição de material orgânico, vegetação aquática submersa, troncos, galhos e folhas caídos na água disponibilizando diversos substratos de fundo de 76% a 100% do trecho avaliado.",
  ];

  var slider_1_value = 0.0;
  String slider_1_text =
      "Péssimo: Trechos com dominância clara de areia, velocidade da água promovendo o carreamento de estruturas e limitando fortemente o estabelecimento de vegetação aquática submersa e material orgânico em decomposição. Menos de 25% do trecho com troncos, galhos e folhas.";

  final List<String> lista_de_qualidade_2 = [
    "Péssima: O canal encontra-se desprovido de vegetação aquática, remansos e pequenas cachoeiras, vegetação marginal inclinada sobre o canal, e presença mínima de troncos, galhos e folhas em menos de 25% do trecho.",
    "Regular: O trecho apresenta de 26% a 50% de habitats em potencial, com galhos e folhas caídas na água, vegetação marginal inclinada sobre o canal, pequenas cachoeiras, com presença mínima ou ausência de vegetação aquática e poucos ou nenhum tipo de remanso para abrigo e reprodução das comunidades aquáticas.",
    "Boa: A proporção de habitats em potencial é encontrada em 51% a 75% do trecho avaliado, com galhos e folhas caídos na água, vegetação marginal inclinada sobre o canal, pequenas cachoeiras, com presença mínima ou ausência de vegetação aquática, margens escavadas e/ou remansos representativos.",
    "Ótima: Entre 76% e 100% de presença de vegetação aquática, galhos e folhas caídos na água, vegetação marginal inclinada sobre o canal, presença de remansos, pequenas cachoeiras e margens escavadas distribuídos ao longo do trecho avaliado como habitats em potencial.",
  ];

  var slider_2_value = 0.0;
  String slider_2_text =
      "Péssimo: O canal encontra-se desprovido de vegetação aquática, remansos e pequenas cachoeiras, vegetação marginal inclinada sobre o canal, e presença mínima de troncos, galhos e folhas em menos de 25% do trecho.";

  final List<String> lista_de_qualidade_3 = [
    "Péssima: Prevalência de apenas 1 tipo de regime, caso predomine o regime lento a pontuação é menor.",
    "Regular: Presença de 2 tipos de regimes; se o regime rápido/raso estiver ausente a pontuação é menor.",
    "Boa: Presença de 3 regimes, sendo obrigatória a presença do regime do tipo rápido/raso.",
    "Ótima: Presença dos 4 tipos de regimes. Rápido/raso ; rápido/fundo; lento/raso; lento/fundo.",
  ];
  var slider_3_value = 0.0;
  String slider_3_text =
      "Péssima: Prevalência de apenas 1 tipo de regime, caso predomine o regime lento a pontuação é menor.  ";

  final List<String> lista_de_qualidade_4 = [
    "Péssima: O trecho apresenta-se retilíneo. Em caso de canalização provocada pelo homem, a nota é menor.",
    "Regular: O trecho apresenta poucas curvas, suaves e distantes.",
    "Boa: A sinuosidade do canal não é tão evidente, podendo ser observadas curvas menos acentuadas e mais distantes.",
    "Ótima: Ocorrência de curvas acentuadas e evidentes ao longo do trecho avaliado.",
  ];

  var slider_4_value = 0.0;
  String slider_4_text =
      "Péssima: O trecho apresenta-se retilíneo. Em caso de canalização provocada pelo homem, a nota é menor.";

  final List<String> lista_de_qualidade_5a = [
    "Péssima: Pouquíssima água no canal, sendo a maioria de água parada em poços.",
    "Regular: A água preenche entre 26% e 75% do canal, e/ou a maioria dos substratos estão expostos.",
    "Boa: A água preenche mais de 75% do canal e menos de 25% de substratos estão expostos.",
    "Ótima: O nível de água contempla os substratos presentes adequados à colonização.",
  ];

  var slider_5a_value = 0.0;
  String slider_5a_text =
      "Péssima: Pouquíssima água no canal, sendo a maioria de água parada em poços.";

  final List<String> lista_de_qualidade_5b = [
    "Péssima: O canal encontra-se completamente seco.",
    "Boa: A água preenche mais de 75% do canal e menos de 25% de substratos estão expostos ",
    "Ótima: O nível de água contempla os substratos presentes adequados à colonização, com exposição mínima dos mesmos",
    "Ótima: O nível de água contempla os substratos presentes adequados à colonização, com exposição mínima dos mesmos",
  ];

  var slider_5b_value = 0.0;
  String slider_5b_text = "Péssima: O canal encontra-se completamente seco.";

  final List<String> lista_de_qualidade_6 = [
    "Péssima: As margens estão revestidas de cimento ou sustentadas por gabiões, ou ainda em locais onde mais de 51% da extensão do curso está canalizado e com presença de rupturas ou qualquer outra alteração. ",
    "Regular: Presença de barragens, diques, escoamento ou qualquer uma das alterações citadas, recentes, modificando de 21% a 50% do curso natural do rio.",
    "Boa: Presença de algumas alterações antigas como pontes ou dragagens em até 20% do trecho, com ausência de alterações recentes.",
    "Ótima: Ausência ou mínima presença de alterações como canalizações, dragagens, pontes, diques, aterros, barragens, concretamento ou desvio de fluxo. O curso d’água segue com padrão de fluxo natural.",
  ];
  var slider_6_value = 0.0;
  String slider_6_text =
      "Péssima: As margens estão revestidas de cimento ou sustentadas por gabiões, ou ainda em locais onde mais de 51% da extensão do curso está canalizado e com presença de rupturas ou qualquer outra alteração. ";

  final List<String> lista_de_qualidade_7 = [
    "Péssima: Mais de 66% dos bancos estão erodidos, com sinais claros de sepultamento e interrupção do fluxo devido a erosão e assoreamento, vegetação arbórea mínima. Alongamento dominado por gramíneas ou vegetação herbácea.",
    "Regular: Erosão visualizada entre 31% a 65% do trecho, com exposição de raízes, aumento do domínio de gramíneas e presença mínima de vegetação arbórea em alguns locais esparsos, movimentação clara do solo e assoreamento ao longo dos eventos sucessionais de vegetação limitante do trecho.",
    "Boa: Os barrancos apresentam 11% a 30% de erosão, com exposição do solo em locais esparsos devido à falta de vegetação, colonização por gramíneas e vegetação herbácea, exposição de raízes, movimentos do solo formando pequenas praias que podem ser colonizadas novamente pela vegetação terrestre.",
    "Ótima: Alongamentos com mínima ocorrência de erosão, vegetação ribeirinha preservada sustentando o solo.",
  ];
  var slider_7me_value = 0.0;
  String slider_7me_text =
      "Péssima: Mais de 66% dos bancos estão erodidos, com sinais claros de sepultamento e interrupção do fluxo devido a erosão e assoreamento, vegetação arbórea mínima. Alongamento dominado por gramíneas ou vegetação herbácea.";

  var slider_7md_value = 0.0;
  String slider_7md_text =
      "Péssima: Mais de 66% dos bancos estão erodidos, com sinais claros de sepultamento e interrupção do fluxo devido a erosão e assoreamento, vegetação arbórea mínima. Alongamento dominado por gramíneas ou vegetação herbácea.";

  final List<String> lista_de_qualidade_8 = [
    "Péssima: Menos de 50% dos barrancos dos riachos cobertos por qualquer tipo de vegetação natural, grandes descontinuidades e ausência de vegetação arbórea. Dominado por vegetação herbácea e gramíneas. Uso da terra nos 20 metros de largura ocupados pela agricultura, pastagem e / ou uso do solo urbano.",
    "Regular: De 50% até 69% dos barrancos cobertos com pouca vegetação arbórea; agricultura evidente, pastagem e / ou ocupação urbana, a vegetação natural está ausente. Sempre que o uso da terra urbana ocorre, as pontuações são mais baixas.",
    "Boa: De 70% a 89% dos mananciais cobertos por vegetação natural e multi-estratos, com evidências mínimas de agricultura, pastagem e / ou uso do solo urbano ao longo de 20 metros de largura. Nenhuma descontinuidade representativa na vegetação ripária.",
    "Ótima: Trechos com mais 90% de vegetação natural,  com espécies arbóreas, shrubby e espécies herbáceas, formando um multi-estratos de vegetação. Não evidências de agricultura, pastagem e / ou uso do solo urbano ao longo de 20 metros largura. Espécies de plantas pode crescer naturalmente.",
  ];

  var slider_8me_value = 0.0;
  String slider_8me_text =
      "Péssima: Menos de 50% dos barrancos dos riachos cobertos por qualquer tipo de vegetação natural, grandes descontinuidades e ausência de vegetação arbórea. Dominado por vegetação herbácea e gramíneas. Uso da terra nos 20 metros de largura ocupados pela agricultura, pastagem e / ou uso do solo urbano.";

  var slider_8md_value = 0.0;
  String slider_8md_text =
      "Péssima: Menos de 50% dos barrancos dos riachos cobertos por qualquer tipo de vegetação natural, grandes descontinuidades e ausência de vegetação arbórea. Dominado por vegetação herbácea e gramíneas. Uso da terra nos 20 metros de largura ocupados pela agricultura, pastagem e / ou uso do solo urbano.";

  final List<String> lista_de_qualidade_9 = [
    "Péssima: A vegetação do entorno é praticamente inexistente devido, principalmente, a retirada da vegetação nativa para uso da madeira, abertura de trilhas e clareiras ou ainda queimadas e desmatamento, dando lugar a espécies invasoras.",
    "Regular: Presença nítida de espécies exóticas e pouco resquício de vegetação nativa associada à presença de impactos antrópicos.",
    "Boa: A vegetação é composta não só por espécies nativas, mas também por espécies exóticas, contudo apresentando bom estado de conservação, com mínima evidência de impactos antrópicos.",
    "Ótima: A vegetação do entorno é composta por espécies nativas em bom estado de conservação.",
  ];
  var slider_9me_value = 0.0;
  String slider_9me_text =
      "Péssima: A vegetação do entorno é praticamente inexistente devido, principalmente, a retirada da vegetação nativa para uso da madeira, abertura de trilhas e clareiras ou ainda queimadas e desmatamento, dando lugar a espécies invasoras.";

  var slider_9md_value = 0.0;
  String slider_9md_text =
      "Péssima: A vegetação do entorno é praticamente inexistente devido, principalmente, a retirada da vegetação nativa para uso da madeira, abertura de trilhas e clareiras ou ainda queimadas e desmatamento, dando lugar a espécies invasoras.";

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
    StepState.editing
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
    false
  ];
  final int stepperLenght = 12;
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
    var temporary_pars = prefs.containsKey("temporary_pars")
        ? json.decode(prefs.getString("temporary_pars"))
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
      "parametro_3": slider_3_value,
      "parametro_4": slider_4_value,
      "parametro_5a": slider_5a_value,
      "parametro_5b": slider_5b_value,
      "parametro_6": slider_6_value,
      "parametro_7me": slider_7me_value,
      "parametro_7md": slider_7md_value,
      "parametro_8me": slider_8me_value,
      "parametro_8md": slider_8md_value,
      "parametro_9me": slider_9me_value,
      "parametro_9md": slider_9md_value,
      "soma": ((slider_1_value +
              slider_2_value +
              slider_3_value +
              slider_4_value +
              slider_5a_value +
              slider_5b_value +
              slider_6_value +
              slider_7me_value +
              slider_7md_value +
              slider_8me_value +
              slider_8md_value +
              slider_9me_value +
              slider_9md_value))
          .toStringAsFixed(2),
      "observacoes": observacoes_controller.text,
      "images": imgList,
      "image_captions": imgCaptionList.map((e) => e.text).toList(),
    };
    print(newPAR);
    temporary_pars.add(newPAR);
    prefs.setString("temporary_pars", json.encode(temporary_pars));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  next() {
    var _stepEnded = stepEnded(currentStep);
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
        appBar: AppBar(title: Text("Preencher PAR")),
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
                            child: currentStep == 11
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
                  subtitle: Text("Substrato de fundo"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
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
                                slider_3_value +
                                slider_4_value +
                                slider_5a_value +
                                slider_5b_value +
                                slider_6_value +
                                slider_7me_value +
                                slider_7md_value +
                                slider_8me_value +
                                slider_8md_value +
                                slider_9me_value +
                                slider_9md_value);
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
                  subtitle: Text("Complexidade do habitat submerso"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
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
                                slider_3_value +
                                slider_4_value +
                                slider_5a_value +
                                slider_5b_value +
                                slider_6_value +
                                slider_7me_value +
                                slider_7md_value +
                                slider_8me_value +
                                slider_8md_value +
                                slider_9me_value +
                                slider_9md_value);
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
                  subtitle: Text("Variação de velocidade e profundidade"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
                      Text(slider_3_text),
                      Slider(
                        value: slider_3_value,
                        min: 0,
                        max: 20,
                        divisions: 20,
                        label: slider_3_value.round().toString(),
                        onChanged: (double newValue) {
                          setState(() {
                            slider_3_value = newValue;

                            if (slider_3_value >= 0.0 &&
                                slider_3_value <= 5.0) {
                              slider_3_text = lista_de_qualidade_3[0];
                            } else if (slider_3_value >= 5.1 &&
                                slider_3_value <= 10.0) {
                              slider_3_text = lista_de_qualidade_3[1];
                            } else if (slider_3_value >= 10.1 &&
                                slider_3_value <= 15.0) {
                              slider_3_text = lista_de_qualidade_3[2];
                            } else if (slider_3_value >= 15.1 &&
                                slider_3_value <= 20.0) {
                              slider_3_text = lista_de_qualidade_3[3];
                            }
                            soma = (slider_1_value +
                                slider_2_value +
                                slider_3_value +
                                slider_4_value +
                                slider_5a_value +
                                slider_5b_value +
                                slider_6_value +
                                slider_7me_value +
                                slider_7md_value +
                                slider_8me_value +
                                slider_8md_value +
                                slider_9me_value +
                                slider_9md_value);
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_3_value.toString()),
                          Text("20.0")
                        ],
                      ),
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[4],
                  state: steps_status[4],
                  title: Text('Parâmetro 4'),
                  subtitle: Text("Sinuosidade do canal"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
                      Text(slider_4_text),
                      Slider(
                        value: slider_4_value,
                        min: 0,
                        max: 20,
                        divisions: 20,
                        label: slider_4_value.round().toString(),
                        onChanged: (double newValue) {
                          setState(() {
                            slider_4_value = newValue;

                            if (slider_4_value >= 0.0 &&
                                slider_4_value <= 5.0) {
                              slider_4_text = lista_de_qualidade_4[0];
                            } else if (slider_4_value >= 5.1 &&
                                slider_4_value <= 10.0) {
                              slider_4_text = lista_de_qualidade_4[1];
                            } else if (slider_4_value >= 10.1 &&
                                slider_4_value <= 15.0) {
                              slider_4_text = lista_de_qualidade_4[2];
                            } else if (slider_4_value >= 15.1 &&
                                slider_4_value <= 20.0) {
                              slider_4_text = lista_de_qualidade_4[3];
                            }
                            soma = (slider_1_value +
                                slider_2_value +
                                slider_3_value +
                                slider_4_value +
                                slider_5a_value +
                                slider_5b_value +
                                slider_6_value +
                                slider_7me_value +
                                slider_7md_value +
                                slider_8me_value +
                                slider_8md_value +
                                slider_9me_value +
                                slider_9md_value);
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_4_value.toString()),
                          Text("20.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[5],
                  state: steps_status[5],
                  title: Text('Parâmetro 5A'),
                  subtitle: Text("Condições de escoamento do canal"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "PERÍODO DE CHUVA – COMPREENDIDO ENTRE OS MESES DE OUTUBRO A MARÇO"),
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
                      Text(slider_5a_text),
                      Slider(
                          value: slider_5a_value,
                          min: 0,
                          max: 20,
                          divisions: 20,
                          label: slider_5a_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_5a_value = newValue;
                              // print(slider_5a_value);
                              if (slider_5a_value >= 0.0 &&
                                  slider_5a_value <= 5.0) {
                                slider_5a_text = lista_de_qualidade_5a[0];
                              } else if (slider_5a_value >= 5.1 &&
                                  slider_5a_value <= 10.0) {
                                slider_5a_text = lista_de_qualidade_5a[1];
                              } else if (slider_5a_value >= 10.1 &&
                                  slider_5a_value <= 15.0) {
                                slider_5a_text = lista_de_qualidade_5a[2];
                              } else if (slider_5a_value >= 15.1 &&
                                  slider_5a_value <= 20.0) {
                                slider_5a_text = lista_de_qualidade_5a[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3_value +
                                  slider_4_value +
                                  slider_5a_value +
                                  slider_5b_value +
                                  slider_6_value +
                                  slider_7me_value +
                                  slider_7md_value +
                                  slider_8me_value +
                                  slider_8md_value +
                                  slider_9me_value +
                                  slider_9md_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_5a_value.toString()),
                          Text("20.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[6],
                  state: steps_status[6],
                  title: Text('Parâmetro 5B'),
                  subtitle: Text("Condições de escoamento do canal"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "PERÍODO DE ESTIAGEM – COMPREENDIDO ENTRE OS MESE DE ABRIL E SETEMBRO"),
                      Text("Péssimo: 0 - Regular: 10 a 19 - Ótima: 20"),
                      Text(slider_5b_text),
                      Slider(
                        value: slider_5b_value,
                        min: 0,
                        max: 20,
                        divisions: 20,
                        label: slider_5b_value.round().toString(),
                        onChanged: (double newValue) {
                          setState(() {
                            slider_5b_value =
                                newValue > 0 && newValue < 10 ? 0 : newValue;
                            // print(slider_5b_value);
                            if (slider_5b_value == 0) {
                              slider_5b_text = lista_de_qualidade_5b[0];
                            } else if (slider_5b_value >= 10.0 &&
                                slider_5b_value <= 19.0) {
                              slider_5b_text = lista_de_qualidade_5b[1];
                            } else if (slider_5b_value == 20.0) {
                              slider_5b_text = lista_de_qualidade_5b[3];
                            }
                            soma = (slider_1_value +
                                slider_2_value +
                                slider_3_value +
                                slider_4_value +
                                slider_5a_value +
                                slider_5b_value +
                                slider_6_value +
                                slider_7me_value +
                                slider_7md_value +
                                slider_8me_value +
                                slider_8md_value +
                                slider_9me_value +
                                slider_9md_value);
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_5b_value.toString()),
                          Text("20.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[7],
                  state: steps_status[7],
                  title: Text('Parâmetro 6'),
                  subtitle: Text("Alterações no canal"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 5 - Regular: 6 a 10 - Boa: 11 a 15 - Ótima: 16 a 20"),
                      Text(slider_6_text),
                      Slider(
                          value: slider_6_value,
                          min: 0,
                          max: 20,
                          divisions: 20,
                          label: slider_6_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_6_value = newValue;
                              // print(slider_6_value);
                              if (slider_6_value >= 0.0 &&
                                  slider_6_value <= 5.0) {
                                slider_6_text = lista_de_qualidade_6[0];
                              } else if (slider_6_value >= 5.1 &&
                                  slider_6_value <= 10.0) {
                                slider_6_text = lista_de_qualidade_6[1];
                              } else if (slider_6_value >= 10.1 &&
                                  slider_6_value <= 15.0) {
                                slider_6_text = lista_de_qualidade_6[2];
                              } else if (slider_6_value >= 15.1 &&
                                  slider_6_value <= 20.0) {
                                slider_6_text = lista_de_qualidade_6[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3_value +
                                  slider_4_value +
                                  slider_5a_value +
                                  slider_5b_value +
                                  slider_6_value +
                                  slider_7me_value +
                                  slider_7md_value +
                                  slider_8me_value +
                                  slider_8md_value +
                                  slider_9me_value +
                                  slider_9md_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_6_value.toString()),
                          Text("20.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[8],
                  state: steps_status[8],
                  title: Text('Parâmetro 7'),
                  subtitle: Text("Estabilidade dos barrancos"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 2 - Regular: 3 a 5 - Boa: 6 a 8 - Ótima: 9 a 10"),
                      Text("Margem Esquerda"),
                      Text(slider_7me_text),
                      Slider(
                          value: slider_7me_value,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: slider_7me_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_7me_value = newValue;
                              // print(slider_7me_value);
                              if (slider_7me_value >= 0.0 &&
                                  slider_7me_value <= 2.0) {
                                slider_7me_text = lista_de_qualidade_7[0];
                              } else if (slider_7me_value >= 2.1 &&
                                  slider_7me_value <= 5.0) {
                                slider_7me_text = lista_de_qualidade_7[1];
                              } else if (slider_7me_value >= 5.1 &&
                                  slider_7me_value <= 8.0) {
                                slider_7me_text = lista_de_qualidade_7[2];
                              } else if (slider_7me_value >= 8.1 &&
                                  slider_7me_value <= 10.0) {
                                slider_7me_text = lista_de_qualidade_7[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3_value +
                                  slider_4_value +
                                  slider_5a_value +
                                  slider_5b_value +
                                  slider_6_value +
                                  slider_7me_value +
                                  slider_7md_value +
                                  slider_8me_value +
                                  slider_8md_value +
                                  slider_9me_value +
                                  slider_9md_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_7me_value.toString()),
                          Text("10.0")
                        ],
                      ),
                      Text("Margem Direita"),
                      Text(slider_7md_text),
                      Slider(
                          value: slider_7md_value,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: slider_7md_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_7md_value = newValue;
                              // print(slider_7_value);
                              if (slider_7md_value >= 0.0 &&
                                  slider_7md_value <= 2.0) {
                                slider_7md_text = lista_de_qualidade_7[0];
                              } else if (slider_7md_value >= 2.1 &&
                                  slider_7md_value <= 5.0) {
                                slider_7md_text = lista_de_qualidade_7[1];
                              } else if (slider_7md_value >= 5.1 &&
                                  slider_7md_value <= 8.0) {
                                slider_7md_text = lista_de_qualidade_7[2];
                              } else if (slider_7md_value >= 8.1 &&
                                  slider_7md_value <= 10.0) {
                                slider_7md_text = lista_de_qualidade_7[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3_value +
                                  slider_4_value +
                                  slider_5a_value +
                                  slider_5b_value +
                                  slider_6_value +
                                  slider_7me_value +
                                  slider_7md_value +
                                  slider_8me_value +
                                  slider_8md_value +
                                  slider_9me_value +
                                  slider_9md_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_7md_value.toString()),
                          Text("10.0")
                        ],
                      )
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[9],
                  state: steps_status[9],
                  title: Text('Parâmetro 8'),
                  subtitle: Text("Proteção vegetal das margens"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 2 - Regular: 3 a 5 - Boa: 6 a 8 - Ótima: 9 a 10"),
                      Text("Margem Esquerda"),
                      Text(slider_8me_text),
                      Slider(
                          value: slider_8me_value,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: slider_8me_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_8me_value = newValue;
                              // print(slider_8me_value);
                              if (slider_8me_value >= 0.0 &&
                                  slider_8me_value <= 2.0) {
                                slider_8me_text = lista_de_qualidade_8[0];
                              } else if (slider_8me_value >= 2.1 &&
                                  slider_8me_value <= 5.0) {
                                slider_8me_text = lista_de_qualidade_8[1];
                              } else if (slider_8me_value >= 5.1 &&
                                  slider_8me_value <= 8.0) {
                                slider_8me_text = lista_de_qualidade_8[2];
                              } else if (slider_8me_value >= 8.1 &&
                                  slider_8me_value <= 10.0) {
                                slider_8me_text = lista_de_qualidade_8[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3_value +
                                  slider_4_value +
                                  slider_5a_value +
                                  slider_5b_value +
                                  slider_6_value +
                                  slider_7me_value +
                                  slider_7md_value +
                                  slider_8me_value +
                                  slider_8md_value +
                                  slider_9me_value +
                                  slider_9md_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_8me_value.toString()),
                          Text("10.0")
                        ],
                      ),
                      Text("Margem Direita"),
                      Text(slider_8md_text),
                      Slider(
                          value: slider_8md_value,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: slider_8md_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_8md_value = newValue;
                              // print(slider_8md_value);
                              if (slider_8md_value >= 0.0 &&
                                  slider_8md_value <= 2.0) {
                                slider_8md_text = lista_de_qualidade_8[0];
                              } else if (slider_8md_value >= 2.1 &&
                                  slider_8md_value <= 5.0) {
                                slider_8md_text = lista_de_qualidade_8[1];
                              } else if (slider_8md_value >= 5.1 &&
                                  slider_8md_value <= 8.0) {
                                slider_8md_text = lista_de_qualidade_8[2];
                              } else if (slider_8md_value >= 8.1 &&
                                  slider_8md_value <= 10.0) {
                                slider_8md_text = lista_de_qualidade_8[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3_value +
                                  slider_4_value +
                                  slider_5a_value +
                                  slider_5b_value +
                                  slider_6_value +
                                  slider_7me_value +
                                  slider_7md_value +
                                  slider_8me_value +
                                  slider_8md_value +
                                  slider_9me_value +
                                  slider_9md_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_8md_value.toString()),
                          Text("10.0")
                        ],
                      ),
                    ],
                  ),
                ),
                Step(
                  isActive: steps_active[10],
                  state: steps_status[10],
                  title: Text('Parâmetro 9'),
                  subtitle: Text("Cobertura vegetal original das margens"),
                  content: Column(
                    children: <Widget>[
                      Text(
                          "Péssimo: 0 a 2 - Regular: 3 a 5 - Boa: 6 a 8 - Ótima: 9 a 10"),
                      Text("Margem Esquerda"),
                      Text(slider_9me_text),
                      Slider(
                          value: slider_9me_value,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: slider_9me_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_9me_value = newValue;
                              // print(slider_9me_value);
                              if (slider_9me_value >= 0.0 &&
                                  slider_9me_value <= 2.0) {
                                slider_9me_text = lista_de_qualidade_9[0];
                              } else if (slider_9me_value >= 2.1 &&
                                  slider_9me_value <= 5.0) {
                                slider_9me_text = lista_de_qualidade_9[1];
                              } else if (slider_9me_value >= 5.1 &&
                                  slider_9me_value <= 8.0) {
                                slider_9me_text = lista_de_qualidade_9[2];
                              } else if (slider_9me_value >= 8.1 &&
                                  slider_9me_value <= 10.0) {
                                slider_9me_text = lista_de_qualidade_9[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3_value +
                                  slider_4_value +
                                  slider_5a_value +
                                  slider_5b_value +
                                  slider_6_value +
                                  slider_7me_value +
                                  slider_7md_value +
                                  slider_8me_value +
                                  slider_8md_value +
                                  slider_9me_value +
                                  slider_9md_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_9me_value.toString()),
                          Text("10.0")
                        ],
                      ),
                      Text("Margem Direira"),
                      Text(slider_9md_text),
                      Slider(
                          value: slider_9md_value,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: slider_9md_value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              slider_9md_value = newValue;
                              // print(slider_9md_value);
                              if (slider_9md_value >= 0.0 &&
                                  slider_9md_value <= 2.0) {
                                slider_9md_text = lista_de_qualidade_9[0];
                              } else if (slider_9md_value >= 2.1 &&
                                  slider_9md_value <= 5.0) {
                                slider_9md_text = lista_de_qualidade_9[1];
                              } else if (slider_9md_value >= 5.1 &&
                                  slider_9md_value <= 8.0) {
                                slider_9md_text = lista_de_qualidade_9[2];
                              } else if (slider_9md_value >= 8.1 &&
                                  slider_9md_value <= 10.0) {
                                slider_9md_text = lista_de_qualidade_9[3];
                              }
                              soma = (slider_1_value +
                                  slider_2_value +
                                  slider_3_value +
                                  slider_4_value +
                                  slider_5a_value +
                                  slider_5b_value +
                                  slider_6_value +
                                  slider_7me_value +
                                  slider_7md_value +
                                  slider_8me_value +
                                  slider_8md_value +
                                  slider_9me_value +
                                  slider_9md_value);
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("0.0"),
                          Text(slider_9md_value.toString()),
                          Text("10.0")
                        ],
                      ),
                    ],
                  ),
                ),
                Step(
                    isActive: steps_active[11],
                    state: steps_status[11],
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
                              DataCell(Text("P3")),
                              DataCell(Text(slider_3_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P4")),
                              DataCell(Text(slider_4_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P5A")),
                              DataCell(Text(slider_5a_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P5B")),
                              DataCell(Text(slider_5b_value.toString()))
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
                              DataCell(Text("P7-ME")),
                              DataCell(Text(slider_7me_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P7-MD")),
                              DataCell(Text(slider_7md_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P8-ME")),
                              DataCell(Text(slider_8me_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P8-MD")),
                              DataCell(Text(slider_8md_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P9-ME")),
                              DataCell(Text(slider_9me_value.toString()))
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("P9-MD")),
                              DataCell(Text(slider_9md_value.toString()))
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
                                    soma >= 124 && soma <= 200
                                        ? "Ótima"
                                        : soma >= 81 && soma <= 123
                                            ? "Boa"
                                            : soma >= 38 && soma <= 80
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
                                                      var index =
                                                          imgList.indexOf(item);
                                                      setState(() {
                                                        imgList.removeAt(index);
                                                        imgCaptionList
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  )),
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
