import 'package:expense_app/main.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController webController = TextEditingController();

  @override
  void dispose() {
    emailController.clear();
    webController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFFBF00FF);
    const Color surface = Color(0xFF2D2D2D);
    const Color background = Color(0xFF080808);

    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔮 Title
              Text(
                "ACCOUNT",
                style: TextStyle(
                  color: primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(color: primary.withOpacity(0.8), blurRadius: 20),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 📧 Email Input
              Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: primary,
                  decoration: InputDecoration(
                    hintText: "Enter your username",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Icon(Icons.email, color: primary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),

                child: TextField(
                  controller: webController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: primary,
                  decoration: InputDecoration(
                    hintText: "Enter Website",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Icon(Icons.email, color: primary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🚀 Save Button
              GestureDetector(
                onTap: () async {
                  final email = emailController.text.trim();
                  final website = emailController.text.trim();
                  final id = supabase.auth.currentUser!.id;
                  print("Email: $email");

                  await supabase
                      .from('profiles')
                      .update({'username': email, 'website': website})
                      .eq('id', id);

                  dispose();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFBF00FF), Color(0xFF8A00CC)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🧬 Subtle footer
              Text(
                "CYBER PROFILE",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
