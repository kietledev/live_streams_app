import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streams_app/common/helpers/helpers.dart';
import 'package:live_streams_app/common/helpers/utils.dart';
import 'package:live_streams_app/data/repositories/repositories.dart';
import 'package:live_streams_app/features/live_stream/cubit/live_stream_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

import 'broadcast_page.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const LiveStreamPage());
  @override
  _LiveStreamPageState createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  // final _channelName = TextEditingController();
  String check = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LiveStreamCubit>(
      create: (_) => LiveStreamCubit(LiveStreamRepository())..queryChannel(),
      child: Scaffold(
          appBar: AppBar(title: const Text('Live stream')),
          resizeToAvoidBottomInset: true,
          body: Center(
            child: BlocBuilder<LiveStreamCubit, LiveStreamState>(
              buildWhen: (previous, current) =>
                  previous.channel != current.channel,
              builder: (context, state) {
                if (state.progress == Progress.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.progress == Progress.success) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: TextFormField(
                          enabled: false,
                          // controller: _channelName,
                          initialValue: 'live_stream_app',
                          decoration: InputDecoration(
                              labelText: 'Channel Name',
                              hintStyle: Utils.setStyle(color: Colors.black38)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          onJoin(
                              isBroadcaster: false,
                              appId: state.channel.channelId,
                              token: state.channel.token!);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Just Watch  ',
                                style: TextStyle(fontSize: 20)),
                            Icon(
                              Icons.remove_red_eye,
                            )
                          ],
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.pink,
                        ),
                        onPressed: () {
                          onJoin(
                              isBroadcaster: true,
                              appId: state.channel.channelId,
                              token: state.channel.token!);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Broadcast    ',
                                style: TextStyle(fontSize: 20)),
                            Icon(Icons.live_tv)
                          ],
                        ),
                      ),
                      Text(
                        check,
                        style: Utils.setStyle(color: Colors.red),
                      )
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          )),
    );
  }

  Future<void> onJoin(
      {required bool isBroadcaster,
      required String appId,
      required String token}) async {
    await [Permission.camera, Permission.microphone].request();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BroadcastPage(
          channelName: 'live_stream_app', //_channelName.text,
          isBroadcaster: isBroadcaster,
          appId: appId,
          token: token,
        ),
      ),
    );
  }
}
