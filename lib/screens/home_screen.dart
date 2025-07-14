import 'package:flutter/material.dart';
import 'lista_screen.dart';
import 'tipoderegistro.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'GUARDA EQUIPAJES',
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
            const Icon(Icons.luggage, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 30),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TipoRegistroScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.blue),
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
                  MaterialPageRoute(builder: (context) => const ListaScreen()),
                );
              },
              icon: const Icon(Icons.list_alt, color: Colors.green),
              label: const Text(
                'Ver lista de equipajes',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.green, width: 2),
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
