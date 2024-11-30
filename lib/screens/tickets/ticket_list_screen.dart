import 'package:flutter/material.dart';
import 'package:oirs_utem/services/oirs_api_service.dart';
import '../../models/ticket.dart';
import '../../widgets/ticket_card.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  _TicketListScreenState createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  final OirsApiService _apiService = OirsApiService();
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    try {
      final loadedTickets = await _apiService.getTickets();
      setState(() {
        tickets = loadedTickets.cast<Ticket>();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar tickets')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Tickets')),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return TicketCard(ticket: tickets[index]);
        },
      ),
    );
  }
}
