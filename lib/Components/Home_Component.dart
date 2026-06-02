import 'dart:io';
import 'dart:ui';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:bogbon/servis/provider/FavoritesProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeComponent extends StatelessWidget {
  final PlantModel plantModel;
  final VoidCallback onTap;
  final String heroPrefix;

  const HomeComponent({
    super.key,
    required this.plantModel,
    required this.onTap,
    this.heroPrefix = "home",
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.white.withOpacity(0.05) : Colors.white;
    final shadowColor = isDark ? Colors.black26 : Colors.black.withOpacity(0.05);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.03),
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(isDark),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, isDark),
                        const SizedBox(height: 4),
                        _buildLatinName(),
                        const SizedBox(height: 12),
                        _buildStatsRow(isDark),
                        const SizedBox(height: 12),
                        _buildBottomRow(isDark),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(bool isDark) {
    final difficultyColor = _getDifficultyColor(plantModel.difficulty);
    return Stack(
      children: [
        Hero(
          tag: '${heroPrefix}_plant_${plantModel.id}',
          child: SizedBox(
            width: 130,
            height: 160,
            child: plantModel.thumbnailImage.isEmpty
                ? _buildPlaceholder()
                : plantModel.thumbnailImage.startsWith('assets/')
                    ? Image.asset(
                        plantModel.thumbnailImage,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => _buildPlaceholder(),
                      )
                    : Image.file(
                        File(plantModel.thumbnailImage),
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => _buildPlaceholder(),
                      ),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: difficultyColor.withOpacity(isDark ? 0.4 : 0.7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  _getDifficultyText(plantModel.difficulty),
                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFav = favoritesProvider.isFavorite(plantModel.id);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                plantModel.name,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () => favoritesProvider.toggleFavorite(plantModel.id),
              child: Icon(
                isFav ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                color: isFav ? Colors.green : (isDark ? Colors.white38 : Colors.black26),
                size: 22,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLatinName() {
    return Text(
      plantModel.latinName.isEmpty ? "Noma'lum tur" : plantModel.latinName,
      style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.green.shade600),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatsRow(bool isDark) {
    final textColor = isDark ? Colors.white60 : Colors.black54;
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _buildSmallStat(Icons.wb_sunny_outlined, _getSunlightShort(plantModel.care.sunlight.type), textColor),
        _buildSmallStat(Icons.water_drop_outlined, "${plantModel.care.watering.days}k", textColor),
        _buildSmallStat(Icons.thermostat_outlined, "${plantModel.care.temperature.ideal}°", textColor),
      ],
    );
  }

  Widget _buildSmallStat(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.poppins(fontSize: 10, color: color, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildBottomRow(bool isDark) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            plantModel.category,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              "Sog'lom",
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.green.withOpacity(0.1),
      child: const Center(
        child: Icon(Icons.eco_outlined, size: 40, color: Colors.green),
      ),
    );
  }

  Color _getDifficultyColor(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.easy: return const Color(0xFF2E7D32);
      case DifficultyLevel.medium: return const Color(0xFFE65100);
      case DifficultyLevel.hard: return const Color(0xFFB71C1C);
    }
  }

  String _getDifficultyText(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.easy: return "OSON";
      case DifficultyLevel.medium: return "O'RTACHA";
      case DifficultyLevel.hard: return "QIYIN";
    }
  }

  String _getSunlightShort(SunlightType type) {
    switch (type) {
      case SunlightType.direct: return "Quyosh";
      case SunlightType.partial: return "Yarim";
      case SunlightType.lowLight: return "Soya";
    }
  }
}
