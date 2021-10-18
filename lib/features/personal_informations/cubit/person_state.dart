part of 'person_cubit.dart';

@immutable
class PersonState extends Equatable {
  const PersonState({
    this.person = Person.empty,
    this.progress = Progress.loading,
    this.firstName = const Value.pure(),
    this.lastName = const Value.pure(),
    this.birthDay = const ValueDate.pure(),
    this.email = const Email.pure(),
    this.address = const Value.pure(),
    this.status = FormzStatus.pure,
    this.photo = const FileValue.pure(),
    this.errorMessage = 'Submit Failure',
  });

  final Person person;
  final Progress progress;
  final Value firstName;
  final Value lastName;
  final ValueDate birthDay;
  final Email email;
  final Value address;
  final FormzStatus status;
  final FileValue photo;
  final String errorMessage;

  @override
  List<Object> get props => [
        person,
        progress,
        firstName,
        lastName,
        birthDay,
        email,
        address,
        status,
        photo,
        errorMessage
      ];

  PersonState copyWith({
    Person? person,
    Progress? progress,
    Value? firstName,
    Value? middleName,
    Value? lastName,
    ValueDate? birthDay,
    Email? email,
    Value? address,
    FormzStatus? status,
    FileValue? photo,
    String? errorMessage,
  }) {
    return PersonState(
        person: person ?? this.person,
        progress: progress ?? this.progress,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        birthDay: birthDay ?? this.birthDay,
        email: email ?? this.email,
        address: address ?? this.address,
        status: status ?? this.status,
        photo: photo ?? this.photo,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
