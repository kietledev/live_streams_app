import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:live_streams_app/common/helpers/camera_utils.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraUtils cameraUtils;
  final ResolutionPreset resolutionPreset;
  CameraLensDirection cameraLensDirection;
  bool isBack = true;
  bool isFlash = false;
  late String path;
  late CameraController _controller;

  CameraBloc({
    required this.cameraUtils,
    this.resolutionPreset = ResolutionPreset.veryHigh,
    this.cameraLensDirection = CameraLensDirection.back,
  }) : super(CameraInitial());

  CameraController getController() => _controller;

  bool isInitialized() => _controller.value.isInitialized;

  @override
  Stream<CameraState> mapEventToState(
    CameraEvent event,
  ) async* {
    if (event is CameraInitialized) {
      yield* _mapCameraInitializedToState(event);
    } else if (event is CameraCaptured) {
      yield* _mapCameraCapturedToState(event);
    } else if (event is CameraStopped) {
      yield* _mapCameraStoppedToState(event);
    } else if (event is CameraCapturedAgain) {
      yield* _mapCameraCapturedAgainToState(event);
    } else if (event is CameraChange) {
      yield* _mapChangeCameraToState(event);
    } else if (event is CameraShowFlash) {
      yield* _mapCameraShowFlashToState(event);
    } else if (event is SendImage) {
      yield* _mapSendImageToState(event);
    }
  }

  Stream<CameraState> _mapCameraInitializedToState(
      CameraInitialized event) async* {
    try {
      _controller = await cameraUtils.getCameraController(
          resolutionPreset, cameraLensDirection);
      await _controller.initialize();
      _controller.setFlashMode(FlashMode.off);
      yield CameraReady(isFlash);
    } on CameraException catch (error) {
      _controller.dispose();
      yield CameraFailure(error: error.description!);
    } catch (error) {
      yield CameraFailure(error: error.toString());
    }
  }

  Stream<CameraState> _mapCameraCapturedAgainToState(
      CameraCapturedAgain event) async* {
    try {
      yield CameraReady(isFlash);
    } on CameraException catch (error) {
      _controller.dispose();
      yield CameraFailure(error: error.description!);
    } catch (error) {
      yield CameraFailure(error: error.toString());
    }
  }

  Stream<CameraState> _mapCameraCapturedToState(CameraCaptured event) async* {
    if (state is CameraReady) {
      yield CameraCaptureInProgress();
      try {
        final image = await _controller.takePicture();
        path = image.path;
        yield CameraCaptureSuccess(path);
      } on CameraException catch (error) {
        yield CameraCaptureFailure(error: error.description!);
      }
    }
  }

  Stream<CameraState> _mapChangeCameraToState(CameraChange event) async* {
    if (isBack) {
      cameraLensDirection = CameraLensDirection.front;
      isBack = false;
    } else {
      cameraLensDirection = CameraLensDirection.back;
      isBack = true;
    }

    try {
      _controller = await cameraUtils.getCameraController(
        resolutionPreset,
        cameraLensDirection,
      );
      await _controller.initialize();
      if (isFlash) {
        _controller.setFlashMode(FlashMode.always);
      } else {
        _controller.setFlashMode(FlashMode.off);
      }
      yield CameraInitial();
      yield CameraReady(isFlash);
    } on CameraException catch (error) {
      _controller.dispose();
      yield CameraFailure(error: error.description!);
    } catch (error) {
      yield CameraFailure(error: error.toString());
    }
  }

  Stream<CameraState> _mapCameraShowFlashToState(CameraShowFlash event) async* {
    if (isFlash) {
      _controller.setFlashMode(FlashMode.off);
      isFlash = false;
    } else {
      _controller.setFlashMode(FlashMode.always);
      isFlash = true;
    }
    yield CameraInitial();
    yield CameraReady(isFlash);
  }

  Stream<CameraState> _mapSendImageToState(SendImage event) async* {
    if (path.isNotEmpty) {
      yield SendImageSuccess(path);
    } else {
      try {
        yield CameraReady(isFlash);
      } on CameraException catch (error) {
        _controller.dispose();
        yield CameraFailure(error: error.description!);
      } catch (error) {
        yield CameraFailure(error: error.toString());
      }
    }
  }

  Stream<CameraState> _mapCameraStoppedToState(CameraStopped event) async* {
    _controller.dispose();
    yield CameraInitial();
  }

  @override
  Future<void> close() {
    _controller.dispose();
    return super.close();
  }
}
