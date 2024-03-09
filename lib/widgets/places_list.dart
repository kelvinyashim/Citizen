import 'package:ekene/model/place.dart';
import 'package:ekene/provider/user_place.dart';
import 'package:ekene/screens/place_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) => SizedBox(
        height: 75,
        child: Dismissible(
          key: ValueKey(places[index]),
          onDismissed: (direction,) {
            ref.read(userPlacesProvider.notifier).deletePlace(places[index]);
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: FileImage(places[index].image),
            ),
            title: Text(
              places[index].title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 25),
            ),
            subtitle: Text(places[index].location.address,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 17,
                    )),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlaceDetailScreen(
                  place: places[index],
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
