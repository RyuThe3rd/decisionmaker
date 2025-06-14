import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/decision.dart';
//import '../Models/UserProvider.dart'; ///precisa de usuário, ma

class DecisionController extends ChangeNotifier {
  String _titulo = "Nova Decisão"; //titulo Da decisão final
  String _tituloOpcao = "Opção nr 1"; //titulo da Opção
  double _impacto = 1; //peso emocional
  late double _tempoImplementacao;
  late double _tempoImpactoPositivo;
  late double _valor;
  late int _tempo;
  late String descricao;

  bool _showingTutorial = false;
  int _currentTutorialStep = 0;

  bool get showingTutorial => _showingTutorial;
  int get currentTutorialStep => _currentTutorialStep;

  String _termoBusca = '';


  static const Map<String, int> fatoresConversao ={
    'dias': 1,
    'meses': 30,
    'anos': 365
  };

  final ValueNotifier<String> unidadeTempoGlobal = ValueNotifier('dias');
  TextEditingController pesoController = TextEditingController(text: "1"); // 1 à 10
  TextEditingController tituloOpcaoCtrl = TextEditingController();

  TextEditingController tempoImpplementacaoCtrl = TextEditingController();

  TextEditingController tempoImpactoPositivoCtrl = TextEditingController();

  TextEditingController valorCtrl = TextEditingController(); //custo

  TextEditingController tempoCtrl = TextEditingController(); // {'dias': 1 , 'meses': 30 , 'anos', 365}

  //login
  TextEditingController loginController = TextEditingController(text: "Email");
  TextEditingController passwordController = TextEditingController(text: "Password");

  //barra de pesquisa
  //TextEditingController descricaoController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String get termoBusca => _termoBusca;

  DecisionController() {
    // Quando a unidade global muda, atualiza todas as decisions e...
    //o seu valor calculado
    unidadeTempoGlobal.addListener(_atualizarTodasDecisions);
  }

  dynamic Usuario;

  int selectedIndex = 0;
  String selectedTitle = "Decision Maker";


  void setIndex(int n){

    this.selectedIndex = n;
  }

  String get titulo => _titulo;
  double get impacto => _impacto;
  List<Decision> _decisoes = [];

  List<Decision> get decisoes => _decisoes;

  // Simulação de utilizador premium
  bool _isPremium = false;

  get tituloOpcao => _tituloOpcao;

  // Atributo de leitura
  bool isUserPremium() => _isPremium;

  //Método para login como premium
  void autenticarComoPremium() {
    _isPremium = true;
    Usuario = FirebaseAuth.instance.currentUser; // Atualiza com o usuário do Firebase
    selectedIndex = 0; // Garante que a página inicial seja carregada

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  ImageProvider? get userImage {
    if (!isUserPremium()) return null;

    // Se estiver usando Firebase Auth com foto do Google
    final user = FirebaseAuth.instance.currentUser;
    if (user?.photoURL != null) {
      return NetworkImage(user!.photoURL!);
    }


  }



  //Método para logout
  void sairDaConta() async {
    _isPremium = false;
    Usuario = null;
    await FirebaseAuth.instance.signOut(); // Faz logout do Firebase
    notifyListeners();
  }

  void atualizarTitulo(String novoTitulo) {
    _titulo = novoTitulo;
    notifyListeners();
  }

  void atualizarImpacto(double novoValor) {
    _impacto = novoValor;
    pesoController.text = novoValor.toStringAsFixed(0);
    notifyListeners();
  }

  void atualizarImpactoPorTexto(String texto) {
    final valor = double.tryParse(texto);
    if (valor != null && valor >= 1 && valor <= 10) {
      _impacto = valor;
      notifyListeners();
    }
  }

  void _atualizarTodasDecisions() {
    for (var decision in _decisoes) {
      decision.tempo = unidadeTempoGlobal.value;
      decision.valorCalculado = calcularValorFinal(decision);
    }
  }

  void alterarUnidadeTempoGlobal(String novaUnidade) {
    unidadeTempoGlobal.value = novaUnidade;
    // Não precisa chamar notifyListeners() aqui porque o ValueNotifier já notifica
  }

  void adicionarDecision(Decision decisao) {
    decisao.tempo = unidadeTempoGlobal.value; // Sincroniza com a unidade global
    _decisoes.add(decisao);
    notifyListeners();
  }

  void editarDecision(int index, Decision newDecision) {
    if (index >= 0 && index < _decisoes.length) {
      _decisoes[index] = newDecision;
      notifyListeners();
    }
  }

  void removerDecision(int index) {
    if (index >= 0 && index < _decisoes.length) {
      _decisoes.removeAt(index);
      notifyListeners();
    }
  }

  void atualizarTermoBusca(String termo) {
    _termoBusca = termo.toLowerCase();
    notifyListeners();
  }

  List<Decision> get decisoesFiltradas {
    if (_termoBusca.isEmpty) return _decisoes;
    return _decisoes.where((decisao) =>
        decisao.titulo.toLowerCase().contains(_termoBusca)
    ).toList();
  }

  get unidedeDeTempoCtrl => null;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // No DecisionController:

  void atualizarTempoImplementacao(double valor) {
    _tempoImplementacao = valor;
    tempoImpplementacaoCtrl.text = valor.toString();
    notifyListeners();
  }

  void limparForm() {
    tituloOpcaoCtrl.clear();
    valorCtrl.clear();
    tempoImpactoPositivoCtrl.clear();
    tempoImpplementacaoCtrl.clear();
    pesoController.clear();
    notifyListeners();
  }

  void basicoTutorial(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Fecha se possível
    }
    selectedIndex = 1;
    notifyListeners();
  }




  void fecharTutorial() {
    _showingTutorial = false;
    notifyListeners();
  }

  void premiumTutorial(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Fecha se possível
    }
    selectedIndex = 1;
    notifyListeners();
  }

  double calcularValorFinal(Decision decisao) {
    final fator = fatoresConversao[unidadeTempoGlobal.value] ?? 1;
    return ((decisao.tempoDeImpactoPositivo - decisao.tempoDeImplementacao) *
        decisao.pesoEmocional / decisao.valor) * fator;
  }

  /// metodos para calcular decisioes e escolher a melhor decisao
  List<Decision> compararDecisoes() {
    final decisoes = List<Decision>.from(_decisoes);
    decisoes.sort((a, b) {
      final impactoA = calcularValorFinal(a);
      final impactoB = calcularValorFinal(b);
      return impactoB.compareTo(impactoA); // Ordena do maior para o menor
    });
    return decisoes;
  }

  Decision? get melhorDecision {
    if (_decisoes.isEmpty) return null;
    return compararDecisoes().first;
  }
}