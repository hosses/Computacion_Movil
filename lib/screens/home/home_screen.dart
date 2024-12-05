import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../tickets/create_ticket_screen.dart';
import '../tickets/ticket_list_screen.dart';
import '../../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OIRS UTEM'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Ver mis tickets'),
            leading: const Icon(Icons.list),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TicketListScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Crear nuevo ticket'),
            leading: const Icon(Icons.add),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateTicketScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Iniciar con Google'),
            leading: const Icon(Icons.add),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
