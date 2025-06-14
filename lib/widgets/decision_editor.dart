import 'package:decisionmaker/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/decision.dart';
import '../controllers/decision_controller.dart';
import '../controllers/tutorial_provider.dart';
import 'slider_controlado.dart';
import 'tutorial_overlay.dart';
import '../services/decision_calculator.dart';

class DecisionEditor extends StatelessWidget {

  final bool mostrarDialogos;
  const DecisionEditor({ this.mostrarDialogos = false, super.key});

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
            Text('Impacto: ${decisao.valorCalculado.toStringAsFixed(2)}'),
            Text('Valor: ${decisao.valor.toStringAsFixed(2)}'),
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
    final bool mostrarDialogos = tutorialProvider.mostrarDialogos;;

    return Stack(
        children:[ LayoutBuilder(
            builder: (context, constraints) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        /// Título Principal/da escolha
                        Container(
                          child: Column(
                            children: [
                              TextField(
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 29),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  label:  Align(
                                    alignment: Alignment.center,
                                    child: Text("Nova Decisão"),
                                  ),
                                  labelStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                ),
                                onChanged: controller.atualizarTitulo,
                              ),
                              Divider(indent: 10, endIndent: 10),
                              const SizedBox(height: 10),

                              ///
                              Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  /*border: Border.all(color: Colors.black)*/
                                ),
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width - 60,
                                ),
                                padding: const EdgeInsets.only(right: 14.0, left: 20),
                                child: Column(
                                  children: [
                                    /// Título da Opção
                                    FractionallySizedBox(
                                      widthFactor: 0.98,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          /*border: Border.all(
                                  //color: Colors.black,
                                )*/
                                        ),
                                        child: GestureDetector(
                                          onTap:
                                              () => _mostrarAjuda(
                                            context,
                                            "Nomeie a opção (ex: Carro elétrico).",
                                          ),
                                          child: Row(
                                            children: [
                                              LabeledTextField(label: "Nova Opção", hintText: "Opção nr 1", controller: context.read<DecisionController>().tituloOpcaoCtrl,),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    ///espaço vertical
                                    SizedBox(height: 20),

                                    ///tempo de impacto positivo + box de dias, meses, ou anos, ou nenhum
                                    ///quando mudo a box de dias de um, é suposto mudar a o valor(box de dias em todas...
                                    ///...em todas opções dessa Nova Decisão)
                                    FractionallySizedBox(
                                      widthFactor: 0.98,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          /* border: Border.all(
                                  color: Colors.black,
                                  )*/
                                        ),
                                        child: IntrinsicHeight(

                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  flex:7,
                                                  child:

                                                  Padding(
                                                    padding: EdgeInsets.only(left:  0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          //width: double.infinity, //adicionei agora
                                                          decoration: BoxDecoration(
                                                            color: Color.fromARGB(200, 175, 160, 221),
                                                            border: Border(
                                                                bottom: BorderSide(color: Colors.black)),

                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(6),
                                                              topRight: Radius.circular(6),
                                                              bottomLeft: Radius.circular(0),
                                                              bottomRight: Radius.circular(0),
                                                            ),
                                                          ),
                                                          child: Container(
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left: 1.0, bottom: 0, ),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 13.0, bottom: 2, top: 12),
                                                                          child: Text(
                                                                            "Tempo de impacto positivo",
                                                                            textAlign: TextAlign.left,
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Color(0xFD373333),
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),

                                                                Padding(
                                                                  padding: const EdgeInsets.all(0.0),
                                                                  child: TextField(
                                                                    controller: controller.tempoImpactoPositivoCtrl,

                                                                    decoration: InputDecoration(
                                                                      border: InputBorder.none,
                                                                      hintText: "Escreva um número",
                                                                      hintStyle: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 22,
                                                                      ),
                                                                      contentPadding: EdgeInsets.only (left: 14, top: 0, bottom: 20),
                                                                    ),

                                                                    style: TextStyle(
                                                                      fontSize: 22,
                                                                      color: Colors.black,
                                                                    ),

                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),


                                                SizedBox(width: 19,),

                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right:0),
                                                    child: Container(
                                                      ///height: 90,
                                                      decoration: BoxDecoration(
                                                        /*border: Border.all(color: Colors.black)*/
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: Center(
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: Color.fromARGB(200,175,160,221),
                                                                  border: Border.all(color: Colors.black),
                                                                  borderRadius: BorderRadius.circular(6),
                                                                ),
                                                                child: ValueListenableBuilder(
                                                                    valueListenable: controller.unidadeTempoGlobal,
                                                                    builder: (context, unidadeAtual, _){
                                                                      return Center(
                                                                        child: DropdownButton<String>(
                                                                          style: TextStyle(
                                                                              fontSize: 20
                                                                          ),
                                                                          alignment: Alignment.center,
                                                                          isExpanded: true,
                                                                          value: unidadeAtual,
                                                                          onChanged: (String? novaUnidade) {
                                                                            if (novaUnidade != null) {
                                                                              controller.alterarUnidadeTempoGlobal(novaUnidade);
                                                                            }
                                                                          },
                                                                          items: <String>['dias','meses','anos'].map(
                                                                                  (String value) {
                                                                                return DropdownMenuItem<String>(

                                                                                  value: value,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                    child: Text(value),
                                                                                  ),
                                                                                );
                                                                              }
                                                                          ).toList(),

                                                                        ),
                                                                      );
                                                                    }
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                    ),

                                    SizedBox(height: 20,),

                                    /// Tempo de Implementação
                                    FractionallySizedBox(
                                      widthFactor: 0.98,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          /*border: Border.all(color: Colors.black),*/
                                        ),
                                        child: Row(
                                          //mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Flexible(
                                              flex:5,
                                              //fit: FlexFit.loose,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    //width: double.infinity, //adicionei agora
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(200, 175, 160, 221),
                                                      border: Border(
                                                          bottom: BorderSide(color: Colors.black)),

                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(6),
                                                        topRight: Radius.circular(6),
                                                        bottomLeft: Radius.circular(0),
                                                        bottomRight: Radius.circular(0),
                                                      ),
                                                    ),
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 1.0, bottom: 0, ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 13.0, bottom: 5, top: 12),
                                                                    child: Container(
                                                                      width: 150,
                                                                      child: FittedBox(
                                                                        alignment: Alignment.centerLeft,
                                                                        fit: BoxFit.scaleDown,
                                                                        child: Text(
                                                                          "Tempo de implementação",
                                                                          softWrap: false,
                                                                          textAlign: TextAlign.left,
                                                                          style: TextStyle(
                                                                            fontSize: 14,
                                                                            color: Color(0xFD373333),
                                                                            fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          ///quando adiciono Flexible como pai do textfield dá erro
                                                          TextField(
                                                            controller: controller.tempoImpplementacaoCtrl,
                                                            decoration: InputDecoration(
                                                              hint: FittedBox(
                                                                  alignment: Alignment.centerLeft,
                                                                  fit: BoxFit.scaleDown,
                                                                  child: Text("Insira um número", style: TextStyle(
                                                                    fontSize: 22,
                                                                    color: Colors.black,
                                                                  ),)),
                                                              isDense: true,
                                                              border: InputBorder.none,
                                                              contentPadding: EdgeInsets.only (left: 14, top: 0, bottom: 20, right: 10),
                                                            ),
                                                            style: TextStyle(
                                                              fontSize: 22,
                                                              color: Colors.black,
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 30,),
                                            Flexible(
                                              flex: 5,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    //width: double.infinity, //adicionei agora
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(200, 175, 160, 221),
                                                      border: Border(
                                                          bottom: BorderSide(color: Colors.black)),

                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(6),
                                                        topRight: Radius.circular(6),
                                                        bottomLeft: Radius.circular(0),
                                                        bottomRight: Radius.circular(0),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 1.0, bottom: 0, ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 13.0, bottom: 2, top: 12),
                                                                child: Container(
                                                                  width: 150,
                                                                  child: FittedBox(
                                                                    alignment: Alignment.centerLeft,
                                                                    fit: BoxFit.scaleDown,
                                                                    child: Text(
                                                                      "Custo de Implementação",
                                                                      textAlign: TextAlign.left,
                                                                      softWrap: false,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        color: Color(0xFD373333),
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        Padding(
                                                          padding: const EdgeInsets.all(0.0),
                                                          child: TextField(
                                                            controller: controller.valorCtrl,

                                                            decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              hint:  FittedBox(
                                                                  alignment: Alignment.centerLeft,
                                                                  fit: BoxFit.scaleDown,
                                                                  child: Text("Insira um número", style: TextStyle(
                                                                    fontSize: 22,
                                                                    color: Colors.black,
                                                                  ),)),
                                                              contentPadding: EdgeInsets.only (left: 14, top: 0, bottom: 20, right: 10),
                                                            ),

                                                            style: TextStyle(
                                                              fontSize: 22,
                                                              color: Colors.black,
                                                            ),

                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            )
                                          ],

                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),

                                    FractionallySizedBox(
                                      widthFactor: 0.98,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Impacto Emocional", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),


                                          SliderControlado(),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),


                            ],
                          ),
                        ),

                        Divider(thickness: 1, indent: 10, endIndent: 10),

                        const SizedBox(height: 10),

                        Container(
                          width: double.maxFinite,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 60,
                          ),
                          padding: const EdgeInsets.only(right: 14.0, left: 20),
                          child:

                          ///Botões de acções
                          FractionallySizedBox(
                            widthFactor: 0.98,
                            child: IntrinsicWidth(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
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
                                            valor: double.tryParse(controller.valorCtrl.text) ?? 1,//denominador
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
                              
                                  SizedBox(width: 40.0),
                              
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          final controller = Provider.of<DecisionController>(context, listen: false);
                                          final decisoes = controller.decisoes;
                                          if (decisoes.isEmpty) return;
                                          final melhor = DecisionCalculator.calcularMelhor(decisoes);
                              
                              
                                           controller.salvarDecisaoFinal();
                              
                                            print("Ja");
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(controller.isEditing
                                                    ? "Decisão Atualizada"
                                                    : "Melhor Opção",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                                ),),
                              
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "${melhor.titulo}",
                                                        ),
                                                        Text(
                                                          "Impacto:${melhor.valorCalculado.toStringAsFixed(2)}",
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text("Fechar"),
                                                  ),
                                                ],
                                              ),
                                            );
                              
                                            /*if (controller.isEditing) {
                                              Navigator.pop(context); // Fecha o editor se estava editando
                                            }*/
                                          ;
                                        },
                                        label: Text(
                                          controller.isEditing ? "Atualizar Decisão" : "Comparar Opções",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                              
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 5),
                        Divider(thickness: 1.5, indent: 10, endIndent: 10, color: Colors.black,),


                        //Parte de barra de pesquisa
                        Container(
                          width: double.maxFinite,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 60,
                          ),
                          padding: const EdgeInsets.only(right: 14.0, left: 20),
                          child: FractionallySizedBox(
                            widthFactor: 0.98,
                            child: Column(
                              children: [
                                // Search Bar
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 237, 232, 240),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      controller: controller.searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Pesquise por uma opção. Ex: opção 1',
                                        prefixIcon: Icon(Icons.search),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      onChanged: controller.atualizarTermoBusca,
                                    ),
                                  ),
                                ),

                                // Lista de Opções Filtradas
                                Consumer<DecisionController>(
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
                                      shrinkWrap: true,  // Importante!
                                      physics: AlwaysScrollableScrollPhysics(),
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
          ValueListenableBuilder<bool>(
            valueListenable: tutorialProvider.mostrarDialogosNotifier,
            builder: (context, mostrarDialogos, child) {
              return mostrarDialogos ? const TutorialOverlay() : const SizedBox.shrink();
            },
          ),
        ]
    );
  }
}