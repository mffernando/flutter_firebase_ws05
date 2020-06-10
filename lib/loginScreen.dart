import 'package:flutter/material.dart';
import 'firebaseAuth.dart';
import 'user.dart';
import 'mainProduct.dart';
import 'package:flutter/services.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class LoginPage extends StatefulWidget {
  User user;

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  BaseAuth _baseAuth = BaseAuth();
  bool _isFieldEmailValid;
  bool _isFieldPasswordValid;

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.user != null) {
      _isFieldEmailValid = true;
      _controllerEmail.text = widget.user.email;
      _isFieldPasswordValid = true;
      _controllerPassword.text = widget.user.password;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Login".toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildTextFieldEmail(),
                  _buildTextFieldPassword(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RaisedButton(
                      onPressed: () async {
                        if (_isFieldEmailValid == null ||
                            _isFieldPasswordValid == null ||
                            !_isFieldEmailValid ||
                            !_isFieldPasswordValid) {
                          _scaffoldState.currentState.showSnackBar(
                            SnackBar(
                              content:
                                  Text("Por favor, preencher e-mail e senha"),
                            ),
                          );
                          return;
                        }
                        setState(() => _isLoading = true);
                        String email = _controllerEmail.text.toString();
                        String password = _controllerPassword.text.toString();
                        User user = User(email: email, password: password);
                        if (widget.user == null) {
                          try {
                            // _apiAuth.loginUser(email, password).then((isSuccess) {
                            _baseAuth
                                .loginUser(email: email, password: password)
                                .then((isSuccess) {
                              setState(() => _isLoading = false);
                              if (isSuccess) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainProduct()));
                                // Navigator.pop(_scaffoldState.currentState.context);
                              } else {
                                _scaffoldState.currentState
                                    .showSnackBar(SnackBar(
                                  content: Text("Por favor, verificar o e-mail e senha"),
                                ));
                              }
                            });
                          } on PlatformException catch(e) {
                            _scaffoldState.currentState
                                .showSnackBar(SnackBar(
                              content: Text(e.toString()),
                            ));
                          }
                        }
                      },
                      child: Text(
                        "Conectar".toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldEmail() {
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "E-mail",
        errorText: _isFieldEmailValid == null || _isFieldEmailValid
            ? null
            : "Preencher o e-mail",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldEmailValid) {
          setState(() => _isFieldEmailValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldPassword() {
    return TextField(
      controller: _controllerPassword,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Senha",
        errorText: _isFieldPasswordValid == null || _isFieldPasswordValid
            ? null
            : "Preencher a senha",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldPasswordValid) {
          setState(() => _isFieldPasswordValid = isFieldValid);
        }
      },
    );
  }
}
