part of puffer.puffer;

class _PufferAxis implements PufferGraph {
  final Puffer puffer;
  String label;
  String color;
  
  s.SvgElement get element => _element;
  
  s.GElement _axis;
  s.GElement _graphBorder;
  s.GElement _labels;
  s.GElement _chartLines; // Maybe?
  s.GElement _element;
  s.LineElement _xAxis; // Actual x axis 
  s.LineElement _yAxis;
  s.LineElement _xGraphAxis;
  s.LineElement _yGraphAxis;
  
  var _gStartX;
  var _gStartY;
  var _gEndX;
  var _gEndY;
  
  _PufferAxis(this.puffer, this.label, this.color) {
    if(color == null) color = 'black';
    _element = new s.GElement();
    
    _xAxis = new s.LineElement()
        ..setAttribute('stroke', 'inherit')
        ..setAttribute('stroke-width', '1');
    _yAxis = new s.LineElement()
        ..setAttribute('stroke', 'inherit')
        ..setAttribute('stroke-width', '1');
    _axis = new s.GElement()
        ..setAttribute('stroke', color)
        ..append(_xAxis)
        ..append(_yAxis);
    _xGraphAxis = new s.LineElement()
        ..setAttribute('stroke', 'inherit')
        ..setAttribute('stroke-width', '.5');
    _yGraphAxis = new s.LineElement()
        ..setAttribute('stroke', 'inherit')
        ..setAttribute('stroke-width', '.5');
    _graphBorder = new s.GElement()
        ..setAttribute('stroke', 'black')
        ..append(_xGraphAxis)
        ..append(_yGraphAxis);
    _element = new s.GElement()
        ..append(_graphBorder)
        ..append(_axis);
  }
  
  void _calculatePosition() {
    num svgHeight = puffer.svgHeight;
    num svgWidth = puffer.svgWidth;
    num graphHeight = puffer.height; // 10% of the height
    num graphWidth = puffer.width; // 10% of the width
    
    _gStartX = puffer.graphStartX;
    _gStartY = puffer.graphStartY;
    _gEndX = puffer.graphEndX;
    _gEndY = puffer.graphEndY;

    _calculateGraphAxis();
    _calculateXYAxis();

  }

  
  void _calculateGraphAxis() {
    _xGraphAxis..setAttribute('x1', '$_gStartX')
        ..setAttribute('x2', '$_gEndX')
        ..setAttribute('y1', '$_gEndY')
        ..setAttribute('y2', '$_gEndY');
    
    _yGraphAxis..setAttribute('y1', '$_gStartY')
        ..setAttribute('y2', '$_gEndY')
        ..setAttribute('x1', '$_gStartX')
        ..setAttribute('x2', '$_gStartX');
  }

  void _calculateXYAxis() {
    var y0 = (0 - puffer._minY) / (puffer._maxY - puffer._minY) * puffer.height;
    y0 = puffer.height - y0;
    
    if(puffer._minY != 0) { // X axis raise/lower depending on min Y value
      _xAxis..setAttribute('x1', '$_gStartX')
          ..setAttribute('x2', '$_gEndX')
          ..setAttribute('y1', '$y0')
          ..setAttribute('y2', '$y0');
    } else {
      // Would be same position as Graph axis. Just remove it.
      _xAxis.remove();
    }

    var x0 = (0 - puffer._minX) / (puffer._maxX - puffer._minX) * puffer.width;
    x0 += _gStartX;
    
    if(puffer._minX != 0) {
      _yAxis..setAttribute('y1', '$_gStartY')
          ..setAttribute('y2', '$_gEndY')
          ..setAttribute('x1', '$x0')
          ..setAttribute('x2', '$x0');
    } else {
      // Would be same position as Graph axis, just remove it.
      _yAxis.remove();
    }
  }
  
  void addPoint(xVal, yVal) => 
      throw new UnsupportedError('Cannot add points to an axis');
}