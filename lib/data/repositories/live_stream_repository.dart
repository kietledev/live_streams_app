import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_streams_app/data/model/channel.dart';

class LiveStreamRepository {
  LiveStreamRepository({
    CollectionReference? channel,
  }) : _channel = channel ?? FirebaseFirestore.instance.collection('channel');
  final CollectionReference? _channel;

  Future<Channel> getChannel() async {
    try {
      var result = await _channel!.get();
      if (result.docs.isNotEmpty && result.docs[0].data() != null) {
        return Channel.fromJson(result.docs[0].data() as Map<String, dynamic>);
      } else {
        return Channel.empty;
      }
    } on Exception catch (_) {
      return Channel.empty;
    }
  }

  Future<void> addChannel() async {
    await _channel!.add({
      'channelId': '0a19ac4b30984f538eaf9cb83738a869',
      'token':
          '0060a19ac4b30984f538eaf9cb83738a869IADAL94DQkxQzrln/BpPYn6kPjreysh7wGYbUnru4ehKDO2OtDMAAAAAEADjpwysY45tYQEAAQBjjm1h',
      'channelName': 'live_stream_app',
    });
  }
}
