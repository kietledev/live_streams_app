import 'package:equatable/equatable.dart';

class Channel extends Equatable {
  const Channel({
    required this.channelId,
    this.token,
    this.channelName,
  });

  final String channelId;
  final String? token;
  final String? channelName;

  static const empty = Channel(channelId: '');

  bool get isEmpty => this == Channel.empty;

  bool get isNotEmpty => this != Channel.empty;

  @override
  List<Object?> get props => [
        channelId,
        token,
        channelName,
      ];

  factory Channel.fromJson(Map<String, dynamic> map) {
    return Channel(
      channelId: map['channelId'] as String? ?? "",
      token: map['token'] as String? ?? '',
      channelName: map['channelName'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "channelId": channelId,
        "token": token,
        "channelName": channelName,
      };
}
