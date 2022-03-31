import 'package:flutter_map/flutter_map.dart';

/// Actions with Payload

/// Map Actions
class Points {
  final List<Marker> payload;
  Points(this.payload);
}

class Selected {
  final int payload;
  Selected(this.payload);
}

class Locais {
  final List<dynamic> payload;
  Locais(this.payload);
}

class PARs {
  final List<dynamic> payload;
  PARs(this.payload);
}

class BasaltoPARs {
  final List<dynamic> payload;
  BasaltoPARs(this.payload);
}
