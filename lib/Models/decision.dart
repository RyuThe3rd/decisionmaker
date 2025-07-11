class Decision {
  final String titulo;
  late String descricao;
  late double valor; //CUSTO! ISTO É O CUSTO, este é o denominador
  final double tempoDeImpactoPositivo;
  final double tempoDeImplementacao;
  final int pesoEmocional;
  String tempo; // dias, meses, anos
  double valorCalculado; //ESTE É O RESULTADO DO CALCULO

  Decision({
    this.valorCalculado = -1,
    required this.titulo,
    required this.valor,
    required this.tempoDeImplementacao,
    required this.tempoDeImpactoPositivo,
    required this.pesoEmocional,
    this.tempo = "dias",
    this.descricao = "",
  });


  Map<String, dynamic> toMap() {
    return {
      'title': titulo,
      'value': valor,
      'impactTime': tempoDeImpactoPositivo,
      'implementationTime': tempoDeImplementacao,
      'emotionalWeight': pesoEmocional,
      'timeUnit': tempo,
      'finalDecisionValue': valorCalculado,
    };
  }

  factory Decision.fromMap(Map<String, dynamic> map) {
    return Decision(
      valorCalculado: (map['finalDecisionValue'] ?? -1).toDouble(),
      titulo: map['title'] ?? '',
      valor: (map['value'] ?? 0).toDouble(),
      tempoDeImpactoPositivo: (map['impactTime'] ?? 0).toDouble(),
      tempoDeImplementacao: (map['implementationTime'] ?? 0).toDouble(),
      pesoEmocional: (map['emotionalWeight'] ?? 1).toInt(),
      tempo: map['timeUnit']?.toLowerCase() ?? 'dias',
    );
  }
}