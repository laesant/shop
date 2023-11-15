import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/models/auth.dart';

enum AuthMode {
  signup,
  login;
}

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.login;
  final _passwordController = TextEditingController();
  Map<String, String> _authData = {'email': '', 'password': ''};
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1.5), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isLogin() => _authMode == AuthMode.login;
  // bool _isSignUp() => _authMode == AuthMode.signup;

  void _switchAuthMode() => setState(() {
        if (_isLogin()) {
          _authMode = AuthMode.signup;
          _controller.forward();
        } else {
          _authMode = AuthMode.login;
          _controller.reverse();
        }
      });

  void _showErrorDialog(String msg) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Ocorreu um Erro"),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Fechar"))
            ],
          ));

  void _submit() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    setState(() => _isLoading = true);
    _formKey.currentState!.save();
    Auth auth = Provider.of(context, listen: false);
    try {
      if (_isLogin()) {
        await auth.login(
            email: _authData['email']!, password: _authData['password']!);
      } else {
        await auth.signup(
            email: _authData['email']!, password: _authData['password']!);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (_) {
      _showErrorDialog("Ocorreu um erro inesperado!");
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastEaseInToSlowEaseOut,
          padding: const EdgeInsets.all(16),
          height: _isLogin() ? 324 : 400,
          width: deviceSize.width * 0.75,
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                    ),
                    onSaved: (value) => _authData['email'] = value ?? "",
                    validator: (value) {
                      final String email = value ?? '';
                      if (email.trim().isEmpty || !email.contains('@')) {
                        return 'Informe um email válida';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                    ),
                    controller: _passwordController,
                    onSaved: (value) => _authData['password'] = value ?? "",
                    validator: (value) {
                      final String password = value ?? '';
                      if (password.isEmpty || password.length < 5) {
                        return 'Informe uma senha válida';
                      }

                      return null;
                    },
                  ),
                  AnimatedContainer(
                    constraints: BoxConstraints(
                      minHeight: _isLogin() ? 0 : 60,
                      maxHeight: _isLogin() ? 0 : 120,
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastEaseInToSlowEaseOut,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirmar Senha',
                          ),
                          validator: (value) {
                            final String password = value ?? '';
                            if (password != _passwordController.text) {
                              return 'Senhas informadas não conferem.';
                            }

                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(_isLogin() ? "ENTRAR" : "REGISTRAR")),
                  const Spacer(),
                  TextButton(
                      onPressed: _switchAuthMode,
                      child: Text(_isLogin()
                          ? 'DESEJA REGISTRAR?'
                          : 'JÁ POSSUI CONTA?'))
                ],
              ))),
    );
  }
}
