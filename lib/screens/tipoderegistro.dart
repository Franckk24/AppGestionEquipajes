import 'package:flutter/material.dart';
import 'registro_screen.dart';
import 'encomiendas.dart';

class TipoRegistroScreen extends StatelessWidget {
  const TipoRegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'TIPO DE REGISTRO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 30),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistroScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.luggage, color: Colors.blue),
              label: const Text(
                'Registrar equipaje',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue, width: 2),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistroEncomiendaScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.local_shipping, color: Colors.orange),
              label: const Text(
                'Registrar encomienda',
                style: TextStyle(fontSize: 18, color: Colors.orange),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.orange, width: 2),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
