import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/decisao_final.dart';
import '../Models/decision.dart';
import '../services/decision_service.dart';
//import '../Models/UserProvider.dart'; ///precisa de usuário, ma

class DecisionController extends ChangeNotifier {
  static final DecisionController _instance = DecisionController._internal();
  String _titulo = "Nova Decisão"; //titulo Da decisão final
  String _tituloOpcao = "Opção nr 1"; //titulo da Opção
  double _impacto = 1; //peso emocional
  late double _tempoImplementacao;
  late double _tempoImpactoPositivo;
  late double _valor;
  late int _tempo;
  late String descricao;
  final DecisionService _decisionService = DecisionService();
  String? _editingDecisionId;

  void setTitulo(String novoTitulo) {
    _titulo = novoTitulo;
    tituloDecisaoFinal.text = novoTitulo; // Atualiza o TextEditingController
    notifyListeners(); // Importante para widgets ouvirem mudanças
  }


  bool _showingTutorial = false;
  int _currentTutorialStep = 0;

  bool get showingTutorial => _showingTutorial;
  int get currentTutorialStep => _currentTutorialStep;
  bool get isEditing => _editingDecisionId != null;
  String? get editingDecisionId => _editingDecisionId;

  String _termoBusca = '';


  static const Map<String, int> fatoresConversao ={
    'dias': 1,
    'meses': 30,
    'anos': 365
  };

  void _atualizarTodasDecisions() {
    for (var decision in _decisoes) {
      decision.tempo = unidadeTempoGlobal.value;
      decision.valorCalculado = calcularValorFinal(decision);
    }
  }

  DecisionController._internal() {
    unidadeTempoGlobal.addListener(_atualizarTodasDecisions);
  }

  static DecisionController get instance => _instance;

  final ValueNotifier<String> unidadeTempoGlobal = ValueNotifier('dias');

  TextEditingController pesoController = TextEditingController(text: "1"); // 1 à 10
  TextEditingController tituloOpcaoCtrl = TextEditingController();

  TextEditingController tituloDecisaoFinal = TextEditingController();

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
    return null;
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


  void alterarUnidadeTempoGlobal(String novaUnidade) {
    unidadeTempoGlobal.value = novaUnidade;
    // Não precisa chamar notifyListeners() aqui porque o ValueNotifier já notifica
  }

  void adicionarDecision(Decision decisao) {
    decisao.tempo = unidadeTempoGlobal.value; // Sincroniza com a unidade global
    decisao.valorCalculado = calcularValorFinal(decisao);
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
    final valor = decisao.valor == 0 ? 1 : decisao.valor;
    return ((decisao.tempoDeImpactoPositivo - decisao.tempoDeImplementacao) *
        decisao.pesoEmocional / valor) * fator;
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

  Future<void> salvarDecisaoFinal() async {
    if (Usuario == null || _decisoes.isEmpty) return;

    final decisaofinal = DecisaoFinal(
      id: _editingDecisionId ?? FirebaseFirestore.instance.collection('finalDecisions').doc().id,
      userId: Usuario!.uid,
      nome: _titulo,
      data: DateTime.now(),
      decisoes: _decisoes,
    );

    await _decisionService.saveFinalDecision(decisaofinal);

    _resetEditingState();
  }

  void _resetEditingState() {
    _decisoes.clear();
    _titulo = "Nova Decisão";
    tituloDecisaoFinal.text = "";
    _editingDecisionId = null;
    notifyListeners();
  }

  void cancelarEdicao() {
    _resetEditingState();
  }

  Stream<List<DecisaoFinal>>? carregarHistorico() {
    if (Usuario == null) return Stream.value([]);
    return _decisionService.getFinalDecisions(Usuario!.uid);
  }

  Future<void> deleteFinalDecision(String decisionId) async {
    if (Usuario == null) return;
    await _decisionService.deleteFinalDecision(Usuario!.uid, decisionId);
    notifyListeners();
  }

  Future<void> editarDecisaoFinal(String decisionId) async {
    if (Usuario == null) return;

    _editingDecisionId = decisionId;
    final decisaoFinal = await _decisionService.getFinalDecision(Usuario!.uid, decisionId);

    if (decisaoFinal != null) {
      _decisoes = List<Decision>.from(decisaoFinal.decisoes);
      setTitulo(decisaoFinal.nome);
      //notifyListeners(); no need for it
    }
  }
}