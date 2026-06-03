import 'dart:async';
import 'package:flutter/material.dart';

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
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const TelaMeditacao(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.spa, size: 120, color: corPadrao),
                const SizedBox(height: 20),
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

// 2. TELA PRINCIPAL (Modos Visuais Avançados e Customização de Cores)
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
  
  List<String> _historicoPlacar = [];
  late AnimationController _animationController;

  // Modos Visuais: 0 = Ampulheta, 1 = Terra, 2 = Sol/Lua, 3 = Montanha
  int _modoVisualAtual = 0; 

  // Sistema de 10 Cores de Tema (A primeira é o Azul Padrão)
  int _indiceCorAtual = 0;
  final List<Color> _listaDeCores = [
    const Color(0xFF0175C2), // 1. Azul Padrão
    Colors.teal,             // 2. Verde Mental
    Colors.purple,           // 3. Roxo Zen
    Colors.deepOrange,       // 4. Laranja Energia
    Colors.indigo,           // 5. Índigo Noturno
    Colors.pink,             // 6. Rosa Compaixão
    Colors.amber[800]!,      // 7. Âmbar Ouro
    Colors.cyan[700]!,       // 8. Ciano Calmaria
    Colors.brown[600]!,      // 9. Marrom Terra
    Colors.blueGrey,         // 10. Cinza Foco
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  void _alternarModoVisual() {
    setState(() {
      _modoVisualAtual = (_modoVisualAtual + 1) % 4;
    });
  }

  void _alternarCorTema() {
    setState(() {
      _indiceCorAtual = (_indiceCorAtual + 1) % _listaDeCores.length;
    });
  }

  void _alternarMeditacao() {
    if (_estaMeditando) {
      _timer?.cancel();
      _animationController.stop();
      
      if (_segundosPassados > 0) {
        setState(() {
          _historicoPlacar.insert(0, _formatarTempo(_segundosPassados));
          if (_segundosPassados > _melhorTempo) {
            _melhorTempo = _segundosPassados;
          }
        });
      }

      setState(() {
        _estaMeditando = false;
      });
    } else {
      setState(() {
        _estaMeditando = true;
      });
      _animationController.repeat();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _segundosPassados++;
        });
      });
    }
  }

  void _resetarMeditacao() {
    _timer?.cancel();
    _animationController.reset();
    setState(() {
      _segundosPassados = 0;
      _estaMeditando = false;
    });
  }

  String _formatarTempo(int segundosTotais) {
    int minutos = segundosTotais ~/ 60;
    int segundos = segundosTotais % 60;
    return "${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}";
  }

  // Renderizador dos formatos visuais com as novas regras de transição
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
      // REGRA: Transição lenta entre Sol e Lua do segundo 50 ao 60
      int segundoNoMinuto = _segundosPassados % 60;
      int minutoAtual = _segundosPassados ~/ 60;
      bool ehMinutoPar = minutoAtual % 2 == 0;

      double opacidadeSol = 1.0;
      double opacidadeLua = 0.0;

      if (segundoNoMinuto >= 50) {
        // Calcula a evolução de 0.0 a 1.0 nos últimos 10 segundos do minuto
        double fatorTransicao = (segundoNoMinuto - 50) / 10;
        opacidadeSol = 1.0 - fatorTransicao;
        opacidadeLua = fatorTransicao;
      }

      // Inverte os papéis caso o minuto atual seja o da Lua
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
            child: const Icon(Icons.nightlight_round, size: 100, color: Color(0xFF0A192F)), // Azul Escuro profundo
          ),
        ],
      );
    } else {
      // REGRA: Montanha verde até 1 min, volta a ficar cinza até 2 min
      int minutoAtual = _segundosPassados ~/ 60;
      int segundoNoMinuto = _segundosPassados % 60;
      bool indoParaVerde = minutoAtual % 2 == 0;

      double progresso = segundoNoMinuto / 60.0;
      // Se estiver no minuto ímpar, inverte o progresso (voltando do verde para o cinza)
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
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final corTema = _listaDeCores[_indiceCorAtual]; // Captura a cor ativa selecionada pelo usuário
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Medita em Paz', style: TextStyle(color: Colors.white)),
        backgroundColor: corTema,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // Botão 1: Mudar formato visual
          IconButton(
            icon: const Icon(Icons.style, color: Colors.white, size: 26),
            tooltip: "Mudar Formato Visual",
            onPressed: _alternarModoVisual,
          ),
          // Botão 2: Seletor de 10 cores do tema
          IconButton(
            icon: const Icon(Icons.palette, color: Colors.white, size: 26),
            tooltip: "Mudar Cor do Tema",
            onPressed: _alternarCorTema,
          ),
          // Botão 3: Engrenagem do Placar
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
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
                          leading: Icon(Icons.timer, color: corTema),
                          title: Text('Sessão ${_historicoPlacar.length - index}'),
                          trailing: Text(
                            _historicoPlacar[index],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: Center(child: _construirVisualCronometro(corTema)),
            ),
            const SizedBox(height: 10),
            Text(
              "Modo: ${_obterNomeModo()}",
              style: TextStyle(fontSize: 14, color: Colors.grey[500], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              _formatarTempo(_segundosPassados),
              style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: corTema),
            ),
            Text(
              'Seu melhor foi: ${_formatarTempo(_melhorTempo)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
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
                _estaMeditando ? 'Pausar Meditação' : 'Iniciar Meditação',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (_segundosPassados > 0) ...[
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: _resetarMeditacao,
                style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
                icon: const Icon(Icons.refresh),
                label: const Text('Resetar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}