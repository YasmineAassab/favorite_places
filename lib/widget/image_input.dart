import 'dart:io';

import 'package:flutter/material.dart';

class ImageInput extends StatelessWidget {
  const ImageInput({
    super.key,
    this.imagePath,
    required this.takePicture,
  });

  final File? imagePath;
  final Function() takePicture;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: imagePath == null
          ? Center(
              child: TextButton.icon(
                onPressed: takePicture,
                icon: const Icon(Icons.camera),
                label: const Text('Add picture'),
              ),
            )
          : GestureDetector(
              onTap: takePicture,
              child: Image.file(
                imagePath!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
    );
  }
}
