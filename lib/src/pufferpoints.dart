part of puffer.puffer;

class PufferPoint implements PufferGraph {
  final Puffer puffer;
  String label;
  final xVal;
  final yVal;
  
  s.SvgElement get element => _circle;
  
  s.CircleElement _circle;
  s.Point _point;
  
  PufferPoint(this.puffer, this.xVal, this.yVal, this.label, String color) {
    if(xVal > puffer._maxX) puffer._maxX = xVal;
    if(xVal < puffer._minX) puffer._minX = xVal;
    
    if(yVal > puffer._maxY) puffer._maxY = yVal;
    if(yVal < puffer._minY) puffer._minY = yVal;
    
    if(color == null) color = 'red';
    _circle = new s.CircleElement();
    _circle..setAttribute('fill', 'black')
      ..setAttribute('stroke', color)
      ..setAttribute('stroke-width', '1')
      ..setAttribute('r', '3');
  }
  
  void _calculatePosition() {
    num svgHeight = puffer.height;
    num svgWidth = puffer.width;
    var x = (xVal - puffer._minX) / (puffer._maxX - puffer._minX) * svgWidth;
    var y = (yVal - puffer._minY) / (puffer._maxY - puffer._minY) * svgHeight;
    y = svgHeight - y;
    
    _point = puffer.svg.createSvgPoint();
    _point.x = x;
    _point.y = y;
    _circle..setAttribute('cx', '$x')
        ..setAttribute('cy', '$y');
  }
  
  void addPoint(xVal, yVal) {
    throw new UnsupportedError('Point should be passed to the constructor.');
  }
}

class PufferPointGraph implements PufferGraph {
  final Puffer puffer;
  List<PufferPoint> points;
  String label;
  
  s.SvgElement get element => _group;
  
  s.GElement _group;
  
  PufferPointGraph(this.puffer, this.label, String color) {
    if(color == null) color = 'red';
    _group = new s.GElement()
        ..setAttribute('stroke', color);
    points = new List<PufferPoint>();
  }
  
  void addPoint(xVal, yVal, {String label, String color}) {
    if(color == null) color = 'inherit';
    var pp = new PufferPoint(puffer, xVal, yVal, label, color);
    points.add(pp);
    _group.children.add(pp.element);
  }
  
  void _calculatePosition() {
    points.forEach((pt) => pt._calculatePosition());
  }
}