import 'dart:io';

import 'package:ekene/model/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import "package:sqflite/sqlite_api.dart";

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<Database> getDb() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(path.join(dbPath, "places.db"),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    }, version: 1);
    return db;
  }

  Future<void> loadDB() async {
    final db = await getDb();
    final data = await db.query('user_places'); //this yields a map
    //so we convert it back to a Place object
    final places =  data
        .map(
          (row) => Place(
            id: row['id'] as String,
            location: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String),
            title: row['title'] as String,
            image: File(row['image'] as String),
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
//first to save the image locally on the device we need the path provider
//this helps to dynamically select the preferred OS for the device.
    final directory =
        await getApplicationDocumentsDirectory(); //get application document directory
    final filePath = path.basename(image.path);
    final copiedImage = await image.copy("${directory.path}/$filePath");
//all this was to save the image locally
    final newPlace =
        Place(title: title, image: copiedImage, location: location);
    final db = await getDb();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address
    });

    state = [newPlace, ...state];
  }

  void deletePlace(Place place) {
    state = List<Place>.from(state)..remove(place);
    place.image.delete();
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
