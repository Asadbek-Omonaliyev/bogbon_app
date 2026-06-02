import 'package:bogbon/Pages/Home_Page.dart';
import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/NotificationService.dart';
import 'package:bogbon/servis/WeatherService.dart';
import 'package:bogbon/servis/provider/FavoritesProvider.dart';
import 'package:bogbon/servis/provider/NavigationProvider.dart';
import 'package:bogbon/servis/provider/NotificationProvider.dart';
import 'package:bogbon/servis/provider/PlantProvider.dart';
import 'package:bogbon/servis/provider/ThemeProvider.dart';
import 'package:bogbon/servis/provider/UserProvider.dart';
import 'package:bogbon/servis/provider/CareProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // 1. Bazani ishga tushirish (backgroundda ham ma'lumotlar kerak)
    await DatabaseService.init();
    
    // 2. Haroratni tekshirish va bildirishnoma yuborish
    await WeatherService.checkTemperatureAndNotify();
    
    return Future.value(true);
  });
}

void main() async {
  // Flutter bindinglarni ishga tushirish
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // 1. Lokal bazani yuklash (Hive)
    await DatabaseService.init();
    
    // 2. Bildirishnomalarni yuklash
    await NotificationService.init();
    
    // 3. Til sozlamalari
    await initializeDateFormatting('uz', null);

    // 4. Workmanager-ni ishga tushirish
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
    
    // Periodik vazifani ro'yxatdan o'tkazish (har 3 soatda)
    await Workmanager().registerPeriodicTask(
      "temp_check_task",
      "checkTemperatureAction",
      frequency: const Duration(hours: 3),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
    
    debugPrint("Barcha xizmatlar muvaffaqiyatli ishga tushdi");
  } catch (e) {
    debugPrint("Xizmatlarni ishga tushirishda xatolik: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => PlantProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => CareProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          home: const HomePage(),
        );
      },
    );
  }
}
