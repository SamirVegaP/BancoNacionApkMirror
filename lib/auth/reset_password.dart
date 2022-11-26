import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veebank/auth/login.dart';
import 'package:veebank/utilities/custom_flat_button.dart';
import 'package:veebank/utilities/services.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset-password';
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  var _phoneTextController = TextEditingController();
  String? phoneNumber;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    Services _services = Services();
    // final _authData = Provider.of<AuthProvider>(context);

    return Scaffold(
        appBar: _services.simpleAppBar(
            title: "Restablecer contraseña", context: context),
        body: Form(
          key: _formKey,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _services.logo(45, null),
                    _services.sizedBox(h: 20),
                    Text('Recuperar contraseña',
                        style: TextStyle(fontFamily: 'Anton', fontSize: 20)),
                  ],
                ),
                _services.sizedBox(h: 20),
                RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                      text: '¿Ha olvidado su contraseña? ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                  TextSpan(
                      text:
                          'No se preocupe, sólo proporcione su número de teléfono, le ayudaremos a recuperar su cuenta.',
                      style: TextStyle(color: Colors.black87)),
                ])),
                _services.sizedBox(h: 20),
                Container(
                  child: TextFormField(
                      controller: _phoneTextController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, introduzca su número de teléfono';
                        }

                        setState(() {
                          phoneNumber = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Teléfono',
                        prefixIcon: Icon(Icons.phone_android),
                        labelStyle: TextStyle(color: Colors.grey),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                        focusColor: Theme.of(context).primaryColor,
                      )),
                ),
                _services.sizedBox(h: 2),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 35),
                  child: CustomFlatButton(
                    label: "Restablecer contraseña",
                    labelStyle: TextStyle(fontSize: 20),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _loading = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Por favor, compruebe su número de teléfono ${_phoneTextController.text} para las instrucciones de restablecimiento de la contraseña')));
                      }
                      Navigator.pushReplacementNamed(context, LoginScreen.id);
                    },
                    borderRadius: 30,
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
