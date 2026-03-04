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
    page: const Lab1(),
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
    return Scaffold(
      appBar: AppBar(title: const Text("Лабораторные работы 1 и 2")),
      body: const Center(child: Text("Логика шифров work in progress")),
    );
  }
}
