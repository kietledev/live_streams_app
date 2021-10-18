import 'package:formz/formz.dart';

enum FileValueValidationError { invalid }

class FileValue extends FormzInput<String, FileValueValidationError> {
  const FileValue.pure() : super.pure('');

  const FileValue.dirty([String value = '']) : super.dirty(value);

  @override
  FileValueValidationError? validator(String? value) {
    return value!.isNotEmpty ? null : FileValueValidationError.invalid;
  }
}
