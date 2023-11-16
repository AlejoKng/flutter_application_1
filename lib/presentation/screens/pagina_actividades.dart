import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/principal_contactos.dart';
import 'package:flutter_application_1/presentation/screens/principal_whatsApp.dart';
import 'package:flutter_application_1/presentation/screens/pagina_documentos.dart';

class PaginaActividades extends StatefulWidget {
  const PaginaActividades({Key? key}) : super(key: key);

  @override
  _PaginaActividadesState createState() => _PaginaActividadesState();
}

class _PaginaActividadesState extends State<PaginaActividades> {
  List<Actividad> actividades = []; // Lista de actividades

  @override
  void initState() {
    super.initState();

    // Inicializar el vector de actividades con dos actividades diferentes
    Actividad actividad1 = Actividad(
      dia: 10,
      mes: 'Nov',
      nota: 'Reunión de trabajo',
      hora: '15:00',
    );

    Actividad actividad2 = Actividad(
      dia: 15,
      mes: 'Nov',
      nota: 'Entrenamiento',
      hora: '18:30',
    );

    setState(() {
      actividades = [actividad1, actividad2];
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    double iconSizeButt = screenWidth * 0.2;
    double iconSizePerf = screenWidth * 0.133;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 151, 206, 251),
        title: const Text('WhatsApp'),
      ),
      body: Column(
        children: <Widget>[
          // División superior para botones de navegación
          Container(
            color: const Color.fromARGB(255, 151, 206, 251),
            height: 80,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/perfil1.png',
                      width: iconSizePerf,
                      height: iconSizePerf,
                    ),
                    onPressed: () {
                      // Acción al presionar el botón
                    },
                  ),
                ],
              ),
            ),
          ),
          // División central para mostrar contenido
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: ListView.builder(
                itemCount: actividades.length,
                itemBuilder: (context, index) {
                  Actividad actividad = actividades[index];
                  return ListTile(
                    title: Text('${actividad.dia} ${actividad.mes}'),
                    subtitle: Text(actividad.nota),
                    trailing: Text(actividad.hora),
                  );
                },
              ),
            ),
          ),
          // División inferior para botones de imagen
          Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            height: 100,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/contactos2.png',
                      width: iconSizeButt,
                      height: iconSizeButt,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrincipalContactos()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/watsapp2.png',
                      width: iconSizeButt,
                      height: iconSizeButt,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrincipalWhatsApp()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/seg1.png',
                      width: iconSizeButt,
                      height: iconSizeButt,
                    ),
                    onPressed: () {
                      // Acción para el botón 3
                    },
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/docs2.png',
                      width: iconSizeButt,
                      height: iconSizeButt,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PaginaDocumentos()),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Lógica para agregar un recordatorio
                      _mostrarVentanaEmergente();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Función para mostrar la ventana emergente de agregar recordatorio
  Future<void> _mostrarVentanaEmergente() async {
    DateTime fechaSeleccionada = DateTime.now();
    TimeOfDay horaSeleccionada = TimeOfDay.now();
    String nota = '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Recordatorio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de fecha con calendario predeterminado
              ElevatedButton(
                onPressed: () async {
                  DateTime? fecha = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (fecha != null) {
                    setState(() {
                      fechaSeleccionada = fecha;
                    });
                  }
                },
                child: const Text('Seleccionar Fecha'),
              ),
              const SizedBox(height: 8),
              // Campo de hora
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? hora = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (hora != null) {
                    setState(() {
                      horaSeleccionada = hora;
                    });
                  }
                },
                child: const Text('Seleccionar Hora'),
              ),
              const SizedBox(height: 8),
              // Campo de nota
              TextField(
                onChanged: (value) {
                  nota = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Nota o Recordatorio',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Lógica para guardar el recordatorio en la lista
                Actividad nuevaActividad = Actividad(
                  dia: fechaSeleccionada.day,
                  mes: _obtenerNombreMes(fechaSeleccionada.month),
                  nota: nota,
                  hora: horaSeleccionada.format(context),
                );
                setState(() {
                  actividades.add(nuevaActividad);
                });
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Función para obtener el nombre del mes
  String _obtenerNombreMes(int numeroMes) {
    const nombresMeses = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return nombresMeses[numeroMes - 1];
  }
}

// Clase para representar una actividad o recordatorio
class Actividad {
  final int dia;
  final String mes;
  final String nota;
  final String hora;

  Actividad({
    required this.dia,
    required this.mes,
    required this.nota,
    required this.hora,
  });
}
