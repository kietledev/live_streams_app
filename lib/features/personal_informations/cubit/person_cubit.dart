import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:live_streams_app/data/model/model.dart';
import 'package:live_streams_app/common/helpers/helpers.dart';
import 'package:live_streams_app/data/repositories/repositories.dart';

part 'person_state.dart';

class PersonCubit extends Cubit<PersonState> {
  PersonCubit(this._personRepository) : super(const PersonState());

  final PersonRepository _personRepository;

  void queryPerson(String userId) async {
    var person = await _personRepository.getPerson(userId);
    emit(state.copyWith(person: person, progress: Progress.success));

    firstNameChanged(person.firstName!);
    lastNameChanged(person.lastName!);
    birhtDayChanged(person.birthDay!);
    emailChanged(person.email!);
    addressChanged(person.address!);
    await getUrlImage(person.photo!);
  }

  void firstNameChanged(String value) {
    final firstName = Value.dirty(value);
    emit(state.copyWith(
      firstName: firstName,
      status: Formz.validate([
        firstName,
        state.lastName,
        state.email,
        state.birthDay,
        state.address,
        state.photo,
      ]),
    ));
  }

  void lastNameChanged(String value) {
    final lastName = Value.dirty(value);
    emit(state.copyWith(
      lastName: lastName,
      status: Formz.validate([
        lastName,
        state.firstName,
        state.email,
        state.birthDay,
        state.address,
        state.photo,
      ]),
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.firstName,
        state.lastName,
        state.birthDay,
        state.address,
        state.photo,
      ]),
    ));
  }

  void birhtDayChanged(String value) {
    final birhtDay = ValueDate.dirty(value);
    emit(state.copyWith(
      birthDay: birhtDay,
      status: Formz.validate([
        birhtDay,
        state.firstName,
        state.lastName,
        state.email,
        state.address,
        state.photo,
      ]),
    ));
  }

  void addressChanged(String value) {
    final address = Value.dirty(value);
    emit(state.copyWith(
      address: address,
      status: Formz.validate([
        address,
        state.firstName,
        state.lastName,
        state.email,
        state.birthDay,
        state.photo,
      ]),
    ));
  }

  void pathChange(String value) {
    final photo = FileValue.dirty(value);
    emit(state.copyWith(
      photo: photo,
      status: Formz.validate([
        state.address,
        state.firstName,
        state.lastName,
        state.email,
        state.birthDay,
        photo
      ]),
    ));
  }

  Future<void> getUrlImage(String value) async {
    if (value.isNotEmpty) {
      final url = await _personRepository.getUrlFile(value);

      final photo = FileValue.dirty(url);
      emit(state.copyWith(
        photo: photo,
        status: Formz.validate([
          state.address,
          state.firstName,
          state.lastName,
          state.email,
          state.birthDay,
          photo
        ]),
      ));
    }
  }

  Future<void> personFormSubmitted(String id) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final url = await _personRepository.getUrlFile(state.person.photo!);
      final String photo;
      if (state.photo.value == url) {
        photo = '';
      } else {
        photo = id + now.toString();
        await _personRepository.uploadFile(photo, state.photo.value);
      }

      if (state.person.role == 0) {
        await _personRepository.updatePerson(
          id: id,
          firstName: state.firstName.value,
          lastName: state.lastName.value,
          birthDay: state.birthDay.value,
          address: state.address.value,
          photo: photo,
          verify: false,
          verifyRequest: true,
        );
        await _personRepository.sendFcm(id, 'verify', 'Submit information!',
            '${state.firstName.value} ${state.lastName.value} updated their personal information');
      } else if (state.person.role == 1) {
        await _personRepository.updatePerson(
          id: id,
          firstName: state.firstName.value,
          lastName: state.lastName.value,
          birthDay: state.birthDay.value,
          address: state.address.value,
          photo: photo,
          verify: true,
          verifyRequest: true,
        );
      }

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
