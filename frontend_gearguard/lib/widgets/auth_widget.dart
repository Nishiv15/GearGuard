import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController companyController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 380,
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

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (!isLogin)
                        _textField(
                          controller: companyController,
                          label: "Company Name",
                        ),
                      if (!isLogin)
                        _textField(
                          controller: nameController,
                          label: "Name",
                        ),
                      _textField(
                        controller: emailController,
                        label: "Email",
                        keyboardType: TextInputType.emailAddress,
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
                      _textField(
                        controller: passwordController,
                        label: "Password",
                        obscureText: true,
                        validator: (v) =>
                            v != null && v.length < 6
                                ? "Min 6 characters"
                                : null,
                      ),
                      if (!isLogin)
                        _textField(
                          controller: confirmPasswordController,
                          label: "Re-enter Password",
                          obscureText: true,
                          validator: (v) =>
                              v != passwordController.text
                                  ? "Passwords do not match"
                                  : null,
                        ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: loading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(isLogin ? "Login" : "Register"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===================== LOGIC =====================
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      if (isLogin) {
        await AuthService.login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.pushReplacementNamed(context, '/app');
      } else {
        await AuthService.signup(
          companyName: companyController.text.trim(),
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          repassword: confirmPasswordController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration successful. Please login."),
          ),
        );

        setState(() => isLogin = true);
        _clearSignupFields();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  void _clearSignupFields() {
    companyController.clear();
    nameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  // ===================== UI HELPERS =====================
  Widget _toggleButton(String text, bool mode) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isLogin = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: isLogin == mode
                    ? Colors.indigo
                    : Colors.grey.shade300,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  isLogin == mode ? Colors.indigo : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator ??
            (v) => v == null || v.isEmpty ? "$label required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
