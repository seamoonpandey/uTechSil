import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen(
    this.cameras, {
    super.key,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;

  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  double confidenceThreshold = 0.5;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    vision = FlutterVision();
    controller = CameraController(widget.cameras[0], ResolutionPreset.high);

    await controller.initialize().then((_) {
      loadYoloModel().then((_) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    }).catchError((error) {
      // Handle camera initialization error
      print('Error initializing camera: $error');
    });
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/yolov8.tflite',
      modelVersion: "yolov8",
      numThreads: 1,
      useGpu: false,
      quantization: false,
    );
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5);

    // Debug print to check results
    print('YOLO results: $result');

    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        await yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
    await controller.stopImageStream();
  }

  @override
  void dispose() {
    controller.dispose();
    vision.closeYoloModel();
    super.dispose();
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size size) {
    if (cameraImage == null || yoloResults.isEmpty) {
      return [];
    }

    double factorX = size.width / cameraImage!.width.toDouble();
    double factorY = size.height / cameraImage!.height.toDouble();

    Color colorPick = Colors.pink;

    return yoloResults.map((result) {
      double? x = result['x'];
      double? y = result['y'];
      double? width = result['width'];
      double? height = result['height'];
      double? confidence = result['confidence'];

      if (x == null ||
          y == null ||
          width == null ||
          height == null ||
          confidence == null) {
        return const SizedBox(); // Skip null or invalid results
      }

      return Positioned(
        left: x * factorX,
        top: y * factorY,
        width: width * factorX,
        height: height * factorY,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: colorPick,
              width: 3,
            ),
          ),
          child: Text(
            '${result['tag']} ${(confidence * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
          ...displayBoxesAroundRecognizedObjects(size),
          Positioned(
            bottom: 75,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 5, color: Colors.white, style: BorderStyle.solid),
              ),
              child: isDetecting
                  ? IconButton(
                      onPressed: () async {
                        stopDetection();
                      },
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.red,
                      ),
                      iconSize: 50,
                    )
                  : IconButton(
                      onPressed: () async {
                        await startDetection();
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      iconSize: 50,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
