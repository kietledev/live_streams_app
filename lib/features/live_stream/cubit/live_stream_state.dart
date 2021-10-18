part of 'live_stream_cubit.dart';

class LiveStreamState extends Equatable {
  const LiveStreamState(
      {this.channel = Channel.empty, this.progress = Progress.loading});
  final Channel channel;
  final Progress progress;

  LiveStreamState copyWith({
    Channel? channel,
    Progress? progress,
  }) {
    return LiveStreamState(
        channel: channel ?? this.channel, progress: progress ?? this.progress);
  }

  @override
  List<Object> get props => [channel, progress];
}
