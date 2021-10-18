import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:live_streams_app/common/helpers/helpers.dart';
import 'package:live_streams_app/data/model/model.dart';
import 'package:live_streams_app/data/repositories/repositories.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._personRepository) : super(const HomeState());
  final PersonRepository _personRepository;

  void queryPerson(String userId) async {
    var person = await _personRepository.getPerson(userId);
    emit(state.copyWith(person: person, progress: Progress.success));
  }
}
