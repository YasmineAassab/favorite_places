import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/screens/map_screen.dart';
import '../widget/map.dart';

class PlaceDetail extends ConsumerWidget {
  const PlaceDetail({super.key, required this.place});

  final Place place;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: CircleAvatar(
                      radius: 90,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: Map(
                          latLng: place.latLong,
                          initialZoom: 7,
                          onTap: (tapPosition, point) =>
                              Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) => MapScreen(
                                isSelecting: false,
                                place: place,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    place.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
