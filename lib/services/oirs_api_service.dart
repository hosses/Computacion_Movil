import 'package:flutter/material.dart';
import 'dart:io';
import 'package:oirs_utem/widgets/file_picker_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class OirsApiService {
  Future<void> createTicket({
    required String title,
    required String description,
    required String type,
    required List<File> attachments,
  }) async {
    // Simula un retraso (puedes implementar una API real aquí)
    await Future.delayed(const Duration(seconds: 2));

    // Imprime los valores recibidos para debugging
    print("Título: $title");
    print("Descripción: $description");
    print("Tipo: $type");
    print("Adjuntos: ${attachments.length} archivos");

    // Aquí puedes agregar la lógica para llamar a tu API REST
    // throw Exception('Error simulado'); // Descomentar para probar errores
  }

  final String baseUrl =
      'https://tu-api.com/api'; // Reemplaza con la URL de tu API

  /// Función para obtener los tickets
  Future<List<Map<String, dynamic>>> getTickets() async {
    final url = Uri.parse('$baseUrl/tickets');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON
        final List<dynamic> data = json.decode(response.body);

        // Asegúrate de convertir la lista en el formato adecuado
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        // Maneja errores de la API
        throw Exception('Error al obtener los tickets: ${response.statusCode}');
      }
    } catch (e) {
      // Manejo de excepciones
      throw Exception('Error al conectarse a la API: $e');
    }
  }
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<File> _attachments = [];
  String? _selectedType;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // List of ticket types
  static const List<String> _ticketTypes = [
    'CLAIM',
    'SUGGESTION',
    'INFORMATION'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedType == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione un tipo de solicitud')),
        );
        return;
      }

      try {
        await OirsApiService().createTicket(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          type: _selectedType!,
          attachments: _attachments,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket creado exitosamente')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear ticket')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Ticket'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _ticketTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedType = value);
                },
                validator: (value) =>
                    value == null ? 'Seleccione un tipo' : null,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Solicitud',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.trim().isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.trim().isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              FilePickerWidget(
                onFilesPicked: (List<File> files) {
                  setState(() => _attachments.addAll(files));
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitTicket,
                child: const Text('Crear Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
