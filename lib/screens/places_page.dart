import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/screens/place_detail.dart';
import 'package:favorite_places/widget/app_bar.dart';

import '../provider/place_provider.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> places;

  @override
  void initState() {
    places = ref.read(placesListProvider.notifier).loadPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(context: context),
      body: ref.watch(placesListProvider).isEmpty
          ? const Center(
              child: Text(
                'No places added yet!',
                style: TextStyle(color: Colors.white),
              ),
            )
          : FutureBuilder(
              future: places,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: ref.watch(placesListProvider).length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => PlaceDetail(
                            place: ref.watch(placesListProvider)[index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundImage: FileImage(
                            ref.watch(placesListProvider)[index].imagePath,
                          ),
                        ),
                        title: Text(
                          ref.watch(placesListProvider)[index].title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          ref.watch(placesListProvider)[index].address,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
