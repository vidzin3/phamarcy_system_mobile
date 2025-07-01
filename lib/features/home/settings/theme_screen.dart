import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/util/theme_provider.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Theme Settings")),
      body: ListTile(
        title: const Text("Dark Mode"),
        trailing: Switch(
          value: themeProvider.isDarkMode,
          onChanged: (val) {
            themeProvider.toggleTheme();
          },
        ),
      ),
    );
  }
}
