# Puffer - SVG Graphing Library

A Dart-based SVG Graphing library.

*Warning This Library is still under heavy development and is not yet suitable
for production.*

## Defining Graphs

First create a new [Puffer class][Puffer]:

		var puffer = new Puffer();

Then assign the [SVG Element][svg] to the container. *(While not required to be
added at this point, it should be added before we draw the graph so best to do
so immediately)*

		querySelector('div#container').append(puffer.svg);

Next add a graph. Here's a minimal Line graph with default settings:

		var lineGraph = puffer.addPufferLine();

[addPufferLine()][addPufferLine] returns an empty [PufferLine] object.

Now populate the graph with points such as:

		lineGraph..addPoint(0, 25)
		    ..addPoint(2, 50)
		    ..addPoint(4, 50)
		    ..addPoint(6, 75)
		    ..addPoint(8, 100);

Finally we need to draw the graph. The [draw()][draw] method calculates the
correct position for each of the elements.

		puffer.draw();

See the `Example` directory for more examples on adding and displaying graphs.
