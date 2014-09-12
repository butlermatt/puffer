part of puffer.puffer;

class _PufferAxis implements PufferGraph {
  final Puffer puffer;
  String label;
  String color;
  bool hAxisGridline;
  
  s.SvgElement get element => _element;
  
  s.GElement _axis;
  s.GElement _graphBorder;
  s.GElement _axisLabels;
  s.GElement _chartLines; // Maybe?
  s.GElement _element;
  s.LineElement _xAxis; // Actual x axis 
  s.LineElement _yAxis;
  s.LineElement _xGraphAxis;
  
  var _gStartX;
  var _gStartY;
  var _gEndX;
  var _gEndY;
  
  _PufferAxis(this.puffer, this.label, this.color, this.hAxisGridline) {
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
        ..setAttribute('stroke-width', '1');
    _graphBorder = new s.GElement()
        ..setAttribute('stroke', 'DimGray')
        ..append(_xGraphAxis);
    _axisLabels = new s.GElement();
    _element = new s.GElement()
        ..append(_graphBorder)
        ..append(_axis)
        ..append(_axisLabels);
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
    _calculateAxisLabels();

  }

  
  void _calculateGraphAxis() {
    _xGraphAxis..setAttribute('x1', '$_gStartX')
        ..setAttribute('x2', '$_gEndX')
        ..setAttribute('y1', '$_gEndY')
        ..setAttribute('y2', '$_gEndY');
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
  
  void _calculateAxisLabels() {
    // Calculate Y-Axis 0 point.
    var zeroLabel = new s.TextElement()
        ..text = '0'
        ..setAttribute('text-anchor', 'middle');
    var x;
    if(puffer._minX != 0) {
      x = _calcXPos(0);
    } else {
      x = _gStartX;
    }
    var y;
    y = _gEndY + 25;
    zeroLabel..setAttribute('x', '$x')
        ..setAttribute('y', '$y');
    _axisLabels.append(zeroLabel);
    
    // Calculate X-Axis 0 point.
    zeroLabel = new s.TextElement()
        ..text = '0'
        ..setAttribute('text-anchor', 'end');
    
    x = _gStartX - 15;
    if(puffer._minY != 0) {
      y = _calcYPos(0);
    } else {
      y = _gEndY;
    }
    y += 7;
    zeroLabel..setAttribute('x', '$x')
        ..setAttribute('y', '$y');
    _axisLabels.append(zeroLabel);
    
    final num_points_x = 10;
    final num_points_y = 7;
    var xDelta = puffer._maxX - puffer._minX;
    var step = (xDelta / num_points_x).ceil();
    
    var lbl;
    var py = _gEndY + 25; // Constant for X values
    // Calculate X labels below 0
    var pt = 0 - step;
    while(pt >= puffer._minX) {
      var px = _calcXPos(pt);
      lbl = new s.TextElement()
          ..setAttribute('text-anchor', 'middle')
          ..text = '$pt'
          ..setAttribute('x', '$px')
          ..setAttribute('y', '$py');
      _axisLabels.append(lbl);
      pt = pt - step;
    }
    
    // Calculate x Labels above 0
    pt = 0 + step;
    while(pt <= puffer._maxX) {
      var px = _calcXPos(pt);
      lbl = new s.TextElement()
          ..setAttribute('text-anchor', 'middle')
          ..text = '$pt'
          ..setAttribute('x', '$px')
          ..setAttribute('y', '$py');
      _axisLabels.append(lbl);
      pt += step;
    }
    
    var yDelta = puffer._maxY - puffer._minY;
    step = (yDelta / num_points_y).ceil();
    var px = _gStartX - 15;
    
    // Calculate y labels below 0
    pt = 0 - step;
    while(pt >= puffer._minY) {
      py = _calcYPos(pt);
      if(hAxisGridline) {
        var line = new s.LineElement()
            ..setAttribute('y1', '$py')
            ..setAttribute('y2', '$py')
            ..setAttribute('x1', '${puffer.graphStartX}')
            ..setAttribute('x2', '${puffer.graphEndX}');
        _graphBorder.append(line);
      }
      
      py += 6; // Move down a few pixels to center text
      lbl = new s.TextElement()
          ..setAttribute('text-anchor', 'end')
          ..text = '$pt'
          ..setAttribute('x', '$px')
          ..setAttribute('y', '$py');
      _axisLabels.append(lbl);
      pt = pt - step;
    }
    
    pt = 0 + step;
    while(pt <= puffer._maxY) {
      py = _calcYPos(pt);
      if(hAxisGridline) {
        var line = new s.LineElement()
            ..setAttribute('y1', '$py')
            ..setAttribute('y2', '$py')
            ..setAttribute('x1', '${puffer.graphStartX}')
            ..setAttribute('x2', '${puffer.graphEndX}');
        _graphBorder.append(line);
      }
      
      py += 6; // Move down a few pixels to center text
      lbl = new s.TextElement()
          ..setAttribute('text-anchor', 'end')
          ..text = '$pt'
          ..setAttribute('x', '$px')
          ..setAttribute('y', '$py');
      _axisLabels.append(lbl);
      pt += step;
    }
  }
  
  // Calculate the pixel x coordinates based on x-graph value
  num _calcXPos(num xVal) {
    var x = (xVal - puffer._minX) / (puffer._maxX - puffer._minX) * puffer.width;
    x += puffer.xOffset;
    return x;
  }
  
// Calculate the pixel y coordinates based on y-graph value
  num _calcYPos(num yVal) {
    num y = (yVal - puffer._minY) / (puffer._maxY - puffer._minY) *
            puffer.height;
    y = (puffer.height - y) + puffer.yOffset;
    return y;
  }
  
  void addPoint(xVal, yVal) => 
      throw new UnsupportedError('Cannot add points to an axis');
}