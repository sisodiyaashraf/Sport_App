import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/skills.dart';
import '../provider/theme_provider.dart';

class DrillPage extends StatefulWidget {
  final Skill skill;
  const DrillPage({super.key, required this.skill});

  @override
  State<DrillPage> createState() => _DrillPageState();
}

class _DrillPageState extends State<DrillPage> {
  int totalTime = 30;
  int remainingTime = 30;
  Timer? _timer;
  bool isRunning = false;
  bool isCompleted = false;

  //Save completed state
  Future<void> _markAsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("completed_${widget.skill.name}", true);
  }

  //Start Timer
  void _startTimer() {
    if (isRunning) return;
    setState(() => isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() => remainingTime--);
      } else {
        timer.cancel();
        setState(() {
          isRunning = false;
          isCompleted = true;
        });
        _markAsCompleted();
        _showCompletionDialog();
      }
    });
  }

  // Pause Timer
  void _pauseTimer() {
    _timer?.cancel();
    setState(() => isRunning = false);
  }

  //Reset Timer
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      remainingTime = totalTime;
      isRunning = false;
      isCompleted = false;
    });
  }

  //Completion Dialog
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Drill Completed!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/animated_image/Trophy cup.json',
                height: 120, repeat: false),
            const SizedBox(height: 8),
            Text(
              "You completed your ${widget.skill.name} drill!",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Icon(Icons.check_circle, color: Colors.green, size: 48),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
            },
            child: const Text("Restart"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get formattedTime {
    final minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingTime % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    final gradient = LinearGradient(
      colors: isDark
          ? [
              const Color(0xFF0F2027),
              const Color(0xFF203A43),
              const Color(0xFF2C5364)
            ]
          : [const Color(0xFF89f7fe), const Color(0xFF66a6ff)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "${widget.skill.name} Drill",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: gradient),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.12),

              //Title
              Text(
                "🔥 ${widget.skill.name} Drill 🔥",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.065,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 1.1,
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              //Timer Circle
              SleekCircularSlider(
                appearance: CircularSliderAppearance(
                  size: screenWidth * 0.7,
                  customColors: CustomSliderColors(
                    progressBarColors: [Colors.tealAccent, Colors.blueAccent],
                    trackColor: Colors.white24,
                    dotColor: Colors.white,
                  ),
                  customWidths: CustomSliderWidths(
                    progressBarWidth: 10,
                    trackWidth: 6,
                    handlerSize: 6,
                  ),
                ),
                min: 0,
                max: totalTime.toDouble(),
                initialValue: (totalTime - remainingTime).toDouble(),
                innerWidget: (_) => Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.12,
                      color: isCompleted ? Colors.greenAccent : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text(formattedTime),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              //Control Buttons
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 10,
                children: [
                  _buildControlButton(
                    icon: isRunning
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    label: isRunning ? "Pause" : "Start",
                    color: Colors.tealAccent,
                    onPressed: isRunning ? _pauseTimer : _startTimer,
                  ),
                  _buildControlButton(
                    icon: Icons.replay_rounded,
                    label: "Reset",
                    color: Colors.white,
                    onPressed: _resetTimer,
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.06),

              //Duration Selector
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  children: [
                    Text(
                      "Set Drill Duration",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [15, 30, 45, 60].map((time) {
                        final isSelected = totalTime == time;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.tealAccent
                                : Colors.white24.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.tealAccent
                                  : Colors.white38,
                              width: 1.5,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              if (!isRunning) {
                                setState(() {
                                  totalTime = time;
                                  remainingTime = time;
                                });
                              }
                            },
                            child: Text(
                              "$time sec",
                              style: GoogleFonts.roboto(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.white.withOpacity(0.9),
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              //Completion Indicator
              if (isCompleted)
                Column(
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.greenAccent, size: screenWidth * 0.15),
                    const SizedBox(height: 8),
                    Text(
                      "Drill Completed!",
                      style: GoogleFonts.poppins(
                        color: Colors.greenAccent,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 26),
      label: Text(
        label,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 8,
        shadowColor: color.withOpacity(0.5),
      ),
    );
  }
}
