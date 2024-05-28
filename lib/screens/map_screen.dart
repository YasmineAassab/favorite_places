import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/place.dart';
import '../widget/map.dart';
import 'new_place.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({
    super.key,
    required this.isSelecting,
    this.onTap,
    this.place,
  });

  final bool isSelecting;
  final Function()? onTap;
  final Place? place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSelecting ? 'Pick Your Location' : 'Your Location'),
        actions: [
          isSelecting
              ? IconButton(
                  onPressed: onTap,
                  icon: const Icon(Icons.save),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Map(
        onTap: isSelecting
            ? (tapPosition, point) {
                ref.watch(latLng.notifier).state = point;
              }
            : null,
        latLng: place == null ? ref.watch(latLng) : place!.latLong,
        initialZoom: 9,
      ),
    );
  }
}
