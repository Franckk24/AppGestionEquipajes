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

  final nombreController = TextEditingController();
  final cedulaController = TextEditingController();
  final fichaController = TextEditingController();
  final precioController = TextEditingController();

  String? tipoIdSeleccionado;
  int? maletasSeleccionadas;

  final List<String> tiposId = ['CC', 'TI', 'CE', 'Pasaporte'];

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

      await DBHelper.insertarRegistro(nuevoRegistro);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 60, color: Colors.green.shade700),
              const SizedBox(height: 16),
              const Text(
                '¡Registro exitoso!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text('El equipaje fue registrado correctamente.', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );

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
      labelStyle: TextStyle(color: Colors.grey.shade700),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'Registrar Equipaje',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Icon(Icons.luggage, size: 80, color: Colors.blueAccent),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Ingresa la información solicitada para registrar el equipaje',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: nombreController,
                decoration: inputDecoration('Nombre del cliente'),
                maxLength: 30,
                validator: (value) => value == null || value.trim().isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: inputDecoration('Tipo de identificación'),
                value: tipoIdSeleccionado,
                items: tiposId.map((tipo) {
                  return DropdownMenuItem(value: tipo, child: Text(tipo));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    tipoIdSeleccionado = value;
                    cedulaController.clear();
                  });
                },
                validator: (value) => value == null ? 'Seleccione un tipo de identificación' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: cedulaController,
                decoration: inputDecoration('Número de identificación'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (tipoIdSeleccionado == null) return 'Seleccione primero el tipo';
                  if (value == null || value.isEmpty) return 'Campo obligatorio';
                  if (!RegExp(r'^\d+$').hasMatch(value)) return 'Solo números';

                  int longitudEsperada = tipoIdSeleccionado == 'CC'
                      ? 10
                      : tipoIdSeleccionado == 'TI'
                          ? 11
                          : tipoIdSeleccionado == 'CE'
                              ? 12
                              : 15;

                  if (value.length != longitudEsperada) {
                    return 'Debe tener exactamente $longitudEsperada dígitos';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Número de maletas:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        color: seleccionado ? Colors.white : Colors.blue.shade700,
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

              TextFormField(
                controller: fichaController,
                decoration: inputDecoration('Ficha entregada'),
                maxLength: 10,
                validator: (value) => value == null || value.trim().isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: precioController,
                decoration: inputDecoration('Precio por maleta (COP)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo obligatorio';
                  if (!RegExp(r'^\d+$').hasMatch(value)) return 'Solo números';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                icon: Icon(Icons.save, color: Colors.white),
                label: Text(
                  'Guardar Registro',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: guardarRegistro,
              ),
              const SizedBox(height: 20),
              Divider(),
              Center(
                child: Text(
                  'Verifica que la información ingresada sea correcta antes de guardar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
