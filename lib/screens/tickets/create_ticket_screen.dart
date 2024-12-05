import 'package:flutter/material.dart';
import 'package:oirs_utem/services/oirs_api_service.dart';
import 'package:oirs_utem/widgets/file_picker_widget.dart';
import 'dart:io';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
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
