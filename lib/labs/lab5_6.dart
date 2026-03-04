import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:bcrypt/bcrypt.dart';

class Lab5Hub extends StatelessWidget {
  const Lab5Hub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторная работа 5: Вход в систему'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.blue),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Lab5Login()),
              ),
              icon: const Icon(Icons.login),
              label: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Авторизация', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Lab5Register()),
              ),
              icon: const Icon(Icons.person_add),
              label: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Регистрация', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Lab5Login extends StatefulWidget {
  const Lab5Login({super.key});

  @override
  State<Lab5Login> createState() => _Lab5LoginState();
}

class _Lab5LoginState extends State<Lab5Login> {
  final _loginCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  Future<void> _login() async {
    final login = _loginCtrl.text;
    final password = _passCtrl.text;
    if (login.isEmpty || password.isEmpty) return;
    final isSuccess = await DatabaseHelper.loginUser(login, password);
    if (!mounted) return;
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Успешный вход! Секретный доступ открыт.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Неверный логин или пароль'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Авторизация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _loginCtrl,
              decoration: const InputDecoration(
                labelText: 'Логин',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _login,
                icon: const Icon(Icons.login),
                label: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Войти', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Lab5Register extends StatefulWidget {
  const Lab5Register({super.key});

  @override
  State<Lab5Register> createState() => _Lab5RegisterState();
}

class _Lab5RegisterState extends State<Lab5Register> {
  final _formKey = GlobalKey<FormState>();

  final _loginCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  final RegExp passwordRegExp = RegExp(r'^(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final result = await DatabaseHelper.registerUser(
        _loginCtrl.text,
        _passCtrl.text,
      );
      if (!mounted) return;
      if (result == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Успешная регистрация! Теперь войдите.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _loginCtrl,
              decoration: const InputDecoration(
                labelText: 'Логин',
                hintText: 'Придумайте имя пользователя',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Поле обязательно для заполнения';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Пароль',
                hintText: 'Минимум 8 симв., 1 цифра, 1 спецсимвол',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Поле обязательно для заполнения';
                }
                if (!passwordRegExp.hasMatch(value)) {
                  return 'Пароль слишком простой (нужна цифра и спецсимвол)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _confirmPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Подтвердите пароль',
                hintText: 'Введите пароль еще раз',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Поле обязательно для заполнения';
                }
                if (value != _passCtrl.text) {
                  return 'Пароли не совпадают!';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Зарегистрироваться',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatabaseHelper {
  static Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'security_labs.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, login TEXT UNIQUE, hash TEXT)',
        );
      },
    );
  }

  static Future<String> registerUser(String login, String password) async {
    final db = await getDatabase();
    final existing = await db.query(
      'users',
      where: 'login = ?',
      whereArgs: [login],
    );
    if (existing.isNotEmpty) {
      return 'Пользователь с таким логином уже существует!';
    }

    final String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
    await db.insert('users', {'login': login, 'hash': hashed});
    return 'success';
  }

  static Future<bool> loginUser(String login, String password) async {
    final db = await getDatabase();
    final users = await db.query(
      'users',
      where: 'login = ?',
      whereArgs: [login],
    );
    if (users.isEmpty) return false;
    final hash = users.first['hash'] as String;
    return BCrypt.checkpw(password, hash);
  }
}
