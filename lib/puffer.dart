library puffer.puffer;

import 'dart:svg' as s;

part 'src/pufferline.dart';

class Puffer {
  s.SvgSvgElement svg;
  
  s.PointList _points;
  
  List _myEls;

  String xAxis;
  String yAxis;
  num _maxX = 0;
  num _maxY = 0;
  num _minX = 0;
  num _minY = 0;
  
  
  Puffer() {
    svg = new s.SvgSvgElement();
    svg.style..width = '100%'
          ..height = '100%';
    _myEls = new List();
  }
  
  PufferLine addPufferLine({String label, String color}) {
    var pl = new PufferLine(this, label, color);
    _myEls.add(pl);
    return pl;
  }
  
  num get width => svg.getBoundingClientRect().width;
  num get height => svg.getBoundingClientRect().height;
  
  void draw() => _myEls.forEach((el) => el._calculatePoints());
  
}
