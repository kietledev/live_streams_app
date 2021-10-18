part of 'verify_cubit.dart';


@immutable
class VerifyState extends Equatable {
  const VerifyState(
      {this.person = Person.empty,
      this.progress = Progress.loading,
      this.urlPhoto = const FileValue.pure(),
      this.verifyStatus = VerifyStatus.initial});

  final Person person;
  final Progress progress;
  final FileValue urlPhoto;
  final VerifyStatus verifyStatus;

  @override
  List<Object> get props => [person, progress, urlPhoto, verifyStatus];

  VerifyState copyWith({
    Person? person,
    Progress? progress,
    FileValue? urlPhoto,
    VerifyStatus? verifyStatus,
  }) {
    return VerifyState(
        person: person ?? this.person,
        progress: progress ?? this.progress,
        urlPhoto: urlPhoto ?? this.urlPhoto,
        verifyStatus: verifyStatus ?? this.verifyStatus);
  }
}
