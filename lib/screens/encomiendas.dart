import 'package:flutter/material.dart';
import '../models/encomiendas.dart';
import '../database/db_helper.dart';

class RegistroEncomiendaScreen extends StatefulWidget {
  const RegistroEncomiendaScreen({super.key});

  @override
  State<RegistroEncomiendaScreen> createState() =>
      _RegistroEncomiendaScreenState();
}

class _RegistroEncomiendaScreenState extends State<RegistroEncomiendaScreen> {
  final _formKey = GlobalKey<FormState>();

  final nombreConductorController = TextEditingController();
  final telefonoController = TextEditingController();
  final numeroBusetaController = TextEditingController();
  final valorEncomiendaController = TextEditingController();
  final valorGuardadoController = TextEditingController();

  int? maletas;

  Future<void> guardarRegistro() async {
    if (_formKey.currentState!.validate() && maletas != null) {
      final nombreConductor = nombreConductorController.text.trim();
      final telefono = telefonoController.text.trim();
      final numeroBuseta = numeroBusetaController.text.trim();
      final valorEncomienda = int.parse(valorEncomiendaController.text.trim());
      final valorGuardado = int.parse(valorGuardadoController.text.trim());
      final ahora = DateTime.now();
      final fecha = ahora.toIso8601String();

      final nuevaEncomienda = Encomienda(
        nombreConductor: nombreConductor,
        telefono: telefono,
        numeroBuseta: numeroBuseta,
        maletas: maletas!,
        valorEncomienda: valorEncomienda,
        valorGuardado: valorGuardado,
        fecha: fecha,
      );

      await DBHelper.insertarEncomienda(nuevaEncomienda);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
              const Text(
                'La encomienda fue registrada correctamente.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );

      nombreConductorController.clear();
      telefonoController.clear();
      numeroBusetaController.clear();
      valorEncomiendaController.clear();
      valorGuardadoController.clear();
      setState(() => maletas = null);
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
          'REGISTRO ENCOMIENDAS',
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
              const SizedBox(height: 10),
              Center(
                child: Icon(
                  Icons.local_shipping,
                  size: 80,
                  color: Colors.orange.shade400,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Completa los datos para registrar la encomienda',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: nombreConductorController,
                decoration: inputDecoration('Nombre del conductor'),
                maxLength: 30,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Campo obligatorio'
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: telefonoController,
                decoration: inputDecoration('Número de teléfono'),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Campo obligatorio'
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: numeroBusetaController,
                decoration: inputDecoration('Número de buseta'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Campo obligatorio'
                    : null,
              ),
              const SizedBox(height: 20),

              const Text(
                'Cantidad de maletas:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: List.generate(10, (index) {
                  final numero = index + 1;
                  final seleccionado = maletas == numero;
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
                    onSelected: (_) => setState(() => maletas = numero),
                  );
                }),
              ),
              if (maletas == null)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Selecciona la cantidad de maletas',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 20),

              TextFormField(
                controller: valorEncomiendaController,
                decoration: inputDecoration('Valor de la encomienda (COP)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null ||
                        value.trim().isEmpty ||
                        !RegExp(r'^\d+$').hasMatch(value)
                    ? 'Ingrese un valor válido'
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: valorGuardadoController,
                decoration: inputDecoration('Valor por guardado (COP)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null ||
                        value.trim().isEmpty ||
                        !RegExp(r'^\d+$').hasMatch(value)
                    ? 'Ingrese un valor válido'
                    : null,
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                icon: Icon(Icons.save, color: Colors.white),
                label: Text(
                  'Guardar Registro',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: guardarRegistro,
              ),
              const SizedBox(height: 20),
              Divider(),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Asegúrate que los valores sean correctos\nantes de guardar la encomienda.',
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
