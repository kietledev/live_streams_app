import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_streams_app/common/helpers/camera_utils.dart';

import 'bloc/camera_bloc.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);
  static Route<String> route() =>
      MaterialPageRoute<String>(builder: (_) => const CameraPage());

  @override
  _CameraPage2State createState() => _CameraPage2State();
}

class _CameraPage2State extends State<CameraPage> with WidgetsBindingObserver {
  final bloc = CameraBloc(cameraUtils: CameraUtils());
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (bloc.isInitialized()) return;

    if (state == AppLifecycleState.inactive) {
      bloc.add(CameraStopped());
    } else if (state == AppLifecycleState.paused) {
      bloc.add(CameraStopped());
    } else if (state == AppLifecycleState.resumed) {
      bloc.add(CameraInitialized());
    } else if (state == AppLifecycleState.detached) {
      // add event detache
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc..add(CameraInitialized()),
      child: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) {
          if (state is SendImageSuccess) {
            Navigator.of(context).pop(state.path);
          } else if (state is CameraCaptureFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(behavior: SnackBarBehavior.floating,content: Text(state.error)),
              );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: state is CameraReady
                ? buildCameraReady(context, state)
                : state is CameraFailure
                    ? Error(
                        key: const Key('__errorScreen__'), message: state.error)
                    : state is CameraCaptureSuccess
                        ? buildCaptureSuccess(state)
                        : const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Stack buildCameraReady(BuildContext context, CameraReady state) {
    return Stack(
      key: const Key('__cameraPreviewScreen__'),
      children: [
        CameraPreview(BlocProvider.of<CameraBloc>(context).getController()),
        Column(
          key: const Key('__buildColumTopActions__'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTopActions(context, state),
            const Spacer(),
            buildBottomAcctions()
          ],
        ),
      ],
    );
  }

  Widget buildTopActions(BuildContext context, CameraReady state) {
    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 12),
          customAction(
              press: () => Navigator.of(context).pop(''),
              icon: 'ic_cross.svg',
              size: 16),
          const Spacer(),
          customAction(
              press: () => bloc.add(CameraChange()),
              icon: 'ic_switch_camera.svg',
              size: 28),
          const SizedBox(width: 12),
          customAction(
              press: () => bloc.add(CameraShowFlash()),
              icon: state.isFlash ? 'ic_flash.svg' : 'ic_unflash.svg',
              size: 28),
          const Spacer(),
          const SizedBox(width: 32)
        ],
      ),
    );
  }

  Stack buildBottomAcctions() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24),
              customAction(press: () {}, icon: 'ic_picture_chat.svg', size: 40),
              const Spacer(),
              buildButtonTakeCamera(),
              const Spacer(),
              const SizedBox(width: 52)
            ],
          ),
        )
      ],
    );
  }

  InkWell buildButtonTakeCamera() {
    return InkWell(
      onTap: () => bloc.add(CameraCaptured()),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 5),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(75),
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
    );
  }

  Stack buildCaptureSuccess(CameraCaptureSuccess state) {
    return Stack(
      children: [
        Image.file(File(state.path), fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.only(top: 36, left: 12),
          child: customAction(
              press: () => bloc.add(CameraCapturedAgain()),
              icon: 'ic_back.svg',
              size: 22),
        ),
        sendImage(press: () {
          bloc.add(SendImage());
        }),
      ],
    );
  }

  Widget customAction(
      {required VoidCallback press, required String icon, double size = 40}) {
    String asset = 'assets/icons/$icon';
    return InkWell(
      onTap: press,
      child: SizedBox(
        child: SvgPicture.asset(asset, color: Colors.white),
        width: size,
        height: size,
      ),
    );
  }

  Widget sendImage({required VoidCallback press}) {
    return Align(
      alignment: Alignment.bottomRight,
      child: InkWell(
        onTap: press,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
            child: SvgPicture.asset(
              'assets/icons/ic_send_message.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class Error extends StatelessWidget {
  final String message;

  const Error({Key? key, this.message = "Camera Error"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Icon(Icons.error), Text(message)]),
    );
  }
}
