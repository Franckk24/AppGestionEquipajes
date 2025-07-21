import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistroCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEntregar;
  final int precio;

  const RegistroCard({
    super.key,
    required this.item,
    required this.onEntregar,
    required this.precio,
  });

  @override
  Widget build(BuildContext context) {
    final tipo = item['tipo'];
    final nombre = item['nombre'];
    final ficha = item['ficha'];
    final maletas = item['maletas'];
    final fechaTexto = item['fecha'];
    final fecha = DateTime.parse(fechaTexto);
    final fechaBonita = DateFormat('dd/MM/yyyy - hh:mm a').format(fecha);
    final horas = DateTime.now().difference(fecha).inHours;

    final detalleFicha = tipo == 'registro'
        ? 'Ficha: $ficha'
        : 'Buseta: $ficha';

    final detalleIdentificacion = tipo == 'registro'
        ? 'Identificación: ${item['cedula']}'
        : 'Teléfono: ${item['cedula']}';

    final cardColor = Colors.white;
    final BorderRadius cardRadius = BorderRadius.circular(24);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
              width: 3,
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
                        style: const TextStyle(
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
                    Icon(Icons.credit_card, color: Colors.grey[500], size: 21),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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
                    TextButton(
                      onPressed: onEntregar,
                      style: TextButton.styleFrom(
                        backgroundColor: tipo == 'registro'
                            ? const Color(0xFF007AFF)
                            : const Color(0xFF34C759),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        tipo == 'registro'
                            ? 'Entregar equipaje'
                            : 'Entregar encomienda',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
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
    );
  }
}
