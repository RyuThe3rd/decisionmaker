import 'package:flutter/material.dart';
import '../Models/tutorial_card.dart';

class TutorialProvider extends ChangeNotifier {
  final List<TutorialCard> _cards = [
    TutorialCard(
      titulo: "O que é o paradoxo do burro?",
      conteudo: "O paradoxo ilustra a indecisão extrema: um burro faminto e sedento, colocado no meio entre um balde e um fardo de feno, não consegue decidir o que fazer e acaba morrendo de sede"
          ,
      imagemPath: 'assets/images/donkey.png',
    ),
    TutorialCard(
      titulo: "O que é o Decision Maker?",
      conteudo: "O nosso app resolve esse problema ao ajudar utilizadores a tomar decisões quando têm múltiplas opções e não sabem qual escolher para maximizar o seu benefício.",
    ),
    // Adicione mais cards conforme necessário
  ];

  int _currentIndex = 0;
  bool _isTutorialActive = false;
  final ValueNotifier<bool> _mostrarDialogos = ValueNotifier<bool>(false);

  // Atualize os getters
  ValueNotifier<bool> get mostrarDialogosNotifier => _mostrarDialogos;
  bool get mostrarDialogos => _mostrarDialogos.value;


  // Getters
  List<TutorialCard> get cards => _cards;
  int get currentIndex => _currentIndex;
  bool get isTutorialActive => _isTutorialActive;
  TutorialCard get currentCard => _cards[_currentIndex];
  double get progress => (_currentIndex + 1) / _cards.length;

  // Métodos de controle
  void basicoTutorial() {
    _currentIndex = 0;
    _mostrarDialogos.value = true;
    notifyListeners();
  }

  void nextCard() {
    if (_currentIndex < _cards.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousCard() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void endTutorial() {
    _mostrarDialogos.value = false;
    notifyListeners();
  }


}