import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class WeatherComponent extends StatefulWidget {
  const WeatherComponent({super.key});

  @override
  State<WeatherComponent> createState() => WeatherComponentState();
}

class WeatherComponentState extends State<WeatherComponent> {
  String city = "Yuklanmoqda...";
  String temp = "--";
  String description = "Kuting...";
  String humidity = "--";
  String windSpeed = "--";
  String date = "";
  bool isLoading = true;
  IconData weatherIcon = Icons.wb_cloudy_rounded;

  @override
  void initState() {
    super.initState();
    date = DateFormat('EEEE, d-MMMM', 'uz').format(DateTime.now());
    getWeather();
  }

  Future<void> getWeather() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Manzilni aniqlash uchun ruxsat so'rash
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );

        final apiKey = "f093ea8fca470fb116cc6aa2b8fc9bf2";
        final url = "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric&lang=uz";

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            city = data['name'];
            temp = "${data['main']['temp'].round()}°C";
            description = data['weather'][0]['description'];
            humidity = "${data['main']['humidity']}% namlik";
            windSpeed = "${data['wind']['speed']} km/s";
            isLoading = false;
            _setWeatherIcon(data['weather'][0]['main']);
          });
        } else {
          setState(() {
            city = "API Xatosi: ${response.statusCode}";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          city = "Ruxsat berilmadi";
          isLoading = false;
        });
      }
    } on SocketException {
      setState(() {
        city = "Internet yo'q";
        isLoading = false;
      });
    }catch (e) {
      setState(() {
        city = "Xatolik: Nomalum xatolik!";
        isLoading = false;
      });
    }
  }

  void _setWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear': weatherIcon = Icons.wb_sunny_rounded; break;
      case 'clouds': weatherIcon = Icons.wb_cloudy_rounded; break;
      case 'rain': weatherIcon = Icons.umbrella_rounded; break;
      case 'snow': weatherIcon = Icons.ac_unit_rounded; break;
      case 'thunderstorm': weatherIcon = Icons.flash_on_rounded; break;
      default: weatherIcon = Icons.wb_cloudy_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(25),
            ),
            child: isLoading 
              ? Center(child: CircularProgressIndicator(color: isDark ? Colors.white : Colors.green))
              : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            city,
                            style: GoogleFonts.poppins(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            date,
                            style: GoogleFonts.poppins(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      weatherIcon,
                      color: isDark ? Colors.orangeAccent : Colors.orange,
                      size: 50,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      temp,
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            description,
                            style: GoogleFonts.poppins(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.water_drop, color: Colors.blueAccent, size: 16),
                                const SizedBox(width: 5),
                                Text(
                                  humidity,
                                  style: GoogleFonts.poppins(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12),
                                ),
                                const SizedBox(width: 15),
                                Icon(Icons.air, color: isDark ? Colors.white70 : Colors.black54, size: 16),
                                const SizedBox(width: 5),
                                Text(
                                  windSpeed,
                                  style: GoogleFonts.poppins(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
