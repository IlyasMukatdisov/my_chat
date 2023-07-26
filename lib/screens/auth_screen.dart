import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isLogin;
  late bool _isPasswordVisible;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _isPasswordVisible = false;
    _isLogin = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final double imageSize = width * 0.5 < 250 ? width * 0.5 : 250;

    String? emailValidator(String? email) {
      if (email == null || email.isEmpty) {
        return 'Please fill email field';
      }
      //Regex for email validation
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(email)) {
        return 'Please enter a valid email address';
      }

      return null;
    }

    String? passwordValidator(String? password) {
      if (password == null || password.isEmpty) {
        return 'Please fill email field';
      }

      if (password.length < 8) {
        return 'Password must be at least 8 characters';
      }
      //Regex for password validation must contain at least 1 Capital letter, 1 number and 1 special character
      String pattern =
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(password)) {
        return 'Email must contain at least 1 Capital letter, 1 number and 1 special character';
      }

      return null;
    }

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: width,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/chat.png',
                      width: imageSize,
                      height: imageSize,
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              return emailValidator(value);
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: _isPasswordVisible,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              return passwordValidator(value);
                            },
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  child: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    key: ValueKey(
                                      _isPasswordVisible,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: ElevatedButton(
                        key: ValueKey(_isLogin),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_isLogin
                                    ? 'Logging in...'
                                    : 'Registering...'),
                              ),
                            );
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please check all the fields...'),
                            ),
                          );
                          return;
                        },
                        child: Text(_isLogin ? 'Login' : 'Register'),
                      ),
                    ),
                    AnimatedSwitcher(
                      key: ValueKey(!_isLogin),
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create an account'
                            : 'I already have an account'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
