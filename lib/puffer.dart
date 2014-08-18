library puffer.puffer;


import 'dart:svg' as s;

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
  
  PufferLine addPufferLine() {
    var pl = new PufferLine(this);
    _myEls.add(pl);
    return pl;
  }
  
  num get width => svg.getBoundingClientRect().width;
  num get height => svg.getBoundingClientRect().height;
  
  void draw() => _myEls.forEach((el) => el._calculatePoints());
  
}

class PufferLine {
  final Puffer puffer;
  s.PolylineElement _line;
  s.PointList _points;
  s.GElement _dots;
  
  List points;

  PufferLine(this.puffer) {
    _line = new s.PolylineElement()
        ..setAttribute('fill', 'white')
        ..setAttribute('fill-opacity', '0.2')
        ..setAttribute('stroke', 'red')
        ..setAttribute('stroke-width', '2');
    _points = _line.points;
    _dots = new s.GElement();
    points = new List();
    puffer.svg.children..add(_line)
                      ..add(_dots);
  }
  
  void addPoint(num xVal, num yVal) {
    if(xVal > puffer._maxX) puffer._maxX = xVal;
    if(xVal < puffer._minX) puffer._minX = xVal;
    
    if(yVal > puffer._maxY) puffer._maxY = yVal;
    if(yVal < puffer._minY) puffer._minY = yVal;

    points.add([xVal, yVal]);
//    _calculatePoints();
  }
  
  void _calculatePoints() {
    var numPoints = points.length;
    
    num svgHeight = puffer.height;
    num svgWidth = puffer.width;
    
    _points.clear();
    _dots.children.clear();
    for(List pt in points) {
      var x = (pt[0] - puffer._minX) / puffer._maxX * svgWidth;
      var y = (pt[1] - puffer._minY) / puffer._maxY * svgHeight;
      y = svgHeight - y;
      print('x: $x y: $y');
      var point = puffer.svg.createSvgPoint();
      point..x = x
          ..y = y;
      
      var circle = new s.CircleElement();
      circle..setAttribute('fill', 'black')
        ..setAttribute('stroke', 'red')
        ..setAttribute('stroke-width', '1')
        ..setAttribute('r', '3')
        ..setAttribute('cx', '$x')
        ..setAttribute('cy', '$y');
      _dots.append(circle);
      _points.appendItem(point);
    }
  }
}