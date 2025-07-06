import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/decision_controller.dart';
import '../Models/decisao_final.dart';
import '../widgets/decision_editor.dart';

class HistoricoPage extends StatelessWidget {
  const HistoricoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DecisionController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Decisões'),
      ),
      body: StreamBuilder<List<DecisaoFinal>>(
        stream: controller.carregarHistorico(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final decisoes = snapshot.data ?? [];

          if (decisoes.isEmpty) {
            return const Center(child: Text('Nenhuma decisão salva ainda'));
          }

          return ListView.builder(
            itemCount: decisoes.length,
            itemBuilder: (context, index) {
              final decisao = decisoes[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(decisao.nome),
                  subtitle: Text(
                    '${decisao.decisoes.length} opções - ${decisao.data.toString()}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          controller.editarDecisaoFinal(decisao.id);
                          Navigator.pop(context);
                          controller.setIndex(1);
                          // Navega para a tela de editor
                          }
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _excluirDecisao(context, decisao.id),
                      ),
                    ],
                  ),
                  onTap: () => _mostrarDetalhes(context, decisao),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _mostrarDetalhes(BuildContext context, DecisaoFinal decisao) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(decisao.nome),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Data: ${decisao.data.toString()}'),
            const SizedBox(height: 16),
            const Text('Opções:'),
            ...decisao.decisoes.map((d) => ListTile(
              title: Text(d.titulo),
              subtitle: Text('Impacto: ${d.tempoDeImpactoPositivo}'),
            )).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _excluirDecisao(BuildContext context, String id) async {
    final controller = Provider.of<DecisionController>(context, listen: false);
    await controller.deleteFinalDecision(id);
  }
}