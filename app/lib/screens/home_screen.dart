import 'package:flutter/material.dart';
import 'package:app/screens/scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GL Mobile Scanner App')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ScannerScreen(),
                  ),
                );
              },
              child: Text("Start Scanning"),
            ),
          ),
        ),
      ),
    );
  }
}