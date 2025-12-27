import 'package:flutter/material.dart';
import '../services/auth_services.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool isLogin = true;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  final companyController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    String? error;

    if (isLogin) {
      // 🔐 LOGIN
      final token = await AuthService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (token != null && token.startsWith("ey")) {
        Navigator.pushReplacementNamed(context, "/app");
      } else {
        error = token ?? "Login failed";
      }
    } else {
      // 🏢 SIGNUP
      error = await AuthService.signup(
        companyName: companyController.text.trim(),
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        repassword: confirmPasswordController.text.trim(),
      );

      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registered successfully. Please login")),
        );
        setState(() => isLogin = true);
      }
    }

    setState(() => loading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 380,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _tab("Login", true),
                    _tab("Signup", false),
                  ],
                ),
                const SizedBox(height: 24),

                if (!isLogin)
                  _field(companyController, "Company Name"),
                if (!isLogin)
                  _field(nameController, "Name"),

                _field(
                  emailController,
                  "Email",
                  validator: (v) =>
                      v!.contains("@") ? null : "Invalid email",
                ),

                _field(
                  passwordController,
                  "Password",
                  obscure: true,
                  validator: (v) =>
                      v!.length < 6 ? "Min 6 chars" : null,
                ),

                if (!isLogin)
                  _field(
                    confirmPasswordController,
                    "Re-enter Password",
                    obscure: true,
                    validator: (v) =>
                        v != passwordController.text
                            ? "Passwords do not match"
                            : null,
                  ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: loading ? null : _submit,
                  child: loading
                      ? const CircularProgressIndicator()
                      : Text(isLogin ? "Login" : "Register"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab(String text, bool mode) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isLogin = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isLogin == mode ? Colors.indigo : Colors.grey,
                width: 2,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isLogin == mode ? Colors.indigo : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        obscureText: obscure,
        validator: validator ??
            (v) => v!.isEmpty ? "$label required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
