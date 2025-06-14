import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/decision.dart';
import '../Models/decisao_final.dart';

class DecisionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveFinalDecision(DecisaoFinal decisaoFinal) async {
    await _firestore
        .collection('users')
        .doc(decisaoFinal.userId)
        .collection('finalDecisions')
        .doc(decisaoFinal.id)
        .set(decisaoFinal.toMap());
  }

  Stream<List<DecisaoFinal>> getFinalDecisions(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('finalDecisions')
        .orderBy('data', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => DecisaoFinal.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<DecisaoFinal?> getFinalDecision(String userId, String decisionId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('finalDecisions')
        .doc(decisionId)
        .get();

    return doc.exists ? DecisaoFinal.fromMap(doc.data()!, doc.id) : null;
  }

  Future<void> deleteFinalDecision(String userId, String decisionId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('finalDecisions')
        .doc(decisionId)
        .delete();
  }


}