import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class Lab4 extends StatefulWidget {
  const Lab4({super.key});

  @override
  State<Lab4> createState() => _Lab4State();
}

class _Lab4State extends State<Lab4> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;

  Future<void> _authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Подтвердите личность для доступа к секретным данным',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );

      setState(() {
        _isAuthenticated = didAuthenticate;
      });
    } catch (e) {
      print("Ошибка авторизации: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторная работа 4: Аутентификация'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isAuthenticated) ...[
              const Icon(Icons.lock_open, size: 100, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                'Доступ разрешен!\nТут профиль пользователя.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => setState(() => _isAuthenticated = false),
                child: const Text('Выйти'),
              ),
            ] else ...[
              const Icon(Icons.security, size: 100, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text(
                'Секретный раздел',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text('Доступ только по отпечатку или ПИН-коду'),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint, size: 32),
                label: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Войти', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
