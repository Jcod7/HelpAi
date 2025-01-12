import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:help_ai/screens/pages/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _termsAccepted = false;  // Términos y condiciones
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _cedulaController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe aceptar los términos y condiciones')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Verificar si las contraseñas coinciden
      if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
        throw FirebaseAuthException(
          code: 'passwords-dont-match',
          message: 'Las contraseñas no coinciden',
        );
      }

      // Crear usuario en Authentication
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Crear documento en Firestore
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'email': _emailController.text.trim(),
          'nombre': _nameController.text.trim(),
          'apellido': _lastNameController.text.trim(),
          'cedula': _cedulaController.text.trim(),
          'edad': int.parse(_ageController.text.trim()),
          'fechaRegistro': FieldValue.serverTimestamp(),
          'ultimoAcceso': FieldValue.serverTimestamp(),
          'activo': true,
          'verificado': false,
        });

        // Actualizar perfil en Authentication
        await userCredential.user!.updateDisplayName(
          '${_nameController.text.trim()} ${_lastNameController.text.trim()}'
        );

        // Enviar email de verificación
        await userCredential.user!.sendEmailVerification();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro exitoso. Por favor verifica tu correo electrónico.'),
              duration: Duration(seconds: 5),
            ),
          );
          // Redirigir al usuario a la pantalla Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(title: 'HelpAi'),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error al registrar usuario';

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'La contraseña debe tener al menos 6 caracteres';
          break;
        case 'email-already-in-use':
          errorMessage = 'Ya existe una cuenta con este correo electrónico';
          break;
        case 'invalid-email':
          errorMessage = 'El correo electrónico no es válido';
          break;
        case 'passwords-dont-match':
          errorMessage = e.message ?? 'Las contraseñas no coinciden';
          break;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Un amigo que cuida de ti',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                _buildCustomInputField(
                  controller: _nameController,
                  hintText: 'Ingrese su nombre',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildCustomInputField(
                  controller: _lastNameController,
                  hintText: 'Ingrese su apellido',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su apellido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildCustomInputField(
                  controller: _cedulaController,
                  hintText: 'Ingrese su cédula de identidad',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su cédula de identidad.';
                    }
                    if (value.length < 6) {
                      return 'La cédula debe tener al menos 6 dígitos.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildCustomInputField(
                  controller: _ageController,
                  hintText: 'Ingrese su edad',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su edad.';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 18) {
                      return 'Debe ser mayor de edad.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildCustomInputField(
                  controller: _emailController,
                  hintText: 'Ingrese su correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (value == null || !regex.hasMatch(value)) {
                      return 'Por favor ingresa un correo electrónico válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildCustomInputField(
                  controller: _passwordController,
                  hintText: 'Ingrese su contraseña',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña.';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildCustomInputField(
                  controller: _confirmPasswordController,
                  hintText: 'Repite tu contraseña',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor repite tu contraseña.';
                    }
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'He leído y acepto los términos y condiciones.',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : _buildCustomButton(
                        text: 'Registrarse',
                        onPressed: _register,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomInputField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.outfit(
            fontSize: 18.0,
            color: Colors.black54,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildCustomButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CC2FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
