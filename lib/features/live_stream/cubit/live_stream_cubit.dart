import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:live_streams_app/common/helpers/helpers.dart';
import 'package:live_streams_app/data/model/model.dart';
import 'package:live_streams_app/data/repositories/live_stream_repository.dart';

part 'live_stream_state.dart';

class LiveStreamCubit extends Cubit<LiveStreamState> {
  LiveStreamCubit(this._liveStreamRepository) : super(const LiveStreamState());
  final LiveStreamRepository _liveStreamRepository;

  void queryChannel() async {
    var channel = await _liveStreamRepository.getChannel();
    print(channel);
    emit(state.copyWith(channel: channel, progress: Progress.success));
  }

  void createChannel() async {
    await _liveStreamRepository.addChannel();
  }
}
