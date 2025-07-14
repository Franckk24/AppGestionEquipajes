import 'package:flutter/material.dart';
import '../models/registro.dart';
import '../database/db_helper.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final nombreController = TextEditingController();
  final cedulaController = TextEditingController();
  final fichaController = TextEditingController();
  final precioController = TextEditingController();

  String? tipoIdSeleccionado;
  int? maletasSeleccionadas;

  final List<String> tiposId = ['CC', 'TI', 'CE', 'Pasaporte'];
  final List<int> opcionesMaletas = List.generate(10, (i) => i + 1);

  Future<void> guardarRegistro() async {
    if (_formKey.currentState!.validate() && maletasSeleccionadas != null) {
      final nombre = nombreController.text.trim();
      final tipoId = tipoIdSeleccionado!;
      final cedula = cedulaController.text.trim();
      final maletas = maletasSeleccionadas!;
      final ficha = fichaController.text.trim();
      final precio = int.parse(precioController.text.trim());
      final ahora = DateTime.now();
      final fechaIngreso = ahora.toIso8601String();

      final nuevoRegistro = Registro(
        nombre: nombre,
        tipoId: tipoId,
        cedula: cedula,
        maletas: maletas,
        ficha: ficha,
        precio: precio,
        fechaIngreso: fechaIngreso,
      );

      print('Registro creado: ${nuevoRegistro.toMap()}');

      await DBHelper.insertarRegistro(nuevoRegistro);

      // Mostrar mensaje visual bonito
      void mostrarDialogoExitoso() {
        showDialog(
          context: context,
          barrierDismissible: false, // Evita que se cierre tocando fuera
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Colors.green.shade700,
                ),
                const SizedBox(height: 16),
                const Text(
                  '¡Registro exitoso!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'El equipaje fue registrado correctamente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      mostrarDialogoExitoso();

      nombreController.clear();
      cedulaController.clear();
      fichaController.clear();
      precioController.clear();
      setState(() {
        tipoIdSeleccionado = null;
        maletasSeleccionadas = null;
      });
    }
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.grey[800]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'REGISTRAR EQUIPAJE',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30), // 👈 Esto es nuevo
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Nombre
                    TextFormField(
                      controller: nombreController,
                      decoration: inputDecoration('Nombre del cliente'),
                      maxLength: 30,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Tipo ID
                    DropdownButtonFormField<String>(
                      decoration: inputDecoration('Tipo de identificación'),
                      value: tipoIdSeleccionado,
                      items: tiposId
                          .map(
                            (tipo) => DropdownMenuItem(
                              value: tipo,
                              child: Text(tipo),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          tipoIdSeleccionado = value;
                          cedulaController.clear(); // 👈 Limpia el campo
                        });
                      },
                      validator: (value) => value == null
                          ? 'Seleccione un tipo de identificación'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Número ID con texto de ayuda
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: cedulaController,
                          decoration: inputDecoration(
                            'Número de identificación',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (tipoIdSeleccionado == null) {
                              return 'Seleccione primero el tipo';
                            }
                            if (value == null || value.isEmpty) {
                              return 'Campo obligatorio';
                            }
                            if (!RegExp(r'^\d+$').hasMatch(value)) {
                              return 'Solo números';
                            }

                            int longitudEsperada = tipoIdSeleccionado == 'CC'
                                ? 10
                                : tipoIdSeleccionado == 'TI'
                                ? 11
                                : tipoIdSeleccionado == 'CE'
                                ? 12
                                : tipoIdSeleccionado == 'Pasaporte'
                                ? 15
                                : 0;

                            if (value.length != longitudEsperada) {
                              return 'Debe tener exactamente $longitudEsperada dígitos';
                            }

                            return null;
                          },
                        ),

                        // Texto dinámico explicando la cantidad de dígitos
                        if (tipoIdSeleccionado != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                            child: Text(
                              'Debe ingresar exactamente ${tipoIdSeleccionado == 'CC'
                                  ? 10
                                  : tipoIdSeleccionado == 'TI'
                                  ? 11
                                  : tipoIdSeleccionado == 'CE'
                                  ? 12
                                  : 15} dígitos',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Número de maletas
                    const Text(
                      'Número de maletas:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(10, (index) {
                        final numero = index + 1;
                        final seleccionado = maletasSeleccionadas == numero;
                        return ChoiceChip(
                          label: Text(
                            '$numero',
                            style: TextStyle(
                              color: seleccionado
                                  ? Colors.white
                                  : Colors.blue.shade700,
                            ),
                          ),
                          selected: seleccionado,
                          selectedColor: Colors.blue.shade700,
                          backgroundColor: Colors.white,
                          shape: StadiumBorder(
                            side: BorderSide(color: Colors.blue.shade700),
                          ),
                          onSelected: (_) {
                            setState(() => maletasSeleccionadas = numero);
                          },
                        );
                      }),
                    ),
                    if (maletasSeleccionadas == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Selecciona una cantidad de maletas',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Ficha
                    TextFormField(
                      controller: fichaController,
                      decoration: inputDecoration('Ficha entregada'),
                      maxLength: 10,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Precio por maleta
                    TextFormField(
                      controller: precioController,
                      decoration: inputDecoration('Precio por maleta (COP)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Campo obligatorio';
                        if (!RegExp(r'^\d+$').hasMatch(value))
                          return 'Solo números';
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Botón guardar
                    OutlinedButton.icon(
                      icon: const Icon(Icons.save, color: Colors.blue),
                      label: const Text(
                        'Guardar registro',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: guardarRegistro,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
