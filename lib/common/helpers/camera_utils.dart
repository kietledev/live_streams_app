import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraUtils {
  Future<CameraController> getCameraController(
      ResolutionPreset resolutionPreset,
      CameraLensDirection cameraLensDirection) async {
    await [Permission.camera, Permission.microphone].request();
    final cameras = await availableCameras();
    final camera = cameras
        .firstWhere((camera) => camera.lensDirection == cameraLensDirection);

    return CameraController(camera, resolutionPreset,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.bgra8888);
  }

  Future<String> getPath() async => join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
}
