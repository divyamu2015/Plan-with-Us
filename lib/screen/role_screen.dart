import 'package:flutter/material.dart';
import 'package:house_construction_pro/authantication/engineer_auth/eng_reg/eng_registration_page_view.dart';
import 'package:house_construction_pro/authantication/user_authentication/login_screen/login_view_page.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // cute pastel background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose Your Role',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat', // or any cute rounded font
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // User Button
                _RoleButton(
                  label: 'User',
                  icon: Icons.person,
                  color: Colors.blue[300]!,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                  cuteDecoration: true,
                ),
                SizedBox(width: 10),
                // Engineer Button
                _RoleButton(
                  label: 'Engineer',
                  icon: Icons.engineering,
                  color: Colors.purple[300]!,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EngineeringRegistrationPage();
                        },
                      ),
                    );
                    /* Handle Engineer */
                  },
                  cuteDecoration: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool cuteDecoration;

  const _RoleButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.cuteDecoration = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (cuteDecoration)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.star,
                  color: Colors.yellowAccent,
                  size: 18,
                ), // cute accent
              ),
          ],
        ),
      ),
    );
  }
}
