import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:favorite_places/screens/map_screen.dart';

import '../screens/new_place.dart';
import 'location_container.dart';
import 'map.dart';

class LocationInput extends ConsumerStatefulWidget {
  const LocationInput({super.key, required this.getLocation});

  final Future<LocationData> Function() getLocation;
  @override
  ConsumerState<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends ConsumerState<LocationInput> {
  bool isLocationChosen = false;
  MapController? _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  Future<void> _setLatLng() async {
    await widget.getLocation().then((value) => {
          ref.watch(latLng.notifier).state =
              LatLng(value.latitude!, value.longitude!)
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        !isLocationChosen
            ? LocationContainer(
                height: 150,
                child: Text(
                  textAlign: TextAlign.center,
                  'No location chosen!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            : ref.watch(latLng) != const LatLng(0, 0) && isLocationChosen
                ? LocationContainer(
                    height: 150,
                    child: Map(
                      latLng: ref.watch(latLng),
                      initialZoom: 9,
                      mapController: _mapController,
                    ),
                  )
                : const LocationContainer(
                    height: 150,
                    child: CircularProgressIndicator(),
                  ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () async {
                setState(() {
                  isLocationChosen = true;
                });
                await _setLatLng();
              },
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            const SizedBox(
              width: 10,
            ),
            TextButton.icon(
              onPressed: () async {
                setState(() {
                  isLocationChosen = true;
                });
                await _setLatLng();
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (builder) => MapScreen(
                        isSelecting: true,
                        onTap: () {
                          _mapController?.move(ref.watch(latLng), 9);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            )
          ],
        )
      ],
    );
  }
}
