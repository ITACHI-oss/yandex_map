import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geocoding/geocoding.dart';

class SimpleYandexMap extends StatefulWidget {
  const SimpleYandexMap({super.key});

  @override
  State<SimpleYandexMap> createState() => _SimpleYandexMapState();
}

class _SimpleYandexMapState extends State<SimpleYandexMap> {
  late YandexMapController _controller;
  final List<MapObject> _mapObjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yandex Map")),
      body: YandexMap(
        onMapCreated: (ctrl) => _controller = ctrl,
        mapObjects: _mapObjects,
        onMapTap: (Point point) async {
          await _controller.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: point, zoom: 15),
            ),
            animation: const MapAnimation(
              type: MapAnimationType.smooth,
              duration: 1,
            ),
          );

          _mapObjects.clear();

          final marker = PlacemarkMapObject(
            mapId: MapObjectId('tap_marker'),
            point: point,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  'assets/images/map-marker.png',
                ),
                scale: 0.2,
              ),
            ),
            onTap: (self, _) async {
              String address = await _getAddress(point);
              _showBottomSheet(context, address);
            },
          );

          setState(() {
            _mapObjects.add(marker);
          });

          String address = await _getAddress(point);
          _showBottomSheet(context, address);
        },
      ),
    );
  }

  Future<String> _getAddress(Point point) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      final place = placemarks.first;
      return '${place.street}, ${place.locality}, ${place.country}';
    } catch (e) {
      return 'Ma’lumot topilmadi';
    }
  }

  void _showBottomSheet(BuildContext context, String info) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Container(
            padding: const EdgeInsets.all(16),
            height: 150,
            child: Center(child: Text(info, style: TextStyle(fontSize: 16))),
          ),
    );
  }
}
