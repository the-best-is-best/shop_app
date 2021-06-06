import 'package:flutter/material.dart';
import 'package:flutter_app/models/http_exception.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:provider/provider.dart';

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { Login, Singup }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _fromKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  final _passwordController = TextEditingController();

  AnimationController _animController;
  Animation<Offset> _sideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _sideAnimation = Tween<Offset>(begin: Offset(0, -15), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _animController, curve: Curves.fastOutSlowIn));

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  Future<void> _submit() async {
    if (!_fromKey.currentState.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _fromKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await context
            .read<Auth>()
            .login(_authData['email'], _authData['password']);
      } else {
        await context
            .read<Auth>()
            .singup(_authData['email'], _authData['password']);
      }
    } on HttpException catch (e) {
      var errorMessage = "Auth Failed";

      if (e.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "Email is already in use.";
      } else if (e.toString().contains("INVALID_EMAIL")) {
        errorMessage = "Email is invalid.";
      } else if (e.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "Password is to weak.";
      } else if (e.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Email not found.";
      } else if (e.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Password is invalid.";
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      const errorMessage = 'Can not auth you. please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("An error Occurred!"),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  child: Text('Okay!'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Singup;
      });
      _animController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8,
        child: AnimatedContainer(
          margin: EdgeInsets.symmetric(horizontal: 18.0),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: _authMode == AuthMode.Singup ? 320 : 260,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.Singup ? 320 : 260),
          width: deviceSize.width * 75,
          child: Form(
            key: _fromKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val.isEmpty || !val.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    onSaved: (val) => _authData['email'] = val,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (val) {
                      if (val.isEmpty || val.length < 5) {
                        return 'Password is too short';
                      }
                      return null;
                    },
                    onSaved: (val) => _authData['password'] = val,
                  ),
                  AnimatedContainer(
                    constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.Singup ? 60 : 0,
                        maxHeight: _authMode == AuthMode.Singup ? 120 : 0),
                    duration: Duration(milliseconds: 300),
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _sideAnimation,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.Singup,
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: _authMode == AuthMode.Singup
                              ? (val) {
                                  if (val != _passwordController.text) {
                                    return 'Password is not match';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: _submit,
                      child: Text(
                        _authMode == AuthMode.Login ? 'LOGIN' : 'SINGUP',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color),
                      ),
                    ),
                  TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                        '${_authMode == AuthMode.Login ? 'SINGUP' : 'LOGIN'} INSTEAD'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
