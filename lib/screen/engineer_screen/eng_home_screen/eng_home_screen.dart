import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:house_construction_pro/authantication/user_authentication/login_screen/login_view_page.dart';
import 'package:house_construction_pro/screen/engineer_screen/eng_profile_management/eng_profile_manage_view.dart';
import 'package:house_construction_pro/screen/engineer_screen/engineer_pro_bio/engineer_bio.dart';

class ProjectBioPage extends StatefulWidget {
  const ProjectBioPage({super.key, required this.employeeId});
  final int employeeId;

  @override
  State<ProjectBioPage> createState() => _ProjectBioPageState();
}

class _ProjectBioPageState extends State<ProjectBioPage> {
  int _selectedIndex = 2;
  int? emploId;
  String title = "Mark";
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  final List<Widget> _pages = [
    Center(child: Text('Project Details', style: TextStyle(fontSize: 24))),
    Center(child: Text('Chart Sheet', style: TextStyle(fontSize: 24))),
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('View Comments', style: TextStyle(fontSize: 24))),
    Center(child: Text('Logout', style: TextStyle(fontSize: 24))),
  ];

  @override
  void initState() {
    super.initState();
    emploId = widget.employeeId;
  }

  void _onTap(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EngineerBio(engineerId: emploId!)),
      );
    } else if (index == 4) {
      _showLogoutDialog();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Do you want to Logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliderDrawer(
      key: _sliderDrawerKey,
      sliderOpenSize: 300.0,
      slideDirection: SlideDirection.leftToRight,
      sliderBoxShadow: SliderBoxShadow(
        blurRadius: 25,
        spreadRadius: 5,
        color: const Color.fromARGB(255, 94, 135, 168),
      ),
      appBar: SliderAppBar(
        config: SliderAppBarConfig(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
      ),

      slider: _buildSliderMenu(),
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.react,
          backgroundColor: Colors.deepPurple,
          activeColor: Colors.white,
          color: Colors.white70,
          items: const [
            TabItem(icon: Icons.policy_rounded, title: 'Bio'),
            TabItem(icon: Icons.bar_chart, title: 'Chart'),
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.comment, title: 'Comments'),
            TabItem(icon: Icons.logout, title: 'Logout'),
          ],
          initialActiveIndex: _selectedIndex,
          onTap: _onTap,
          elevation: 8,
          curveSize: 90,
          height: 60,
        ),
      ),
    );
  }

  Widget _buildSliderMenu() {
    return Material(
      // <-- Add Material here
      color: const Color(0xFF35774F), // your drawer background color
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // const Text(
                    //   'Hello User',
                    //   style: TextStyle(color: Colors.white, fontSize: 18),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildMenuItem(
                icon: Icons.person,
                title: 'Profile Management',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EngProfileManagementScreen(emploId: emploId!,),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.feedback_outlined,
                title: 'Feedback',
                onTap: () {
                  // implement feedback navigation
                },
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: _showLogoutDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
