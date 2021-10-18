import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_streams_app/common/helpers/custom_button.dart';
import 'package:live_streams_app/features/app/bloc/app_bloc.dart';
import 'package:live_streams_app/features/notification/notification.dart';
import 'package:live_streams_app/features/person/widgets/item_menu_listview.dart';
import 'package:live_streams_app/features/personal_informations/personal_informations.dart';

class PersonPage extends StatelessWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Person'),
        actions: <Widget>[
          IconButton(
              key: const Key('homePage_logout_iconButton'),
              icon: SvgPicture.asset(
                'assets/icons/ic_notification.svg',
                color: Colors.white,
              ),
              onPressed: () =>
                  Navigator.of(context).push<void>(NotificationsPage.route()))
        ],
      ),
      body: const PersonBody(),
    );
  }
}

class PersonBody extends StatefulWidget {
  const PersonBody({
    Key? key,
  }) : super(key: key);

  @override
  State<PersonBody> createState() => _PersonBodyState();
}

class _PersonBodyState extends State<PersonBody> {
  final List<ItemMenu> listItemsClassInformation = [
    ItemMenu(
        1, "Personal informations", "assets/icons/ic_personal_information.svg"),
    ItemMenu(2, "Change password", "assets/icons/ic_password.svg"),
    ItemMenu(3, "Settings", "assets/icons/ic_setting.svg"),
    ItemMenu(4, "Helps", "assets/icons/ic_helps.svg"),
  ];
  int currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: listItemsClassInformation.length,
              itemBuilder: (context, index) {
                final item = listItemsClassInformation[index];
                return ItemMenuListView(
                  index: index,
                  isSelected: currentIndex == index,
                  item: item,
                  onSelect: () {
                    setState(() => currentIndex = index);
                    if (index == 0) {
                      Navigator.of(context)
                          .push<void>(PersonalInformationsPage.route());
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('signUpForm_continue_raisedButton'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                primary: Colors.blue,
              ),
              onPressed: () =>
                  context.read<AppBloc>().add(AppLogoutRequested()),
              child: const Text('SIGN OUT'),
            ),
          ],
        ),
      ),
    );
  }
}
