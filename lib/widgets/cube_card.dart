import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/styles.dart';

class CubeCard extends StatelessWidget {
  final String title;
  final Image? image;
  final Function onTap;

  const CubeCard({
    Key? key,
    required this.title,
    required this.onTap,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Use constraints to determine available width and height
          double cardWidth = constraints.maxWidth < 150
              ? constraints.maxWidth * 0.45
              : 150.0; // Cap width or scale dynamically
          double cardHeight = constraints.maxHeight < 80
              ? constraints.maxHeight * 0.10
              : 80.0; // Cap height or scale dynamically

          return Container(
            width: cardWidth,
            height: cardHeight,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: DigicardStyles.backgroundColor,
              border: Border.all(
                color: DigicardStyles.accentColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DefaultTextStyle(
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: DigicardStyles.textColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (image != null)
                    SizedBox(
                      width: cardWidth * 0.2, // 20% of card width
                      height: cardHeight * 0.4, // 40% of card height
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          DigicardStyles.accentColor,
                          BlendMode.srcIn,
                        ),
                        child: image,
                      ),
                    ),
                  SizedBox(height: cardHeight * 0.15), // 15% of card height
                  Flexible(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
