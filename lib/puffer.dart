library puffer.puffer;

import 'dart:svg' as s;

part 'src/pufferaxis.dart';
part 'src/pufferline.dart';
part 'src/pufferpoints.dart';

abstract class PufferGraph {
  String label;
  
  s.SvgElement get element;
  void addPoint(xVal, yVal);
  void _calculatePosition();
}

/// This class is the manager for the graph elements on the SVG image. This 
/// class should be used for adding all graphs. They should not be created
/// manually.
/// 
/// ## Usage ##
/// 
/// Initiate a new instance, and assign the SVG element to a container.
/// 
///     var puffer = new Puffer();
///     querySelector('#container').append(puffer.svg);
/// 
class Puffer {
  /// The Svg image that the graphs will be composed onto. Should be inserted
  /// into the container prior to calling [draw].
  final s.SvgSvgElement svg;
  
  s.PointList _points;
  List<PufferGraph> _myEls;
  PufferAxis _axis;
  num _maxX = 0;
  num _maxY = 0;
  num _minX = 0;
  num _minY = 0;
  
  /// Create a new Puffer instance.
  Puffer() : svg = new s.SvgSvgElement() {
    svg.style..width = '100%'
          ..height = '100%';
    _myEls = new List<PufferGraph>();
    _axis = new PufferAxis(this, null, 'black');
    _myEls.add(_axis);
    svg.append(_axis.element);
  }
  
  /// Create a new Line Graph to be displayed.
  /// 
  /// If [label] is set, the string will be displayed when hovering over
  /// the line graph.
  /// If [color] is specified, the line graph will be displayed with that
  /// color. You may use valid CSS color values. (eg: 'black',
  /// 'rgb(255, 128, 0)', '#f7b', '#f8295a'). Default is 'red'
  /// This method returns a [PufferLine] object to which points may be added.
  PufferLine addPufferLine({String label, String color}) {
    var pl = new PufferLine(this, label, color);
    _myEls.add(pl);
    svg.children.add(pl.element);
    return pl;
  }
  
  /// Create a new Point Graph to be displayed.
  /// 
  /// If [label] is set, the string will be displayed when hovering over
  /// the point graph.
  /// If [color] is specified, the line graph will be displayed with that
  /// color. You may use valid CSS color values. (eg: 'black',
  /// 'rgb(255, 128, 0)', '#f7b', '#f8295a'). Default is 'red'
  /// This method returns a [PufferPointGraph] object to which points may be 
  /// added.
  PufferPointGraph addPufferPointGraph({String label, String color}) {
    var ppg = new PufferPointGraph(this, label, color);
    _myEls.add(ppg);
    svg.append(ppg.element);
    return ppg;
  }
  
  /// Create a new Point to be displayed.
  /// 
  /// If [label] is set, the string will be displayed when hovering over
  /// the point.
  /// If [color] is specified, the line graph will be displayed with that
  /// color. You may use valid CSS color values. (eg: 'black',
  /// 'rgb(255, 128, 0)', '#f7b', '#f8295a'). Default is 'red'
  /// This method returns a [PufferPoint] object.
  PufferPoint addPufferPoint(xVal, yVal, {String label, String color}) {
    var pp = new PufferPoint(this, xVal, yVal, label, color);
    _myEls.add(pp);
    svg.append(pp.element);
    return pp;
  }
  
  /// Returns the width of the SVG Element
  num get width => svg.getBoundingClientRect().width;
  /// Returns the Height of the SVG Element.
  num get height => svg.getBoundingClientRect().height;
  
  /// This method calculates the correct position of all elements on the
  /// graph and displays them.
  void draw() => _myEls.forEach((el) => el._calculatePosition());
  
}
