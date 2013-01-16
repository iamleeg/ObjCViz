# ObjCViz

This is based on [an earlier ObjCViz](http://people.no-distance.net/ol/software/objcviz/) project, by [@olg](http://twitter.com/olg). I just updated it to work with the modern objective-c runtime.

## Usage

Currently you have to link the framework built by this project into your app, then call `-[obj graphvizRepresentation]` on the interesting object. A better UI may be forthcoming.

## Results

See the example at the original project page above. Notice that this isn't generating class or interaction diagrams, it's a graph representing the _current, live_ state of the object.

## License

See `LICENSE.txt`.