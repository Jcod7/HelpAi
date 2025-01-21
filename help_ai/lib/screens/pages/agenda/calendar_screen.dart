import 'package:flutter/material.dart';
import 'confirmation_screen.dart';

class CalendarScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const CalendarScreen({super.key, required this.doctor});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();

  // Datos de prueba expandidos para todos los doctores
  final Map<String, dynamic> jsonData = {
    "available_slots": [
      {
        "doctor_id": 1,
        "available_dates":
            _generateDatesForNextMonth(["09:00", "10:30", "14:00", "16:00"]),
      },
      {
        "doctor_id": 2,
        "available_dates":
            _generateDatesForNextMonth(["08:00", "11:30", "15:00"]),
      },
      {
        "doctor_id": 3,
        "available_dates":
            _generateDatesForNextMonth(["10:00", "13:00", "16:30"]),
      },
      {
        "doctor_id": 4,
        "available_dates":
            _generateDatesForNextMonth(["09:30", "12:00", "14:30"]),
      },
      {
        "doctor_id": 5,
        "available_dates":
            _generateDatesForNextMonth(["08:30", "11:00", "15:30"]),
      },
      {
        "doctor_id": 6,
        "available_dates":
            _generateDatesForNextMonth(["09:00", "12:30", "16:00"]),
      },
      {
        "doctor_id": 7,
        "available_dates":
            _generateDatesForNextMonth(["10:30", "13:30", "15:00"]),
      },
      {
        "doctor_id": 8,
        "available_dates":
            _generateDatesForNextMonth(["08:00", "11:30", "14:00"]),
      },
      {
        "doctor_id": 9,
        "available_dates":
            _generateDatesForNextMonth(["09:30", "12:00", "16:30"]),
      },
      {
        "doctor_id": 10,
        "available_dates":
            _generateDatesForNextMonth(["10:00", "13:00", "15:30"]),
      },
    ],
  };

  // Función estática para generar fechas y horarios
  static List<Map<String, dynamic>> _generateDatesForNextMonth(
      List<String> times) {
    final List<Map<String, dynamic>> dates = [];
    final now = DateTime.now();

    // Generar datos para los próximos 30 días
    for (int i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      // Solo incluir días de lunes a viernes
      if (date.weekday <= 5) {
        // 1 = Lunes, 5 = Viernes
        dates.add({
          "date": date.toIso8601String().split("T")[0],
          "times": times,
        });
      }
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final availableTimes = getAvailableTimes();

    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda: ${widget.doctor["nombre"]}'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Selecciona una fecha para ver los horarios disponibles',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 30)),
            onDateChanged: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: availableTimes.isNotEmpty
                ? ListView.builder(
                    itemCount: availableTimes.length,
                    itemBuilder: (context, index) {
                      final time = availableTimes[index];
                      return ListTile(
                        title: Text(time),
                        leading: const Icon(Icons.access_time),
                        onTap: () {
                          // Navegar a la pantalla de confirmación
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmationScreen(
                                doctor: widget.doctor,
                                date: selectedDate,
                                time: time,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No hay horarios disponibles para esta fecha.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<String> getAvailableTimes() {
    try {
      // Encontrar los slots disponibles para el doctor
      Map<String, dynamic>? doctorSlots =
          jsonData["available_slots"].firstWhere(
        (slot) => slot["doctor_id"] == widget.doctor["id"],
        orElse: () => {"available_dates": []},
      );

      if (doctorSlots == null) {
        return [];
      }

      final dateStr = selectedDate.toIso8601String().split("T")[0];

      // Encontrar las fechas disponibles para el día seleccionado
      final List<dynamic> availableDates =
          doctorSlots["available_dates"] as List<dynamic>;

      // Buscar los horarios para la fecha seleccionada
      Map<String, dynamic>? selectedDateSlot =
          availableDates.cast<Map<String, dynamic>>().firstWhere(
                (dateSlot) => dateSlot["date"] == dateStr,
                orElse: () => {"times": <String>[]},
              );

      // Convertir y retornar la lista de horarios
      return (selectedDateSlot["times"] as List<dynamic>).cast<String>();
    } catch (e) {
      print('Error en getAvailableTimes: $e');
      return [];
    }
  }
}
