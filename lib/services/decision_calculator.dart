import '../Models/decision.dart';

class DecisionCalculator {
  static Decision calcularMelhor(List<Decision> opcoes) {
    final decisoes = List<Decision>.from(opcoes);
    decisoes.sort((a, b) {
      final impactoA = a.valorCalculado;
      final impactoB = b.valorCalculado;
      return impactoB.compareTo(impactoA); // Ordena do maior para o menor
    });
    return decisoes.first;
  }
}