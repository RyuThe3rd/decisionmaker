import 'package:flutter/material.dart';
import '../Models/tutorial_card.dart';
import '../controllers/tutorial_provider.dart';
import 'package:provider/provider.dart';

class TutorialOverlay extends StatelessWidget {
  const TutorialOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TutorialProvider>(context);
    final card = provider.currentCard;
    final currentStep = provider.currentIndex + 1;
    final totalSteps = provider.cards.length;

    return Stack(
      children: [
        // Fundo escurecido
        Positioned.fill(
          child: GestureDetector(
            onTap: provider.endTutorial,
            child: Container(color: Colors.black54),
          ),
        ),

        // Card do tutorial
        Center(
          child: SingleChildScrollView(
            child: _buildTutorialCard(context, card, currentStep, totalSteps, provider),
          ),
        ),
      ],
    );
  }

  Widget _buildTutorialCard(
      BuildContext context,
      TutorialCard card,
      int currentStep,
      int totalSteps,
      TutorialProvider provider,
      ) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(card.titulo, style: Theme.of(context).textTheme.headlineMedium),
            if (card.imagemPath != null) ...[
              const SizedBox(height: 16),
              Image.asset(card.imagemPath!),
            ],
            const SizedBox(height: 16),
            Text(card.conteudo),
            const SizedBox(height: 24),
            _buildNavigationControls(provider, currentStep, totalSteps),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationControls(
      TutorialProvider provider,
      int currentStep,
      int totalSteps,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: provider.endTutorial,
          child: const Text('Pular'),
        ),
        Text('$currentStep/$totalSteps'),
        TextButton(
          onPressed: currentStep == totalSteps ? provider.endTutorial : provider.nextCard,
          child: Text(currentStep == totalSteps ? 'Concluir' : 'Próximo'),
        ),
      ],
    );
  }
}