part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState(
      {this.person = Person.empty, this.progress = Progress.loading});
  final Person person;
  final Progress progress;

  HomeState copyWith({
    Person? person,
    Progress? progress,
  }) {
    return HomeState(
        person: person ?? this.person, progress: progress ?? this.progress);
  }

  @override
  List<Object> get props => [person, progress];
}
