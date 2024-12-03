// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<String> getCurrentAddress() async {
    // 위치 권한 확인
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return '위치 권한이 거부되었습니다.';
      }
    }

    try {
      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );

      // 위도/경도를 주소로 변환
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: 'ko_KR'
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // 동 이름 추출
        String dong = place.subLocality ?? '';
        return dong;
      }
      
      return '알 수 없는 위치';
    } catch (e) {
      return '위치를 가져올 수 없습니다';
    }
  }
}