import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/httpException.dart';
import 'package:shop_app/providers/auth.dart';

enum AuthMode { Login, SignUp }

class AuthScreen extends StatelessWidget {
  static const routeName = '/Auth_Screen';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                      ),
                      padding: EdgeInsets.all(20),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).accentColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  TextEditingController _passwordController = TextEditingController();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  void _showDialogWidget(String message) {
    showDialog<Null>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('an error occured'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('okey'),
              ),
            ],
          );
        });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .signIn(email: _authData['email'], password: _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(email: _authData['email'], password: _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMassage = 'an error occured';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMassage = 'The email address is already in use by another account';
      } else if (error.toString().contains('OPERATION_NOT_ALLOWED')) {
        errorMassage = 'Password sign-in is disabled for this project';
      } else if (error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMassage =
            'We have blocked all requests from this device due to unusual activity. Try again later';
      } else if (error.toString().contains('OPERATION_NOT_ALLOWED')) {
        errorMassage = 'Password sign-in is disabled for this project';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMassage =
            ' There is no user record corresponding to this identifier. The user may have been deleted.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMassage =
            'The password is invalid or the user does not have a password.';
      } else if (error.toString().contains('USER_DISABLED')) {
        errorMassage =
            'The user account has been disabled by an administrator.';
      }

      _showDialogWidget(errorMassage);
    } catch (error) {
      const errorMassage = 'somenting ent wrong please try later!';
      _showDialogWidget(errorMassage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: Container(
        // height: _authMode == AuthMode.SignUp ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.SignUp ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'E-Mail',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid E-mail';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty || value.length < 6) {
                    return 'password is too short';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              if (_authMode == AuthMode.SignUp)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'password does not match';
                    }
                    return null;
                  },
                ),
              SizedBox(
                height: 20,
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      child: Text(
                          _authMode == AuthMode.Login ? 'Log In' : 'Sign In'),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _submit,
                    ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                child: Text(_authMode == AuthMode.Login
                    ? 'Sign Up Instaed'
                    : 'Log In insted'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _switchAuthMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
