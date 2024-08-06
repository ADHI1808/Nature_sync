import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart'; // Ensure Tflite is correctly imported
import 'dart:developer' as devtools;

class LeafScanner extends StatefulWidget {
  const LeafScanner({super.key});

  @override
  State<LeafScanner> createState() => _LeafScannerState();
}

class _LeafScannerState extends State<LeafScanner> {
  File? filePath;
  String label = '';
  double confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeTfLite();
  }

  Future<void> _initializeTfLite() async {
    try {
      await Tflite.loadModel(
        model: "assets/internml.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );
    } catch (e) {
      devtools.log("Failed to load model: $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image == null) return;

    final imageFile = File(image.path);

    setState(() {
      filePath = imageFile;
    });

    _classifyImage(image.path);
  }

  Future<void> _classifyImage(String path) async {
    try {
      final recognitions = await Tflite.runModelOnImage(
        path: path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true,
      );

      if (recognitions == null) {
        devtools.log("No recognitions found");
        return;
      }

      devtools.log(recognitions.toString());
      setState(() {
        confidence = (recognitions[0]['confidence'] * 100);
        label = recognitions[0]['label'].toString();
      });
    } catch (e) {
      devtools.log("Failed to classify image: $e");
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaf Scan"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (filePath != null)
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: FileImage(filePath!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage('assets/upload.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text(
                    "No image selected",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (label.isNotEmpty)
              Column(
                children: [
                  Text(
                    "Label: $label",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Confidence: ${confidence.toStringAsFixed(2)}%",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text("Gallery"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
