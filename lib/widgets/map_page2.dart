import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage2 extends HookWidget {
  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();

    // 現在位置
    ValueNotifier<LocationData> _yourLocation = useState(LocationData.fromMap({
      'latitude': 34.643208,
      'longitude': 134.997586,
    }));
    ValueNotifier<bool> hasFetched = useState(false);

    Location _locationService = Location();
    // 現在位置の監視状況
    StreamSubscription _locationChangedListen;

    useEffect(() {
      void _getLocation() async {
        _yourLocation.value = await _locationService.getLocation();
        print(_yourLocation.value);
        hasFetched.value = true;
      }

      _getLocation();

      _locationChangedListen = _locationService.onLocationChanged
          .listen((LocationData result) async {
        _yourLocation.value = result;
      });
    }, []);

    Widget _makeGoogleMap() {
      if (!hasFetched.value) {
        // 現在位置が取れるまではローディング中
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        // Google Map ウィジェットを返す
        return GoogleMap(
          // 初期表示される位置情報を現在位置から設定
          initialCameraPosition: CameraPosition(
            target: LatLng(
                _yourLocation.value.latitude!, _yourLocation.value.longitude!),
            zoom: 18.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },

          // 現在位置にアイコン（青い円形のやつ）を置く
          myLocationEnabled: true,
        );
      }
    }

    return Scaffold(
      body: _makeGoogleMap(),
    );
  }

  CameraPosition getCameraPosition(latlng) {
    final CameraPosition pos = CameraPosition(
      target:
          LatLng(double.parse(latlng.latitude), double.parse(latlng.longitude)),
      zoom: 15.0,
    );
    return pos;
  }
}
