part of puffer.puffer;

class PufferLine implements PufferGraph {
  final Puffer puffer;
  String label;
  List points;
  String color;
  
  s.SvgElement get element => _lineGroup;
  
  PufferPointGraph _dots;
  s.PolylineElement _line;
  s.PointList _points;
  s.GElement _lineGroup;

  PufferLine(this.puffer, this.label, this.color) {
    if(color == null) color = 'red';
    _lineGroup = new s.GElement()
        ..setAttribute('stroke', color);
    
    _line = new s.PolylineElement()
        ..setAttribute('fill', 'white')
        ..setAttribute('fill-opacity', '0.2')
        ..setAttribute('stroke', 'inherit')
        ..setAttribute('stroke-width', '2');
    _points = _line.points;
    _dots = new PufferPointGraph(puffer, null, 'inherit');
    points = new List();
    _lineGroup.children..add(_line)
        ..add(_dots.element);
  }
  
  void addPoint(num xVal, num yVal, {String label, String color}) {
    if(color == null) color = 'inherit';
    _dots.addPoint(xVal, yVal, label: label, color: color);
  }
  
  void _calculatePosition() {
    _dots._calculatePosition();
    _points.clear();
    for(PufferPoint point in _dots.points) {
      _points.appendItem(point._point);
    }
  }
}