import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/styles.dart';

class CubeCard extends StatelessWidget {
  final String title;
  final Image? image;
  final Function onTap;

  const CubeCard(
      {Key? key, required this.title, required this.onTap, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: screenWidth * 0.45,
        height: screenHeight * 0.10,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: DigicardStyles.backgroundColor, // Card background color
          border: Border.all(
            color: DigicardStyles.accentColor,
            width: 1, // Accent-colored border
          ),
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: DefaultTextStyle(
          style: GoogleFonts.orbitron(
            fontSize: 16,
            color: DigicardStyles.textColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (image != null)
                SizedBox(
                  width: 30,
                  height: 30,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                        DigicardStyles.accentColor, BlendMode.srcIn),
                    child: image,
                  ),
                ),
              const SizedBox(height: 15),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
