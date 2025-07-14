import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'package:intl/intl.dart';

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
                final nombre = item['nombre'];
                final ficha = item['ficha'];
                final maletas = item['maletas'];
                final fechaTexto = item['fecha'];
                final fecha = DateTime.parse(fechaTexto);
                final fechaBonita = DateFormat('dd/MM/yyyy - hh:mm a').format(fecha);
                final horas = DateTime.now().difference(fecha).inHours;

                final precio = tipo == 'registro'
                    ? calcularPrecioRegistro(maletas, item['precioUnitario'] ?? 0, fecha)
                    : calcularPrecioEncomienda(item['valorGuardado'] ?? 0, maletas);

                final detalleFicha = tipo == 'registro' ? 'Ficha: $ficha' : 'Buseta: $ficha';
                final detalleIdentificacion = tipo == 'registro'
                    ? 'Identificación: ${item['cedula']}'
                    : 'Teléfono: ${item['cedula']}';

                // iOS-like shadow and divider
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: AnimatedScale(
                    scale: 1,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    child: Material(
                      color: cardColor,
                      elevation: 0,
                      borderRadius: cardRadius,
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: cardRadius,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: Border.all(
                            color: tipo == 'registro'
                                ? const Color(0xFF007AFF).withOpacity(0.50)
                                : const Color(0xFF34C759).withOpacity(0.50),
                            width:3,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nombre y tipo
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      nombre,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                        letterSpacing: 0.1,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 11),
                                    decoration: BoxDecoration(
                                      color: tipo == 'registro'
                                          ? const Color(0xFF007AFF).withOpacity(0.13)
                                          : const Color(0xFF34C759).withOpacity(0.13),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      tipo == 'registro' ? 'Registro' : 'Encomienda',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: tipo == 'registro'
                                            ? const Color(0xFF007AFF)
                                            : const Color(0xFF34C759),
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Ficha/Buseta y Maletas
                              Row(
                                children: [
                                  Icon(Icons.credit_card,
                                      color: Colors.grey[500], size: 21),
                                  const SizedBox(width: 8),
                                  Text(
                                    detalleFicha,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(Icons.work, color: Colors.grey[500], size: 21),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Maletas: $maletas',
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Identificación o Teléfono
                              Row(
                                children: [
                                  Icon(Icons.perm_identity,
                                      color: Colors.grey[500], size: 21),
                                  const SizedBox(width: 8),
                                  Text(
                                    detalleIdentificacion,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // SOLO PARA ENCOMIENDAS: valor total
                              if (tipo == 'encomienda')
                                Row(
                                  children: [
                                    Icon(Icons.attach_money,
                                        color: Colors.grey[500], size: 21),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Valor encomienda: \$${item['valorEncomienda']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              if (tipo == 'encomienda') const SizedBox(height: 12),

                              // Fecha y horas
                              Row(
                                children: [
                                  Icon(Icons.access_time,
                                      color: Colors.grey[500], size: 21),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ingreso: $fechaBonita',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF8E8E93),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.only(left: 29),
                                child: Text(
                                  'Horas transcurridas: $horas',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFB0B0B8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Precio y botón
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Precio total: \$${precio.toString()}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 38,
                                    width: 38,
                                    child: Material(
                                      color: tipo == 'registro'
                                          ? const Color(0xFF007AFF)
                                          : const Color(0xFF34C759),
                                      shape: const CircleBorder(),
                                      elevation: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.check_rounded,
                                            color: Colors.white, size: 25),
                                        onPressed: () => marcarComoEntregado(index),
                                        tooltip: 'Marcar como entregado',
                                        splashRadius: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}