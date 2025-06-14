import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/decision.dart';
import '../controllers/decision_controller.dart';
import '../controllers/tutorial_provider.dart';
import 'widgets/slider_controlado.dart';
import 'widgets/tutorial_overlay.dart';
import '../services/decision_calculator.dart';

class DecisionEditor extends StatelessWidget {
  final bool mostrarDialogos;

  const DecisionEditor({this.mostrarDialogos = false, super.key});

  Widget _buildDecisionTile(
      BuildContext context,
      DecisionController controller,
      Decision decisao,
      int index,
      ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(decisao.titulo),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Valor: ${decisao.valor.toStringAsFixed(2)}'),
            Text('Impacto: ${decisao.calcularImpacto().toStringAsFixed(2)}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _mostrarDialogoEdicao(context, decisao, index),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => controller.removerDecision(index),
            ),
          ],
        ),
        onTap: () => _showDetailsDialog(context, decisao),
      ),
    );
  }

  void _mostrarDialogoEdicao(
      BuildContext context,
      Decision decisao,
      int index,
      ) {
    final controller = Provider.of<DecisionController>(context, listen: false);
    final titleController = TextEditingController(text: decisao.titulo);
    final valueController = TextEditingController(
      text: decisao.valor.toString(),
    );
    final impactController = TextEditingController(
      text: decisao.tempoDeImpactoPositivo.toString(),
    );
    final implementationController = TextEditingController(
      text: decisao.tempoDeImplementacao.toString(),
    );
    final weightController = TextEditingController(
      text: decisao.pesoEmocional.toString(),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: Text("Editar Opção"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Título"),
              ),
              TextField(
                controller: valueController,
                decoration: InputDecoration(labelText: "Valor"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: impactController,
                decoration: InputDecoration(labelText: "Tempo de Impacto"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: impactController,
                decoration: InputDecoration(
                  labelText: "Tempo de Implementação",
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: "Peso Emocional (1-10)",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              final editedDecision = Decision(
                titulo: titleController.text,
                valor:
                double.tryParse(valueController.text) ?? decisao.valor,
                tempoDeImpactoPositivo:
                double.tryParse(impactController.text) ??
                    decisao.tempoDeImpactoPositivo,
                tempoDeImplementacao:
                double.tryParse(impactController.text) ??
                    decisao.tempoDeImplementacao,
                pesoEmocional:
                int.tryParse(weightController.text) ??
                    decisao.pesoEmocional,
              );

              controller.editarDecision(index, editedDecision);
              Navigator.pop(context);
            },
            child: Text("Salvar"),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Decision decisao) {
    final descricaoController = TextEditingController(text: decisao.descricao);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: Text(decisao.titulo),
        content: TextField(
          controller: descricaoController,
          maxLines: 3, // Permite múltiplas linhas
          decoration: InputDecoration(
            hintText: "Insira a descrição da opção",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              // Atualiza a descrição e fecha o diálogo
              decisao.descricao = descricaoController.text;
              Navigator.pop(context);

              // Opcional: Notifica os ouvintes (se usar ChangeNotifier)
              /* if (decisao is ChangeNotifier) {
                decisao.notifyListeners();
              }*/
            },
            child: Text("Salvar"),
          ),
        ],
      ),
    );
  }

  void _mostrarAjuda(BuildContext context, String mensagem) {
    if (mostrarDialogos) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
          title: const Text("Ajuda"),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Entendi"),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DecisionController>(context);
    final tutorialProvider = Provider.of<TutorialProvider>(context);

    return Stack(
        children:[ Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              /// Título Principal
              GestureDetector(
                onTap:
                    () => _mostrarAjuda(
                  context,
                  "Insira o título da decisão (ex: Comprar carro).",
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: "Título da Decisão",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: controller.atualizarTitulo,
                ),
              ),
              Divider(indent: 10, endIndent: 10),
              const SizedBox(height: 10),

              /// Título da Opção
              GestureDetector(
                onTap:
                    () => _mostrarAjuda(
                  context,
                  "Nomeie a opção (ex: Carro elétrico).",
                ),
                child: TextField(
                  controller: controller.tituloOpcaoCtrl,
                  decoration: const InputDecoration(
                    labelText: "Opção nr 1",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              /// Tempo de Implementação
              GestureDetector(
                onTap:
                    () => _mostrarAjuda(
                  context,
                  "Tempo necessário para implementar esta opção (em dias).",
                ),
                child: TextField(
                  controller: controller.tempoImpplementacaoCtrl,
                  decoration: const InputDecoration(
                    labelText: "Tempo de Implementação",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 10),

              /// Tempo de Impacto Positivo
              GestureDetector(
                onTap:
                    () => _mostrarAjuda(
                  context,
                  "Duração estimada do impacto positivo (em dias).",
                ),
                child: TextField(
                  controller: controller.tempoImpactoPositivoCtrl,
                  decoration: const InputDecoration(
                    labelText: "Tempo de Impacto positivo",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 10),

              /// Valor
              GestureDetector(
                onTap:
                    () =>
                    _mostrarAjuda(context, "Custo ou investimento necessário."),
                child: TextField(
                  controller: controller.valorCtrl,
                  decoration: const InputDecoration(
                    labelText: "Valor",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 10),

              /// Peso Emocional (Slider)
              GestureDetector(
                onTap:
                    () => _mostrarAjuda(
                  context,
                  "Peso emocional: 1 (baixo) a 10 (alto).",
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Peso Emocional (1-10)", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),

                    ///adicionar SliderControlado
                    SliderControlado(),
                  ],
                ),
              ),
              Divider(thickness: 1, indent: 10, endIndent: 10),

              const SizedBox(height: 10),

              ///Botões de acções
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final controller = Provider.of<DecisionController>(
                            context,
                            listen: false,
                          );

                          ///autenticação dos campos antes de criar uma nova decision
                          if (controller.tituloOpcaoCtrl.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("O título da opção é obrigatório"),
                              ),
                            );
                            return;
                          }

                          /// criação de uma nova decision/opção
                          /// preciso conciliar os controllers com os parametros do Decision,
                          final novaOpcao = Decision(
                            titulo: controller.tituloOpcaoCtrl.text,
                            valor: double.tryParse(controller.valorCtrl.text) ?? 0,
                            tempoDeImplementacao:
                            double.tryParse(
                              controller.tempoImpplementacaoCtrl.text,
                            ) ??
                                0,
                            tempoDeImpactoPositivo:
                            double.tryParse(
                              controller.tempoImpactoPositivoCtrl.text,
                            ) ??
                                0,
                            pesoEmocional:
                            int.tryParse(controller.pesoController.text) ?? 1,
                          );

                          ///adição dessa nova opção na lista de Decisions que está no controller
                          controller.adicionarDecision(novaOpcao);
                          controller.limparForm();
                        },
                        icon: Icon(Icons.add_circle_outline),
                        label: Text("Nova Opção"),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final decisoes = controller.decisoes;
                          if (decisoes.isEmpty) return;

                          final melhor = DecisionCalculator.calcularMelhor(
                            decisoes,
                          );
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                              title: Text("Melhor Opção: "),
                              content: Text(
                                "${melhor.titulo} \n Impacto: ${melhor.calcularImpacto().toStringAsFixed(2)} \n Tempo de implementação: ${melhor.valor} ",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Fechar"),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.compare),
                        label: Text("Comparar Opções"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(thickness: 2, indent: 10, endIndent: 10),

              //Parte de barra de pesquisa
              Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: 'Pesquise por uma opção. Ex: opção 1',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: controller.atualizarTermoBusca,
                    ),
                  ),

                  // Lista de Opções Filtradas
                  Expanded(
                    child: Consumer<DecisionController>(
                      builder: (context, controller, _) {
                        final decisoes = controller.decisoesFiltradas;

                        if (decisoes.isEmpty) {
                          return Center(
                            child: Text(
                              controller.termoBusca.isEmpty
                                  ? 'Nenhuma opção adicionada'
                                  : 'Nenhuma opção encontrada',
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: decisoes.length,
                          itemBuilder: (context, index) {
                            final decisao = decisoes[index];
                            return _buildDecisionTile(
                              context,
                              controller,
                              decisao,
                              index,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
          // Overlay de tutorial
          if (tutorialProvider.isTutorialActive)
            TutorialOverlay(
              card: tutorialProvider.currentCard,
              currentStep: tutorialProvider.currentIndex + 1,
              totalSteps: tutorialProvider.cards.length,
              onNext: () {
                tutorialProvider.nextCard();
                if (tutorialProvider.currentIndex == tutorialProvider.cards.length - 1) {
                  tutorialProvider.endTutorial();
                }
              },
              onClose: () => tutorialProvider.endTutorial(),
            ),

        ]
    );
  }
}
