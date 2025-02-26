import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../pages/contacts_page.dart";
import "../pages/home_page.dart";
import "../pages/qr_page.dart";
import "../providers/navigation_provider.dart";
import "../providers/qr_data_provider.dart";
import "../styles/styles.dart";
import "navigation/destination.dart";

class DefaultLayout extends StatefulWidget {
  const DefaultLayout({Key? key}) : super(key: key);

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  static const List<Destination> allDestinations = <Destination>[
    Destination(0, '/qr', DestinationInfo('QR', CupertinoIcons.qrcode)),
    Destination(1, '/', DestinationInfo('Home', CupertinoIcons.at)),
    Destination(
        2, '/contacts', DestinationInfo('Contacts', CupertinoIcons.person)),
  ];

  late final List<Widget> destinationViews;
  int _currentIndex = 1;
  bool _isSplashRoute = true;

  @override
  void initState() {
    super.initState();
    // Set up destination views
    destinationViews = allDestinations.map((Destination destination) {
      switch (destination.route) {
        case '/':
          return const HomePage();
        case '/qr':
          return const QRPage();
        case '/contacts':
          return const ProfilePage(); // Corrected to ContactsPage
        default:
          return const HomePage();
      }
    }).toList();

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isSplashRoute = false;
      });
    });
  }

  // Splash screen widget with circular progress
  Widget _buildSplashScreen() {
    return const Scaffold(
      backgroundColor: DigicardStyles.accentColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.qrcode,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Digital Card', // Replace with your app name
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30), // Space between text and progress
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                DigicardStyles.primaryColor, // Matches your theme
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Main layout widget
  Widget _buildMainLayout(BuildContext context) {
    NavigationProvider nav = Provider.of<NavigationProvider>(context);
    QRCodeData qrData = Provider.of<QRCodeData>(context);

    return Scaffold(
      backgroundColor: DigicardStyles.accentColor,
      body: PageView.builder(
        controller: nav.pageController,
        itemCount: allDestinations.length,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemBuilder: (context, index) {
          return destinationViews[index];
        },
      ),
      bottomNavigationBar: NavigationBar(
        height: 40,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorColor: Colors.transparent,
        backgroundColor: DigicardStyles.accentColor,
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          if (index == _currentIndex) return;
          setState(() => _currentIndex = index);
          nav.navigateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          qrData.reset();
        },
        destinations: allDestinations.map((Destination destination) {
          return NavigationDestination(
            icon: Icon(destination.info.icon,
                color: _currentIndex == destination.index
                    ? DigicardStyles.primaryColor
                    : Colors.grey[400]),
            label: destination.info.title,
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Render splash screen first, then main layout
    return _isSplashRoute ? _buildSplashScreen() : _buildMainLayout(context);
  }
}
