import 'package:flutter/material.dart';

class TreatmentScreen extends StatelessWidget {
  const TreatmentScreen({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamiento'),
      ),
      body: const Center(
        child: Text('Contenido básico de tratamiento'),
      ),
    );
  }
}