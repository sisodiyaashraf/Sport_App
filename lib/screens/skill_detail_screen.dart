import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:sports_app/screens/drill_screen.dart';
import '../models/skills.dart';
import '../provider/theme_provider.dart';

class SkillDetailScreen extends StatelessWidget {
  final Skill skill;

  const SkillDetailScreen({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final bgGradient = LinearGradient(
      colors: isDark
          ? [
              const Color(0xFF0F2027),
              const Color(0xFF203A43),
              const Color(0xFF2C5364)
            ]
          : [const Color(0xFF1e3c72), const Color(0xFF2a5298)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryText = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        title: Text(
          skill.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            isDark ? const Color(0xFF1F1F1F) : const Color(0xFF1e3c72),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🖼️ Skill Image
              Hero(
                tag: skill.name,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    skill.image,
                    height: screenWidth * 0.75,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: screenWidth * 0.6,
                      color: isDark ? Colors.white12 : Colors.black12,
                      child: Icon(
                        Icons.sports_soccer,
                        size: 70,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🏷️ Skill Name
              Text(
                skill.name,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.075,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // 🎯 Level Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.tealAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Level: ${skill.level}",
                  style: GoogleFonts.roboto(
                    fontSize: screenWidth * 0.045,
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 💬 Motivational Taglines
              AnimatedTextKit(
                repeatForever: true,
                pause: const Duration(milliseconds: 1000),
                animatedTexts: [
                  FadeAnimatedText(
                    '🔥 Keep pushing your limits!',
                    textStyle: GoogleFonts.lato(
                      fontSize: screenWidth * 0.045,
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FadeAnimatedText(
                    '🏆 Consistency builds mastery!',
                    textStyle: GoogleFonts.lato(
                      fontSize: screenWidth * 0.045,
                      color: Colors.lightGreenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 📖 Description
              Text(
                skill.description,
                style: GoogleFonts.roboto(
                  fontSize: screenWidth * 0.04,
                  color: textColor.withOpacity(0.9),
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 30),

              // 🎥 Training Video Placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.white10, Colors.white12]
                        : [Colors.white, Colors.grey.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: isDark ? Colors.white70 : Colors.black54,
                    size: 70,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Training Video (Coming Soon)",
                style: GoogleFonts.roboto(
                  color: secondaryText,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 40),

              // 🚀 Start Drill Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: Colors.tealAccent.withOpacity(0.6),
                ),
                onPressed: () {
                  // 🚀 Navigate to Drill Page
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 700),
                      pageBuilder: (_, __, ___) => DrillPage(skill: skill),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position: Tween(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.sports_martial_arts, size: 24),
                label: Text(
                  "Start Drill",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
