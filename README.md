SEGSegmentedViewController
-------------

A UIViewController subclass used to allow choosing the displayed controller via a UISegmentedControl. Sources titles from the contained controllers, or presents icons if you prefer.

###Installation
Until Xcode supports Swift in static libraries, or Cocoapods finds a way to accommodate this, you'll have to drag-n-drop the files into your project.

###Usage
Subclass SegmentedViewController (Swift)/SEGSegmentedViewControll (Obj-C), override viewDidLoad and call one of the many addController overloads to present your controllers. You must instantiate your controllers and provide them at this time (via instantiateViewControllerWithIdentifier on your storyboard, for instance).

###Future Work
- Segues could be used to map relations between the SegmentedViewController and the controllers to be presented within its segments
- Abstracting the segment control implementation is worth considering (so something other than UISegmentedControl could be used)

###License

Available for use under the MIT license: http://bryan.mit-license.org
