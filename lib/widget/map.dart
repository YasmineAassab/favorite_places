import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatelessWidget {
  const Map({
    super.key,
    required this.latLng,
    this.mapController,
    this.onTap,
    required this.initialZoom,
  });

  final LatLng latLng;
  final double initialZoom;
  final MapController? mapController;
  final Function(TapPosition, LatLng)? onTap;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        onTap: onTap,
        initialCenter: latLng,
        initialZoom: initialZoom,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          rotate: true,
          alignment: Alignment.center,
          markers: [
            Marker(
              alignment: Alignment.center,
              point: latLng,
              rotate: true,
              child: const Icon(
                Icons.location_on,
                color: Color(0xFFDB4437),
                size: 35.0,
              ),
            )
          ],
        ),
      ],
    );
  }
}
