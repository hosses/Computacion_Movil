import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Crear una cuenta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Image.asset(
                'assets/images/google_logo.png',
                height: 24, // Ajusta el tamaño del logotipo
              ),
              label: const Text('Registrarse con Google'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                // Acción cuando se presiona el botón
                print("Registro con Google iniciado");
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navegar a otra pantalla o acción alternativa
                print("Navegar a iniciar sesión");
              },
              child: const Text('¿Ya tienes una cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
