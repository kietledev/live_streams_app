part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class CameraInitialized extends CameraEvent {}

class CameraStopped extends CameraEvent {}

class CameraCaptured extends CameraEvent {}

class CameraChange extends CameraEvent {}

class CameraShowFlash extends CameraEvent {}

class CameraCapturedAgain extends CameraEvent {}

class SendImage extends CameraEvent {}
