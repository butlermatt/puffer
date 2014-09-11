import 'dart:html';

import 'package:puffer/puffer.dart';

void main() {
  var container = querySelector('#container');

  var puffer = new Puffer();
  container.append(puffer.svg);

  var line = puffer.addPufferLine();
  line..addPoint(0, 25)
    ..addPoint(2, 50)
    ..addPoint(4, 50)
    ..addPoint(6, 75)
    ..addPoint(8, 100);

  var line2 = puffer.addPufferLine(color: 'blue');
  line2..addPoint(0, 18)
    ..addPoint(3, 32)
    ..addPoint(4, 58, color: 'green')
    ..addPoint(5, 67)
    ..addPoint(9, 7);

  puffer.draw();

}
