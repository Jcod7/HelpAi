import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const CalendarScreen({super.key, required this.doctor});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  final Map<String, dynamic> jsonData = {
    "available_slots": [
      {
        "doctor_id": 1,
        "available_dates": [
          {
            "date": "2025-01-14",
            "times": ["09:00", "10:30", "14:00"]
          },
          {
            "date": "2025-01-15",
            "times": ["08:00", "11:30", "13:00"]
          },
        ],
      },
      {
        "doctor_id": 2,
        "available_dates": [
          {
            "date": "2025-01-14",
            "times": ["10:00", "12:00", "15:00"]
          },
        ],
      },
      // Agrega más datos según sea necesario
    ],
  };

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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Has seleccionado el horario $time para ${widget.doctor["nombre"]}'),
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
    final doctorSlots = jsonData["available_slots"].firstWhere(
      (slot) => slot["doctor_id"] == widget.doctor["id"],
      orElse: () => {"doctor_id": widget.doctor["id"], "available_dates": []},
    );

    final dateStr = selectedDate.toIso8601String().split("T").first;

    final selectedDateSlot =
        (doctorSlots["available_dates"] as List).firstWhere(
      (dateSlot) => dateSlot["date"] == dateStr,
      orElse: () => {"times": []},
    );

    return List<String>.from(selectedDateSlot["times"] ?? []);
  }
}
