import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final host = TextEditingController();

  final port = TextEditingController();

  @override
  void dispose() {
    host.dispose();

    port.dispose();

    super.dispose();
  }

  void requestToRemoteServer(String endpoint) async {
    await TcpClient(host: host.text, port: int.parse(port.text))
        .send("GET $endpoint\r");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "WiFi IP Address",
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              TextFormField(
                controller: host,
                decoration: const InputDecoration(
                  hintText: "192.168.0.1",
                  label: Text("Host"),
                ),
              ),
              TextFormField(
                controller: port,
                decoration: const InputDecoration(
                  hintText: "3000",
                  label: Text("Port"),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      requestToRemoteServer("/left");
                    },
                    child: const Text("Left"),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      requestToRemoteServer("/right");
                    },
                    child: const Text("Right"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TcpClient {
  final String host;

  final int port;

  const TcpClient({required this.host, required this.port});

  Future<void> send(String message) async {
    final socket = await Socket.connect(host, port);

    socket.write(message);

    await socket.done;

    socket.close();
  }
}
