import 'package:flutter/material.dart';

enum AuthMode {
  signup,
  login;
}

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.login;
  final _passwordController = TextEditingController();
  Map<String, String> _authData = {'email': '', 'password': ''};

  void _submit() {}
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 320,
        width: deviceSize.width * 0.75,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
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
              if (_authMode == AuthMode.signup)
                TextFormField(
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
              const SizedBox(height: 20),
              FilledButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onPressed: _submit,
                  child: Text(
                      _authMode == AuthMode.login ? "ENTRAR" : "REGISTRAR"))
            ],
          )),
        ),
      ),
    );
  }
}
