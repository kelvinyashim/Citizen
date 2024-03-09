import 'package:ekene/model/place.dart';
import 'package:ekene/screens/map.dart';
import 'package:flutter/material.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({
    super.key,
    required this.place,
  });
  final Place place;

  String get locationImage {
    final lat = place.location.latitude;
    final lng = place.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyDLcwxUggpPZo8lcbH0TB4Crq5SJjtj4ag';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        place.title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      )),
      body: Stack(children: [
        Image.file(
          place.image,
          height: double.infinity,
          fit: BoxFit.fitHeight,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MapScreen(location: place.location, isSelecting: false,),
                  ));
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(locationImage),
                  maxRadius: 60,
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.black54,
                    Colors.transparent,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Text(
                  place.location.address,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
