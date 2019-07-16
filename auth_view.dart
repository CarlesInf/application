import 'package:flutter/material.dart';

import '../presenter/auth_presenter.dart';
import '../models_utilities/auth.dart';

class AuthView extends StatefulWidget {
  AuthView({Key key}) : super(key: key);

  @override
  AuthViewState createState() => new AuthViewState();
}

// class AuthViewState extends State<AuthView> {
class AuthViewState extends State<AuthView>
    with TickerProviderStateMixin {
  AuthPresenterState _presenter;

  AuthViewState();

  set presenter(AuthPresenterState value) {
    this._presenter = value;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {'email': null, 'password': null};
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  BuildContext context;

  int _state = 0;
  GlobalKey _globalKey = new GlobalKey();
  Animation _animation;
  AnimationController _controller;
  // AnimationController _menu;
  double _width = double.maxFinite;

  @override
  void initState() {
    super.initState();
    _presenter = new AuthPresenterState();
    _presenter.view = this;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final double width = MediaQuery.of(context).size.width;
    final double fixWidth = width > 550.0 ? 500.0 : width * 0.95;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(image: _imagenFondo()),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: fixWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _emailTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _passwordTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _authMode == AuthMode.Signup
                        ? _passwordConfirmTextField()
                        : Container(),
                    SizedBox(
                      height: 10.0,
                    ),
                    FlatButton(
                      child: Text(
                          '${_authMode == AuthMode.Login ? '¿Aún no te has registrado?' : '¿Ya tienes una sesión?'}'),
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.Login
                              ? AuthMode.Signup
                              : AuthMode.Login;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    PhysicalModel(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(25.0),
                      child: Container(
                        key: _globalKey,
                        height: 48,
                        width: _width,
                        child: RaisedButton(
                            textColor: Colors.white,
                            child: setUpButtonChild(),
                            onPressed: () {
                              setState(() {
                                if (_state == 0) {
                                  animateButton();
                                }
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDialogMethod(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ha ocurrido un error!'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  setState(() {
                    _state = 0;
                    _width = double.maxFinite;
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  DecorationImage _imagenFondo() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage('assets/Frutas.jpg'),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Correo electrónico',
          filled: true,
          fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Introduzca un correo válido';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Contraseña', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Contraseña inválida';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _passwordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirma la Contraseña',
          filled: true,
          fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Las contraseñas no coinciden!';
        }
      },
    );
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;
    // _menu = AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _controller =
        // AnimationController(duration: Duration(milliseconds: 300), vsync: null);
    AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animation = Tween(begin: 0.0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = 75;
        });
      });
    _controller.forward();

    

    setState(() {
      _state = 1;
    });

    // Timer(Duration(milliseconds: 1000), () {
      _presenter.submitForm(context, _formKey, _formData, _authMode);
    // });
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        _authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  // setUpButtonChild() {
  //   if (_state == 0) {
  //     return Text(
  //       "Click Here",
  //       style: const TextStyle(
  //         color: Colors.white,
  //         fontSize: 16,
  //       ),
  //     );
  //   } else if (_state == 1) {
  //     return SizedBox(
  //       height: 36,
  //       width: 36,
  //       child: CircularProgressIndicator(
  //         value: null,
  //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //       ),
  //     );
  //   } else {
  //     return Icon(Icons.check, color: Colors.white);
  //   }
  // }

  // void animateButton() {
  //   double initialWidth = _globalKey.currentContext.size.width;

  //   _controller =
  //       AnimationController(duration: Duration(milliseconds: 300), vsync: this);

  //   _animation = Tween(begin: 0.0, end: 1).animate(_controller)
  //     ..addListener(() {
  //       setState(() {
  //         _width = initialWidth - ((initialWidth - 48) * _animation.value);
  //       });
  //     });
  //   _controller.forward();

  //   setState(() {
  //     _state = 1;
  //   });

  //   Timer(Duration(milliseconds: 3300), () {
  //     setState(() {
  //       _state = 2;
  //     });
  //   });
  // }
}
