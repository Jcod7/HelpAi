// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required String title});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _glucoseController = TextEditingController();
  double _currentGlucose = 125.0;

  // Estructura JSON simulada con tipos específicos
  final Map<String, dynamic> userData = {
    "name": "José Alfredo Romero Guillén",
    "profileImage": "assets/images/profile.jpg",
    "healthIndicators": <Map<String, String>>[
      {"label": "Peso", "value": "85.5 kg"},
      {"label": "Glucosa", "value": "125 ml/dL"},
      {"label": "Tipo de sangre", "value": "O+"}
    ],
    "personalInfo": <String, String>{
      "Edad": "65",
      "Altura": "1.85 cm",
      "Correo": "joseromero@gmail.com",
      "Dirección": "18 de Noviembre y Mercadillo"
    },
    "nextAppointment": <String, String>{"date": "25/10/2024", "time": "10:15"},
    "prescription": <String, String>{
      "medication": "Metformina 500 mg",
      "instructions": "Tomar 1 tableta después del desayuno"
    }
  };

  void _showEmergencyDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // El usuario debe interactuar con el diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  '¡Alerta de Glucosa!',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.medical_information, color: Colors.red.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pasos inmediatos a seguir:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              _buildStep(1, 'Revisar nivel de azúcar en sangre nuevamente'),
              _buildStep(2,
                  'Seguir el protocolo de emergencia indicado por su médico'),
              _buildStep(
                  3, 'Mantener la calma y tomar las medidas correspondientes'),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Se ha notificado automáticamente a su médico y a su contacto de confianza sobre esta situación.',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Entendido',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Text(
              number.toString(),
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  void _updateGlucose() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Actualizar nivel de glucosa'),
          content: TextField(
            controller: _glucoseController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nivel de glucosa (mg/dL)',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final newGlucose = double.tryParse(_glucoseController.text);
                if (newGlucose != null) {
                  setState(() {
                    _currentGlucose = newGlucose;
                    (userData["healthIndicators"]
                            as List<Map<String, String>>)[1]["value"] =
                        "$newGlucose ml/dL";
                  });
                  Navigator.pop(context);

                  // Verificar niveles de glucosa
                  if (newGlucose < 70) {
                    _showEmergencyDialog(
                        context, '¡Nivel de glucosa muy bajo!');
                  } else if (newGlucose > 180) {
                    _showEmergencyDialog(
                        context, '¡Nivel de glucosa muy alto!');
                  }
                }
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              // Perfil y datos principales
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
                              userData["name"] as String,
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
                                    as List<Map<String, String>>)
                                .length,
                            (index) {
                              final indicator = (userData["healthIndicators"]
                                  as List<Map<String, String>>)[index];
                              return _HealthIndicator(
                                icon: healthIcons[index],
                                label: indicator["label"] ?? "",
                                value: index == 1
                                    ? '$_currentGlucose ml/dL'
                                    : indicator["value"] ?? "",
                                onUpdate: index == 1 ? _updateGlucose : null,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Información personal
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

              // Próxima cita (Expandible)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ExpandablePanel(
                  header: const Text(
                    'Próxima cita / control',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  collapsed: const Text('Ver detalles'),
                  expanded: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Fecha: ${(userData["nextAppointment"] as Map<String, String>)["date"]}'),
                          Text(
                              'Hora: ${(userData["nextAppointment"] as Map<String, String>)["time"]}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Receta Médica (Expandible)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ExpandablePanel(
                  header: const Text(
                    'Receta Médica',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  collapsed: const Text('Ver detalles'),
                  expanded: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Medicamento: ${(userData["prescription"] as Map<String, String>)["medication"]}'),
                          Text(
                              'Instrucciones: ${(userData["prescription"] as Map<String, String>)["instructions"]}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _glucoseController.dispose();
    super.dispose();
  }
}

class _HealthIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onUpdate;

  const _HealthIndicator({
    required this.icon,
    required this.label,
    required this.value,
    this.onUpdate,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Icon(icon, color: const Color(0xFF4CC2FF), size: 30),
            if (onUpdate != null)
              Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: onUpdate,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: Color(0xFF4CC2FF),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Actualizar',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4CC2FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4CC2FF),
          ),
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
            '$label: ',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
