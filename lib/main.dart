import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_cifo/firebase_options.dart';
import 'package:todo_app_cifo/modules/recipes/models/cubits/recipe_list/recipe_list_cubit.dart';
import 'package:todo_app_cifo/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routeredApp = MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
    return BlocProvider<RecipeListCubit>(
      create: (context) => RecipeListCubit(),
      child: AuthGate(app: routeredApp),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.app});

  final Widget app;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasData) {
          return app;
        }
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: EmailPasswordAuthScreen(),
        );
      },
    );
  }
}

class EmailPasswordAuthScreen extends StatefulWidget {
  const EmailPasswordAuthScreen({super.key});

  @override
  State<EmailPasswordAuthScreen> createState() =>
      _EmailPasswordAuthScreenState();
}

class _EmailPasswordAuthScreenState extends State<EmailPasswordAuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInAnonymously() async {
    await _runAuthAction(FirebaseAuth.instance.signInAnonymously);
  }

  Future<void> _signInWithEmailAndPassword() async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Introduce un correo y una contraseña válidos.';
      });
      return;
    }

    await _runAuthAction(() {
      return FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<void> _runAuthAction(
    Future<UserCredential> Function() action,
  ) async {
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      await action();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _mapAuthError(e);
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'Ocurrió un error inesperado. Intenta de nuevo.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  String _mapAuthError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'El correo tiene un formato inválido.';
      case 'user-disabled':
        return 'Esta cuenta está deshabilitada.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Correo o contraseña incorrectos.';
      case 'operation-not-allowed':
        return 'El método de acceso no está habilitado en Firebase.';
      default:
        return exception.message ?? 'No se pudo completar la autenticación.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Autenticación',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                  ],
                  FilledButton(
                    onPressed:
                        _submitting ? null : _signInWithEmailAndPassword,
                    child: _submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Entrar con correo'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _submitting ? null : _signInAnonymously,
                    child: const Text('Acceso anónimo'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
