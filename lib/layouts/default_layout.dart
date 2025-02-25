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
    Destination(2, '/contacts',
        DestinationInfo('Contacts', CupertinoIcons.person_2_square_stack)),
  ];

  late final List<Widget> destinationViews;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    destinationViews = allDestinations.map((Destination destination) {
      switch (destination.route) {
        case '/':
          return const HomePage();
        case '/qr':
          return const QRPage();
        case '/contacts':
          return const ProfilePage();
        default:
          return const HomePage();
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    NavigationProvider nav = Provider.of<NavigationProvider>(context);
    QRCodeData qrData = Provider.of<QRCodeData>(context);

    return Scaffold(
      backgroundColor: DigicardStyles.accentColor, // Set dark background
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
}
