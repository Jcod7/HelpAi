import 'package:flutter/material.dart';
import 'package:help_ai/screens/pages/agenda/calendar_screen.dart';
import 'package:help_ai/screens/pages/agenda/doctor_screen.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key, required String title});

  @override
  AgendaScreenState createState() => AgendaScreenState();
}

class AgendaScreenState extends State<AgendaScreen> {
  final List<Map<String, dynamic>> doctors = [
    {
      "id": 1,
      "nombre": "Ana García",
      "especialidad": "Endocrinóloga",
      "subespecialidad": "Diabetes tipo 2",
      "clinica": "Clínica Médica",
      "calificacion": 4.7,
      "imagen": "assets/images/doctora1.png",
    },
    {
      "id": 2,
      "nombre": "Luis Rodríguez",
      "especialidad": "Endocrinólogo",
      "subespecialidad": "Diabetes gestacional",
      "clinica": "Hospital Central",
      "calificacion": 4.9,
      "imagen": "assets/images/doctor1.png"
    },
    {
      "id": 3,
      "nombre": "María Fernández",
      "especialidad": "Nutricionista",
      "subespecialidad": "Diabetes",
      "clinica": "Centro de Nutrición",
      "calificacion": 4.6,
      "imagen": "assets/images/doctora2.png"
    },
    {
      "id": 4,
      "nombre": "Pedro López",
      "especialidad": "Podólogo",
      "subespecialidad": "Pie diabético",
      "clinica": "Clínica del Pie",
      "calificacion": 4.8,
      "imagen": "assets/images/doctor2.png"
    },
    {
      "id": 5,
      "nombre": "Laura Martínez",
      "especialidad": "Enfermera",
      "subespecialidad": "Educación en diabetes",
      "clinica": "Clínica de Especialidades",
      "calificacion": 4.5,
      "imagen": "assets/images/doctora3.png"
    },
    {
      "id": 6,
      "nombre": "Sofía Pérez",
      "especialidad": "Oftalmóloga",
      "subespecialidad": "Retinopatía diabética",
      "clinica": "Clínica Oftalmológica",
      "calificacion": 4.9,
      "imagen": "assets/images/doctora4.png"
    },
    {
      "id": 7,
      "nombre": "Daniel Gómez",
      "especialidad": "Nefrólogo",
      "subespecialidad": "Enfermedad renal diabética",
      "clinica": "Hospital Nefrológico",
      "calificacion": 4.7,
      "imagen": "assets/images/doctor3.png"
    },
    {
      "id": 8,
      "nombre": "Carla Álvarez",
      "especialidad": "Cardióloga",
      "subespecialidad": "Enfermedad cardiovascular en diabetes",
      "clinica": "Clínica Cardiológica",
      "calificacion": 4.6,
      "imagen": "assets/images/doctora5.png"
    },
    {
      "id": 9,
      "nombre": "Miguel Santos",
      "especialidad": "Psicólogo",
      "subespecialidad": "Psicología clínica en diabetes",
      "clinica": "Centro de Psicología",
      "calificacion": 4.8,
      "imagen": "assets/images/doctor4.png"
    },
    {
      "id": 10,
      "nombre": "Javier Fernández",
      "especialidad": "Endocrinólogo",
      "subespecialidad": "Diabetes tipo 1",
      "clinica": "Clínica de Especialidades Médicas",
      "calificacion": 4.8,
      "imagen": "assets/images/doctor5.png"
    }
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredDoctors = doctors
        .where((doctor) =>
            doctor["nombre"]
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            doctor["especialidad"]
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            doctor["subespecialidad"]
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            doctor["clinica"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Médica'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DoctorSearchDelegate(doctors),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredDoctors.length,
        itemBuilder: (context, index) {
          final doctor = filteredDoctors[index];
          return doctorCard(doctor);
        },
      ),
    );
  }

  Widget doctorCard(Map<String, dynamic> doctor) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundImage: AssetImage(doctor["imagen"]),
          radius: 30,
        ),
        title: Text(
          doctor["nombre"],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doctor["especialidad"]),
            Text(doctor["subespecialidad"]),
            Text('Clínica: ${doctor["clinica"]}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              doctor["calificacion"].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.star, color: Colors.amber),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalendarScreen(doctor: doctor),
            ),
          );
        },
      ),
    );
  }
}
