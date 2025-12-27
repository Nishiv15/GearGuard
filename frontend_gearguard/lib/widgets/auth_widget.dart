import 'package:flutter/material.dart';
import 'package:frontend_gearguard/services/auth_services.dart'; // Add this import

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool isLogin = true;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController companyController = TextEditingController();
  final TextEditingController managerController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
                    _toggleButton("Login", true),
                    _toggleButton("Signup", false),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    if (!isLogin)
                      _field(
                        companyController,
                        "Company Name",
                      ),
                    if (!isLogin)
                      _field(
                        managerController,
                        "Name",
                      ),
                    _field(
                      emailController,
                      "Email",
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Email required";
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v)) {
                          return "Invalid email";
                        }
                        return null;
                      },
                    ),
                    _field(
                      passwordController,
                      "Password",
                      obscure: true,
                      validator: (v) =>
                          v != null && v.length < 6 ? "Min 6 characters" : null,
                    ),
                    if (!isLogin)
                      _field(
                        confirmPasswordController,
                        "Re-enter Password",
                        obscure: true,
                        validator: (v) => v != passwordController.text
                            ? "Passwords do not match"
                            : null,
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: loading
                          ? null
                          : _handleSubmit, // Disable button during loading
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: loading
                          ? const CircularProgressIndicator() // Show loader
                          : Text(isLogin ? "Login" : "Register"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      if (isLogin) {
        final result = await AuthService.login(
          email: emailController.text,
          password: passwordController.text,
        );
        if (result != null && result.startsWith("ey")) {
          // JWT tokens start with "ey"
          // Assuming token is stored elsewhere, e.g., shared preferences
          Navigator.pushReplacementNamed(context, '/app');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result ?? "Login failed")),
          );
        }
      } else {
        final error = await AuthService.signup(
          companyName: companyController.text,
          name: managerController.text,
          email: emailController.text,
          password: passwordController.text,
          repassword: confirmPasswordController.text,
        );
        if (error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registration successful. Please login."),
            ),
          );
          setState(() => isLogin = true);
          _clearSignupFields();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  void _clearSignupFields() {
    companyController.clear();
    managerController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  Widget _toggleButton(String text, bool mode) {
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
        validator: validator ?? (v) => v!.isEmpty ? "$label required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
