import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import '../models/skills.dart';
import '../provider/theme_provider.dart';
import '../screens/skill_detail_screen.dart';

class SkillCard extends StatefulWidget {
  final Skill skill;
  const SkillCard({super.key, required this.skill});

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> with TickerProviderStateMixin {
  bool isCompleted = false;

  late AnimationController _badgeController;
  late Animation<double> _pulse;
  late AnimationController _tapController;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _loadCompletionStatus();

    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _pulse = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.easeOutBack),
    );

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.05).animate(_tapController);
  }

  Future<void> _loadCompletionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool("completed_${widget.skill.name}") ?? false;

    if (completed && !isCompleted) {
      _badgeController.forward().then((_) => _badgeController.reverse());
    }

    setState(() => isCompleted = completed);
  }

  Future<void> _navigateToDetail(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SkillDetailScreen(skill: widget.skill),
      ),
    );
    _loadCompletionStatus();
  }

  @override
  void dispose() {
    _badgeController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final gradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF232526), Color(0xFF414345)], // subtle steel dark
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)], // bright blue
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return GestureDetector(
      onTapDown: (_) => _tapController.forward(),
      onTapUp: (_) async {
        await _tapController.reverse();
        _navigateToDetail(context);
      },
      onTapCancel: () => _tapController.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: screenWidth * 0.38,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: gradient,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.4)
                    : Colors.blueAccent.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(2, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // 🔹 Full background image
                Positioned.fill(
                  child: Hero(
                    tag: widget.skill.name,
                    child: Image.network(
                      widget.skill.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        "assets/images/fallback.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        isDark
                            ? Colors.black.withOpacity(0.6)
                            : Colors.black.withOpacity(0.3),
                        Colors.transparent,
                        isDark
                            ? Colors.black.withOpacity(0.7)
                            : Colors.black.withOpacity(0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.skill.name,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.0,
                          shadows: const [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 6,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.skill.level,
                        style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 20,
                        child: AnimatedTextKit(
                          repeatForever: true,
                          pause: const Duration(milliseconds: 800),
                          animatedTexts: [
                            FadeAnimatedText(
                              'Train smarter ⚡',
                              textStyle: GoogleFonts.lato(
                                fontSize: screenWidth * 0.032,
                                color: Colors.tealAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            FadeAnimatedText(
                              'Boost your skills 🚀',
                              textStyle: GoogleFonts.lato(
                                fontSize: screenWidth * 0.032,
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, child) => Transform.scale(
                      scale: isCompleted ? _pulse.value : 0.0,
                      child: child,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.greenAccent,
                        size: 22,
                      ),
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
}
