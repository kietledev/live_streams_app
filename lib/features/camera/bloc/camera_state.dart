part of 'camera_bloc.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

class CameraInitial extends CameraState {}

class CameraReady extends CameraState {
  final bool isFlash;

  CameraReady(this.isFlash);
}

class CameraFailure extends CameraState {
  final String error;

  const CameraFailure({this.error = "CameraFailure"});

  @override
  List<Object> get props => [error];
}

class CameraCaptureInProgress extends CameraState {}

class CameraCaptureSuccess extends CameraState {
  final String path;

  const CameraCaptureSuccess(this.path);
}

class CameraCaptureFailure extends CameraReady {
  final String error;

  CameraCaptureFailure({this.error = "CameraFailure"}) : super(false);

  @override
  List<Object> get props => [error];
}

class SendImageSuccess extends CameraState {
  final String path;

  const SendImageSuccess(this.path);
}
