import 'package:camera/camera.dart';
import 'package:chickfit/core/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionWidget extends StatefulWidget {
  const FaceDetectionWidget({super.key});

  @override
  FaceDetectionWidgetState createState() => FaceDetectionWidgetState();
}

class FaceDetectionWidgetState extends State<FaceDetectionWidget> {
  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  List<Face> _faces = [];
  late CameraImage _cameraImage;

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
      ),
      ResolutionPreset.high,
    );
    await _cameraController?.initialize();
    if (_cameraController!.value.isInitialized) {
      LogUtil.info("TES initialize 1 ");
      // Mulai menangkap gambar secara real-time
      _cameraController?.startImageStream((CameraImage image) {
        LogUtil.info("TES initialize 3");
        _detectFaces(image);
      });
    } else {
      LogUtil.info("TES initialize 2");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: Text('Face Detection')),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          CustomPaint(
            painter: FacePainter(_faces),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  // Fungsi untuk mendeteksi wajah pada gambar
  Future<void> _detectFaces(CameraImage image) async {
    LogUtil.info("TESsss}");
    final inputImage = InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.yuv_420_888,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
    LogUtil.info("TES}");

    final faces = await _faceDetector?.processImage(inputImage);
    setState(() {
      _faces = faces ?? [];
    });
  }
}

class FacePainter extends CustomPainter {
  final List<Face> faces;

  FacePainter(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    for (Face face in faces) {
      final rect = face.boundingBox;
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
