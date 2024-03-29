import 'package:ekene/model/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
    this.isSelecting = true,
    this.location = const PlaceLocation(
      latitude: 37.22,
      longitude: -122.22,
      address: "",
    ),
  }) : super(key: key);
  final PlaceLocation location;
  final bool isSelecting;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? "Pick a Location" : "Your location"),                                                                          
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    pickedLocation
                  );
                },
                icon: const Icon(Icons.save)),
        ],
      ),
      body: GoogleMap(
        onTap: widget.isSelecting == false ? null : (position) {
          setState(() {
            pickedLocation = position;
          });
        },
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.location.latitude, widget.location.longitude),
            zoom: 18),
        markers: (pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                    markerId: const MarkerId("m1"),
                    position: pickedLocation ??
                        LatLng(widget.location.latitude,
                            widget.location.longitude)),
              },
      ),
    );
  }
}
