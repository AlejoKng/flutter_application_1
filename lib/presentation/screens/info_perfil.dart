// ignore_for_file: file_names, unused_local_variable, use_build_context_synchronously, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/application/services/crear_usuario.dart';
import 'package:flutter_application_1/data/file_storage.dart';
import 'package:flutter_application_1/main.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class InfoPerfil extends StatefulWidget {
  InfoPerfil({Key? key}) : super(key: key);
  final FileStorage fileStorageExample = FileStorage();
  @override
  _InfoPerfilState createState() => _InfoPerfilState();
}

class _InfoPerfilState extends State<InfoPerfil> {
  File? _image;
  TextEditingController nombreController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController identificacionController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  CrearUsuario creausuario = CrearUsuario();

  Future<void> _takePicture() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _saveImage(_image!);
    }
  }

  Future<String> _saveImage(File image) async {
    try {
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

      final String newFileName = 'fotoperfil_$formattedDate.png';
      final String newFilePath = '${appDocumentsDir.path}/$newFileName';
      await image.copy(newFilePath);

      await GallerySaver.saveImage(newFilePath);

      return newFilePath;
    } catch (e) {
      print('Error al guardar la imagen: $e');
      return '';
    }
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _saveUserData() async {
    try {
      User? newUser = await creausuario.signUp(
          correoController.text.trim(), contrasenaController.text.trim());
      await FirebaseFirestore.instance.collection('Users').doc().set({
        'nombre': nombreController.text.trim(),
        'correo': correoController.text.trim(),
        'cc': identificacionController.text.trim(),
        'contraseña': contrasenaController.text.trim(),
        'numero': numeroController.text.trim(),
        // Puedes añadir más campos según tus necesidades
      });

      print('Usuario registrado y datos guardados en Firestore');

      // Después de guardar los datos, navegar a la página principal y eliminar los valores de los campos
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: '')),
      );

      // Limpiar los valores de los campos
      nombreController.clear();
      correoController.clear();
      identificacionController.clear();
      numeroController.clear();
      contrasenaController.clear();
    } catch (e) {
      print('Error al registrar el usuario: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _image == null
                ? Image.asset(
                    'assets/icons/userphoto-icon.png',
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    _image!,
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cambiar Imagen'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _takePicture();
                        },
                        child: const Text('Tomar Foto'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _pickImage();
                        },
                        child: const Text('Seleccionar de Galería'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Cambiar Imagen'),
            ),
            TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre Completo"),
            ),
            TextFormField(
              controller: correoController,
              decoration: const InputDecoration(labelText: "Correo"),
            ),
            TextFormField(
              controller: identificacionController,
              decoration: const InputDecoration(labelText: "Identificación"),
            ),
            TextFormField(
              controller: numeroController,
              decoration: const InputDecoration(labelText: "numero"),
            ),
            TextFormField(
              controller: contrasenaController,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _saveUserData();
                    print('Las contraseñas no coinciden');
                  },
                  child: const Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
