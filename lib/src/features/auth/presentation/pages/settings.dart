import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_on_assig/config/default/widgets/containers.dart';
import 'package:habit_on_assig/config/default/widgets/text.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme = false;
  String selectedLanguage = 'English';
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut().then((u) {
        Navigator.pushReplacementNamed(context, "/");
      });
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(selectedLanguage),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Confirm Logout'),
          actions: [
            ButtonDef(
              width: 70,
              things: const TextDef("Confirm"),
              onTap: () {
                logout();
              },
            )
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<String>(
                title: const Text('English'),
                value: 'English',
                groupValue: selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text('Spanish'),
                value: 'Spanish',
                groupValue: selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
