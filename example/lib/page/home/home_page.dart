import 'dart:io';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:example/page/printer/printer_page.dart';
import 'package:example/utils/utils_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_halftone/image_halftone.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? imagePrint;

  Future<void> getLostData() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (file != null) {
      final img = File(file.path);
      final imageFilter = await convertImageToHalftoneBlackAndWhite(img);
      setState(() {
        imagePrint = imageFilter;
      });
    }
  }

  printer() async {
    if (imagePrint == null) {
      return;
    }
    final textImage = await printImage(imagePrint!);
    final utf = Uint8List.fromList(textImage);

    BluetoothPrintPlus.write(utf);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrinterPage()),
              );
            },
            icon: Icon(CupertinoIcons.printer),
          ),
        ],
      ),
      body: Center(
        child:
            imagePrint == null ? Text('Sem imagem') : Image.memory(imagePrint!),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          FloatingActionButton(
            onPressed: () => getLostData(),
            heroTag: null,
            child: Icon(CupertinoIcons.photo),
          ),
          FloatingActionButton(
            onPressed: printer,
            heroTag: null,
            child: Icon(CupertinoIcons.printer),
          ),
        ],
      ),
    );
  }
}
