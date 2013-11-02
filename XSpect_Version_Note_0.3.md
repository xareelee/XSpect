





### Version 0.3

* Rewrite XAspectCore. 
	* Now XAspect will inject an empty function if there is no implementation of target selector before swapping implementations. 
	* Add some assertion to check the parameters.
* Rename some macros in the XAspectExtension.
* Change XAspectExtension to XAspectStyleSheet, and XIntrospectExtension to XIntrospectStyleSheet. 

#### Migration Guide From 0.2 to 0.3

* Now XAspectCore will check whether the implementation of the target selector exists before swapping. If not, XAspectCore will inject an empty function.

### Version 0.2 

* Add and rename some macros for XAspectExtension and XIntrosepctExtension.

#### Migration Guid From 0.1 to 0.2

* Change `WeaveAspectOfClassMethods()` to `WeaveAspectClassMethods()`

### Version 0.1

* Add XAspectCore and XAspectExtension.
* Add XIntrospectCore and XIntrosepctExtension.