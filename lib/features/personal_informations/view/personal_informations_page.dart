import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:live_streams_app/common/helpers/helpers.dart';
import 'package:live_streams_app/data/repositories/repositories.dart';
import 'package:live_streams_app/features/app/bloc/app_bloc.dart';
import 'package:live_streams_app/features/camera/camera_page.dart';
import 'package:live_streams_app/features/personal_informations/personal_informations.dart';

final style = Utils.setStyle(color: Colors.black);
final hintStyle = Utils.setStyle(color: Colors.black38);

class PersonalInformationsPage extends StatelessWidget {
  const PersonalInformationsPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const PersonalInformationsPage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(title: const Text('Personal infomation')),
      body: BlocProvider<PersonCubit>(
        create: (_) => PersonCubit(PersonRepository())..queryPerson(user.id),
        child: const PersonalInformationForm(),
      ),
    );
  }
}

class PersonalInformationForm extends StatelessWidget {
  const PersonalInformationForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PersonCubit, PersonState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Submission Successful')),
            );
          Timer(const Duration(seconds: 1), () => Navigator.of(context).pop());
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(state.errorMessage)),
            );
        }
      },
      builder: (context, state) {
        if (state.progress == Progress.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.progress == Progress.success) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(flex: 1, child: _FirstNameInput()),
                      const SizedBox(width: 8),
                      Expanded(flex: 1, child: _LastNameInput())
                    ],
                  ),
                  const SizedBox(height: 8),
                  _BirthDayInput(),
                  const SizedBox(height: 8),
                  _EmailInput(),
                  const SizedBox(height: 8),
                  _AddressInput(),
                  Text('Identity Card or Driving license',
                      style: Utils.setStyle()),
                  const ImageFile(),
                  _SubmitButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class ImageFile extends StatelessWidget {
  const ImageFile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonCubit, PersonState>(
      buildWhen: (previous, current) => previous.photo != current.photo,
      builder: (context, state) {
        return InkWell(
          onTap: () => Navigator.of(context)
              .push<String>(CameraPage.route())
              .then((photo) => photo!.isNotEmpty
                  ? context.read<PersonCubit>().pathChange(photo)
                  : null),
          child: Container(
            margin:
                const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 24),
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFFE4E5EA),
              border: Border.all(
                color: const Color(0xFFDEDEE7),
                width: 4.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: state.photo.value.isEmpty
                ? const Center(
                    child: Text('No photo ID card or driving license'))
                : state.photo.value.isNotEmpty
                    ? LoadImageFile(path: state.photo.value)
                    : const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

class LoadImageFile extends StatelessWidget {
  const LoadImageFile({
    Key? key,
    required this.path,
  }) : super(key: key);
  final String path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: File(path).existsSync()
            ? Image.file(
                File(path),
                fit: BoxFit.contain,
              )
            : Image.network(path, fit: BoxFit.contain));
  }
}

class _FirstNameInput extends StatelessWidget {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonCubit, PersonState>(
      buildWhen: (previous, current) =>
          previous.firstName.value != current.firstName.value,
      builder: (context, state) {
        controller.text = state.firstName.value;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
        return TextField(
          key: const Key('personForm_firstNameInput_textField'),
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (firstName) =>
              context.read<PersonCubit>().firstNameChanged(firstName),
          keyboardType: TextInputType.streetAddress,
          style: style,
          decoration: InputDecoration(
              labelText: 'First name',
              helperText: '',
              errorText: state.firstName.invalid
                  ? 'First name must not be empty'
                  : null,
              hintStyle: hintStyle),
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonCubit, PersonState>(
      buildWhen: (previous, current) =>
          previous.lastName.value != current.lastName.value,
      builder: (context, state) {
        controller.text = state.lastName.value;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
        return TextField(
          key: const Key('personForm_lastNameInput_textField'),
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (lastName) =>
              context.read<PersonCubit>().lastNameChanged(lastName),
          keyboardType: TextInputType.streetAddress,
          style: style,
          decoration: InputDecoration(
              labelText: 'Last name',
              helperText: '',
              errorText: state.lastName.invalid
                  ? 'First name must not be empty'
                  : null,
              hintStyle: hintStyle),
        );
      },
    );
  }
}

class _BirthDayInput extends StatelessWidget {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonCubit, PersonState>(
      buildWhen: (previous, current) =>
          previous.birthDay.value != current.birthDay.value,
      builder: (context, state) {
        controller.text = state.birthDay.value;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
        return TextField(
          key: const Key('personForm_birthDayInput_textField'),
          controller: controller,
          onChanged: (birthDay) =>
              context.read<PersonCubit>().birhtDayChanged(birthDay),
          keyboardType: TextInputType.datetime,
          style: style,
          decoration: InputDecoration(
              labelText: 'Birth Day',
              helperText: '',
              errorText: state.birthDay.invalid ? 'Invalid birthDay' : null,
              hintStyle: hintStyle),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonCubit, PersonState>(
      buildWhen: (previous, current) =>
          previous.email.value != current.email.value,
      builder: (context, state) {
        controller.text = state.email.value;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
        return TextField(
          key: const Key('personForm_emailInput_textField'),
          controller: controller,
          onChanged: (email) => context.read<PersonCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          style: style,
          decoration: InputDecoration(
              labelText: 'Email',
              helperText: '',
              errorText: state.email.invalid ? 'Invalid email' : null,
              hintStyle: hintStyle),
        );
      },
    );
  }
}

class _AddressInput extends StatelessWidget {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonCubit, PersonState>(
      buildWhen: (previous, current) =>
          previous.address.value != current.address.value,
      builder: (context, state) {
        controller.text = state.address.value;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
        return TextField(
          key: const Key('personForm_addressInput_textField'),
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (address) =>
              context.read<PersonCubit>().addressChanged(address),
          keyboardType: TextInputType.streetAddress,
          style: style,
          decoration: InputDecoration(
              labelText: 'Address',
              helperText: '',
              errorText: state.address.invalid ? 'Invalid address' : null,
              hintStyle: hintStyle),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocBuilder<PersonCubit, PersonState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Center(
          child: state.status.isSubmissionInProgress
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  key: const Key('submitForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    primary: Colors.blue,
                  ),
                  onPressed: state.status.isValidated
                      ? () => context
                          .read<PersonCubit>()
                          .personFormSubmitted(user.id)
                      : null,
                  child: const Text('SUBMIT'),
                ),
        );
      },
    );
  }
}
