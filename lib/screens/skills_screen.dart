import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slider_button/slider_button.dart';
import 'package:sports_app/models/skills.dart';
import 'package:sports_app/provider/theme_provider.dart';
import '../widgets/skill_card.dart';

class SkillsScreen extends StatefulWidget {
  final Function(List<Skill>)? onSkillsLoaded;
  const SkillsScreen({super.key, this.onSkillsLoaded});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  List<Skill> skills = [];
  bool isLoading = true;
  bool isError = false;

  final String apiUrl = "https://68dd46a07cd1948060ad13cb.mockapi.io/skills";

  Future<void> fetchSkills() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List parsedList = json.decode(response.body);
        setState(() {
          skills = parsedList.map((e) => Skill.fromJson(e)).toList();
          isLoading = false;
        });
        widget.onSkillsLoaded?.call(skills);
      } else {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSkills();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final levels = ["Basic", "Intermediate", "Advanced"];
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = screenWidth < 400 ? 160.0 : 200.0;

    return Scaffold(
      // AppBar with small slider on the top-right
      appBar: AppBar(
        backgroundColor:
            isDark ? Colors.grey.shade900.withOpacity(0.9) : Colors.transparent,
        elevation: 0,
        title: Text(
          'Skills',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // Small padded container so the slider fits in the AppBar
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 6.0, bottom: 6.0),
            child: SizedBox(
              height: 36,
              width: 110,
              child: SliderButton(
                width: 110,
                radius: 18,
                action: () async {
                  // Toggle theme globally
                  themeProvider.toggleTheme();

                  return false;
                },
                label: Text(
                  isDark ? "🌞" : "🌙",
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                icon: Icon(
                  isDark ? Icons.nightlight_round : Icons.wb_sunny,
                  color: isDark ? Colors.yellowAccent : Colors.white,
                  size: 18,
                ),
                backgroundColor:
                    isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                buttonColor: isDark ? Colors.tealAccent : Colors.blueAccent,
                baseColor: Colors.white,
                highlightedColor: isDark
                    ? Colors.tealAccent.withOpacity(0.25)
                    : Colors.blue.withOpacity(0.25),
              ),
            ),
          ),
        ],
      ),

      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [
                    Color(0xFF0f2027),
                    Color(0xFF203a43),
                    Color(0xFF2c5364),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFFa1c4fd),
                    Color(0xFFc2e9fb),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: isLoading
                    ? _buildShimmerList(screenWidth, cardHeight)
                    : isError
                        ? Center(
                            child: Text(
                              "Failed to load skills 😢",
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: levels.map((level) {
                                  final filteredSkills = skills
                                      .where((s) => s.level == level)
                                      .toList();

                                  return filteredSkills.isEmpty
                                      ? const SizedBox.shrink()
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenWidth * 0.05,
                                                ),
                                                child: Text(
                                                  level,
                                                  style: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.055,
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                height: cardHeight,
                                                child: ListView.separated(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.04,
                                                  ),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      filteredSkills.length,
                                                  separatorBuilder: (_, __) =>
                                                      const SizedBox(width: 12),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final skill =
                                                        filteredSkills[index];

                                                    return TweenAnimationBuilder(
                                                      tween: Tween<double>(
                                                          begin: 50, end: 0),
                                                      duration: Duration(
                                                          milliseconds: 400 +
                                                              (index * 150)),
                                                      curve: Curves.easeOut,
                                                      builder: (context, value,
                                                          child) {
                                                        return Opacity(
                                                          opacity: value == 0
                                                              ? 1
                                                              : 0.5,
                                                          child: Transform
                                                              .translate(
                                                            offset: Offset(
                                                                0, value),
                                                            child: child,
                                                          ),
                                                        );
                                                      },
                                                      child: SizedBox(
                                                        width:
                                                            screenWidth * 0.5,
                                                        child: SkillCard(
                                                            skill: skill),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                }).toList(),
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shimmer placeholder used while loading
  Widget _buildShimmerList(double screenWidth, double cardHeight) {
    return ListView.builder(
      itemCount: 3,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color.fromARGB(255, 228, 222, 222),
        highlightColor: const Color.fromARGB(255, 235, 228, 228),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          height: cardHeight,
          width: screenWidth * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
