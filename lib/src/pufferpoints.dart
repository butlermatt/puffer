part of puffer.puffer;

/// Represents a single Point on the graph.  It should not be instantiated
/// directly. It should be created with [Puffer.addPufferPoint]
class PufferPoint implements PufferGraph {
  final Puffer _puffer;
  /// Label to be displayed when hovering over the point.
  String label;
  /// Value on the X-axis of this point.
  final xVal;
  /// Value on the Y-axis of this point.
  final yVal;
  
  /// If the point should be visible on the graph.
  bool visible = true;

  /// The composed SVG element displayed on the graph.
  s.SvgElement get element => _circle;

  s.CircleElement _circle;
  s.Point _point;

  /// Creates a new instance of [PufferPoint]. Should not be instantiated
  /// directly.
  PufferPoint(this._puffer, this.xVal, this.yVal, this.label, String color, {this.visible}) {
    if (xVal > _puffer._maxX) _puffer._maxX = xVal;
    if (xVal < _puffer._minX) _puffer._minX = xVal;

    if (yVal > _puffer._maxY) _puffer._maxY = yVal;
    if (yVal < _puffer._minY) _puffer._minY = yVal;

    if (color == null) color = 'red';
    _circle = new s.CircleElement();
    _circle
        ..setAttribute('fill', 'black')
        ..setAttribute('fill-width', '1')
        ..setAttribute('stroke', color)
        ..setAttribute('stroke-width', '2')
        ..setAttribute('r', '3');
    if(!visible) {
      _circle.setAttribute('visibility', 'hidden');
    }
  }

  void _calculatePosition() {
    num graphHeight = _puffer.height;
    num graphWidth = _puffer.width;
    var x = _calcXPos(xVal);
    var y = _calcYPos(yVal);

    _point = _puffer.svg.createSvgPoint();
    _point.x = x;
    _point.y = y;
    _circle
        ..setAttribute('cx', '$x')
        ..setAttribute('cy', '$y');
  }
  
  // Calculate the pixel x coordinates based on x-graph value
  num _calcXPos(num xVal) {
    var x = (xVal - _puffer._minX) / (_puffer._maxX - _puffer._minX) * _puffer.width;
    x += _puffer.graphStartX;
    return x;
  }
  
// Calculate the pixel y coordinates based on y-graph value
  num _calcYPos(num yVal) {
    num y = (yVal - _puffer._minY) / (_puffer._maxY - _puffer._minY) *
            _puffer.height;
    y = (_puffer.height - y) + _puffer.graphStartY;
    return y;
  }

  /// Throws an [UnsupportedError]. Unable to add a point a point.
  void addPoint(xVal, yVal) {
    throw new UnsupportedError('Point should be passed to the constructor.');
  }
}

/// This class represents a Point Graph on the [Puffer] Svg element. It should
/// not be instantiated directly. It should be created with
/// [Puffer.addPufferPointGraph]
class PufferPointGraph implements PufferGraph {
  final Puffer puffer;
  List<PufferPoint> points;
  String label;

  s.SvgElement get element => _group;

  s.GElement _group;

  /// Creates a new instance of [PufferPoint]. Should not be instantiated
  /// directly.
  PufferPointGraph(this.puffer, this.label, String color) {
    if (color == null) color = 'red';
    _group = new s.GElement()..setAttribute('stroke', color);
    points = new List<PufferPoint>();
  }

  /// Add a point to the point graph. Points may be added in any order.
  /// [xVal] and [yVal] are the X and Y coordinates of the point. The graph
  /// will scale appropriately based on values. The optional, named, parameter
  /// [label] will display the provided string when hovering over the point on
  /// the graph. The optional, named, parameter [color] specifies the color
  /// of this point. Default is inherited from the point graph.
  void addPoint(xVal, yVal, {String label, String color, bool visible}) {
    if (color == null) color = 'inherit';
    var pp;
    if(visible != null) {
      pp = new PufferPoint(puffer, xVal, yVal, label, color, visible: visible);
    } else {
      pp = new PufferPoint(puffer, xVal, yVal, label, color);
    }
    points.add(pp);
    _group.children.add(pp.element);
  }

  void _calculatePosition() {
    points.forEach((pt) => pt._calculatePosition());
  }
}
