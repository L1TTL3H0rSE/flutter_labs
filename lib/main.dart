import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Security Labs",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0075FF)),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class LabItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;

  LabItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });
}

final List<LabItem> labs = [
  LabItem(
    title: "Лабораторная работа 1 & 2",
    subtitle: "Шифры: Атбаш и Цезарь",
    icon: Icons.security,
    page: const Lab1(),
  ),
  LabItem(
    title: "Лабораторная работа 4",
    subtitle: "Биометрия и ПИН-код",
    icon: Icons.fingerprint,
    page: const Lab4(),
  ),
  LabItem(
    title: "Лабораторная работа 5 и 6",
    subtitle: "Формы и валидация",
    icon: Icons.app_registration,
    page: const Lab5Hub(), // Наш новый хаб
  ),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Лабораторные работы"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: labs.length,
        itemBuilder: (context, index) {
          final lab = labs[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Icon(
                lab.icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                lab.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(lab.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => lab.page),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class Lab1 extends StatelessWidget {
  const Lab1({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Шифры'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Атбаш (Лаба 1)'),
              Tab(text: 'Цезарь (Лаба 2)'),
            ],
          ),
        ),
        body: const TabBarView(children: [AtbashTab(), CaesarTab()]),
      ),
    );
  }
}

class AtbashTab extends StatefulWidget {
  const AtbashTab({super.key});

  @override
  State<AtbashTab> createState() => _AtbashTabState();
}

class _AtbashTabState extends State<AtbashTab> {
  final _inputController = TextEditingController();

  String _result = '';
  String _lang = 'ru';

  void _encrypt() {
    setState(() {
      _result = Lab1Utils.atbash(_inputController.text, _lang);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'ru', label: Text('Русский')),
              ButtonSegment(value: 'en', label: Text('Английский')),
            ],
            selected: {_lang},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() => _lang = newSelection.first);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _inputController,
            decoration: const InputDecoration(
              labelText: 'Введите текст',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: _encrypt,
            icon: const Icon(Icons.lock),
            label: const Text('Зашифровать'),
          ),
          const SizedBox(height: 24),

          const Text(
            'Результат:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SelectableText(
            _result.isEmpty ? 'Тут будет шифр...' : _result,
            style: const TextStyle(fontSize: 18, color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }
}

class CaesarTab extends StatefulWidget {
  const CaesarTab({super.key});

  @override
  State<CaesarTab> createState() => _CaesarTabState();
}

class _CaesarTabState extends State<CaesarTab> {
  final _inputController = TextEditingController();
  final _shiftController = TextEditingController(text: '3');

  String _result = '';
  String _lang = 'ru';

  void _processText({required bool decrypt}) {
    int shift = int.tryParse(_shiftController.text) ?? 0;

    setState(() {
      _result = Lab1Utils.caesar(
        _inputController.text,
        shift,
        _lang,
        decrypt: decrypt,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'ru', label: Text('Русский')),
              ButtonSegment(value: 'en', label: Text('Английский')),
            ],
            selected: {_lang},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() => _lang = newSelection.first);
            },
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    labelText: 'Текст',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _shiftController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Сдвиг',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _processText(decrypt: false),
                  icon: const Icon(Icons.lock),
                  label: const Text('Зашифровать'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _processText(decrypt: true),
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Расшифровать'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Результат:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SelectableText(
            _result.isEmpty ? 'Тут будет результат...' : _result,
            style: const TextStyle(fontSize: 18, color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }
}

class Lab1Utils {
  static const rus = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ';
  static const eng = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  static String atbash(String input, String lang) {
    final alphabet = lang == 'ru' ? rus : eng;
    String result = '';

    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      bool isLower = char == char.toLowerCase();
      int idx = alphabet.indexOf(char.toUpperCase());

      if (idx != -1) {
        String newChar = alphabet[alphabet.length - 1 - idx];
        result += isLower ? newChar.toLowerCase() : newChar;
      } else {
        result += char;
      }
    }

    return result;
  }

  static String caesar(
    String input,
    int shift,
    String lang, {
    bool decrypt = false,
  }) {
    final alphabet = lang == 'ru' ? rus : eng;
    String result = '';
    if (decrypt) shift = -shift;

    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      bool isLower = char == char.toLowerCase();
      int idx = alphabet.indexOf(char.toUpperCase());

      if (idx != -1) {
        int newIdx = (idx + shift) % alphabet.length;
        if (newIdx < 0) newIdx += alphabet.length;
        String newChar = alphabet[newIdx];
        result += isLower ? newChar.toLowerCase() : newChar;
      } else {
        result += char;
      }
    }

    return result;
  }
}

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
      appBar: AppBar(title: const Text('Лаба 4: Аутентификация')),
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

class Lab5Hub extends StatelessWidget {
  const Lab5Hub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лаба 5: Вход в систему')),
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
    final path = join(dbPath, 'security_labs.db');
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
