import 'package:flutter/material.dart';

import '../screens/new_place.dart';

class AppBarWidget extends AppBar {
  final BuildContext context;

  AppBarWidget({
    super.key,
    required this.context,
  }) : super(
          title: const Text('Your Places'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) => const NewPlace(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            )
          ],
        );
}
