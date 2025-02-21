import 'package:intl/date_symbol_data_local.dart';
import 'package:app/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('en_US', null).then((_) => runApp(const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GL Scanner App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 2, 77, 223),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 2, 77, 223),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
