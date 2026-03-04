import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Lab3Screen extends StatefulWidget {
  const Lab3Screen({super.key});

  @override
  State<Lab3Screen> createState() => _Lab3ScreenState();
}

class _Lab3ScreenState extends State<Lab3Screen> {
  String? _accessToken;

  final String _appId = '7073895';

  void _logout() {
    setState(() {
      _accessToken = null;
    });
  }

  void _openLogin() async {
    final token = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VkAuthPage(appId: _appId)),
    );

    if (token != null) {
      setState(() {
        _accessToken = token;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Успешный вход через ВК!'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лабораторная работа 3: OAuth 2.0')),
      body: Center(
        child: _accessToken == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.public, size: 80, color: Colors.blue),
                  const SizedBox(height: 24),
                  const Text(
                    'Вход через сторонний сервис',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _openLogin,
                    icon: const Icon(Icons.login),
                    label: const Text('Войти через ВКонтакте'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0077FF),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://vk.com/images/camera_200.png',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Вы авторизованы!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      'Ваш токен:\n${_accessToken!.substring(0, 20)}...',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: _logout,
                    child: const Text('Выйти'),
                  ),
                ],
              ),
      ),
    );
  }
}

class VkAuthPage extends StatefulWidget {
  final String appId;
  const VkAuthPage({super.key, required this.appId});

  @override
  State<VkAuthPage> createState() => _VkAuthPageState();
}

class _VkAuthPageState extends State<VkAuthPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('access_token=')) {
              final uri = Uri.parse(request.url.replaceFirst('#', '?'));
              final token = uri.queryParameters['access_token'];

              if (token != null) {
                Navigator.pop(context, token);
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          'https://oauth.vk.com/authorize?client_id=${widget.appId}&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&scope=offline&response_type=token&v=5.131',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход ВКонтакте')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
