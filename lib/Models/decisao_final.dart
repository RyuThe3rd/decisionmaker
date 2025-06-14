import 'package:cloud_firestore/cloud_firestore.dart';
import 'decision.dart';

class DecisaoFinal {
  final String id;
  final String userId;
  final String nome;
  final DateTime data;
  final List<Decision> decisoes;

  DecisaoFinal({
    required this.id,
    required this.userId,
    required this.nome,
    required this.data,
    required this.decisoes,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome, //Nome da Decisão
      'userId': userId,
      'data': Timestamp.fromDate(data),
      'decisoes': decisoes.map((d) => d.toMap()).toList(),
    };
  }

  factory DecisaoFinal.fromMap(Map<String, dynamic> map, String id) {
    return DecisaoFinal(
      id: id,
      userId: map['userId'] ?? '',
      nome: map['nome'] ?? '',
      data: (map['data'] as Timestamp).toDate(),
      decisoes: List<Decision>.from(
          (map['decisoes'] ?? []).map((d) => Decision.fromMap(d))),
    );
  }
}