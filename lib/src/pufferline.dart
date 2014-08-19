part of puffer.puffer;

/// This class represents a Line Graph on the [Puffer] Svg element. It should 
/// not be instantiated directly. It should be created with 
/// [Puffer.addPufferLine] 
class PufferLine implements PufferGraph {
  final Puffer _puffer;
  /// Label to be displayed when hovering over the line graph.
  String label;
  /// List of [PufferPoints] on the line graph.
  List<PufferPoint> get points => _dots.points;
  /// Color of the line graph.
  String color;
  
  /// The composed SVG element displayed on the graph.
  s.SvgElement get element => _lineGroup;
  
  PufferPointGraph _dots;
  s.PolylineElement _line;
  s.PointList _points;
  s.GElement _lineGroup;

  /// Creates a new instance of [PufferLine]. Should not be instantiated
  /// directly.
  PufferLine(this._puffer, this.label, this.color) {
    if(color == null) color = 'red';
    _lineGroup = new s.GElement()
        ..setAttribute('stroke', color);
    
    _line = new s.PolylineElement()
        ..setAttribute('fill', 'white')
        ..setAttribute('fill-opacity', '0.2')
        ..setAttribute('stroke', 'inherit')
        ..setAttribute('stroke-width', '2');
    _points = _line.points;
    _dots = new PufferPointGraph(_puffer, null, 'inherit');
    _lineGroup.children..add(_line)
        ..add(_dots.element);
  }
  
  /// Add a point to the line graph. Points should be added in order they should
  /// appear in on the graph.
  /// [xVal] and [yVal] are the X and Y coordinates of the point. The graph
  /// will scale appropriately based on values. The optional, named, parameter 
  /// [label] will display the provided string when hovering over the point on 
  /// the graph. The optional, named, parameter [color] specifies the color
  /// of this point. Default is inherited from the line graph.  
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