import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'registro_card.dart'; //

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<Map<String, dynamic>> registrosCombinados = [];

  @override
  void initState() {
    super.initState();
    cargarRegistros();
  }

  Future<void> cargarRegistros() async {
    final registros = await DBHelper.obtenerRegistros();
    final encomiendas = await DBHelper.obtenerEncomiendas();

    final listaNormal = registros
        .map(
          (r) => {
            'tipo': 'registro',
            'nombre': r.nombre,
            'cedula': '${r.tipoId} ${r.cedula}',
            'maletas': r.maletas,
            'ficha': r.ficha,
            'fecha': r.fechaIngreso,
            'precioUnitario': r.precio,
          },
        )
        .toList();

    final listaEncomiendas = encomiendas
        .map(
          (e) => {
            'tipo': 'encomienda',
            'nombre': e.nombreConductor,
            'cedula': e.telefono,
            'maletas': e.maletas,
            'ficha': e.numeroBuseta,
            'fecha': e.fecha,
            'valorGuardado': e.valorGuardado,
            'valorEncomienda': e.valorEncomienda,
          },
        )
        .toList();

    setState(() {
      registrosCombinados = [
        ...listaNormal.toList(),
        ...listaEncomiendas.toList(),
      ];
    });
  }

  int calcularPrecioRegistro(int maletas, int precioUnitario, DateTime fecha) {
    final duracion = DateTime.now().difference(fecha);
    final bloques = (duracion.inHours / 12)
        .ceil()
        .clamp(1, double.infinity)
        .toInt();
    return bloques * maletas * precioUnitario;
  }

  int calcularPrecioEncomienda(int valorGuardado, int maletas) {
    return valorGuardado * maletas; // Precio fijo por encomienda
  }

  void marcarComoEntregado(int index) {
    setState(() {
      registrosCombinados.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro eliminado (solo visualmente)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Colors.grey[100]!;
    final Color cardColor = Colors.white;
    final BorderRadius cardRadius = BorderRadius.circular(24);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'EQUIPAJES Y ENCOMIENDAS',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.black,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.blue[700],
            size: 28,
          ),
        ),
      ),
      body: registrosCombinados.isEmpty
          ? const Center(
              child: SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: registrosCombinados.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = registrosCombinados[index];
                final tipo = item['tipo'];
                final fecha = DateTime.parse(item['fecha']);

                final precio = tipo == 'registro'
                    ? calcularPrecioRegistro(
                        item['maletas'],
                        item['precioUnitario'] ?? 0,
                        fecha,
                      )
                    : calcularPrecioEncomienda(
                        item['valorGuardado'] ?? 0,
                        item['maletas'],
                      );

                return RegistroCard(
                  item: item,
                  precio: precio, 
                  onEntregar: () => marcarComoEntregado(index),
                );
              },
            ),
    );
  }
}
