import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apali_pmpl/PassScreen.dart'; // ✅ correct import (your PassScreen file)

void main() {
  runApp(const PMMPLApp());
}

class PMMPLApp extends StatelessWidget {
  const PMMPLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PMPML',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/pmpl_logo.png.webp', fit: BoxFit.contain),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF090909),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Color(0xFF0B0B0B),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4F5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'कुठे जायचं आहे?',
                    hintStyle: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF4A9BA7)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // ⚡ Quick Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickButton(
                    icon: Icons.receipt,
                    label: 'Bus Ticket',
                    backgroundColor: const Color(0xFFE8F4F5),
                  ),
                  _buildQuickButton(
                    icon: FontAwesomeIcons.calendarDays,
                    label: 'Daily Pass',
                    backgroundColor: const Color(0xFFE8F4F5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🧭 Feature Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFeatureButton(
                    icon: Icons.airplane_ticket_outlined,
                    label: 'View Ticket',
                    iconColor: Colors.black,
                  ),
                  _buildFeatureButton(
                    icon: Icons.card_giftcard,
                    label: 'View Pass',
                    iconColor: Colors.black,
                    onTap: () {
                      // ✅ Navigate to ticket/pass screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PassScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    icon: FontAwesomeIcons.route,
                    label: 'Route\nTimetable',
                    iconColor: Colors.black,
                  ),
                  _buildFeatureButton(
                    icon: FontAwesomeIcons.train,
                    label: 'Metro\nTicket',
                    iconColor: Colors.black,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 📍 Near Me Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Near Me',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Show all',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4A9BA7),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 🗺️ Google Maps Placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text(
                      'Google Maps Integration',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ⚙️ Footer
            Center(
              child: Text(
                'Powered by Chartr for PMPML',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Nearby',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.train_outlined),
            label: 'Metro',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.black, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FaIcon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
