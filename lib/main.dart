import 'package:bogbon/Pages/bogbon/Home_Page.dart';
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
import 'package:bogbon/servis/shared_preferences/Shared_preferens.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // 1. Bazani ishga tushirish (backgroundda ham ma'lumotlar kerak)
    await DatabaseService.init();
    
    // 2. Haroratni tekshirish va bildirishnoma yuborish
    await WeatherService.checkTemperatureAndNotify();

    // 3. Sug'orish vaqtini tekshirish va "Keyinroq" ro'yxatini yangilash
    // Bu yerda CareProvider-ni bevosita ishlata olmaymiz (ChangeNotifier)
    // Lekin SharedPreferens orqali sync qilishimiz mumkin
    await _syncPostponedPlantsInBackground();
    
    return Future.value(true);
  });
}

Future<void> _syncPostponedPlantsInBackground() async {
  final allPlants = DatabaseService.getAllPlants();
  if (allPlants.isEmpty) return;

  final now = DateTime.now();
  final List<String> postponed = await SharedPreferens.getPostponedPlants();
  List<String> newPostponedList = List.from(postponed);
  bool changed = false;

  for (var plant in allPlants) {
    final nextWatering = plant.lastWateredAt.add(Duration(days: plant.care.watering.days));
    if (now.isAfter(nextWatering)) {
      final plantData = "${plant.id}|${plant.name}";
      if (!newPostponedList.contains(plantData)) {
        newPostponedList.add(plantData);
        changed = true;
      }
    }
  }

  if (changed) {
    await SharedPreferens.setPostponedPlants(newPostponedList);
  }
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  try {

    await DatabaseService.init();
    

    await NotificationService.init();


    await initializeDateFormatting('uz', null);


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
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
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
      },
    );
  }
}
