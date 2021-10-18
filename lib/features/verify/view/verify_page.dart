import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streams_app/common/helpers/helpers.dart';
import 'package:live_streams_app/data/repositories/repositories.dart';
import 'package:live_streams_app/features/verify/verify.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({Key? key, required this.userId}) : super(key: key);
  final String userId;
  static Route route(String userId) => MaterialPageRoute<void>(
      builder: (_) => VerifyPage(
            userId: userId,
          ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify information')),
      body: BlocProvider<VerifyCubit>(
        create: (_) => VerifyCubit(PersonRepository())..queryPerson(userId),
        child: VerifyBody(
          userId: userId,
        ),
      ),
    );
  }
}

class VerifyBody extends StatelessWidget {
  VerifyBody({Key? key, required this.userId}) : super(key: key);
  final String userId;

  final style = Utils.setStyle(color: Colors.black);
  final hintStyle = Utils.setStyle(color: Colors.black38);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyCubit, VerifyState>(
      buildWhen: (previous, current) => previous.person != current.person,
      listener: (context, state) {
        if (state.verifyStatus == VerifyStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Submission Successful')),
            );
          Timer(const Duration(seconds: 1), () => Navigator.of(context).pop());
        }
      },
      builder: (context, state) {
        if (state.progress == Progress.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.progress == Progress.success) {
          final person = state.person;
          return SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child:
                          buildTextFormValue(person.firstName!, 'First name'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                        flex: 1,
                        child:
                            buildTextFormValue(person.lastName!, 'Last name'))
                  ],
                ),
                const SizedBox(height: 8),
                buildTextFormValue(person.birthDay!, 'Birth day'),
                const SizedBox(height: 8),
                buildTextFormValue(person.email!, 'Email'),
                const SizedBox(height: 8),
                buildTextFormValue(person.address!, 'Address'),
                Text('Identity Card or Driving license',
                    style: Utils.setStyle()),
                const ImageFile(),
                BlocBuilder<VerifyCubit, VerifyState>(
                  buildWhen: (previous, current) =>
                      previous.verifyStatus != current.verifyStatus,
                  builder: (context, state) {
                    if (state.verifyStatus == VerifyStatus.initial) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                key:
                                    const Key('verifyForm_reject_raisedButton'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  primary: Colors.orange,
                                ),
                                onPressed: () => context
                                    .read<VerifyCubit>()
                                    .onReject(userId),
                                child: const Text(' REJECT '),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                key: const Key(
                                    'verifyForm_approve_raisedButton'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  primary: Colors.blue,
                                ),
                                onPressed: () => context
                                    .read<VerifyCubit>()
                                    .onApprove(userId),
                                child: const Text('APPROVE'),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state.verifyStatus == VerifyStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  TextFormField buildTextFormValue(String value, String label) {
    return TextFormField(
      style: style,
      enabled: false,
      initialValue: value,
      key: UniqueKey(),
      decoration: InputDecoration(
          labelText: label, helperText: '', hintStyle: hintStyle),
    );
  }
}

class ImageFile extends StatelessWidget {
  const ImageFile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 24),
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
      child: BlocBuilder<VerifyCubit, VerifyState>(
        builder: (context, state) {
          return state.urlPhoto.value.isEmpty
              ? const Center(child: Text('No photo ID card or driving license'))
              : state.urlPhoto.value.isNotEmpty
                  ? Image.network(state.urlPhoto.value, fit: BoxFit.contain)
                  : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
