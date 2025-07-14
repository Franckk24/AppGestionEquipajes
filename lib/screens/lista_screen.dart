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

    for (var r in listaNormal) {
      print('precioUnitario: ${r['precioUnitario']}');
    }

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

    print('Primer registro normal: ${listaNormal.first}');

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
    return Scaffold(
      appBar: AppBar(title: const Text('Equipajes y Encomiendas')),
      body: registrosCombinados.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: registrosCombinados.length,
              itemBuilder: (context, index) {
                final item = registrosCombinados[index];
                final tipo = item['tipo'];
                final nombre = item['nombre'];
                final ficha = item['ficha'];
                final maletas = item['maletas'];
                final fechaTexto = item['fecha'];
                final fecha = DateTime.parse(fechaTexto); // desde SQLite
                final fechaBonita = DateFormat(
                  'dd/MM/yyyy - hh:mm a',
                ).format(fecha);
                final horas = DateTime.now().difference(fecha).inHours;

                if (tipo == 'registro') {
                  print(
                    'Calculando precio para: maletas=$maletas, precioUnitario=${item['precioUnitario']}, fecha=$fecha',
                  );
                }

                // Mostrar precio solo si es registro normal
                final precio = tipo == 'registro'
                    ? calcularPrecioRegistro(
                        maletas,
                        item['precioUnitario'] ?? 0,
                        fecha,
                      )
                    : calcularPrecioEncomienda(
                        item['valorGuardado'] ?? 0,
                        maletas,
                      );
                print('Precio final mostrado en pantalla: $precio');

                // Mostrar texto solo si aplica
                final detalleFicha = tipo == 'registro'
                    ? 'Ficha: $ficha'
                    : 'Buseta: $ficha';
                final detalleIdentificacion = tipo == 'registro'
                    ? 'Identificación: ${item['cedula']}'
                    : 'Teléfono: ${item['cedula']}';
                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: tipo == 'registro' ? Colors.blue : Colors.green,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre y tipo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              nombre,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: tipo == 'registro'
                                    ? Colors.blue
                                    : Colors.green,
                              ),
                            ),
                            Text(
                              tipo == 'registro' ? 'Registro' : 'Encomienda',
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Ficha/Buseta y Maletas
                        Row(
                          children: [
                            Icon(Icons.card_travel, color: Colors.grey[600]),
                            const SizedBox(width: 6),
                            Text(
                              detalleFicha,
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Spacer(),
                            Icon(Icons.work, color: Colors.grey[600]),
                            const SizedBox(width: 6),
                            Text(
                              'Maletas: $maletas',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Identificación o Teléfono
                        Row(
                          children: [
                            Icon(Icons.perm_identity, color: Colors.grey[600]),
                            const SizedBox(width: 6),
                            Text(
                              detalleIdentificacion,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // SOLO PARA ENCOMIENDAS: valor total
                        if (tipo == 'encomienda')
                          Row(
                            children: [
                              Icon(Icons.attach_money, color: Colors.grey[600]),
                              const SizedBox(width: 6),
                              Text(
                                'Valor encomienda: \$${item['valorEncomienda']}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),

                        // Fecha y horas
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.grey[600]),
                            const SizedBox(width: 6),
                            Text(
                              'Ingreso: $fechaBonita',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Horas transcurridas: $horas',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Precio y botón
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Precio total: \$${precio.toString()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 28,
                              ),
                              onPressed: () => marcarComoEntregado(index),
                              tooltip: 'Marcar como entregado',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
