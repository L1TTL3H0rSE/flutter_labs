import 'package:flutter/material.dart';

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
    page: const CaesarTab(),
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
