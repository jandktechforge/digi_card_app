import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../providers/qr_data_provider.dart';
import '../styles/styles.dart';
import '../widgets/profile_header.dart';

class QRPage extends StatelessWidget {
  const QRPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const ProfileHeader(),
        Expanded(
          child: SingleChildScrollView(
            // Added to prevent overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 25),
                  child: Center(
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      height: screenWidth * 0.8,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: DigicardStyles.primaryColor,
                            width: 5,
                          ),
                        ),
                        child: Consumer<QRCodeData>(
                          builder: (context, qrCodeData, child) {
                            return QrImageView(
                              padding: const EdgeInsets.all(10),
                              backgroundColor: DigicardStyles.primaryColor,
                              data: qrCodeData.data,
                              version: QrVersions.auto,
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.circle,
                                color: CupertinoColors.white,
                              ),
                              eyeStyle: const QrEyeStyle(
                                color: CupertinoColors.white,
                                eyeShape: QrEyeShape.circle,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
