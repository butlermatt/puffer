part of puffer.puffer;

class _PufferAxis implements PufferGraph {
  final Puffer puffer;
  String label;
  String color;
  
  s.SvgElement get element => _axis;
  
  s.GElement _axis;
  s.LineElement _xAxis; // Actual x axis 
  s.LineElement _yAxis;
  s.LineElement _xGraphAxis;
  s.LineElement _yGraphAxis;
  
  _PufferAxis(this.puffer, this.label, this.color) {
    if(color == null) color = 'black';
    
    _xAxis = new s.LineElement()
        ..setAttribute('stroke', 'inherit')
        ..setAttribute('stroke-width', '1');
    _xGraphAxis = new s.LineElement()
        ..setAttribute('stroke', 'inherit')
        ..setAttribute('stroke-width', '1');
    _yAxis = new s.LineElement()
        ..setAttribute('stroke', 'inherit')
        ..setAttribute('stroke-width', '1');
    _yGraphAxis = new s.LineElement()
        ..setAttribute('stroke', 'inherit')
        ..setAttribute('stroke-width', '1');
    _axis = new s.GElement()
        ..setAttribute('stroke', color)
        ..append(_xAxis)
        ..append(_xGraphAxis)
        ..append(_yAxis)
        ..append(_yGraphAxis);
  }
  
  void _calculatePosition() {
    num svgHeight = puffer.svgHeight;
    num svgWidth = puffer.svgWidth;
    num graphHeight = puffer.height; // 10% of the height
    num graphWidth = puffer.width; // 10% of the width

    
    var x = (0 - puffer._minX) / (puffer._maxX - puffer._minX) * graphWidth;
    x += puffer.xOffset;
    var y = (0 - puffer._minY) / (puffer._maxY - puffer._minY) * graphHeight;
    y = graphHeight - y;
    
    _xGraphAxis..setAttribute('x1', '${puffer.xOffset}')
        ..setAttribute('x2', '$svgWidth')
        ..setAttribute('y1', '$graphHeight')
        ..setAttribute('y2', '$graphHeight');
    
    _yGraphAxis..setAttribute('y1', '0')
        ..setAttribute('y2', '$graphHeight')
        ..setAttribute('x1', '${puffer.xOffset}')
        ..setAttribute('x2', '${puffer.xOffset}');
    
    if(puffer._minY != 0) {
      _xAxis..setAttribute('x1', '${puffer.xOffset}')
          ..setAttribute('x2', '$svgWidth')
          ..setAttribute('y1', '$y')
          ..setAttribute('y2', '$y');
    } else {
      // Would be same position as Graph axis. Just remove it.
      _xAxis.remove();
    }

    if(puffer._minX != 0) {
      _yAxis..setAttribute('y1', '0')
          ..setAttribute('y2', '$graphHeight')
          ..setAttribute('x1', '$x')
          ..setAttribute('x2', '$x');
    } else {
      // Would be same position as Graph axis, just remove it.
      _yAxis.remove();
    }
  }
  
  void addPoint(xVal, yVal) => 
      throw new UnsupportedError('Cannot add points to an axis');
}