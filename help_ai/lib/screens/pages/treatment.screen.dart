import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({super.key, required String title});

  @override
  TreatmentScreenState createState() => TreatmentScreenState();
}

class TreatmentScreenState extends State<TreatmentScreen> {
  final Map<String, Map<String, dynamic>> tratamientos = {
    "tratamiento_id_1": {
      "codigo": "CIE-10",
      "fecha": "10-12-2023",
      "estado": "Dado de alta",
      "consulta": {
        "fecha": "21 de agosto de 2024",
        "hora": "16:35:54",
        "medico": "Dr. Jorge Cabrera",
        "especialidad": "Cirugía Vascular",
        "departamento": "Clínica Centra Quirúrgico-CG"
      },
      "motivo": "Dolor en miembros inferiores a nivel de pantorrillas",
      "hallazgos": [
        "Pulsos arteriales presentes",
        "Evidencia de material trombótico en poplitea derecha"
      ],
      "diagnostico":
          "Flebitis y tromboflebitis de otros vasos profundos de los miembros inferiores (1802)",
      "medicamentos": [
        {
          "nombre": "Diosmina",
          "dosis": "600mg",
          "frecuencia": "Una vez al día",
          "duracion": 15
        }
      ],
      "proxima_cita": "04/09/2024"
    },
    "tratamiento_id_2": {
      "codigo": "CIE-11",
      "fecha": "05-01-2024",
      "estado": "En tratamiento",
      "consulta": {
        "fecha": "25 de enero de 2024",
        "hora": "09:15:00",
        "medico": "Dr. Ana Pérez",
        "especialidad": "Cardiología",
        "departamento": "Clínica de Cardiología"
      },
      "motivo": "Dolor en el pecho",
      "hallazgos": ["Ruidos cardíacos anormales", "Presión arterial elevada"],
      "diagnostico": "Hipertensión arterial",
      "medicamentos": [
        {
          "nombre": "Losartán",
          "dosis": "50mg",
          "frecuencia": "Una vez al día",
          "duracion": 30
        }
      ],
      "proxima_cita": "15/02/2024"
    }
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tratamientos',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                // Buscador
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar tratamiento',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    // Filtrar los tratamientos basados en la búsqueda
                  },
                ),
                const SizedBox(height: 20),
                // Tabla de tratamientos usando flutter_data_table
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Código')),
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('Estado')),
                  ],
                  rows: tratamientos.entries.map((tratamiento) {
                    return DataRow(
                      cells: [
                        DataCell(Text(tratamiento.value['codigo'])),
                        DataCell(Text(tratamiento.value['fecha'])),
                        DataCell(Text(tratamiento.value['estado'])),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Tratamiento actual (tarjeta expandible)
                for (var tratamiento in tratamientos.entries)
                  ExpandableNotifier(
                    child: ExpandablePanel(
                      header: Text(
                        'Tratamiento: ${tratamiento.value['codigo']}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      collapsed: const Text('Ver detalles'),
                      expanded: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Motivo de la consulta:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(tratamiento.value['motivo']),
                            const SizedBox(height: 10),
                            const Text(
                              'Hallazgos:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            for (var hallazgo in tratamiento.value['hallazgos'])
                              Text('- $hallazgo'),
                            const SizedBox(height: 10),
                            const Text(
                              'Diagnóstico:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(tratamiento.value['diagnostico']),
                            const SizedBox(height: 10),
                            const Text(
                              'Medicamentos:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            for (var medicamento
                                in tratamiento.value['medicamentos'])
                              Text(
                                  '${medicamento['nombre']} - ${medicamento['dosis']} - ${medicamento['frecuencia']}'),
                            const SizedBox(height: 10),
                            const Text(
                              'Próxima cita:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(tratamiento.value['proxima_cita']),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
