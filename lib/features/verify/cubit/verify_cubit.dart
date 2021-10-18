import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:live_streams_app/common/helpers/helpers.dart';
import 'package:live_streams_app/data/model/model.dart';
import 'package:live_streams_app/data/repositories/repositories.dart';

part 'verify_state.dart';

class VerifyCubit extends Cubit<VerifyState> {
  VerifyCubit(this._personRepository) : super(const VerifyState());

  final PersonRepository _personRepository;

  void queryPerson(String userId) async {
    var person = await _personRepository.getPerson(userId);
    emit(state.copyWith(person: person, progress: Progress.success));
    await getUrlImage(person.photo!);
  }

  Future<void> getUrlImage(String value) async {
    final url = await _personRepository.getUrlFile(value);

    final urlPhoto = FileValue.dirty(url);
    emit(state.copyWith(
      urlPhoto: urlPhoto,
    ));
  }

  void onApprove(String id) async {
    emit(state.copyWith(
      verifyStatus: VerifyStatus.loading,
    ));
    await _personRepository.updateVerify(id: id, verify: true);
    await _personRepository.sendFcm(
        id,
        'live_stream',
        'Approve personal information!',
        'The administrator has approved your information. You can start your live stream now',
        role: 1);
    emit(state.copyWith(
      verifyStatus: VerifyStatus.success,
    ));
  }

  void onReject(String id) async {
    emit(state.copyWith(
      verifyStatus: VerifyStatus.loading,
    ));
    await _personRepository.updateVerify(id: id, verify: false);
    await _personRepository.sendFcm(
        id,
        'personal_information',
        'Reject personal information!',
        'The administrator has rejected your request to update your information.',
        role: 1);
    emit(state.copyWith(
      verifyStatus: VerifyStatus.success,
    ));
  }
}
