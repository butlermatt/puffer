library puffer.puffer;

import 'dart:svg' as s;

part 'src/pufferline.dart';
part 'src/pufferpoints.dart';

abstract class PufferGraph {
  String label;
  
  s.SvgElement get element;
  void addPoint(xVal, yVal);
  void _calculatePosition();
}

class Puffer {
  s.SvgSvgElement svg;
  
  s.PointList _points;
  
  List<PufferGraph> _myEls;

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
    _myEls = new List<PufferGraph>();
  }
  
  PufferLine addPufferLine({String label, String color}) {
    var pl = new PufferLine(this, label, color);
    _myEls.add(pl);
    svg.children.add(pl.element);
    return pl;
  }
  
  PufferPointGraph addPufferPointGraph({String label, String color}) {
    var ppg = new PufferPointGraph(this, label, color);
    _myEls.add(ppg);
    svg.children.add(ppg.element);
    return ppg;
  }
  
  PufferPoint addPufferPoint(xVal, yVal, {String label, String color}) {
    var pp = new PufferPoint(this, xVal, yVal, label, color);
    _myEls.add(pp);
    svg.children.add(pp.element);
    return pp;
  }
  
  num get width => svg.getBoundingClientRect().width;
  num get height => svg.getBoundingClientRect().height;
  
  void draw() => _myEls.forEach((el) => el._calculatePosition());
  
}
