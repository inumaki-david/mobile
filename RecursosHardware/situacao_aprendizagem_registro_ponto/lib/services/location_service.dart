import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationException implements Exception {
  const LocationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class LocationService {
  Future<Position> currentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(
        'Ative o serviço de localização do aparelho e tente novamente.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException(
        'A permissão de localização foi negada. Autorize o acesso para registrar o ponto.',
      );
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'A permissão foi negada permanentemente. Altere-a nas configurações do aplicativo.',
      );
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } on TimeoutException {
      throw const LocationException(
        'Não foi possível obter a localização a tempo. Verifique o sinal do GPS.',
      );
    }
  }
}
