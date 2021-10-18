import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_streams_app/common/helpers/constants.dart';
import 'package:live_streams_app/features/home/home.dart';
import 'package:live_streams_app/features/live_stream/live_stream.dart';
import 'package:live_streams_app/features/person/person.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:live_streams_app/features/personal_informations/personal_informations.dart';
import 'package:live_streams_app/features/verify/view/verify_page.dart';
import 'package:live_streams_app/services/local_notification_service.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);
  static Page page() => const MaterialPage<void>(child: NavigationBarPage());

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _currentIndex = 0;
  final _pageController = PageController();

  final home = const HomePage();
  final person = const PersonPage();

  final itemHome = BottomNavigationBarItem(
      label: 'Home',
      icon: SvgPicture.asset('assets/icons/ic_home.svg',
          color: ColorConstants.primaryColor3),
      activeIcon: SvgPicture.asset('assets/icons/ic_home.svg',
          color: ColorConstants.brandColor));
  final itemPerson = BottomNavigationBarItem(
      label: 'Person',
      icon: SvgPicture.asset('assets/icons/ic_profile.svg',
          color: ColorConstants.primaryColor3),
      activeIcon: SvgPicture.asset('assets/icons/ic_profile.svg',
          color: ColorConstants.brandColor));

  @override
  void initState() {
    super.initState();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.getInitialMessage();

    messaging.getToken().then((value) {
      String? token = value;
      print("Instance ID: $token");
    });

    //Forground
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });

    //When the app is in background but opened and users taps
    //on the nofitication
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data['route'];
      if (routeFromMessage == 'verify') {
        final id = message.data['id'];
        Navigator.of(context).push<void>(VerifyPage.route(id));
      } else if (routeFromMessage == 'live_stream') {
        Navigator.of(context).push<void>(LiveStreamPage.route());
      } else if (routeFromMessage == 'personal_information') {
        Navigator.of(context).push<void>(PersonalInformationsPage.route());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (int index) {
            setState(() => _currentIndex = index);
          },
          physics: const NeverScrollableScrollPhysics(),
          children: [home, person],
        ),
        bottomNavigationBar: buildBottomNavigationBar(context));
  }

  Theme buildBottomNavigationBar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        iconSize: 20,
        elevation: 0.0,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontFamily: notoSans),
        unselectedLabelStyle:
            const TextStyle(fontSize: 12, fontFamily: notoSans),
        selectedItemColor: ColorConstants.brandColor,
        unselectedItemColor: ColorConstants.primaryColor3,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: [itemHome, itemPerson],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
