import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Lab7Screen extends StatefulWidget {
  const Lab7Screen({super.key});

  @override
  State<Lab7Screen> createState() => _Lab7ScreenState();
}

class _Lab7ScreenState extends State<Lab7Screen> {
  final Map<Permission, PermissionStatus> _statuses = {
    Permission.camera: PermissionStatus.denied,
    Permission.microphone: PermissionStatus.denied,
    Permission.location: PermissionStatus.denied,
    Permission.sensors: PermissionStatus.denied,
  };

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    for (var perm in _statuses.keys) {
      final status = await perm.status;
      setState(() {
        _statuses[perm] = status;
      });
    }
  }

  Future<void> _requestPermission(Permission perm) async {
    final newStatus = await perm.request();
    setState(() {
      _statuses[perm] = newStatus;
    });
  }

  Icon _getIcon(PermissionStatus status) {
    if (status.isGranted) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 30);
    } else if (status.isPermanentlyDenied) {
      return const Icon(Icons.block, color: Colors.red, size: 30);
    }
    return const Icon(Icons.warning_amber, color: Colors.orange, size: 30);
  }

  String _getTitle(Permission perm) {
    if (perm == Permission.camera) return 'Камера';
    if (perm == Permission.microphone) return 'Микрофон';
    if (perm == Permission.location) return 'Геолокация (GPS)';
    if (perm == Permission.sensors) return 'Биометрия';
    return perm.toString();
  }

  String _getSubtitle(Permission perm) {
    if (perm == Permission.camera) return 'Для фото профиля и сканирования QR';
    if (perm == Permission.microphone) return 'Для голосового управления';
    if (perm == Permission.location) return 'Для отслеживания входа';
    if (perm == Permission.sensors) return 'Для входа по отпечатку';
    return 'Необходимое разрешение';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторная работа 7: Аудит разрешений'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Аудит безопасности:\nПриложение запрашивает только необходимые разрешения. '
                'Ниже вы можете управлять доступом вручную.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),

          ..._statuses.keys.map((perm) {
            final status = _statuses[perm]!;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    perm == Permission.camera
                        ? Icons.camera_alt
                        : perm == Permission.microphone
                        ? Icons.mic
                        : perm == Permission.location
                        ? Icons.location_on
                        : Icons.fingerprint,
                  ),
                ),
                title: Text(
                  _getTitle(perm),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_getSubtitle(perm)),
                trailing: _getIcon(status),
                onTap: () => _requestPermission(perm),
              ),
            );
          }),

          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: openAppSettings,
            icon: const Icon(Icons.settings),
            label: const Text('Открыть настройки системы'),
          ),
        ],
      ),
    );
  }
}
