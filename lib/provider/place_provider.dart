import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

import '../model/place.dart';

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, imagePath TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}

class PlaceList extends StateNotifier<List<Place>> {
  PlaceList() : super([]);

  Future<void> loadPlaces() async {
    final db = await _getDataBase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            imagePath: File(row['imagePath'] as String),
            latLong: LatLng(row['lat'] as double, row['lng'] as double),
            address: row['address'] as String,
          ),
        )
        .toList();
    state = places;
  }

  Future<void> addNewItem(Place newPlace) async {
    final db = await _getDataBase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'imagePath': newPlace.imagePath.path,
      'lat': newPlace.latLong.latitude,
      'lng': newPlace.latLong.longitude,
      'address': newPlace.address,
    });
    state = [newPlace, ...state];
  }
}

final placesListProvider =
    StateNotifierProvider<PlaceList, List<Place>>((ref) => PlaceList());
