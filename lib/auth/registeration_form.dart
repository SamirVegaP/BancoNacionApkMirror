import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veebank/auth/login.dart';
import 'package:veebank/models/auth/register_req_model.dart';
import 'package:veebank/screens/main_page.dart';
import 'package:veebank/services/api_services/api_services.dart';
import 'package:veebank/utilities/custom_flat_button.dart';
import 'package:veebank/utilities/services.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _phoneNumberTextController = TextEditingController();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _confirmPasswordTextController = TextEditingController();
  var _nameTextController = TextEditingController();

  String? email;
  String? phoneNumber;
  String? password;
  String? number;
  String? name;
  // bool _isLoading = false;
  bool isApiCall = false;

  Icon? icon;
  bool _visible = false;

  List<String> _accountType = [
    'Cuenta personal',
    'Cuenta comercial',
  ];
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    Services _services = Services();
    // final _authData = Provider.of<AuthProvider>(context);

    return isApiCall
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Form(
            key: _formKey,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: DropdownButton(
                  hint: Text('Seleccione su tipo de cuenta',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 22)),
                  value: dropdownValue,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value;
                    });
                  },
                  items: _accountType
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return dropdownValue == "Cuenta comercial"
                            ? "Introduzca el nombre de la empresa"
                            : 'Introduzca su nombre';
                      }
                      setState(() {
                        _nameTextController.text = value;
                        name = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        dropdownValue == "Cuenta comercial"
                            ? Icons.business_outlined
                            : Icons.person_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: dropdownValue == "Cuenta comercial"
                          ? "Nombre de la empresa"
                          : 'Nombre',
                      labelStyle: TextStyle(color: Colors.black),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  child: TextFormField(
                      controller: _phoneNumberTextController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, introduzca su n??mero de tel??fono';
                        }

                        setState(() {
                          phoneNumber = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                        // enabledBorder: OutlineInputBorder(),
                        // contentPadding: EdgeInsets.zero,
                        hintText: 'N??mero de tel??fono',
                        prefixIcon: Icon(
                          Icons.phone_android_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelStyle: const TextStyle(color: Colors.black),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0)),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                        focusColor: Theme.of(context).primaryColor,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  child: TextFormField(
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Introduzca su direcci??n de correo electr??nico';
                      }
                      final bool _isValidEmail =
                          EmailValidator.validate(_emailTextController.text);
                      if (!_isValidEmail) {
                        return 'Correo electr??nico no v??lido';
                      }
                      setState(() {
                        email = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Correo electr??nico',
                      labelStyle: TextStyle(color: Colors.black),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  child: TextFormField(
                    // obscureText: true,
                    obscureText: _visible == true ? false : true,
                    controller: _passwordTextController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese su contrase??a';
                      }
                      if (value.length <= 6) {
                        return 'La contrase??a debe tener m??s de 6 caracteres';
                      }
                      setState(() {
                        password = value;
                      });

                      return null;
                    },
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
                      prefixIcon: Icon(
                        Icons.vpn_key_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  child: TextFormField(
                    // obscureText: true,
                    obscureText: _visible == true ? false : true,
                    controller: _confirmPasswordTextController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Confirmar contrase??a';
                      }

                      if (_passwordTextController.text !=
                          _confirmPasswordTextController.text) {
                        return 'Las contrase??as no coincide';
                      }

                      return null;
                    },
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
                      prefixIcon: Icon(
                        Icons.vpn_key_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Confirmar contrase??a',
                      labelStyle: TextStyle(color: Colors.black),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              _services.sizedBox(h: 20),
              Container(
                margin: EdgeInsets.symmetric(vertical: 35),
                child: isApiCall
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                        // backgroundColor: Colors.transparent,
                      )
                    : CustomFlatButton(
                        label: "Crear una cuenta",
                        labelStyle: TextStyle(fontSize: 20),
                        onPressed: () {
                          if (validateAndSave()) {
                            setState(() {
                              isApiCall = true;
                            });
                            RegisterReqModel model = RegisterReqModel(
                                name: name!,
                                phoneNumber: phoneNumber!,
                                password: password!,
                                email: email!,
                                accountType: dropdownValue!,
                                balance: 0);

                            APIService.signup(model).then((res) {
                              setState(() {
                                isApiCall = false;
                              });
                              if (res.data != null) {
                                _services.alertDialog(
                                    title: '??xito',
                                    content:
                                        'Cuenta creada con ??xito. Por favor, inicie sesi??n',
                                    context: context);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, LoginScreen.id, (route) => false);
                              } else {
                                _services.scaffold(
                                    message:
                                        "Error al registrar el usuario: ${res.message}",
                                    context: context);
                              }
                            });
                          }
                        },
                        borderRadius: 30,
                      ),
              ),
            ]),
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
