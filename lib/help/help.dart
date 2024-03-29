import 'package:BeraPAR/constants.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  int currentStep = 0;
  int currentStep2 = 0;
  bool complete = false;
  bool complete2 = false;
  var steps_status = [
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
  ];

  var steps_status2 = [
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
    StepState.complete,
  ];

  var steps_active = [
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
    false,
  ];
  var steps_active2 = [
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
    false,
  ];

  final int stepperLenght = 11;
  final int stepperLenght2 = 13;

  var _controllers = [
    YoutubePlayerController(
      initialVideoId: 'ENeOM3YhPeg',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'Xj7b5eZzQbo',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'NBGXQFvjX1Q',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'V_S7tDEiocM',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: '3Ikr5-F-MsA',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'hgZFtofuICs',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: '2ooy38llJvk',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'ytCv-IL5b64',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'l7NVOjabjgg',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'eYxlaH8MqSU',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
  ];

  var _controllers2 = [
    null,
    YoutubePlayerController(
      initialVideoId: 'OWQXST97oM4', // P2
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'wNXo1KEz5pw', // P3
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'ub2AMVW9NLw', // P4
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    null,
    YoutubePlayerController(
      initialVideoId: '5-xT3y2bKDs', // P6
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'Faw_r0TnqyI', // P7
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'i8_v5QPc0DQ', // P8
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'oL9cOkPLfag', // P9
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: '-FrM-MhDP8Y', // P10
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'AyPg4O2jN08', // P11
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    ),
    YoutubePlayerController(
      initialVideoId: 'ra4bQdwu-fA', // P12
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    )
  ];

  bool stepEnded(step) {
    switch (step) {
      case 0:
        return false;
      default:
        return true;
    }
  }

  bool stepEnded2(step) {
    switch (step) {
      case 0:
        return false;
      default:
        return true;
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  goTo2(int step) {
    setState(() => currentStep2 = step);
  }

  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: TabBar(
                  unselectedLabelColor: kPrimaryLightColor,
                  labelColor: kPrimaryColor,
                  indicatorWeight: 2,
                  indicatorColor: kPrimaryColor,
                  tabs: [
                    Tab(text: "PAR Arenito Caiuá"),
                    Tab(text: "PAR Reg. Basáltica"),
                  ]),
            ),
            Container(
              //Add this to give height
              height: MediaQuery.of(context).size.height - 185,
              child: TabBarView(children: [
                Container(
                  child: Expanded(
                    child: Stepper(
                      controlsBuilder: (BuildContext context,
                          {VoidCallback onStepContinue,
                          VoidCallback onStepCancel}) {
                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[],
                            ),
                          ],
                        );
                      },
                      steps: [
                        Step(
                          isActive: steps_active[0],
                          state: steps_status[0],
                          title: Text('Delimitação da Área de Amostragem '),
                          subtitle: Text(""),
                          content: Column(
                            children: <Widget>[
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers[0],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ]),
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
                                  "Os substratos de fundo são os elementos abióticos e matéria orgânica encontrados no fundo dos riachos. Os diferentes substratos são fundamentais para a manutenção do ecossistema aquático e sua biota local, uma vez que a maior variedade e/ou proporção de substratos em potencial disponibilizam diferentes nichos para peixes, macroinvertebrados bentônicos e perifíton, aumentando assim a diversidade biológica. Destaca-se que o substrato de fundo arenoso é inerente à região, e, portanto, integra a paisagem de forma abundante. Portanto, a presença do mesmo não indica necessariamente uma condição ruim para o ambiente, devendo então ser levado em consideração as proporções de areia, cascalhos e seixos, troncos, galhos e folhas caídos na água, bem como a vegetação aquática submersa e deposição de material orgânico em decomposição."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers[1],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ]),
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
                                  "A complexidade do habitat submerso é formada por características físicas do ambiente e os substratos disponíveis no mesmo. Ambientes com margens escavadas, mistura homogênea e estável de troncos, galhos e folhas em contato com a água, criando remansos, pequenas lagoas marginais e pequenas cachoeiras, disponíveis para a biota aquática como refúgio, alimento e local de desova são caracterizados como ideais para a manutenção da diversidade de ecossistemas aquáticos. Quanto maior a diversificação destes hábitats ao longo do trecho, maior a heterogeneidade ambiental e consequente diversidade biológica."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers[2],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active[3],
                          state: steps_status[3],
                          title: Text('Parâmetro 3'),
                          subtitle:
                              Text("Variação de velocidade e profundidade"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "A variação de velocidade e profundidade mede a presença de diferentes regimes nos rios. Riachos de pequeno porte, de fundo essencialmente arenoso, sofrem mais acentuadamente os efeitos da correnteza, visto que mudam sua conformação à medida que o fluxo é interrompido ou acentuado, refletindo na composição e distribuição das comunidades aquáticas. As referências de profundo e rápido são diferentes, devido à dinâmica de modificações constantes no canal. Baseando-se no local “referência” para este protocolo, os regimes de velocidades são categorizados como rápidos quando o fluxo da água atinge mais que 0,2m/s e são profundos quando alcançam mais que 0,20m. A constatação de trechos com maior fluxo de água está associada à formação de pequenas cachoeiras a partir de troncos grandes caídos na água ou acúmulo de material alóctone, que além de canalizarem o fluxo do canal, aumentando sua velocidade, acabam por escavar poços mais profundos devido a queda de água imediatamente acima."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers[3],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
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
                                  "Este parâmetro mede a ocorrência de curvas e meandros ao longo do trecho avaliado. Quanto maior a sinuosidade, maior é a disponibilidade de habitats para as comunidades aquáticas, aliada à maior capacidade de retenção de flutuações de fluxo ocasionadas por chuvas fortes. A absorção de energia pelas curvas protege o curso de água de excessivas erosões e enchentes, e fornece refúgio para a biota durante os eventos de tempestade. Levando em consideração a geologia e geomorfologia regionais, a formação de curvas e meandros nos canais é de suma importância para conter a lavagem e erosão ocorrida com o aumento do fluxo provocado por chuvas fortes, fornecendo proteção ao carreamento de estruturas promotoras de complexidade ambiental, estabilidade de substrato e dos próprios organismos."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers[4],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active[5],
                          state: steps_status[5],
                          title: Text('Parâmetro 5A e 5B'),
                          subtitle: Text(
                              "Escoamento do canal/ Flutuações de nível do canal"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "As flutuações de nível do canal estão relacionadas com a disponibilidade de substrato e demais locais disponíveis para as comunidades aquáticas. A falta dos mesmos tende a impor restrições à sobrevivência e ao desenvolvimento destas comunidades. Para os rios da região, é imprescindível a avaliação ao longo de um período prolongado, devido às influências de seca e chuva no nível da água e principalmente devido à dificuldade de estabelecimento de uma marca de água nas margens do canal, já que o substrato é composto essencialmente por areia e as margens possuem acúmulo de matéria orgânica recente."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers[5],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active[6],
                          state: steps_status[6],
                          title: Text('Parâmetro 6'),
                          subtitle: Text("Alterações no canal"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Perturbações impostas a corpos aquáticos relacionadas a modificações da estrutura de seus canais impõem condições desfavoráveis à sobrevivência e reprodução de comunidades aquáticas. Existem espécies com requerimentos muito específicos em termos de habitats e qualquer divergência nesses padrões pode levar a eliminação das mesmas nas comunidades afetadas. A formação de diques, dragagens, aterros, drenagens, barragens, pavimento e desvio de fluxo são fatores que contribuem para as perturbações em riachos. A presença dos mesmos influencia a seletividade de espécies mais resistentes, dificultando e até mesmo impedindo a estabilização e manutenção de um equilíbrio ambiental."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers[6],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active[7],
                          state: steps_status[7],
                          title: Text('Parâmetro 7'),
                          subtitle: Text("Estabilidade dos barrancos"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "A estabilidade dos barrancos está estreitamente associada à presença de vegetação enraizada, ou mesmo da serrapilheira, que promove a coesão das partículas de areia e diminui os efeitos da erosão. Estende-se como barranco o trecho de solo imediatamente adjacente ao corpo aquático estudado, sem levar em conta a ocupação do solo das áreas do entorno. A região do Arenito Caiuá apresenta solos pouco coesos e naturalmente suscetíveis à erosão, razão pela qual o afloramento de riachos tende a escavar naturalmente o terreno, expondo margens íngremes, com angulação acentuada. Quando processos antrópicos aliados aos climáticos aceleram o processo de erosão, alcançando locais de inserção de árvores de grande porte, há o desprendimento das mesmas, causando obstruções no canal, forçando o afloramento do fluxo por outros caminhos."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers[7],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active[8],
                          state: steps_status[8],
                          title: Text('Parâmetro 8'),
                          subtitle: Text("Proteção vegetal das margens"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Os efeitos positivos da mata ciliar na filtragem superficial de sedimentos, na estabilização oferecida pelas raízes e no sombreamento dos corpos aquáticos. Visto que as matas ciliares são as formações vegetais mais impactadas pelas atividades humanas, sendo retiradas para implantação de culturas, pastagens e urbanização, este parâmetro avalia a presença da proteção oferecida pelas matas aos corpos aquáticos em detrimento do uso para fins antrópicos. No caso de riachos urbanos, as construções que alcançam as margens imediatas de corpos aquáticos provocam impermeabilização do solo e consequente interrupção da infiltração da água pluvial, além do aumento do aporte de sedimentos e material sólido possivelmente contaminante. Para este parâmetro é avaliado o padrão de ocupação da área de entorno do corpo aquático, estimando a quantidade de vegetação natural disponível ao longo das margens, em detrimento da ocupação para agricultura, pastagem e urbanização (a nota é atribuída separadamente para cada margem)."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers[8],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active[9],
                          state: steps_status[9],
                          title: Text('Parâmetro 9'),
                          subtitle:
                              Text("Cobertura vegetal original das margens"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "As matas ciliares atuam como barreira física para contenção de substâncias provenientes dos ambientes terrestres aos aquáticos, apresentando papel fundamental na estruturação e dinâmica das áreas de contato destes dois ecossistemas. O suporte necessário para o estabelecimento e desenvolvimento de formações ciliares está intimamente relacionado aos fatores geológicos, geomorfológicos, hidrológicos e climáticos, apresentando diferentes feições de acordo com as combinações regionais de tais fatores. O presente protocolo, adaptado para região de domínio da Floresta Estacional Semidecidual pretende avaliar o estado de conservação da vegetação ciliar como um todo, admitindo as condições ecológicas distintas e variáveis das composições florísticas de matas que margeiam cursos de água. Aqui são verificadas as proporções de espécies nativas e exóticas, em especial de porte arbóreo. A presença das últimas podem revelar uma formação reflorestada, posterior a episódios de desmatamento e degradação. Para este parâmetro, os impactos antrópicos considerados são a presença de trilhas e corte raso, além de episódios de queimadas e desmatamento. Para cada margem é atribuída uma nota na avaliação deste parâmetro."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers[9],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active[10],
                          state: steps_status[10],
                          title: Text('Condição de conservação'),
                          subtitle: Text("Pontuação"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "O valor final do protocolo é obtido por meio das somatória das notas atribuídas a cada parâmetro refletindo o estado de conservação de trecho analisado, então compare a nota da somatória com a tabela de Condição de Conservação."),
                              Text(""),
                              Text(
                                  "Saiba mais sobre o PAR do Arenito Caiuá acessando o livro pelo botão abaixo:"),
                              SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  onPressed: () async {
                                    String url =
                                        "https://drive.google.com/file/d/15sVknJfPvLeLYdbpnA2R1dSpItiQBqyM/view";
                                    var urllaunchable = await canLaunch(
                                        url); //canLaunch is from url_launcher package
                                    if (urllaunchable) {
                                      await launch(
                                          url); //launch is from url_launcher package to launch URL
                                    } else {
                                      print("URL can't be launched.");
                                    }
                                  },
                                  child: Text("Livro PAR Arenito Caiuá",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active[11],
                          state: steps_status[11],
                          title: Text('Agradecimentos'),
                          subtitle: Text(""),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Este projeto foi desenvolvido por uma parceria entre o Laboratório de Ecologia Energética e o Laboratório Manna Team da Universidade Estadual de Maringá, tendo como objetivo desenvolver uma versão de aplicativo para dispositivos móveis do Protocolo de Avaliação Rápida, disseminando sua usabilidade, contribuindo com o monitoramento morfológico de riachos e a educação ambiental."),
                              Text(""),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image.asset("assets/images/ecologia.jpeg",
                                        width: 100),
                                    Image.asset(
                                        "assets/images/manna-scientist-circle.png",
                                        width: 100),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image.asset("assets/images/nupelia.png",
                                        width: 100),
                                    Image.asset("assets/images/icmbio.png",
                                        width: 100),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image.asset("assets/images/uem.png",
                                        width: 100),
                                    Image.asset("assets/images/cnpq.png",
                                        width: 100),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image.asset(
                                        "assets/images/fundacao_araucaria.png",
                                        width: 100),
                                    Image.asset("assets/images/capes.png",
                                        width: 100),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image.asset("assets/images/boticario.png",
                                        width: 100),
                                  ]),
                              // SliverGrid.count(
                              //     mainAxisSpacing: 1, //horizontal space
                              //     crossAxisSpacing: 1, //vertical space
                              //     crossAxisCount: 2,
                              //     children: [

                              //
                              //
                              //
                              //
                              //       Image.asset("assets/images/fundacao_araucaria.png",
                              //           width: 100),
                              //       Image.asset("assets/images/capes.png", width: 100),
                              //       Image.asset("assets/images/boticario.png", width: 100),
                              //     ]),
                            ],
                          ),
                        ),
                      ],
                      currentStep: currentStep,
                      onStepTapped: (step) => goTo(step),
                    ),
                  ),
                ),
                Container(
                  child: Expanded(
                    child: Stepper(
                      controlsBuilder: (BuildContext context,
                          {VoidCallback onStepContinue,
                          VoidCallback onStepCancel}) {
                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[],
                            ),
                          ],
                        );
                      },
                      steps: [
                        Step(
                          isActive: steps_active2[0],
                          state: steps_status2[0],
                          title: Text('Parâmetro 1'),
                          subtitle: Text(
                              "Principal atividade no uso e ocupação do solo nos 50m ao redor do riacho"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Aqui vamos avaliar o uso e ocupação do solo nos 50 metros ao redor das margens do riacho,  identificando se essa área está sujeita a impactos antrópicos e quais são eles."),
                              Text(
                                  "Para isso, analisamos a presença de vegetação natural como árvores, arbustos e herbáceas ao redor  da margem, quanto maior a diversidade dessa vegetação melhor são as condições de preservação.  Buscamos também analisar se há pastos e áreas de cultivo e de zona urbana, como comércios,  residências e indústrias."),
                              Text(""),
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[1],
                          state: steps_status2[1],
                          title: Text('Parâmetro 2'),
                          subtitle: Text(
                              "Alterações antrópicas próximas e/ou no canal do riacho"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Neste parâmetro precisamos avaliar as alterações antrópicas próximas e no canal do riacho,  para isso, precisamos observar as alterações que podem provocar mudança na dinâmica do curso natural."),
                              Text(
                                  "Por isso analisaremos a presença de canos de esgoto, descarte de entulhos e lixo nas margens e nos leitos, bem como a presença de animais domésticos nas proximidades do leito, já que estes podem  danificar de forma direta ou indireta a biota aquática dos riachos."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers2[1],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[2],
                          state: steps_status2[2],
                          title: Text('Parâmetro 3'),
                          subtitle: Text("Estabilidade dos barrancos"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Neste parâmetro iremos avaliar o trecho do solo adjacente ao corpo aquático estudado, não levando em conta a ocupação do solo das áreas do entorno."),
                              Text(
                                  "Barrancos estáveis possuem a mínima ocorrência de processos erosivos, ou seja, solo bem  assentado, com alta presença de macroporos e raízes de árvores expostas, assim como  ausência de vegetação ao longo das margens dos riachos."),
                              Text(
                                  "Quando processos antrópicos aliados aos climáticos aceleram o processo de erosão, alcançando locais de inserção de árvores de grande porte, há o desprendimento das mesmas, causando obstruções no canal, forçando o afloramento do fluxo por outros caminhos."),
                              Text(
                                  "É importante lembrar que as margens esquerda  e direita devem ser avaliadas separadamente."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers2[2],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[3],
                          state: steps_status2[3],
                          title: Text('Parâmetro 4'),
                          subtitle: Text("Proteção vegetal das margens"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Nesse parâmetro avaliamos a quantidade de vegetação disponível nas margens do riacho,  buscando a ausência ou pouca ocupação de agricultura, pastagem e urbanização."),
                              Text(
                                  "Margens com crescimento abundante de vegetação natural oferecem melhores condições à biota, pois as raízes das plantas que crescem nas margens dos riachos ajudam a segurar o solo  no local, e reduzem a quantidade de sedimentos e material sólido para o leito do riacho."),
                              Text(
                                  "Aqui são verificadas as proporções de espécies nativas e exóticas, em especial de porte arbóreo. A presença das últimas pode revelar uma formação reflorestada, posterior a episódios de desmatamento e degradação. Para este parâmetro, os impactos antrópicos considerados são a presença de trilhas e corte raso, além de episódios de queimadas e desmatamento. Para cada margem é atribuída uma nota na avaliação deste parâmetro."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers2[3],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[4],
                          state: steps_status2[4],
                          title: Text('Parâmetro 5'),
                          subtitle: Text("Odor da água"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "O parâmetro Odor da água corresponde à sensação olfativa proveniente da água do  riacho, caso haja a presença de despejos de resíduos domésticos e industriais no leito do riacho  estes sofrerão o processo de decomposição, resultando em odores exalados pelo corpo aquático,  denunciando desta forma poluição hídrica."),
                              Text(""),
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[5],
                          state: steps_status2[5],
                          title: Text('Parâmetro 6'),
                          subtitle:
                              Text("Presença de óleo e/ou espuma na água"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Este parâmetro avalia se ocorre a presença de óleo e espuma no leito dos riachos geralmente podendo ser observado em remansos,  proveniente de despejos de resíduos e efluentes urbanos e industriais."),
                              Text(
                                  "A pequena solubilidade dos óleos acarreta em problemas de origem estética e diminui a área de contato entre a  superfície e o ar atmosférico, impedindo a transferência do oxigênio da atmosfera  para a água, afetando negativamente a biota aquática."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers2[5],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[6],
                          state: steps_status2[6],
                          title: Text('Parâmetro 7'),
                          subtitle: Text("Transparênca/Coloração da água"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Nesse parâmetro buscamos avaliar a transparência e a coloração da água. O excesso de  materiais em suspensão na coluna de água pode ser proveniente de poluentes antrópicos, como  esgotos domésticos e industriais, podendo levar a alteração de cor da água do riacho. O  monitoramento deste parâmetro a longo prazo pode fornecer informações sobre a saúde geral  de um riacho, pois durante o monitoramento podem ser detectadas mudanças da transparência  e cor da água ao longo do tempo."),
                              Text(
                                  "Devemos tomar cuidado ao analisar esse parâmetro, tendo em vista que a presença de matéria orgânica ou movimentação na água pode deixar ela turva."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers2[6],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[7],
                          state: steps_status2[7],
                          title: Text('Parâmetro 8'),
                          subtitle:
                              Text("Alterações estruturais no canal do riacho"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "O atributo alterações no canal do riacho visa avaliar mudanças em grande escala na forma do  canal dos riachos como presença de diques, aterros, terraplenagem, barragens, construção de  pontes ou qualquer ação que modifique o curso natural da água dos riachos. A presença dos mesmos influencia a seletividade de espécies mais resistentes, dificultando e até mesmo impedindo a estabilização e manutenção de um equilíbrio ambiental."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers2[7],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[8],
                          state: steps_status2[8],
                          title: Text('Parâmetro 9'),
                          subtitle: Text("Sinuosidade do canal"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "O parâmetro sinuosidade do canal avalia a ocorrência de curvas ao longo dos riachos."),
                              Text(
                                  "A alta quantidade de curvas no riacho fornece uma diversidade de habitat e de fauna em  relação a riachos poucos sinuosos. Quando ocorrem oscilações de fluxo, como em fortes  chuvas, por exemplo, riachos mais sinuosos são capazes de absorver energia nas curvas,  evitando erosão excessiva do leito."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers2[8],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[9],
                          state: steps_status2[9],
                          title: Text('Parâmetro 10'),
                          subtitle: Text("Tipos de substrato de fundo"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Neste parâmetro vamos avaliar tipos de substrato de fundo, riachos com substratos uniformes  sustentam uma menor gama de organismos em relação a riachos com diferentes tipos de  substratos."),
                              Text(
                                  "Aqui devemos identificar os habitats submersos mais firmes como seixos e grânulos  e plantas aquáticas enraizadas que abrigam ampla variedade de organismos em detrimento de  riachos com predomínio no fundo de lama, argila e sem plantas aquáticas."),
                              Text(
                                  "Quanto maior a diversificação destes hábitats ao longo do trecho, maior será a heterogeneidade ambiental e consequente diversidade biológica."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers2[9],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[10],
                          state: steps_status2[10],
                          title: Text('Parâmetro 11'),
                          subtitle: Text("Complexidade do habitat submerso"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Para este parâmetro devemos avaliar a quantidade e a variedade de estruturas naturais dos  riachos, tais como: lajes, matacões, cascalhos, troncos e galhos de árvores caídos, presença de  remansos, pequenas lagoas e cachoeiras, além de margens escavadas disponíveis para a biota  aquática como refúgio, alimento e local de desova."),
                              Text(
                                  "Uma mistura homogênea e estável de troncos, galhos e folhas submersos propicia a formação  de habitats ideais para a manutenção da diversidade da biota aquática."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers2[10],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[11],
                          state: steps_status2[11],
                          title: Text('Parâmetro 12'),
                          subtitle: Text("Depósitos sedimentares"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Nesse parâmetro vamos analisar a extensão na qual estruturas do leito do riacho estão  cobertos pela fração areia, silte ou argila, o que reduz a área de superfície disponível para biota  aquática."),
                              Text(
                                  "Altos níveis de sedimentos são sintomas de um ambiente instável e em constante mudança, podendo ser inadequado para muitos organismos."),
                              Text(""),
                              YoutubePlayer(
                                  controller: _controllers2[11],
                                  liveUIColor: Colors.amber,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                      isExpanded: true,
                                    ),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ])
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[12],
                          state: steps_status2[12],
                          title: Text('Condição de conservação'),
                          subtitle: Text("Pontuação"),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "O valor final do protocolo é obtido por meio das somatória das notas atribuídas a cada parâmetro refletindo o estado de conservação de trecho analisado, então compare a nota da somatória com a tabela de Condição de Conservação."),
                              Text(""),
                            ],
                          ),
                        ),
                        Step(
                          isActive: steps_active2[13],
                          state: steps_status2[13],
                          title: Text('Agradecimentos'),
                          subtitle: Text(""),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  "Este projeto foi desenvolvido por uma parceria entre o Laboratório de Ecologia Energética e o Laboratório Manna Team da Universidade Estadual de Maringá, tendo como objetivo desenvolver uma versão de aplicativo para dispositivos móveis do Protocolo de Avaliação Rápida, disseminando sua usabilidade, contribuindo com o monitoramento morfológico de riachos e a educação ambiental."),
                              Text(""),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image.asset("assets/images/ecologia.jpeg",
                                        width: 100),
                                    Image.asset(
                                        "assets/images/manna-scientist-circle.png",
                                        width: 100),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image.asset("assets/images/nupelia.png",
                                        width: 100),
                                    Image.asset("assets/images/icmbio.png",
                                        width: 100),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image.asset("assets/images/uem.png",
                                        width: 100),
                                    Image.asset("assets/images/cnpq.png",
                                        width: 100),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image.asset(
                                        "assets/images/fundacao_araucaria.png",
                                        width: 100),
                                    Image.asset("assets/images/capes.png",
                                        width: 100),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image.asset("assets/images/boticario.png",
                                        width: 100),
                                  ]),
                            ],
                          ),
                        ),
                      ],
                      currentStep: currentStep2,
                      onStepTapped: (step) => goTo2(step),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    ]);
  }
}

// import 'package:flutter/material.dart';

// // @TODO
// // - Adicionar logos dos órgãos, laboratórios, grupos,... envolvidos
// // - Vídeo de até 10 min mostrando o uso da plataforma
// // - Link para os termos de uso
// // - Link para política de privacidade

// class HelpPage extends StatefulWidget {
//   @override
//   _HelpPageState createState() => _HelpPageState();
// }

// class _HelpPageState extends State<HelpPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//           child: Column(children: [
//         //Text("Help"),
//         Text("Como utilizar o Protocolo de Avaliação Rápida (PAR)",
//             style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
//         Text(
//             "1. Entre no Maps e clique localização do riacho a ser avaliado, aparecerá um formulário que deve ser preenchido; ",
//             style: TextStyle(fontSize: 15),
//             textAlign: TextAlign.justify),
//         Text(
//             "2. Após o cadastro inicial clique novamente no ponto atribuido a localização do riacho, onde irá abrir o PAR;",
//             style: TextStyle(fontSize: 15),
//             textAlign: TextAlign.justify),
//         Text(
//             "3. O PAR possui 9 parâmetros que devem ser analisados. A cada parâmetro é atribuído um gradiente de estresse, classificado em quatro categorias: 'ótima' (nota de 16 a 20), 'boa', (nota 11 a 15), ' regular' (nota 6 a 10) e 'péssima' (nota 0 a 5). As notas são dadas a partir da inspeção visual da condição física do ambiente avaliado;",
//             style: TextStyle(fontSize: 15),
//             textAlign: TextAlign.justify),
//         Text(
//             "4. O valor final do protocolo é obtido por meio das somatória das notas atribuídas a cada parâmetro refletindo o estado de conservação de trecho analisado, então compare a nota da somatória com a tabela de Condição de Conservação.",
//             style: TextStyle(fontSize: 15),
//             textAlign: TextAlign.justify),
//         Container(
//           padding: EdgeInsets.all(14),
//           child: Text(
//               "O aplicativo foi desenvolvido por meio do projeto do Progama de Bolsas de Iniciação em Desenvolvimento Técnológico e Inovação em parceria com o Laboratório de Ecologia Energética da UEM e o projeto MannaTeam, financiado pelo CNPq.",
//               textAlign: TextAlign.justify),
//         ),
//       ])),
//     );
//   }
// }
