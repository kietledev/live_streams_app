import 'package:flutter/widgets.dart';
import 'package:live_streams_app/features/app/bloc/app_bloc.dart';
import 'package:live_streams_app/features/login/login.dart';
import 'package:live_streams_app/features/navigation_bar/view/navigation_bar_page.dart';
import 'package:live_streams_app/features/personal_informations/personal_informations.dart';
import 'package:live_streams_app/features/sign_up/view/sign_up_page.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [NavigationBarPage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
    default:
      return [LoginPage.page()];
  }
}
