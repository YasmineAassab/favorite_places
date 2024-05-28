import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

import '../../model/place.dart';
import '../../provider/place_provider.dart';
import '../../screens/new_place.dart';

class LocationUtils {
  static void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Place information is not complete!',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.background),
        ),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
      ),
    );
  }

  static Future<void> addNewPlace(WidgetRef ref, BuildContext context,
      TextEditingController textEditingController, File? imagePath) async {
    final enteredText = textEditingController.text;
    if (enteredText.trim().isEmpty ||
        imagePath == null ||
        ref.watch(latLng.notifier).state == const LatLng(0, 0)) {
      _showSnackBar(context);
      return;
    }
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final filename = path.basename(imagePath.path);
    final copiedImage = await imagePath.copy('${appDir.path}/$filename');

    String? address = await _getAddress(ref);
    final place = Place(
      title: enteredText,
      imagePath: copiedImage,
      latLong: ref.watch(latLng),
      address: address!,
    );
    ref.watch(placesListProvider.notifier).addNewItem(place);
    textEditingController.clear();
    if (context.mounted) Navigator.pop(context);
    ref.watch(latLng.notifier).state = const LatLng(0, 0);
  }

  static Future<String?> _getAddress(WidgetRef ref) async {
    String? address;
    await ref
        .watch(addressProvider.notifier)
        .getAddress(
          ref.watch(latLng).latitude,
          ref.watch(latLng).longitude,
        )
        .then((value) => address = value);

    if (address == null) {
      throw Exception('Address is null !!');
    }
    return address;
  }
}
