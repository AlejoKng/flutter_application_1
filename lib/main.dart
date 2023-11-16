import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/presentation/screens/info_perfil.dart';
import 'package:flutter_application_1/presentation/screens/principal_contactos.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(220, 221, 235, 253),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  Future<void> _handleLogIn() async {
    try {
      // Verificar que los campos no estén vacíos
      if (usuarioController.text.isEmpty || contrasenaController.text.isEmpty) {
        // Mostrar ventana emergente con error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Por favor, completa todos los campos.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // Filtrar en la base de datos
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .where('correo', isEqualTo: usuarioController.text)
              .get();

      if (querySnapshot.docs.isEmpty) {
        // El correo no existe en la base de datos
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Correo no encontrado.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // Verificar la contraseña
      DocumentSnapshot<Map<String, dynamic>> userDocument =
          querySnapshot.docs.first;
      String storedPassword = userDocument['contraseña'];

      if (contrasenaController.text == storedPassword) {
        // Contraseña correcta

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PrincipalContactos(),
          ),
        );
      } else {
        // Contraseña incorrecta
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Contraseña incorrecta.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error en el log in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double logoSize = screenHeight * 0.25;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/images/logoprincipal.jpg',
              width: logoSize,
              height: logoSize,
              fit: BoxFit.cover,
            ),
            const Text(
              'NexusHub Pro',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: usuarioController,
              decoration:
                  const InputDecoration(labelText: "Ingresa tu usuario"),
            ),
            TextFormField(
              controller: contrasenaController,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _handleLogIn,
                  child: const Text('Log In'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InfoPerfil()),
                    );
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ModeloBase extends StatelessWidget {
  const ModeloBase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // División superior para botones de navegación
          Container(
            color: Colors.blue, // Color de fondo de la división superior
            height: 80, // Altura de la división superior
            child: const Center(
              child: Text('Contenido superior'),
            ),
          ),
          // División central para mostrar contenido
          Expanded(
            child: Container(
              color: Colors.green, // Color de fondo de la división central
              child: const Center(
                child: Text('Contenido del centro'),
              ),
            ),
          ),
          // División inferior para botones de imagen
          Container(
            color: Colors.red, // Color de fondo de la división inferior
            height: 100, // Altura de la división inferior
            child: const Center(
              child: Text('Contenido inferior'),
            ),
          ),
        ],
      ),
    );
  }
}
