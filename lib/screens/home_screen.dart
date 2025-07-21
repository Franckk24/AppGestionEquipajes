import 'package:flutter/material.dart';
import 'lista_screen.dart';
import 'tipoderegistro.dart';
import 'preciosfinal.dart';
import '../database/db_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'GUARDA EQUIPAJES',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Icon(Icons.luggage, size: 90, color: Colors.blueAccent),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Bienvenido al Sistema de Equipajes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Selecciona una opción para comenzar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () async {
                await DBHelper.iniciarJornada();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Jornada iniciada')),
                );
              },
              icon: const Icon(
                Icons.play_circle_fill,
                size: 24,
                color: Colors.white,
              ),
              label: const Text(
                'Iniciar Jornada',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    Colors.indigo, // Color diferente para destacarse
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () async {
                await DBHelper.finalizarJornada();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🗑️ Jornada finalizada y datos eliminados'),
                  ),
                );
              },
              icon: const Icon(
                Icons.stop_circle_rounded,
                size: 24,
                color: Colors.white,
              ),
              label: const Text(
                'Finalizar Jornada',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    Colors.redAccent, // Rojo para acción destructiva
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 30),
            Divider(thickness: 1),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'para selecionar algunas de estas opciones debes darle a iniciar jornada primero',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () {
                if (DBHelper.jornadaActiva) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TipoRegistroScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Debes iniciar la jornada primero.'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add, size: 24, color: Colors.white),
              label: const Text(
                'Registrar Equipajes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                if (DBHelper.jornadaActiva) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListaScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Debes iniciar la jornada primero.'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.list_alt, size: 24, color: Colors.white),
              label: const Text(
                'Ver Lista de Equipajes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                if (DBHelper.jornadaActiva) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PreciosFinal(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Debes iniciar la jornada primero.'),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.attach_money,
                size: 24,
                color: Colors.white,
              ),
              label: const Text(
                'Ver Totales / Precios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 40),

            Divider(thickness: 1),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Versión 1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '© 2025 Guarda Equipajes',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
