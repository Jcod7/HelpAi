// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:help_ai/screens/pages/agenda/agenda_screen.dart';
import 'package:help_ai/screens/pages/treatment.screen.dart';
import 'package:help_ai/screens/pages/user_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required String title});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Main Card containing all widgets
              _buildCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // ChatBot Card
                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CC2FF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Consulta con nuestro Chatbot',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: 'Comfortaa',
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Image.asset(
                                    'assets/images/logo1.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Action Buttons Grid
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(
                            icon: Icons.calendar_today,
                            label: 'Agendar\nCita',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AgendaScreen(title: 'HelpAi'),
                                ),
                              );
                            },
                          ),
                          _buildActionButton(
                            icon: Icons.medical_services,
                            label: 'Consulta\nTratamiento',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TreatmentScreen(title: 'HelpAi'),
                                ),
                              );
                            },
                          ),
                          _buildActionButton(
                            icon: Icons.person,
                            label: 'Mi agenda',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const UserProfileScreen(title: 'HelpAi'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),

                      // Emergency Button
                      _buildEmergencyButton(onTap: () {
                        _showEmergencyDialog(context);
                      }),
                      const SizedBox(height: 10),
                      const Text(
                        'Botón de Emergencia',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color.fromARGB(255, 12, 4, 4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Container for all widgets
  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return _buildCard(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: const Color(0xFF4CC2FF),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyButton({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: const BoxDecoration(
          color: Color(0xFFFF1010),
          shape: BoxShape.circle,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notification_important,
              color: Colors.white,
              size: 120,
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
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
                  color: Color(0xFFFF1010),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emergency,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  '¡Emergencia Médica!',
                  style: TextStyle(
                    color: Color(0xFFFF1010),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        '¡Se ha activado el protocolo de emergencia!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF1010),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Acciones inmediatas:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              _buildEmergencyStep(
                1,
                'Mantener la calma y sentarse o recostarse',
                Icons.accessibility_new,
              ),
              _buildEmergencyStep(
                2,
                'Revisar nivel de azúcar en sangre',
                Icons.medication,
              ),
              _buildEmergencyStep(
                3,
                'Administrar insulina si es necesario',
                Icons.health_and_safety,
              ),
              _buildEmergencyStep(
                4,
                'Contactar al médico si los síntomas persisten',
                Icons.local_hospital,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Notificaciones enviadas a:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildNotificationItem(
                        'Dr. Jorge Cabrera (Médico tratante)'),
                    _buildNotificationItem(
                        'María Guillén (Contacto de emergencia)'),
                    _buildNotificationItem('Servicio de emergencias local'),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFF1010),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Aquí podrías agregar la llamada directa al número de emergencia
                      Navigator.of(context).pop();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Llamar a Emergencias',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmergencyStep(int number, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
