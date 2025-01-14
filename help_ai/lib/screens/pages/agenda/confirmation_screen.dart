import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final DateTime date;
  final String time;

  const ConfirmationScreen(
      {super.key,
      required this.doctor,
      required this.date,
      required this.time});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> jsonData = {
      "doctor": {
        "id": "doc_001",
        "name": "Dr. Juan Pérez",
        "specialty": "Cardiología",
        "clinic": "Clínica del Corazón",
        "office": "Consultorio 101"
      },
      "appointment": {"date": "2025-01-15", "time": "10:00"}
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalles de la cita',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Doctor', jsonData["doctor"]["name"]),
                    _buildInfoRow(
                        'Especialidad', jsonData["doctor"]["specialty"]),
                    _buildInfoRow('Clínica', jsonData["doctor"]["clinic"]),
                    _buildInfoRow(
                        'Fecha', DateFormat('dd/MM/yyyy').format(date)),
                    _buildInfoRow('Hora', time),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Aquí iría la lógica para guardar la cita
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text('Confirmar Cita'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
