import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../models/skills.dart';
import '../provider/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  final List<Skill> skills;
  const ProfileScreen({super.key, required this.skills});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Ashraf";
  String userRole = "Learner";
  String? profileImagePath;
  int completedCount = 0;
  double progress = 0.0;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProgress();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("username") ?? "John Doe";
      userRole = prefs.getString("userrole") ?? "Learner";
      profileImagePath = prefs.getString("profileImage");
    });
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedKeys = prefs.getKeys();
    final completed = savedKeys
        .where((k) => k.startsWith("completed_") && prefs.getBool(k) == true)
        .toList();
    final totalSkills = widget.skills.length;
    setState(() {
      completedCount = completed.length;
      progress = totalSkills == 0 ? 0.0 : completedCount / totalSkills;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("profileImage", pickedFile.path);
      setState(() {
        profileImagePath = pickedFile.path;
      });
    }
  }

  void _showImagePickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              children: [
                Center(
                  child: Text(
                    "Choose Profile Photo",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading:
                      const Icon(Icons.camera_alt, color: Colors.tealAccent),
                  title: const Text("Take a photo"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.photo_library, color: Colors.blueAccent),
                  title: const Text("Choose from gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.redAccent),
                  title: const Text("Remove photo"),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove("profileImage");
                    setState(() => profileImagePath = null);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editProfile(BuildContext context) async {
    final nameController = TextEditingController(text: userName);
    final roleController = TextEditingController(text: userRole);

    await showDialog(
      context: context,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Edit Profile",
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter name",
                  hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: isDark ? Colors.white54 : Colors.black26),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: roleController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter role",
                  hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: isDark ? Colors.white54 : Colors.black26),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel",
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString("username", nameController.text);
                await prefs.setString("userrole", roleController.text);
                setState(() {
                  userName = nameController.text;
                  userRole = roleController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryText = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 🧍‍♂️ Profile Avatar with Add Button
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.tealAccent.withOpacity(0.3),
                    backgroundImage: profileImagePath != null
                        ? FileImage(File(profileImagePath!))
                        : const AssetImage(
                            'assets/images/profile_placeholder.png',
                          ) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => _showImagePickerSheet(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.tealAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.black : Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 24,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              Text(
                userName,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                userRole,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 20),

              // 🌟 Stats Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                    icon: const Icon(AntDesign.trophy_fill,
                        color: Colors.amberAccent),
                    label: "Completed",
                    value: "$completedCount",
                    isDark: isDark,
                  ),
                  _buildStatCard(
                    icon: const Icon(Bootstrap.bar_chart_fill,
                        color: Colors.tealAccent),
                    label: "Progress",
                    value: "${(progress * 100).toStringAsFixed(0)}%",
                    isDark: isDark,
                  ),
                  _buildStatCard(
                    icon: const Icon(FontAwesome.crow_solid,
                        color: Colors.pinkAccent),
                    label: "Rank",
                    value: progress >= 0.8
                        ? "Pro"
                        : progress >= 0.5
                            ? "Skilled"
                            : "Beginner",
                    isDark: isDark,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ✏️ Edit Profile Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => _editProfile(context),
                icon: const Icon(AntDesign.edit_outline),
                label: Text(
                  "Edit Profile",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 30),

              // 🎬 Motivational Animation
              Lottie.asset(
                "assets/animated_image/Running Boy.json",
                height: 180,
                repeat: true,
              ),
              Text(
                "Keep moving forward 🚀",
                style: GoogleFonts.poppins(color: secondaryText, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required Widget icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          icon,
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
