import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habit_on_assig/config/routes/routes.dart';
import 'package:habit_on_assig/config/theme/app_themes.dart';
import 'package:habit_on_assig/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:habit_on_assig/src/features/auth/presentation/providers/user_provider.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/model/update_model.dart';
import 'package:habit_on_assig/src/features/habits/presentation/providers/habit_provider.dart';
import 'package:habit_on_assig/src/features/habits/presentation/providers/update_value.dart';
import 'package:habit_on_assig/src/features/skeleton/notification_controller.dart';
import 'package:habit_on_assig/src/features/skeleton/providers/selected_page_provider.dart';
import 'package:habit_on_assig/src/localization/l10n.dart';
import 'package:provider/provider.dart';

import 'settings/settings_controller.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => AuthenticationProvider()..loadLocale(),
            ),
            ChangeNotifierProvider(
              create: (context) => UserProvider()..loadUser(),
            ),
            ChangeNotifierProvider(
              create: (context) => SettingsController()..loadSettings(),
            ),
            ChangeNotifierProvider(
              create: (context) => HabitProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) =>
                  HUProvider(habitData: HabitUpdateModel.emptyHabitData),
            ),
            ChangeNotifierProvider(
              create: (context) => SelectedPageProvider(),
            ),
          ],
          child: Consumer<AuthenticationProvider>(
            builder: (context, ap, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                restorationScopeId: 'app',
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: L10n.all,
                locale: ap.locale,
                onGenerateTitle: (BuildContext context) =>
                    AppLocalizations.of(context)!.appTitle,
                theme: lightTheme(context),
                darkTheme: darkTheme(context),
                themeMode: ap.themeMode,
                onGenerateRoute: AppRoutes.onGenerateRoutes,
              );
            },
          ),
        );
      },
    );
  }
}
