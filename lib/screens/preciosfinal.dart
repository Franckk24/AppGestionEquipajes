import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class PreciosFinal extends StatefulWidget {
  const PreciosFinal({super.key});

  @override
  State<PreciosFinal> createState() => _PreciosFinalState();
}

class _PreciosFinalState extends State<PreciosFinal> {
  int totalRegistros = 0;
  int totalEncomiendas = 0;
  int totalValorEncomienda = 0;
  int totalGeneral = 0;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarTotales();
  }

  Future<void> cargarTotales() async {
    final totales = await DBHelper.obtenerTotalesDesglosados();
    setState(() {
      totalRegistros = totales['totalRegistros'] ?? 0;
      totalEncomiendas = totales['totalEncomiendas'] ?? 0;
      totalGeneral = totales['totalGeneral'] ?? 0;
      totalValorEncomienda = totales['totalValorEncomienda'] ?? 0;
      cargando = false;
    });
  }

  Widget buildMetric(String title, int value, IconData icon, Color color) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(
          '\$$value',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          '📊 TOTALES & PRECIOS',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  buildMetric(
                    'Total de Registros Normales',
                    totalRegistros,
                    Icons.luggage,
                    Colors.blue,
                  ),
                  buildMetric(
                    'Total de Encomiendas',
                    totalEncomiendas,
                    Icons.local_shipping,
                    Colors.green,
                  ),
                  buildMetric(
                    'Total General',
                    totalGeneral,
                    Icons.attach_money,
                    Colors.orange,
                  ),

                  const SizedBox(height: 12),
                  Divider(thickness: 1),
                  const SizedBox(height: 12),

                  // Total Valor Encomiendas separado
                  buildMetric(
                    'Total Valor Encomiendas',
                    totalValorEncomienda,
                    Icons.payments,
                    Colors.purple,
                  ),

                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen General',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '- Registros normales son pasajeros estándar.\n'
                          '- Las encomiendas son productos o paquetes adicionales.\n'
                          '- El Total General combina ambos valores.\n'
                          '- Valor Encomiendas indica solo lo recibido por este concepto.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: cargarTotales,
                    icon: Icon(Icons.refresh, size: 22),
                    label: const Text('Actualizar Totales'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Última actualización:\n${DateTime.now().toLocal().toString().split('.')[0]}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
