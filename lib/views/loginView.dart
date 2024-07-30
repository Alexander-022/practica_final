import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practica_final/controllers/Service.dart';
import 'package:validators/validators.dart';

class LoginView extends StatefulWidget {
  const LoginView({ Key? key }) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();

  void inicio() async {
    FToast ftoast = FToast();
    ftoast.init(context);

    if (_formKey.currentState!.validate()) {
      Map<String, String> data = {
        "correo": correoControl.text,
        "clave": claveControl.text
      };

      log(data.toString());

      Service c = Service();
      try {
        var value = await c.session(data);

        if (value.code == '200') {
          ftoast.showToast(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.green.shade500,
              ),
              child: Text(
                "Has ingresado al sistema " + (value.user ?? ''),
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            gravity: ToastGravity.CENTER,
            toastDuration: const Duration(seconds: 3),
          );
          Navigator.pushNamed(context, '/principal');
        } else {
          String errorMessage = value.datos["errors"] ?? "Correo o clave incorrectos";
          ftoast.showToast(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.red.shade900,
              ),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            gravity: ToastGravity.CENTER,
            toastDuration: const Duration(seconds: 3),
          );
        }
      } catch (e) {
        log(e.toString());
        ftoast.showToast(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.red.shade900,
            ),
            child: Text(
              "Clave o correo incorrectos.",
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          gravity: ToastGravity.CENTER,
          toastDuration: const Duration(seconds: 3),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "PRODUCTOS",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "En esta app se muestran todos los productos",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Inicio de sesión",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  suffixIcon: Icon(Icons.alternate_email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Ingrese su correo";
                  }
                  if (!isEmail(value)) {
                    return "Ingrese un correo válido";
                  }
                  return null; // Agregado para devolver null si la validación es correcta
                },
                controller: correoControl,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                obscureText: true,
                obscuringCharacter: "*",
                decoration: const InputDecoration(
                  labelText: 'Clave',
                  suffixIcon: Icon(Icons.key),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Ingrese su clave";
                  }
                  return null; // Agregado para devolver null si la validación es correcta
                },
                controller: claveControl,
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: () {
                  inicio(); // Llamar a la función `inicio`
                },
                child: const Text("Inicio"),
              ),
            ),
            Row(
              children: <Widget>[
                const Text('¿Perdiste tu cuenta?'),
                TextButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, '/re');
                  },
                  child: const Text(
                    'Regístrate',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
