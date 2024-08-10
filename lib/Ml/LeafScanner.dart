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
                  if (filePath == null)
                    Column(
                      children: [
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
                          height: 200, // Reduced height for the final output image
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
                                "Condition: $label",
                                style: GoogleFonts.openSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const SizedBox(height: 20),
                              if (label == "Healthy")
                                _buildHealthTips(),
                              if (label == "Powdery mildew")
                                _buildPowderyMildewTips(),
                              if (label == "Pyricularia grisea")
                                _buildPyriculariaGriseaTips(),
                              if (label == "Puccinia sorghi")
                                _buildPucciniaSorghiiTips(),
                              if (label == "Blight") _buildBlightTips(),
                            ],
                          ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  SizedBox(height: 15),
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
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      Text('  -OR-  ',style: TextStyle(fontSize: 15),),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo),
                        label: Text(
                          "Gallery",
                          style: GoogleFonts.openSans(),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12.0),
                          backgroundColor: Colors.grey,
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

  Widget _buildHealthTips() {
    return _buildTipsContainer(
      title: "Your plant is healthy! 🌿",
      tips: [
        "Water your plant regularly, but avoid overwatering.",
        "Ensure your plant gets enough sunlight.",
        "Fertilize your plant with a balanced fertilizer every few weeks.",
        "Keep an eye out for pests and remove any dead leaves.",
        "Rotate your plant periodically to ensure even growth.",
        "Check the soil moisture before watering.",
        "Prune your plant to promote healthy growth.",
      ],
    );
  }

  Widget _buildPowderyMildewTips() {
    return _buildTipsContainer(
      title: "Powdery Mildew Detected",
      reason:
      "Powdery mildew is a fungal disease that appears as white, powdery spots on leaves. It thrives in warm, dry conditions.",
      tips: [
        "Remove affected leaves to prevent the spread.",
        "Ensure good air circulation around your plants.",
        "Avoid overhead watering to keep leaves dry.",
        "Apply fungicidal sprays if the infection is severe.",
        "Water plants in the early morning so leaves can dry quickly.",
      ],
    );
  }

  Widget _buildPyriculariaGriseaTips() {
    return _buildTipsContainer(
      title: "Pyricularia Grisea Detected",
      reason:
      "Pyricularia grisea causes rice blast disease, leading to lesions on leaves and reducing crop yield.",
      tips: [
        "Use resistant plant varieties if available.",
        "Avoid excessive nitrogen fertilization.",
        "Apply appropriate fungicides as a preventive measure.",
        "Practice crop rotation to prevent the build-up of the pathogen.",
        "Ensure proper field drainage to avoid standing water.",
      ],
    );
  }

  Widget _buildPucciniaSorghiiTips() {
    return _buildTipsContainer(
      title: "Puccinia Sorghi Detected",
      reason:
      "Puccinia sorghi causes common rust in maize, characterized by reddish-brown pustules on leaves.",
      tips: [
        "Plant resistant varieties of maize.",
        "Apply fungicides at the first sign of rust.",
        "Avoid planting maize in wet, humid conditions.",
        "Monitor crops regularly for early signs of infection.",
        "Remove and destroy infected plant debris after harvest.",
      ],
    );
  }

  Widget _buildBlightTips() {
    return _buildTipsContainer(
      title: "Blight Detected",
      reason:
      "Blight is a plant disease characterized by rapid yellowing, browning, and death of leaves, stems, and flowers.",
      tips: [
        "Remove and destroy infected plant parts immediately.",
        "Avoid overhead watering to keep leaves dry.",
        "Improve air circulation by spacing plants properly.",
        "Apply copper-based fungicides to prevent spread.",
        "Use resistant plant varieties if available.",
      ],
    );
  }

  Widget _buildTipsContainer({required String title, String? reason, required List<String> tips}) {
    return Container(
        padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
    color: Colors.green[50],
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
    color: Colors.green,
    width: 1,
    ),
    ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.openSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 10),
          if (reason != null)
            Text(
              reason,
              style: GoogleFonts.openSans(
                fontSize: 14,
                color: Colors.green[700],
              ),
            ),
          const SizedBox(height: 10),
          Text(
            "Tips:",
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 150, // Adjust height to ensure the tips are scrollable
            child: ListView.builder(
              itemCount: tips.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "• ",
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          color: Colors.green[700],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          tips[index],
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

