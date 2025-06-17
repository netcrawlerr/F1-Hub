import 'package:f1_hub/utils/track_identifiers.dart';

class AppMedia {
  static const String defaultCircuit = 'assets/images/albert_park.png';
  static const String albertParkCircuit = 'assets/images/albert_park.png';
  static const String shangaiCircuit = 'assets/images/shangai.png';
  static const String suzukaCircuit = 'assets/images/suzuka.png';
  static const String bahrainCircuit = 'assets/images/bahrain.png';
  static const String jeddahCircuit = 'assets/images/jeddah.png';
  static const String miamiCircuit = 'assets/images/miami.png';
  static const String imolaCircuit = 'assets/images/imola.png';
  static const String monacoCircuit = 'assets/images/monaco.png';
  static const String montmeloCircuit = 'assets/images/montmelo.png';
  static const String gillesVilleneuveCircuit =
      'assets/images/gilles_villeneuve.png';
  // static const String redBullRingCircuit = 'assets/images/red_bull_ring.png';

  static Map<String, String> circuitImages = {
    TrackIdentifier.australian: albertParkCircuit,
    TrackIdentifier.shangai: shangaiCircuit,
    TrackIdentifier.suzuka: suzukaCircuit,
    TrackIdentifier.bahrain: bahrainCircuit,
    TrackIdentifier.jeddah: jeddahCircuit,
    TrackIdentifier.miami: miamiCircuit,
    TrackIdentifier.emiliaRomagna: imolaCircuit,
    TrackIdentifier.emola: monacoCircuit,
    TrackIdentifier.barcelona: montmeloCircuit,
    TrackIdentifier.canada: gillesVilleneuveCircuit,
    // TrackIdentifier.austria: redBullRingCircuit,
  };

  static String getCircuitImageById(String? circuitId) {
    if (circuitId == null) return defaultCircuit;
    return circuitImages[circuitId] ?? defaultCircuit;
  }
}
