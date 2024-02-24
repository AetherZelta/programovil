import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final RegExp emailValidator =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final pwd = TextEditingController();
  final confirmPwd = TextEditingController();
  Uint8List? _image;
  File? selectedIMage;
  var _hidePwd = true;
  var _hideConfirmPwd = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          body: Stack(
        //thanks for watching
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 5, 1, 2),
                  Color.fromARGB(255, 21, 30, 55),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, right: 22),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  'Crear una\n     Cuenta',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 30,
            child: GestureDetector(
              onTap: () {
                showImagePickerOption(context);
              },
              child: Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 60, backgroundImage: MemoryImage(_image!))
                      : const CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                        ),
                ],
              ),
            ),
          ),
          Padding(
            //padding: const EdgeInsets.fromLTRB(0.0, 200.0, 0.0, 0.0),
            padding: const EdgeInsets.only(top: 220.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                  //topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
                color: Colors.white,
              ),
              height: 500,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 18.0, right: 18),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingresa nombre completo';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text(
                              'Nombre Completo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingresa Correo Electronico';
                            } else if (!emailValidator.hasMatch(value)) {
                              return 'Ingrese un correo valido';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              label: Text(
                            'Correo Electronico',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )),
                        ),
                        TextFormField(
                          controller: pwd,
                          obscureText: _hidePwd,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingresa Constraseña';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _hidePwd
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _hidePwd = !_hidePwd;
                                  });
                                },
                              ),
                              label: const Text(
                                'Contraseña',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                        TextFormField(
                          controller: confirmPwd,
                          obscureText: _hideConfirmPwd,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Confirma Contraseña';
                            } else if (value != pwd.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _hideConfirmPwd
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _hideConfirmPwd = !_hideConfirmPwd;
                                  });
                                },
                              ),
                              label: const Text(
                                'Confirmar Contraseña',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Se ha completado el registro'),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            height: 55,
                            width: 200,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 27, 46, 98),
                                  Color.fromARGB(255, 15, 31, 50),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              //color: const Color.fromARGB(255, 14, 78, 130),
                            ),
                            child: const Center(
                              child: Text(
                                'Registrar',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Tengo una Cuenta',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 7,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 70,
                            ),
                            Text("Gallery")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 70,
                            ),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop(); //close the model sheet
  }

  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }
}
