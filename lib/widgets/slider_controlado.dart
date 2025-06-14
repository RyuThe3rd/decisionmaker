import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/decision_controller.dart';

class SliderControlado extends StatelessWidget {
  const SliderControlado({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DecisionController>(context);

    return Column(
      children: [
        Slider(
          value: controller.impacto,
          min: 1,
          max: 10,
          divisions: 9,
          label: controller.impacto.toStringAsFixed(0),
          onChanged: (value) {
            controller.atualizarImpacto(value);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1', style: TextStyle(fontSize: 12)),
              Text('5', style: TextStyle(fontSize: 12)),
              Text('10', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}