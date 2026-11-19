import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _hidePassword = true;
  bool _loading = false;

  // IDENTIFIANTS LOCAUX

  static const String username = 'admin';
  static const String password = '123456';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // FONCTION DE CONNEXION

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    await Future.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    if (_usernameController.text.trim() == username &&
        _passwordController.text == password) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Identifiant ou mot de passe incorrect.'),
          backgroundColor: Color(0xFFB42318),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ARRIERE-PLAN
          Container(
            height: MediaQuery.sizeOf(context).height * 0.48,

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 15, 15, 20),
                  Color.fromARGB(255, 8, 11, 17),
                ],

                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius: BorderRadius.vertical(bottom: Radius.circular(38)),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),

                child: Column(
                  children: [
                    const SizedBox(height: 26),

                    // LOGO
                    Container(
                      height: 76,
                      width: 76,

                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white24),
                      ),

                      child: const Icon(
                        Icons.badge_outlined,
                        color: Color(0xFF38BDF8),
                        size: 40,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Bienvenue',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      'Connecte-toi pour découvrir mon univers',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),

                    const SizedBox(height: 44),

                    // FORMULAIRE
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(22),

                        child: Form(
                          key: _formKey,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Text(
                                'Connexion',

                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 239, 240, 241),
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                'Entre tes identifiants pour continuer.',
                                style: TextStyle(color: Color(0xFFB8C0CC)),
                              ),

                              const SizedBox(height: 24),

                              // IDENTIFIANT
                              const Text(
                                'Identifiant',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 239, 240, 241),
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _usernameController,

                                textInputAction: TextInputAction.next,

                                decoration: const InputDecoration(
                                  hintText: 'Ex. admin',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Color(0xFFB8C0CC),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Color(0xFFE5E7EB),
                                ),

                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Saisis ton identifiant';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 18),

                              // MOT DE PASSE
                              const Text(
                                'Mot de passe',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 239, 240, 241),
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _passwordController,

                                obscureText: _hidePassword,

                                onFieldSubmitted: (_) => _login(),

                                decoration: InputDecoration(
                                  hintText: 'Ton mot de passe',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF9CA3AF),
                                  ),

                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFFB8C0CC),
                                  ),

                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _hidePassword = !_hidePassword;
                                      });
                                    },

                                    icon: Icon(
                                      _hidePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: const Color(0xFFB8C0CC),
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Color(0xFFE5E7EB),
                                ),

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Saisis ton mot de passe';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 24),

                              // BOUTON CONNEXION
                              SizedBox(
                                width: double.infinity,
                                height: 52,

                                child: FilledButton(
                                  onPressed: _loading ? null : _login,

                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF101B32),

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),

                                  child: _loading
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,

                                          children: [
                                            Text('Se connecter'),

                                            SizedBox(width: 9),

                                            Icon(Icons.arrow_forward, size: 18),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      '',

                      style: TextStyle(
                        color: const Color.fromARGB(255, 229, 232, 233),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
