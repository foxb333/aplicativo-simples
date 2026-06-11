import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medita em Paz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0175C2),
      ),
      home: const TelaDeTransicao(),
    );
  }
}

// 1. TELA DE TRANSIÇÃO
class TelaDeTransicao extends StatefulWidget {
  const TelaDeTransicao({super.key});

  @override
  State<TelaDeTransicao> createState() => _TelaDeTransicaoState();
}

class _TelaDeTransicaoState extends State<TelaDeTransicao> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _subirAnimacao;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _subirAnimacao = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutBack,
    );

    _fadeController.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const TelaMeditacao(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const corPadrao = Color(0xFF0175C2);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeController,
          child: ScaleTransition(
            scale: _subirAnimacao,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.spa, size: 120, color: corPadrao),
                SizedBox(height: 20),
                Text(
                  'Medita em Paz',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: corPadrao,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 2. TELA PRINCIPAL
class TelaMeditacao extends StatefulWidget {
  const TelaMeditacao({super.key});

  @override
  State<TelaMeditacao> createState() => _TelaMeditacaoState();
}

class _TelaMeditacaoState extends State<TelaMeditacao> with TickerProviderStateMixin {
  Timer? _timer;
  int _segundosPassados = 0;
  int _melhorTempo = 0;
  bool _estaMeditando = false;
  
  final List<String> _historicoPlacar = [];
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _modoVisualAtual = 0; 
  int _indiceCorAtual = 0;
  
  // CORREÇÃO: Variáveis com nomes corrigidos (sem espaços)
  int _metaMinutosSelecionada = 0; 
  int _segundosRestantesRegressivo = 0;
  bool _somAmbienteLigado = false;

  final List<String> _frasesZen = [
    "A paz vem de dentro de você mesmo. Não a procure à sua volta.",
    "Respire fundo. Esqueça o que já passou, foque no agora.",
    "Sua mente é como a água; quando está calma, tudo fica claro.",
    "Atenção plena não é controlar os pensamentos, é não deixar que eles controlem você.",
    "Permita-se apenas ser, aqui e agora.",
  ];
  late String _fraseDoDia;

  final List<Color> _listaDeCores = [
    const Color(0xFF0175C2), Colors.teal, Colors.purple, Colors.deepOrange,
    Colors.indigo, Colors.pink, Colors.amber[800]!, Colors.cyan[700]!,
    Colors.brown[600]!, Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fraseDoDia = _frasesZen[Random().nextInt(_frasesZen.length)];
  }

  void _alternarModoVisual() {
    setState(() { _modoVisualAtual = (_modoVisualAtual + 1) % 4; });
  }

  void _alternarCorTema() {
    setState(() { _indiceCorAtual = (_indiceCorAtual + 1) % _listaDeCores.length; });
  }

  void _alternarMeditacao() {
    if (_estaMeditando) {
      _pararEGravarSessao();
    } else {
      if (_metaMinutosSelecionada > 0 && _segundosRestantesRegressivo == 0) {
        _segundosRestantesRegressivo = _metaMinutosSelecionada * 60;
      }

      setState(() { _estaMeditando = true; });
      _animationController.repeat();
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_metaMinutosSelecionada == 0) {
            _segundosPassados++;
          } else {
            _segundosPassados++;
            _segundosRestantesRegressivo--;
            
            if (_segundosRestantesRegressivo <= 0) {
              _concluirMetaPorTempo();
            }
          }
        });
      });
    }
  }

  void _pararEGravarSessao() {
    _timer?.cancel();
    _animationController.stop();
    
    if (_segundosPassados > 0) {
      setState(() {
        String tipoSessao = _metaMinutosSelecionada > 0 ? "Meta de $_metaMinutosSelecionada min" : "Livre";
        _historicoPlacar.insert(0, "${_formatarTempo(_segundosPassados)} ($tipoSessao)");
        if (_segundosPassados > _melhorTempo) {
          _melhorTempo = _segundosPassados;
        }
      });
    }

    setState(() {
      _estaMeditando = false;
    });
  }

  void _concluirMetaPorTempo() {
    _timer?.cancel();
    _animationController.reset();
    HapticFeedback.vibrate(); 

    _historicoPlacar.insert(0, "${_formatarTempo(_segundosPassados)} (Meta Concluída 🎉)");
    if (_segundosPassados > _melhorTempo) _melhorTempo = _segundosPassados;

    setState(() {
      _estaMeditando = false;
      _segundosPassados = 0;
      _segundosRestantesRegressivo = 0;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.amber),
            SizedBox(width: 10),
            Text("Sino Zen Tocou!"),
          ],
        ),
        content: const Text("Parabéns! Você alcançou o seu objetivo de meditação determinado para hoje. Fique em paz."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Gratidão"),
          )
        ],
      ),
    );
  }

  void _resetarMeditacao() {
    _timer?.cancel();
    _animationController.reset();
    setState(() {
      _segundosPassados = 0;
      _segundosRestantesRegressivo = 0;
      _estaMeditando = false;
    });
  }

  String _formatarTempo(int segundosTotais) {
    int minutos = segundosTotais ~/ 60;
    int segundos = segundosTotais % 60;
    return "${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}";
  }

  Widget _construirVisualCronometro(Color corTema) {
    if (_modoVisualAtual == 0) {
      return RotationTransition(
        turns: _animationController,
        child: Icon(Icons.hourglass_top, size: 100, color: corTema),
      );
    } else if (_modoVisualAtual == 1) {
      return RotationTransition(
        turns: _animationController,
        child: const Icon(Icons.public, size: 100, color: Colors.blue),
      );
    } else if (_modoVisualAtual == 2) {
      int segundoNoMinuto = _segundosPassados % 60;
      int minutoAtual = _segundosPassados ~/ 60;
      bool ehMinutoPar = minutoAtual % 2 == 0;

      double opacidadeSol = 1.0;
      double opacidadeLua = 0.0;

      if (segundoNoMinuto >= 50) {
        double fatorTransicao = (segundoNoMinuto - 50) / 10;
        opacidadeSol = 1.0 - fatorTransicao;
        opacidadeLua = fatorTransicao;
      }

      if (!ehMinutoPar) {
        double temp = opacidadeSol;
        opacidadeSol = opacidadeLua;
        opacidadeLua = temp;
      }

      return Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: opacidadeSol,
            child: const Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
          ),
          Opacity(
            opacity: opacidadeLua,
            child: const Icon(Icons.nightlight_round, size: 100, color: Color(0xFF0A192F)),
          ),
        ],
      );
    } else {
      int minutoAtual = _segundosPassados ~/ 60;
      int segundoNoMinuto = _segundosPassados % 60;
      bool indoParaVerde = minutoAtual % 2 == 0;

      double progresso = segundoNoMinuto / 60.0;
      double fatorCor = indoParaVerde ? progresso : (1.0 - progresso);

      Color corMontanha = Color.lerp(Colors.grey[400], Colors.green[700], fatorCor)!;

      return Icon(Icons.terrain, size: 100, color: corMontanha);
    }
  }

  String _obterNomeModo() {
    switch (_modoVisualAtual) {
      case 0: return "Ampulheta";
      case 1: return "Terra";
      case 2: return "Ciclo Sol/Lua Lento";
      case 3: return "Montanha Mutável";
      default: return "Ampulheta";
    }
  }

  @override
  Widget build(BuildContext context) {
    final corTema = _listaDeCores[_indiceCorAtual];
    
    int segundosExibidos = _metaMinutosSelecionada == 0 
        ? _segundosPassados 
        : (_estaMeditando ? _segundosRestantesRegressivo : _metaMinutosSelecionada * 60);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Medita em Paz', style: TextStyle(color: Colors.white)),
        backgroundColor: corTema,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(_somAmbienteLigado ? Icons.volume_up : Icons.volume_off, color: Colors.white),
            tooltip: "Som de Fundo",
            onPressed: () {
              setState(() { _somAmbienteLigado = !_somAmbienteLigado; });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(_somAmbienteLigado ? "Sons relaxantes ativados 🌧️" : "Sons desativados"),
                duration: const Duration(seconds: 1),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.style, color: Colors.white),
            onPressed: _alternarModoVisual,
          ),
          IconButton(
            icon: const Icon(Icons.palette, color: Colors.white),
            onPressed: _alternarCorTema,
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () { _scaffoldKey.currentState?.openEndDrawer(); },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: corTema),
              child: const Center(
                child: Text(
                  'Placar de Meditação',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Recorde Atual: ${_formatarTempo(_melhorTempo)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: corTema),
              ),
            ),
            const Divider(),
            Expanded(
              child: _historicoPlacar.isEmpty
                  ? const Center(child: Text('Nenhuma meditação salva ainda.'))
                  : ListView.builder(
                      itemCount: _historicoPlacar.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.check_circle, color: corTema),
                          title: Text('Sessão ${_historicoPlacar.length - index}'),
                          subtitle: Text(_historicoPlacar[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: corTema.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '"$_fraseDoDia"',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: corTema),
                ),
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                height: 120,
                width: 120,
                child: Center(child: _construirVisualCronometro(corTema)),
              ),
              const SizedBox(height: 10),
              Text(
                "Visual: ${_obterNomeModo()}",
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
              const SizedBox(height: 15),
              
              Text(
                _formatarTempo(segundosExibidos),
                style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: corTema),
              ),
              
              if (!_estaMeditando) ...[
                const Text("Defina sua Meta de Tempo:", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 5, 10, 15].map((tempo) {
                    bool selecionado = _metaMinutosSelecionada == tempo;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(tempo == 0 ? "Livre" : "${tempo}m"),
                        selected: selecionado,
                        selectedColor: corTema.withOpacity(0.3),
                        onSelected: (val) {
                          setState(() { 
                            _metaMinutosSelecionada = tempo; 
                            _segundosRestantesRegressivo = tempo * 60;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ] else ...[
                Text(
                  _metaMinutosSelecionada == 0 ? "Modo Livre Ativo" : "Focando na Meta programada",
                  style: TextStyle(color: corTema, fontWeight: FontWeight.bold),
                ),
              ],
              
              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: _alternarMeditacao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: corTema,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                icon: Icon(_estaMeditando ? Icons.pause : Icons.play_arrow),
                label: Text(
                  _estaMeditando ? 'Pausar Sessão' : 'Iniciar Meditação',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (_segundosPassados > 0) ...[
                const SizedBox(height: 15),
                TextButton.icon(
                  onPressed: _resetarMeditacao,
                  style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Resetar tudo'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}