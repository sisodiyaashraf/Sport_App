import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import '../models/skills.dart';
import '../provider/theme_provider.dart';

class ProgressScreen extends StatefulWidget {
  final List<Skill> skills;
  const ProgressScreen({super.key, required this.skills});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  Set<String> completed = {};
  late ConfettiController _confettiController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedKeys = prefs.getKeys();
    setState(() {
      completed = savedKeys
          .where((k) => k.startsWith("completed_") && prefs.getBool(k) == true)
          .map((k) => k.replaceFirst("completed_", ""))
          .toSet();
    });

    if (completed.length == widget.skills.length && widget.skills.isNotEmpty) {
      _confettiController.play();
    }
  }

  Future<void> _removeCompletion(String skillName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("completed_$skillName");
    setState(() => completed.remove(skillName));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$skillName marked as incomplete ❌"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Future<void> _resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Reset Progress?",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "This will clear all completed skills and restart your progress.",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              icon: const Icon(Icons.restore, color: Colors.white),
              label: Text("Reset",
                  style: GoogleFonts.poppins(color: Colors.white)),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      for (var key in prefs.getKeys()) {
        if (key.startsWith("completed_")) await prefs.remove(key);
      }
      setState(() => completed.clear());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Progress reset successfully 🔄"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Widget safeLottie(String asset, {double height = 120}) {
    try {
      return Lottie.asset(asset, height: height, repeat: true);
    } catch (_) {
      return Icon(Icons.emoji_events_rounded,
          color: Colors.amberAccent, size: height * 0.6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final total = widget.skills.length;
    final done = completed.length;
    final percent = total == 0 ? 0.0 : done / total;

    final textColor = isDark ? Colors.white : Colors.black87;
    final secondary = isDark ? Colors.white70 : Colors.black54;

    final levels = ["Basic", "Intermediate", "Advanced"];
    final completedByLevel = {
      for (var l in levels)
        l: widget.skills
            .where((s) => s.level == l && completed.contains(s.name))
            .length
    };

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: "reload",
            backgroundColor: Colors.tealAccent,
            onPressed: _loadProgress,
            child: const Icon(Icons.refresh, color: Colors.black),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.small(
            heroTag: "reset",
            backgroundColor: Colors.redAccent,
            onPressed: _resetProgress,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 🧊 Glassy gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0F2027), const Color(0xFF203A43)]
                    : [const Color(0xFF56CCF2), const Color(0xFF2F80ED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.15)),
          ),
          FadeTransition(
            opacity: _fadeController,
            child: SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Text(
                      "🏅 Your Training Progress",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircularPercentIndicator(
                      radius: 90,
                      lineWidth: 12,
                      percent: percent,
                      animation: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(
                        "${(percent * 100).toStringAsFixed(0)}%",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      progressColor: percent < 0.33
                          ? Colors.redAccent
                          : percent < 0.66
                              ? Colors.orangeAccent
                              : Colors.greenAccent,
                      backgroundColor: Colors.white24,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "$done / $total skills completed",
                      style: GoogleFonts.lato(color: secondary, fontSize: 14),
                    ),
                    const SizedBox(height: 30),

                    // 🧩 Each Level Card
                    ...levels.map((level) {
                      final skills =
                          widget.skills.where((s) => s.level == level).toList();
                      final doneCount = completedByLevel[level] ?? 0;
                      final p =
                          skills.isEmpty ? 0.0 : doneCount / skills.length;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isDark
                              ? const Color.fromARGB(255, 24, 23, 23)
                                  .withOpacity(0.05)
                              : Colors.white.withOpacity(0.25),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black26
                                  : Colors.blue.shade100,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$level Level",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                "$doneCount / ${skills.length}",
                                style: GoogleFonts.poppins(
                                  color: secondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: LinearPercentIndicator(
                                lineHeight: 10,
                                percent: p,
                                animation: true,
                                barRadius: const Radius.circular(8),
                                backgroundColor:
                                    const Color.fromARGB(26, 193, 43, 43),
                                progressColor: level == "Basic"
                                    ? Colors.lightBlueAccent
                                    : level == "Intermediate"
                                        ? Colors.tealAccent
                                        : Colors.amberAccent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...skills.map((skill) {
                              final isDone = completed.contains(skill.name);
                              return ListTile(
                                dense: true,
                                leading: Icon(
                                  isDone
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: isDone
                                      ? Colors.greenAccent
                                      : Colors.white38,
                                ),
                                title: Text(
                                  skill.name,
                                  style: GoogleFonts.poppins(
                                    color: textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: isDone
                                    ? IconButton(
                                        icon: const Icon(Icons.undo,
                                            color: Colors.redAccent),
                                        onPressed: () =>
                                            _removeCompletion(skill.name),
                                      )
                                    : null,
                              );
                            }),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          // 🎉 Confetti Celebration
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.amber,
              Colors.greenAccent,
              Colors.pinkAccent,
              Colors.blueAccent,
            ],
            gravity: 0.3,
          ),
        ],
      ),
    );
  }
}
