import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_on_assig/config/default/widgets/containers.dart';
import 'package:habit_on_assig/config/default/widgets/text.dart';
import 'package:habit_on_assig/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme = false;
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
    var ln = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(ln.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(ln.theme),
            subtitle:
                Text(context.watch<AuthenticationProvider>().themeMode!.name),
            onTap: () {
              _showThemeDialog(context, ln);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(ln.languagen),
            subtitle: Text(ln.language),
            onTap: () {
              _showLanguageDialog(ln);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(ln.logOut),
            onTap: () {
              _showLogoutDialog(ln);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _showLogoutDialog(var ln) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(ln.confirmLogout),
          actions: [
            ButtonDef(
              width: 70,
              things: TextDef(ln.confirm),
              onTap: () {
                logout();
              },
            )
          ],
        );
      },
    );
  }

  void _showLanguageDialog(var ln) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ln.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
                groupValue:
                    context.watch<AuthenticationProvider>().locale.languageCode,
                onChanged: (String? value) {
                  context
                      .read<AuthenticationProvider>()
                      .setLocale(Locale(value!));
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text('Hindi'),
                value: 'hi',
                groupValue:
                    context.watch<AuthenticationProvider>().locale.languageCode,
                onChanged: (String? value) {
                  context
                      .read<AuthenticationProvider>()
                      .setLocale(Locale(value!));

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context, var ln) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeProvider = context.read<AuthenticationProvider>();
        final themeProviderw = context.watch<AuthenticationProvider>();
        return AlertDialog(
          title: Text(ln.selectTheme),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<ThemeMode>(
                title: const Text('System Default'),
                value: ThemeMode.system,
                groupValue: themeProviderw.themeMode,
                onChanged: (ThemeMode? value) {
                  themeProvider.toggleTheme(value!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Light Mode'),
                value: ThemeMode.light,
                groupValue: themeProviderw.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeProvider.toggleTheme(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark Mode'),
                value: ThemeMode.dark,
                groupValue: themeProviderw.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeProvider.toggleTheme(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
