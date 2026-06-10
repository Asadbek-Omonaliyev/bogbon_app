import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:bogbon/servis/provider/CareProvider.dart';
import 'package:bogbon/servis/provider/ThemeProvider.dart';
import 'package:bogbon/servis/provider/NotificationProvider.dart';
import 'package:bogbon/servis/provider/PlantProvider.dart';
import 'package:intl/intl.dart';

// ─── Rang palitrasi ──────────────────────────────────────────────────────────
class BogbonColors {
  static const primary = Color(0xFF1D9E75); // Asosiy yashil
  static const danger = Color(0xFFE24B4A);  // Xavf (qizil)
  static const warning = Color(0xFFBA7517); // Ogohlantirish (sariq)
  static const neutral = Color(0xFF888780); // Neytral kulrang
  static const lightGreen = Color(0xFFE1F5EE);
  static const cardBgLight = Color(0xFFF5F5F0);
  static const innerCardLight = Color(0xFFF1EFE8);
  static const backgroundDark = Color(0xFF121212);
  
  static Color getPlantColor(int index) {
    final List<Color> colors = [
      Color(0xFF1D9E75), Color(0xFFD4537E), Color(0xFFBA7517), 
      Color(0xFF185FA5), Color(0xFF9C27B0), Color(0xFFE91E63),
      Color(0xFF009688), Color(0xFF673AB7), Color(0xFF3F51B5),
      Color(0xFF795548),
    ];
    return colors[index % colors.length];
  }

  static Color getPlantLightColor(int index) {
    final List<Color> colors = [
      Color(0xFFE1F5EE), Color(0xFFFBEAF0), Color(0xFFFAEEDA), 
      Color(0xFFE6F1FB), Color(0xFFF3E5F5), Color(0xFFFCE4EC),
      Color(0xFFE0F2F1), Color(0xFFEDE7F6), Color(0xFFE8EAF6),
      Color(0xFFEFEBE9),
    ];
    return colors[index % colors.length];
  }
}

class WateringStatsPage extends StatefulWidget {
  final PlantModel? specificPlant;
  const WateringStatsPage({super.key, this.specificPlant});

  @override
  State<WateringStatsPage> createState() => _WateringStatsPageState();
}

class _WateringStatsPageState extends State<WateringStatsPage> {
  late DateTime _viewDate;
  late Set<int> _activePlants;
  late List<PlantModel> _plants;

  @override
  void initState() {
    super.initState();
    _viewDate = DateTime(DateTime.now().year, DateTime.now().month);
    _loadData();
  }

  void _loadData() {
    final notifProvider = context.read<NotificationProvider>();
    if (widget.specificPlant != null) {
      _plants = [widget.specificPlant!];
    } else {
      _plants = notifProvider.notificationPlants;
    }
    _activePlants = Set.from(List.generate(_plants.length, (i) => i));
  }

  // ─── Sug'orish kunlarini hisoblash ─────────────────────────────────────────
  Map<int, String> _getWateringDays(int plantIdx) {
    final plant = _plants[plantIdx];
    final result = <int, String>{};
    final monthStart = DateTime(_viewDate.year, _viewDate.month, 1);
    final monthEnd = DateTime(_viewDate.year, _viewDate.month + 1, 0);
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Anchor - Oxirgi sug'orilgan kun. Jadval aynan shu kundan boshlanadi.
    final anchor = DateTime(plant.lastWateredAt.year, plant.lastWateredAt.month, plant.lastWateredAt.day);
    
    int interval = plant.smartNotifications.wateringDays;
    if (interval <= 0) return result;

    // 1. Faqat oxirgi sug'orilgan kunni 'done' (bajarildi) deb belgilash
    if (_isDateInMonth(anchor, monthStart, monthEnd)) {
      result[anchor.day] = 'done';
    }

    // 2. Oxirgi sug'orilgan kundan boshlab kelajakka (va bugungi kungacha bo'lgan kechikishlarga) hisoblash
    DateTime cur = anchor.add(Duration(days: interval));
    
    // Oyni oxirigacha yoki bugungi kungacha (qaysi biri uzoqroq bo'lsa)
    final limitDate = monthEnd.isAfter(today) ? monthEnd : today;

    while (!cur.isAfter(limitDate)) {
      if (_isDateInMonth(cur, monthStart, monthEnd)) {
        final dateOnly = DateTime(cur.year, cur.month, cur.day);
        
        if (dateOnly.isAtSameMomentAs(today)) {
          result[cur.day] = 'today';
        } else if (dateOnly.isBefore(today)) {
          result[cur.day] = 'overdue';
        } else {
          result[cur.day] = 'plan';
        }
      }
      cur = cur.add(Duration(days: interval));
    }
    
    return result;
  }

  bool _isDateInMonth(DateTime date, DateTime start, DateTime end) {
    return !date.isBefore(start) && !date.isAfter(end);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    return Scaffold(
      backgroundColor: isDark ? BogbonColors.backgroundDark : BogbonColors.cardBgLight,
      appBar: AppBar(
        backgroundColor: isDark ? BogbonColors.backgroundDark : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Sug\'orish jadvali',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: BogbonColors.primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PlantProvider>(
        builder: (context, plantProvider, child) {
          if (widget.specificPlant != null) {
            final updatedPlant = plantProvider.plants.firstWhere(
              (p) => p.id == widget.specificPlant!.id,
              orElse: () => widget.specificPlant!,
            );
            _plants = [updatedPlant];
          } else {
            _plants = plantProvider.plants.where((p) => 
              context.read<NotificationProvider>().isNotificationOn(p.id)
            ).toList();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCalendarCard(isDark),
                const SizedBox(height: 12),
                _buildStatsRow(isDark),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendarCard(bool isDark) {
    return _Card(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthNav(isDark),
          const SizedBox(height: 12),
          Text(
            'Ko\'rsatish uchun o\'simliklarni tanlang:',
            style: GoogleFonts.poppins(fontSize: 12, color: BogbonColors.neutral),
          ),
          const SizedBox(height: 8),
          _buildPlantFilters(isDark),
          const SizedBox(height: 12),
          _buildCalendarGrid(isDark),
          const SizedBox(height: 10),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildMonthNav(bool isDark) {
    final monthNames = [
      'Yanvar', 'Fevral', 'Mart', 'Aprel', 'May', 'Iyun',
      'Iyul', 'Avgust', 'Sentabr', 'Oktabr', 'Noyabr', 'Dekabr'
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _NavButton(
          icon: Icons.chevron_left,
          isDark: isDark,
          onTap: () => setState(() {
            _viewDate = DateTime(_viewDate.year, _viewDate.month - 1);
          }),
        ),
        Text(
          '${monthNames[_viewDate.month - 1]} ${_viewDate.year}',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        _NavButton(
          icon: Icons.chevron_right,
          isDark: isDark,
          onTap: () => setState(() {
            _viewDate = DateTime(_viewDate.year, _viewDate.month + 1);
          }),
        ),
      ],
    );
  }

  Widget _buildPlantFilters(bool isDark) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List.generate(_plants.length, (i) {
        final active = _activePlants.contains(i);
        final pColor = BogbonColors.getPlantColor(i);
        final pLightColor = BogbonColors.getPlantLightColor(i);
        
        return GestureDetector(
          onTap: () => setState(() {
            if (active) {
              if (_activePlants.length > 1) _activePlants.remove(i);
            } else {
              _activePlants.add(i);
            }
          }),
          child: AnimatedOpacity(
            opacity: active ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 150),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: active ? (isDark ? pColor.withOpacity(0.2) : pLightColor) : (isDark ? Colors.white10 : BogbonColors.innerCardLight),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: active ? pColor : (isDark ? Colors.white24 : const Color(0xFFD3D1C7)),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: pColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _plants[i].name,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: active ? (isDark ? Colors.white : pColor) : BogbonColors.neutral,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCalendarGrid(bool isDark) {
    final allData = List.generate(
      _plants.length,
      (i) => _activePlants.contains(i) ? _getWateringDays(i) : <int, String>{},
    );

    final firstDay = DateTime(_viewDate.year, _viewDate.month, 1);
    int startDow = firstDay.weekday - 1; 
    final daysInMonth = DateTime(_viewDate.year, _viewDate.month + 1, 0).day;
    final today = DateTime.now();

    final dayHeaders = ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'];

    return Column(
      children: [
        Row(
          children: dayHeaders.map((d) => Expanded(
            child: Center(
              child: Text(d, style: GoogleFonts.poppins(fontSize: 11, color: BogbonColors.neutral)),
            ),
          )).toList(),
        ),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            childAspectRatio: 1,
          ),
          itemCount: startDow + daysInMonth,
          itemBuilder: (context, index) {
            if (index < startDow) return const SizedBox.shrink();
            final day = index - startDow + 1;
            final isToday = today.year == _viewDate.year &&
                today.month == _viewDate.month &&
                today.day == day;

            final dots = <Widget>[];
            final List<PlantModel> plantsOnThisDay = [];

            for (int i = 0; i < _plants.length; i++) {
              final status = allData[i][day];
              if (status == null) continue;
              
              final pColor = BogbonColors.getPlantColor(i);
              Color dotColor;
              BoxBorder? dotBorder;

              if (status == 'done') {
                dotColor = pColor; 
              } else if (status == 'overdue') {
                dotColor = BogbonColors.danger; 
              } else if (status == 'today') {
                dotColor = Colors.transparent;
                dotBorder = Border.all(color: BogbonColors.primary, width: 2);
              } else {
                dotColor = isDark ? pColor.withOpacity(0.1) : BogbonColors.getPlantLightColor(i);
                dotBorder = Border.all(color: pColor, width: 1.2);
              }

              dots.add(Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: dotBorder,
                ),
              ));
              plantsOnThisDay.add(_plants[i]);
            }

            return GestureDetector(
              onTap: dots.isEmpty ? null : () => _showDayPlantsDialog(day, plantsOnThisDay, allData, isDark),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : BogbonColors.innerCardLight,
                  borderRadius: BorderRadius.circular(8),
                  border: isToday ? Border.all(color: BogbonColors.primary, width: 1.5) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                        color: isToday ? BogbonColors.primary : (isDark ? Colors.white70 : const Color(0xFF1A1A1A)),
                      ),
                    ),
                    if (dots.isNotEmpty)
                      Wrap(alignment: WrapAlignment.center, children: dots),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showDayPlantsDialog(int day, List<PlantModel> dayPlants, List<Map<int, String>> allData, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "$day-${_viewDate.month}-${_viewDate.year}",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Shu kungi sug'orishlar:",
                style: GoogleFonts.poppins(fontSize: 14, color: BogbonColors.neutral),
              ),
              const SizedBox(height: 15),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dayPlants.length,
                  itemBuilder: (context, index) {
                    final plant = dayPlants[index];
                    final plantOrigIdx = _plants.indexOf(plant);
                    final status = allData[plantOrigIdx][day];
                    
                    if (status == null) return const SizedBox.shrink();

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: BogbonColors.getPlantColor(plantOrigIdx).withOpacity(0.2),
                        child: Icon(Icons.water_drop, color: BogbonColors.getPlantColor(plantOrigIdx), size: 20),
                      ),
                      title: Text(plant.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                      subtitle: Text(
                        status == 'done' ? "Sug'orilgan" : 
                        status == 'overdue' ? "Kechikkan" : 
                        status == 'today' ? "Bugun sug'orish kerak" : "Rejalashtirilgan",
                        style: TextStyle(fontSize: 12, color: status == 'overdue' ? Colors.red : Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yopish"),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        _LegendItem(color: BogbonColors.primary, label: 'Sug\'orildi'),
        _LegendItem(
            color: Colors.transparent,
            label: 'Rejalashtirilgan',
            border: Border.all(color: BogbonColors.primary, width: 1.2)),
        _LegendItem(color: BogbonColors.danger, label: 'Kechikdi'),
      ],
    );
  }

  Widget _buildStatsRow(bool isDark) {
    if (_plants.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_plants.length, (i) {
          if (!_activePlants.contains(i)) return const SizedBox();
          final p = _plants[i];
          final data = _getWateringDays(i);
          final done = data.values.where((v) => v == 'done').length;
          final total = data.length;

          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : BogbonColors.innerCardLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name,
                    style: GoogleFonts.poppins(fontSize: 11, color: BogbonColors.getPlantColor(i), fontWeight: FontWeight.w600),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: '$done',
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: BogbonColors.getPlantColor(i))),
                      TextSpan(
                          text: ' / $total',
                          style: GoogleFonts.poppins(fontSize: 12, color: BogbonColors.neutral)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ─── Yordamchi widgetlar ──────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const _Card({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE0DED8), width: 0.5),
      ),
      child: child,
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  const _NavButton({required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: isDark ? Colors.white24 : const Color(0xFFD3D1C7), width: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: BogbonColors.neutral),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final BoxBorder? border;
  const _LegendItem({required this.color, required this.label, this.border});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: border),
        ),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: BogbonColors.neutral)),
      ],
    );
  }
}
