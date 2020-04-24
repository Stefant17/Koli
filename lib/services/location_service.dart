import 'package:location/location.dart';

class LocationService {
  Location location;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  bool _serviceEnabled;

  LocationService() {
    location = new Location();
    locationServiceInit();
  }

  void locationServiceInit() async {
    await checkServiceEnabled();
    if(_serviceEnabled) {
      await checkPermissionGranted();
      getLocation();
    }
  }

  Future checkServiceEnabled() async {
    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled) {
        return;
      }
    }
  }

  Future checkPermissionGranted() async {
    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future getLocation() async {
    _locationData = await location.getLocation();
    print(_locationData.toString());
  }
}