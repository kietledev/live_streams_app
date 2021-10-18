import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_streams_app/common/helpers/enum.dart';
import 'package:live_streams_app/common/helpers/helpers.dart';
import 'package:live_streams_app/data/repositories/repositories.dart';
import 'package:live_streams_app/features/app/bloc/app_bloc.dart';
import 'package:live_streams_app/features/home/cubit/home_cubit.dart';
import 'package:live_streams_app/features/home/home.dart';
import 'package:live_streams_app/features/live_stream/live_stream.dart';
import 'package:live_streams_app/features/notification/view/notifications_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(PersonRepository())..queryPerson(user.id),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
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
        body: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) => previous.person != current.person,
          builder: (context, state) {
            if (state.progress == Progress.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.progress == Progress.success) {
              return Align(
                alignment: const Alignment(0, -1 / 3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Avatar(photo: null),
                    const SizedBox(height: 8),
                    state.person.firstName!.isEmpty
                        ? Text('${state.person.email}')
                        : Text(
                            '${state.person.firstName} ${state.person.lastName}',
                            style: textTheme.headline6),
                    const SizedBox(height: 8),
                    _buildStartLiveStream(state, context),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  ElevatedButton _buildStartLiveStream(HomeState state, BuildContext context) {
    return ElevatedButton(
      key: const Key('verifyForm_approve_raisedButton'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        primary: Colors.blueAccent,
      ),
      onPressed: () {
        if (state.person.role == 1) {
          Navigator.of(context).push<void>(LiveStreamPage.route());
        } else {
          if (state.person.verify!) {
            Navigator.of(context).push<void>(LiveStreamPage.route());
          } else {
            if (state.person.verifyRequest!) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                      content: Text(
                    'Your update has been rejected or is pending approval',
                    style: Utils.setStyle(color: Colors.white),
                  )),
                );
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                      content: Text(
                          'You need to submit your personal information before starting the livestream',
                          style: Utils.setStyle(color: Colors.white))),
                );
            }
          }
        }
      },
      child: const Text('Start your live stream'),
    );
  }
}
