// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    // Estructura JSON simulada sin iconos
    const userData = {
      "name": "José Alfredo Romero Guillén",
      "profileImage": "assets/images/profile.jpg",
      "healthIndicators": [
        {"label": "Peso", "value": "85.5 kg"},
        {"label": "Glucosa", "value": "125 ml/dL"},
        {"label": "Tipo de sangre", "value": "O+"}
      ],
      "personalInfo": {
        "Edad": "65",
        "Altura": "1.85 cm",
        "Correo": "joseromero@gmail.com",
        "Dirección": "18 de Noviembre y Mercadillo"
      },
      "nextAppointment": {"date": "25/10/2024", "time": "10:15"},
      "prescription": {
        "medication": "Metformina 500 mg",
        "instructions": "Tomar 1 tableta después del desayuno"
      }
    };

    // Iconos asignados manualmente
    const healthIcons = [
      Icons.monitor_weight,
      Icons.water_drop,
      Icons.bloodtype
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userData["name"]! as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Color(0xFF4CC2FF)),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage(userData["profileImage"] as String),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            (userData["healthIndicators"]
                                    as List<Map<String, dynamic>>)
                                .length,
                            (index) {
                              final indicator = (userData["healthIndicators"] as List<Map<String, dynamic>>)[index] as Map<String, String>;
                              return _HealthIndicator(
                                icon: healthIcons[index],
                                label: indicator["label"]!,
                                value: indicator["value"]!,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          (userData["personalInfo"] as Map<String, String>)
                              .entries
                              .map<Widget>((entry) {
                        return _InfoRow(label: entry.key, value: entry.value);
                      }).toList(),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Próxima cita / control',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text((userData["nextAppointment"]
                        as Map<String, String>)["date"]!),
                    Text(
                        'Hora: ${(userData["nextAppointment"] as Map<String, String>)["time"]!}'),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Receta Médica',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text((userData["prescription"]
                        as Map<String, String>)["medication"]!),
                    Text((userData["prescription"]
                        as Map<String, String>)["instructions"]!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HealthIndicator({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF4CC2FF)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
