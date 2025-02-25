import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import '../providers/qr_data_provider.dart';
import '../styles/styles.dart';
import '../utils/messageLaunchers.dart';

class ResourceMeta {
  final String name;
  final IconData icon;
  final String link;

  const ResourceMeta(
      {required this.name, required this.icon, required this.link});
}

class ListCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final ResourceMeta resource;
  final String? customMessage;

  const ListCard(
      {Key? key,
      required this.title,
      required this.icon,
      required this.resource,
      this.customMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qrData = context.read<QRCodeData>();
    NavigationProvider nav = Provider.of<NavigationProvider>(context);

    String formattedMessage =
        "Hi! This is Will Binette from the NYC Startup Xmas Party.\nHere's my ${resource.name}: ${resource.link}";
    if (customMessage != null) {
      formattedMessage = "$customMessage ${resource.link}";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: DigicardStyles.backgroundColor, // Background color
        border: Border.all(
          color: DigicardStyles.accentColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: DefaultTextStyle(
        style: GoogleFonts.orbitron(
          fontSize: 18,
          color: DigicardStyles.accentColor,
        ),
        child: Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    FaIcon(icon, color: DigicardStyles.accentColor, size: 20),
                    const SizedBox(width: 30),
                    Text(
                      title,
                      style: const TextStyle(color: DigicardStyles.textColor),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async => {
                        MessageLauncher.launchMessage(
                            "sms:?body=$formattedMessage")
                      },
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            DigicardStyles.accentColor, BlendMode.srcIn),
                        child: Image.asset(
                          'assets/images/whatsapp.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        qrData.setData(resource.link);
                        qrData.setResource(resource.name, resource.icon);
                        nav.navigateToPage(0);
                      },
                      child: const Center(
                        child: Icon(CupertinoIcons.qrcode,
                            color: DigicardStyles.accentColor, size: 30),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
