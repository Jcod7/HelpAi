import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final DateTime date;
  final String time;

  const ConfirmationScreen({
    super.key,
    required this.doctor,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
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
                    _buildInfoRow('Doctor', doctor["nombre"]),
                    _buildInfoRow('Especialidad', doctor["especialidad"]),
                    _buildInfoRow('Clínica', doctor["clinica"]),
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
                // Mostrar un SnackBar de confirmación
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Cita agendada con éxito!'),
                    duration: Duration(seconds: 2),
                  ),
                );

                // Esperar un momento antes de navegar para que el usuario vea el mensaje
                Future.delayed(const Duration(seconds: 2), () {
                  // Navegar de vuelta a la pantalla principal
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Confirmar Cita',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Volver a la pantalla anterior
              },
              child: const Text('Cancelar'),
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
