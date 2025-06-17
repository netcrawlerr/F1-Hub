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
  static const String redBullRingCircuit = 'assets/images/austria.png';
  static const String silverstoneCircuit = 'assets/images/silverstone.png';
  static const String belgianCircuit = 'assets/images/belgian.png';
  static const String hangarianCircuit = 'assets/images/hangarian.png';
  static const String dutchCircuit = 'assets/images/dutch.png';
  static const String monzaCircuit = 'assets/images/monza.png';
  static const String bakuCircuit = 'assets/images/baku.png';
  static const String singaporeCircuit = 'assets/images/singapore.png';
  static const String austinCircuit = 'assets/images/austin.png';
  static const String mexicanCircuit = 'assets/images/mexican.png';
  static const String brazilCircuit = 'assets/images/brazil.png';
  static const String vegasCircuit = 'assets/images/vegas.png';
  static const String qatarCircuit = 'assets/images/qatar.png';
  static const String dhabiCircuit = 'assets/images/dhabi.png';

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
    TrackIdentifier.austria: redBullRingCircuit,
    TrackIdentifier.british: silverstoneCircuit,
    TrackIdentifier.belgium: belgianCircuit,
    TrackIdentifier.hangary: hangarianCircuit,
    TrackIdentifier.dutch: dutchCircuit,
    TrackIdentifier.monza: monzaCircuit,
    TrackIdentifier.baku: bakuCircuit,
    TrackIdentifier.singapore: singaporeCircuit,
    TrackIdentifier.austin: austinCircuit,
    TrackIdentifier.mexican: mexicanCircuit,
    TrackIdentifier.brazil: brazilCircuit,
    TrackIdentifier.vegas: vegasCircuit,
    TrackIdentifier.qatar: qatarCircuit,
    TrackIdentifier.dhabi: dhabiCircuit,
  };

  static String getCircuitImageById(String? circuitId) {
    if (circuitId == null) return defaultCircuit;
    return circuitImages[circuitId] ?? defaultCircuit;
  }
}
