# ObjCViz

This is based on [an earlier ObjCViz](http://people.no-distance.net/ol/software/objcviz/) project, by [@olg](http://twitter.com/olg). I just updated it to work with the modern objective-c runtime.

## Usage

Currently you have to link the classes you want to inspect into this project's binary, then call `-[obj graphvizRepresentation]` on the interesting object. A better UI may be forthcoming.

## License

See `LICENSE.txt`.