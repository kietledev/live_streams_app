class ResponseModel {
  int multicastId;
  int success;
  int failure;
  int canonicalIds;
  List<Results> results;

  ResponseModel(
      {required this.multicastId,
      required this.success,
      required this.failure,
      required this.canonicalIds,
      required this.results});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
        multicastId: json['multicast_id'],
        success: json['success'],
        failure: json['failure'],
        canonicalIds: json['canonical_ids'],
        results: json['results']
            .map((Map<String, dynamic> value) => Results.fromJson(value))
            .toList());
  }
}

class Results {
  String messageId;

  Results({required this.messageId});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(messageId: json['message_id'] as String? ?? '');
  }
}
