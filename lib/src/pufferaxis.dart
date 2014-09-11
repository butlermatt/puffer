part of puffer.puffer;

class _PufferAxis implements PufferGraph {
  final Puffer puffer;
  String label;
  String color;
  
  s.SvgElement get element => _axis;
  
  s.GElement _axis;
  s.LineElement _xAxis;
  s.LineElement _yAxis;
  
  _PufferAxis(this.puffer, this.label, this.color) {
    if(color == null) color = 'black';
    
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
  }
  
  void _calculatePosition() {
    num svgHeight = puffer.height;
    num svgWidth = puffer.width;
    var x = (0 - puffer._minX) / (puffer._maxX - puffer._minX) * svgWidth;
    var y = (0 - puffer._minY) / (puffer._maxY - puffer._minY) * svgHeight;
    y = svgHeight - y;
    
    _xAxis..setAttribute('x1', '0')
        ..setAttribute('x2', '$svgWidth')
        ..setAttribute('y1', '$y')
        ..setAttribute('y2', '$y');
    _yAxis..setAttribute('y1', '0')
        ..setAttribute('y2', '$svgHeight')
        ..setAttribute('x1', '$x')
        ..setAttribute('x2', '$x');
  }
  
  void addPoint(xVal, yVal) => 
      throw new UnsupportedError('Cannot add points to an axis');
}