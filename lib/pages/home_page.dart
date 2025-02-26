import 'package:digi_card/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/ad_service.dart';
import '../utils/messageLaunchers.dart';
import '../widgets/cube_card.dart';
import '../widgets/list_card.dart';
import '../widgets/profile_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdService adService = AdService();

    return Scaffold(
      backgroundColor: DigicardStyles.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ProfileHeader(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CubeCard(
                        title: "Whatsapp",
                        image: Image.asset('assets/images/whatsapp.png'),
                        onTap: () async => MessageLauncher.launchMessage(
                          "sms:?body=Hi! This is Will Binette. We met at the NYC Startup Xmas Party. I'd love to connect with you! Here's my info below: \n\nWilliam Binette\nFull-Stack Software Engineer | Technical Project Manager\nEmail: wsebinette@gmail.com\Phone: 505-917-7900\nLinkedIn: https://www.linkedin.com/in/wsbinette/\nGithub: https://www.github.com/wsbinette/",
                        ),
                      ),
                      CubeCard(
                        title: "Email",
                        image: Image.asset('assets/images/mail.png'),
                        onTap: () async => MessageLauncher.launchMessage(
                          "mailto:?subject=Will Binette from Startup Xmas Party&body=Hi! This is Will Binette. We met at the Startup Xmas Party. I'd love to connect with you! Here's my info below: \n\nWilliam Binette\nFull-Stack Software Engineer | Technical Project Manager\nEmail: wsebinette@gmail.com\Phone: 505-917-7900\nLinkedIn: https://www.linkedin.com/in/wsbinette/\nGithub: https://www.github.com/wsbinette/",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const ListCard(
                    title: "LinkedIn",
                    icon: FontAwesomeIcons.linkedin,
                    resource: ResourceMeta(
                      name: "LinkedIn",
                      icon: FontAwesomeIcons.linkedin,
                      link: "https://www.linkedin.com/in/wsbinette/",
                    ),
                  ),
                  const SizedBox(height: 15),
                  const ListCard(
                    title: "Github",
                    icon: FontAwesomeIcons.github,
                    resource: ResourceMeta(
                      name: "Github",
                      icon: FontAwesomeIcons.github,
                      link: "https://www.github.com/wsbinette/",
                    ),
                  ),
                  const SizedBox(height: 15),
                  const ListCard(
                    title: "Resume",
                    icon: CupertinoIcons.link,
                    resource: ResourceMeta(
                      name: "Resume",
                      icon: CupertinoIcons.cloud_download,
                      link: "https://wsbinette.github.io/downloads/",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
