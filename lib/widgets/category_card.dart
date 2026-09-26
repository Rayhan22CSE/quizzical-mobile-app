import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../app/theme.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  /// Formats raw API category names into clean concise titles matching the reference design.
  String _formatCategoryName(String rawName) {
    String name = rawName;
    if (name.startsWith('Entertainment: ')) {
      name = name.substring('Entertainment: '.length);
    } else if (name.startsWith('Science: ')) {
      name = name.substring('Science: '.length);
    }
    if (name == 'Japanese Anime & Manga') return 'Anime & Manga';
    if (name == 'Cartoon & Animations') return 'Cartoons';
    if (name == 'Musicals & Theatres') return 'Musicals';
    return name;
  }

  /// Returns dedicated high-definition image asset created specifically for each section.
  /// NO duplicate image reuse anywhere in the app!
  String _getDedicatedCategoryAsset(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('knowledge')) return 'assets/images/hd_gk.jpg';
    if (name.contains('film') || name.contains('movie')) return 'assets/images/hd_film.jpg';
    if (name.contains('musical') || name.contains('theatre')) return 'assets/images/hd_musicals.jpg';
    if (name.contains('music')) return 'assets/images/hd_music.jpg';
    if (name.contains('television') || name.contains('tv')) return 'assets/images/hd_television.jpg';
    if (name.contains('video game')) return 'assets/images/hd_videogames.jpg';
    if (name.contains('board game')) return 'assets/images/hd_boardgames.jpg';
    if (name.contains('computer')) return 'assets/images/hd_computers.jpg';
    if (name.contains('math')) return 'assets/images/hd_math.jpg';
    if (name.contains('myth')) return 'assets/images/hd_mythology.jpg';
    if (name.contains('sport')) return 'assets/images/hd_sports.jpg';
    if (name.contains('geography')) return 'assets/images/hd_geography.jpg';
    if (name.contains('history')) return 'assets/images/hd_history.jpg';
    if (name.contains('politics')) return 'assets/images/hd_politics.jpg';
    if (name.contains('art')) return 'assets/images/hd_art.jpg';
    if (name.contains('celebrity')) return 'assets/images/hd_celebrities.jpg';
    if (name.contains('animal')) return 'assets/images/hd_animals.jpg';
    if (name.contains('vehicle')) return 'assets/images/hd_vehicles.jpg';
    if (name.contains('comic')) return 'assets/images/hd_comics.jpg';
    if (name.contains('gadget')) return 'assets/images/hd_gadgets.jpg';
    if (name.contains('anime') || name.contains('manga')) return 'assets/images/hd_anime.jpg';
    if (name.contains('cartoon') || name.contains('animation')) return 'assets/images/hd_cartoons.jpg';
    if (name.contains('book')) return 'assets/images/hd_books.jpg';
    if (name.contains('science') || name.contains('nature')) return 'assets/images/hd_science.jpg';

    return 'assets/images/hd_gk.jpg';
  }

  /// Exact background color matching reference screenshot palette
  Color _getCategoryColor(String categoryName, int idx) {
    final name = categoryName.toLowerCase();
    if (name.contains('knowledge') || name.contains('geography') || name.contains('game')) {
      return AppTheme.colorGeneralKnowledge;
    }
    if (name.contains('book') || name.contains('computer') || name.contains('sport')) {
      return AppTheme.colorBooks;
    }
    if (name.contains('history') || name.contains('film') || name.contains('movie') || name.contains('math')) {
      return AppTheme.colorHistory;
    }
    if (name.contains('science') || name.contains('nature') || name.contains('music') || name.contains('tv')) {
      return AppTheme.colorScience;
    }
    if (name.contains('art') || name.contains('celebrity') || name.contains('comic')) {
      return AppTheme.colorArt;
    }
    if (name.contains('vehicle') || name.contains('animal') || name.contains('gadget')) {
      return AppTheme.colorVehicles;
    }
    return AppTheme.categoryColors[idx % AppTheme.categoryColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _formatCategoryName(category.name);
    final dedicatedAssetPath = _getDedicatedCategoryAsset(category.name);
    final cardBgColor = _getCategoryColor(category.name, index);

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.black.withValues(alpha: 0.08),
          highlightColor: Colors.black.withValues(alpha: 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // High-Definition 3D Image Artwork Area specifically relevant to this section
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: cardBgColor,
                  child: Image.asset(
                    dedicatedAssetPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Category Title at Bottom Left matching Reference Design
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                color: cardBgColor,
                child: Text(
                  displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.titleTextColor,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
