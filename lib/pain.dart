import 'package:decisionmaker/pages/historico.dart';
import 'package:flutter/material.dart';
import 'controllers/tutorial_provider.dart';
import 'package:provider/provider.dart';
import 'controllers/decision_controller.dart';
import '../screens/tutorial_basico.dart';
//import '../screens/decision_maker.dart';
import '../screens/login_page.dart';
import 'widgets/decision_editor.dart';


class Paginas extends StatelessWidget {
  Paginas({super.key});

  final List<Widget> _pages = [
    TelaPrincipal(),
    TelaEdicao(),
    //TutorialPremiumPage(),
  ];

  final List<String> titulos = [
    "Decision Maker",
    "Editar Decisão",
    "Tutorial Básico",
  ];

  @override
  Widget build(BuildContext contexto1) {
    final selectedIndex = contexto1.watch<DecisionController>().selectedIndex ?? 0;
    final tutorial = Provider.of<TutorialProvider>(contexto1, listen: false);
    final controller = contexto1.watch<DecisionController>();
    print("Página selecionada: $selectedIndex");

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            Consumer<DecisionController>(
              builder: (context, controller, child) {
                return DrawerHeader(
                  decoration: BoxDecoration(color: Colors.deepPurple[200]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.account_circle, size: 40),
                      SizedBox(height: 10),
                      Text("Usuário Anónimo", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text("Tutorial Básico"),
              selected: controller.selectedIndex == 0,
              onTap:
                  () { Navigator.pop(contexto1);
              Provider.of<TutorialProvider>(
                contexto1,
               listen: false).basicoTutorial();
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Tutorial Premium"),
              selected: controller.selectedIndex == 1,
              onTap:
                  () { Navigator.pop(contexto1);
              Provider.of<TutorialProvider>(
                contexto1,
              ).basicoTutorial();
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Fazer Nova Decisão"),
              selected: controller.selectedIndex == 2,
              onTap: () {
                Provider.of<DecisionController>(contexto1).premiumTutorial(contexto1);

                Navigator.pushReplacementNamed(contexto1, '/');
              },
            ),

            Divider(height: 1, thickness: 1, color: Colors.black),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico'),
              onTap: () {
                Navigator.pop(contexto1); // Fecha o drawer
                Navigator.push(
                  contexto1,
                  MaterialPageRoute(builder: (context) => const HistoricoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Tutorial Premium"),
              selected: controller.selectedIndex == 4,
              onTap:
                  () =>
                  Provider.of<DecisionController>(
                    contexto1,
                  ).premiumTutorial(contexto1),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Fazer Nova Decisão"),
              selected: controller.selectedIndex == 5,
              onTap: () {
                Provider.of<DecisionController>(contexto1).premiumTutorial(contexto1);

                Navigator.pushReplacementNamed(contexto1, '/');
              },
            ),

            Divider(height: 1, thickness: 1, color: Colors.black),

            ListTile(
              leading: Icon(Icons.book),
              title: Text("Tutorial Básico"),
              selected: controller.selectedIndex == 6,
              onTap:
                  () =>
                  Provider.of<DecisionController>(
                    contexto1,
                  ).basicoTutorial(contexto1),
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Tutorial Premium"),
              selected: controller.selectedIndex == 7,
              onTap:
                  () =>
                  Provider.of<DecisionController>(
                    contexto1,
                  ).premiumTutorial(contexto1),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Fazer Nova Decisão"),
              selected: controller.selectedIndex == 8,
              onTap: () {
                Provider.of<DecisionController>(contexto1).premiumTutorial(contexto1);

                Navigator.pushReplacementNamed(contexto1, '/');
              },
            ),

            Divider(height: 1, thickness: 1, color: Colors.black),

            SizedBox(height: 40,),

           ListTile(onTap: (){

            }, title: Text("Sair da Conta"), ),
            ListTile(onTap: (){

            }, title: Text("Mudar de Conta"), ),
            SizedBox(height: 40,)
          ],
        ),
      ),

      appBar: AppBar(
        actions: [
          Consumer<DecisionController>(
            builder: (context, controller, child) {
              return GestureDetector(
                onTap: () {
                  controller.isUserPremium()
                      ? Navigator.pushNamed(context, '/paginaUsuario')
                      : Navigator.pushNamed(context, '/Login');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child:
                      controller.isUserPremium()
                          ? CircleAvatar(
                              radius: 12,
                              backgroundImage: controller.userImage,
                              child: controller.userImage == null
                                  ? Icon(Icons.person, size: 16)
                                  : null,
                            )
                          : Icon(Icons.account_circle_outlined),
                ),
              );
            },
          ),
        ],

        title: Consumer<DecisionController>(
          builder: (context, controller, child) {

            return Text("${titulos[controller.selectedIndex]}",
            style: TextStyle(fontSize: 23));


          },
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[100],
      ),

      body: _pages[selectedIndex],
      // ...
    );
  }
}

class TelaEdicao extends StatelessWidget {

  TelaEdicao({super.key});

  @override
  Widget build(BuildContext contexto1){
    final controller = contexto1.watch<DecisionController>();
    return DecisionEditor();
  }
}

class TelaPrincipal extends StatelessWidget {
  TelaPrincipal({super.key});

  Widget build(BuildContext contexto1) {
    final controller = contexto1.watch<DecisionController>();
    return DecisionEditor();
  }
}

class PaginaUsuario extends StatelessWidget {
  const PaginaUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de Usuário')),
      body: const Center(child: Text('Por vir :)')),
    );
  }
}


