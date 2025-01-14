import 'package:flutter/material.dart';
import 'package:help_ai/screens/pages/agenda/calendar_screen.dart';

class DoctorSearchDelegate extends SearchDelegate<void> {
  final List<Map<String, dynamic>> doctors;

  DoctorSearchDelegate(this.doctors);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = doctors.where((doctor) {
      return doctor["nombre"].toLowerCase().contains(query.toLowerCase()) ||
          doctor["especialidad"].toLowerCase().contains(query.toLowerCase()) ||
          doctor["subespecialidad"]
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          doctor["clinica"].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final doctor = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(doctor["imagen"]),
          ),
          title: Text(doctor["nombre"]),
          subtitle: Text(
            '${doctor["especialidad"]} - ${doctor["clinica"]}',
          ),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalendarScreen(doctor: doctor),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = doctors.where((doctor) {
      return doctor["nombre"].toLowerCase().contains(query.toLowerCase()) ||
          doctor["especialidad"].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final doctor = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(doctor["imagen"]),
          ),
          title: Text(doctor["nombre"]),
          subtitle: Text(
            '${doctor["especialidad"]} - ${doctor["clinica"]}',
          ),
        );
      },
    );
  }
}
