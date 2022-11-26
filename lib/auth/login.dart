import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veebank/auth/reset_password.dart';
import 'package:veebank/auth/sign_up.dart';
import 'package:veebank/models/auth/login_req_model.dart';
import 'package:veebank/pages/home_page.dart';
import 'package:veebank/screens/main_page.dart';
import 'package:veebank/services/api_services/api_services.dart';
import 'package:veebank/utilities/custom_flat_button.dart';
import 'package:veebank/utilities/services.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _phoneNumberTextController = TextEditingController();
  var _passwordTextController = TextEditingController();

  String? phoneNumber;
  String? password;
  Icon? icon;
  bool _visible = false;
  bool isApiCall = false;

  @override
  Widget build(BuildContext context) {
    Services _services = Services();

    scaffoldMessage(message) {
      return Scaffold.of(context);
    }

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _services.logo(45, null),
                      _services.sizedBox(h: 60),
                      Container(
                        child: TextFormField(
                            controller: _phoneNumberTextController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingrese su número de teléfono';
                              }

                              setState(() {
                                phoneNumber = _phoneNumberTextController.text;
                              });
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Número de Teléfono',
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: Theme.of(context).primaryColor,
                              ),
                              labelStyle: const TextStyle(color: Colors.black),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(30.0)),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2),
                              ),
                              focusColor: Theme.of(context).primaryColor,
                            )),
                      ),
                      _services.sizedBox(h: 20),
                      Container(
                        child: TextFormField(
                          controller: _passwordTextController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese su contraseña';
                            }
                            if (value.length <= 6) {
                              return 'La contraseña debe tener más de seis caracteres';
                            }
                            setState(() {
                              password = _passwordTextController.text;
                            });
                            return null;
                          },
                          obscureText: _visible == true ? false : true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _visible
                                  ? Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              onPressed: () {
                                setState(() {
                                  _visible = !_visible;
                                });
                              },
                            ),
                            hintText: 'Contraseña',
                            prefixIcon: Icon(
                              Icons.vpn_key_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            labelStyle: const TextStyle(color: Colors.black),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0)),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            focusColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      _services.sizedBox(h: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, ResetPassword.id);
                            },
                            child: const Text('¿Ha olvidado su contraseña? ',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      _services.sizedBox(h: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 35),
                        child: isApiCall
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                                // backgroundColor: Colors.transparent,
                              )
                            : CustomFlatButton(
                                label: "Iniciar sesión",
                                labelStyle: const TextStyle(fontSize: 20),
                                onPressed: () {
                                  if (validateAndSave()) {
                                    setState(() {
                                      isApiCall = true;
                                    });

                                    LoginReqModel model = LoginReqModel(
                                      phoneNumber:
                                          _phoneNumberTextController.text,
                                      password: _passwordTextController.text,
                                    );

                                    APIService.login(model).then((res) {
                                      setState(() {
                                        isApiCall = false;
                                      });
                                      if (res) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            MainScreen.id,
                                            (route) => false);
                                      } else {
                                        _services.scaffold(
                                            message:
                                                'Credenciales de acceso no válidas',
                                            context: context);
                                      }
                                    });
                                  }
                                },
                                borderRadius: 30,
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: RichText(
                              text: const TextSpan(text: '', children: [
                                TextSpan(
                                    text: '¿No tienes una cuenta? ',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                  text: 'Crear una cuenta',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ]),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, Signup.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
