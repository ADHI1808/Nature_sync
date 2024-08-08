import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer' as devtools;

import 'package:lottie/lottie.dart';

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
        model: "assets/model_unquant.tflite",
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
        title: Text(
          "Leaf Scan",
          style: GoogleFonts.rubik(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Conditionally render Lottie animation or selected image
                  if (filePath == null)
                    Column(
                      children: [
                        // Lottie animation for taking a picture
                        Lottie.asset("assets/animations/taking_a_picture.json",
                            width: 128, height: 128),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Text(
                              "Choose a picture",
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Select an image from your gallery or take a new picture",
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 4,
                          color: Colors.grey,
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
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
                        ),
                        const SizedBox(height: 20),
                        if (label.isNotEmpty)
                          Column(
                            children: [
                              Text(
                                "Label: $label",
                                style: GoogleFonts.openSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Confidence: ${confidence.toStringAsFixed(2)}%",
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: Text(
                          "Camera",
                          style: GoogleFonts.openSans(),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12.0),
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo),
                        label: Text(
                          "Gallery",
                          style: GoogleFonts.openSans(),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12.0),
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
