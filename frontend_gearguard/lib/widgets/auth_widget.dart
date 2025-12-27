import 'package:flutter/material.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController managerController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
                // Toggle Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          controller: managerController,
                          label: "Name",
                        ),
                      _textField(
                        controller: emailController,
                        label: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      _textField(
                        controller: passwordController,
                        label: "Password",
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      if (!isLogin)
                        _textField(
                          controller: confirmPasswordController,
                          label: "Re-enter Password",
                          obscureText: true,
                          validator: (value) {
                            if (value != passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // TODO: connect API later
                            debugPrint(
                                isLogin ? "Login Success" : "Signup Success");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: Text(isLogin ? "Login" : "Signup"),
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

  Widget _toggleButton(String text, bool loginMode) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isLogin = loginMode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: isLogin == loginMode
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isLogin == loginMode
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
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
            (value) =>
                value == null || value.isEmpty ? "$label is required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
