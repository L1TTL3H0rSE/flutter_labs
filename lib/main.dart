import 'package:flutter/material.dart';
import 'package:flutter_labs/labs/lab1_2.dart';
import 'package:flutter_labs/labs/lab3.dart';
import 'package:flutter_labs/labs/lab4.dart';
import 'package:flutter_labs/labs/lab5_6.dart';
import 'package:flutter_labs/labs/lab7.dart';
import 'package:flutter_labs/models/lib_item.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:bcrypt/bcrypt.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    title: 'Лабораторная работа 3',
    subtitle: 'OAuth 2.0 (VK)',
    icon: Icons.login,
    page: const Lab3Screen(),
  ),
  LabItem(
    title: "Лабораторная работа 5 и 6",
    subtitle: "Формы и валидация",
    icon: Icons.app_registration,
    page: const Lab5Hub(),
  ),
  LabItem(
    title: "Лабораторная работа 7",
    subtitle: "Аудит разрешений и Privacy",
    icon: Icons.admin_panel_settings,
    page: const Lab7Screen(),
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
