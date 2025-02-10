import 'package:flutter/material.dart';
import 'package:powergen_edu/src/features/modules/modules_page.dart';
import '../progress/progress_page.dart';
import '../profile/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Customer name and profile row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hai, Jhon',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 24,
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Progress indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress Kamu 50% :',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 10,
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.deepOrange[500]!,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Menu Grid with 4 buttons
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildMenuButton(
                    icon: Icons.play_circle_outline,
                    label: 'Start Module',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ModulesPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuButton(
                    icon: Icons.note_alt_outlined,
                    label: 'Note',
                    onTap: () {},
                  ),
                  _buildMenuButton(
                    icon: Icons.assignment_outlined,
                    label: 'Evaluation',
                    onTap: () {},
                  ),
                  _buildMenuButton(
                    icon: Icons.architecture_outlined,
                    label: 'Practical Project',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              // Home - already on home page
              break;
            case 1:
              // Progress
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProgressPage(),
                ),
              );
              break;
            case 2:
              // Profile
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
              break;
          }
        },
        currentIndex: 0,
        selectedItemColor: Colors.deepOrange[300],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            label: 'Progres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.deepOrange[50],
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.deepOrange[300],
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.deepOrange[300],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
