import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../pages/contacts_page.dart";
import "../pages/home_page.dart";
import "../pages/qr_page.dart";
import "../providers/navigation_provider.dart";
import "../providers/qr_data_provider.dart";
import "../styles/styles.dart";
import "../utils/ad_service.dart";
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

  final AdService adService = AdService();
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    // Load Banner Ad
    adService.loadGoogleBannerAd(() {
      setState(() {
        _isAdLoaded = true;
      });
    });

    // Load Interstitial Ad
    adService.loadInterstitialAd();

    // Wait for 3 seconds before trying to show the interstitial ad
    Future.delayed(const Duration(seconds: 3), () {
      adService.showInterstitialAd();
    });

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

    // Switch from splash to main layout after 5 seconds
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
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: nav.pageController,
              itemCount: allDestinations.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return destinationViews[index];
              },
            ),
          ),
          // Banner ad placed above the bottom navigation bar
          if (_isAdLoaded)
            Container(
              alignment: Alignment.center,
              child: adService.getGoogleBannerAd(),
            ),
          // Bottom navigation bar
          NavigationBar(
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Render splash screen first, then main layout
    return _isSplashRoute ? _buildSplashScreen() : _buildMainLayout(context);
  }
}
