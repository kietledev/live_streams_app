import 'package:formz/formz.dart';

enum ValueValidationError { invalid }

class Value extends FormzInput<String, ValueValidationError> {
  const Value.pure() : super.pure('');

  const Value.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    '[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]',
  );

  @override
  ValueValidationError? validator(String? value) {
    return _emailRegExp.hasMatch(value ?? '')
        ? null
        : ValueValidationError.invalid;
  }
}

enum ValueDateValidationError { invalid }

class ValueDate extends FormzInput<String, ValueDateValidationError> {
  const ValueDate.pure() : super.pure('');

  const ValueDate.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    '[0-9]{2}/[0-9]{2}/[0-9]{4}',
  );

  @override
  ValueDateValidationError? validator(String? value) {
    return _emailRegExp.hasMatch(value ?? '')
        ? null
        : ValueDateValidationError.invalid;
  }
}



