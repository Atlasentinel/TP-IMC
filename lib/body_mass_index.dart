import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BMIForm extends StatefulWidget {
  const BMIForm({super.key});

  @override
  _BMIFormState createState() => _BMIFormState();
}

class _BMIFormState extends State<BMIForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final int maxLength = 3;

  double? _bmiValue;
  String _result = '';

  // Méthode pour gérer la validation et le calcul de l'IMC
  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      double height = double.parse(_heightController.text);
      double weight = double.parse(_weightController.text);

      BodyMassIndex bmi = BodyMassIndex(height: height, weight: weight);
      double imc = bmi.calculateIMC();
      String category = bmi.getImcCategory();

      setState(() {
        _bmiValue = imc;
        _result = "Votre IMC est de ${imc.toStringAsFixed(2)} ($category)";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _heightController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
              FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
            ],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Taille (cm)'),
            maxLength: maxLength,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Entrez une taille valide';
              }
              if (double.tryParse(value) == null || double.parse(value) <= 0) {
                return 'Entrez un nombre valide';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _weightController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
              FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
            ],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Poids (kg)'),
            maxLength: maxLength,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Entrez un poids valide';
              }
              if (double.tryParse(value) == null || double.parse(value) <= 0) {
                return 'Entrez un nombre valide';
              }
              return null;
            },
          ),

          ElevatedButton(
            onPressed: _calculateBMI,
            child: const Text('Calculer IMC'),
          ),

          if (_bmiValue != null)
            Column(
              children: [
                Text(
                  _result,
                  style: const TextStyle(fontSize: 24),
                ),

                SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 10,
                      maximum: 40,
                      ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 10, endValue: 18.5, color: Colors.blue),
                        GaugeRange(
                            startValue: 18.5, endValue: 25, color: Colors.green),
                        GaugeRange(
                            startValue: 25, endValue: 30, color: Colors.yellow),
                        GaugeRange(
                            startValue: 30, endValue: 40, color: Colors.red),
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                          value: _bmiValue!,
                          enableAnimation: true,
                          animationType: AnimationType.ease,
                          animationDuration: 4000,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Text(
                            _bmiValue!.toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          angle: 90,
                          positionFactor: 0.5,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class BodyMassIndex {
  final double height;
  final double weight;

  BodyMassIndex({required this.height, required this.weight});


  double calculateIMC() {
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }


  String getImcCategory() {
    double imc = calculateIMC();
    if (imc < 18.5) {
      return "Underweight";
    } else if (imc >= 18.5 && imc < 25) {
      return "Normal";
    } else if (imc >= 25 && imc < 30) {
      return "Overweight";
    } else {
      return "Obesity";
    }
  }
}
