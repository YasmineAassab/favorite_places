import 'dart:io';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({
    required this.title,
    required this.imagePath,
    required this.latLong,
    required this.address,
    String? id,
  }) : id = id ?? uuid.v1();

  final String id;
  final String title;
  final File imagePath;
  final LatLng latLong;
  final String address;
}
