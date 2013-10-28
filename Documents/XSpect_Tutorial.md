XSpect Tutorial
===============

> This tutorial demonstrates how XSpect works through code demonstration. 
> For full information, you should read other documentations.

> You can find all the sample code in the [XSpectDemo xcode project][demo project link]. This project uses [CocoaPods][CocoaPods] and to open the project please open `XSpectDemo.xcworkspace`.

Brief Introduction of XSpect
----------------------------

**XSpect** is an open-source library which makes code reusable and maintainable. It contains two independent sub-libraries: 

* [**XApesct**](#XAspect): an implementaiton of [aspect-oriented programming (AOP)][AOP] for Obj-C using method swizzling.
* [**XIntrospect**](#XIntrospect): a way to encapsulate code in the Obj-C blocks for higher reusability and readablity using a technique I call **Block-in-Block**

The purposes of these two libraries are the same: to decouple subtasks from the main task and add them back when you need them. The main difference between XAspect and XIntrospect is how to **"spect"** ([look/see][spect]) the chunks of code ([advices][advice] or subtasks): XAspect *spects* them from outside of a method; XIntrospect *spects* them from inside of a method. 

![selector chain][figure 1]

Here are the comparisons between XApesct and XIntrospect:

Comparison    | XApesct                           | XIntrospect
------------- | --------------------------------- | ------------------------------------
Spect         | outside of a method (aspects)     | inside of a method (introspection)
Dependency    | independent to the main task      | high relative to main task
Technique     | method swizzling (Selector Chain) | Block-in-Block 
Reusable unit | Obj-C Categories                  | IntrospectBlock (or a function which returns the block)
Advantage     | keep OCP principle                | keep SRP principle

XApesct and XIntrospect are independent libraries. You may only choose one to use. 

<a id="XAspect">[XAspect](#XAspect)</a>
=======

> This section only demonstrates a brief introduction of XAspect and how to use it.
> For more information about using XAspect, you should read the documentation of XAspect.

XAspect is a lightweight library to add code to a method from the outside. With XAspect, you can encapsulate all *cross-cutting concerns* in a file for aspect-oriented programming. 

The core idea is simple: redirect the selector of a Obj-C message (via method swizzling) to your custom implementations to form a "selector chain".

![selector chain][figure 2]

After swapping the original implementation (IMP A) with a recursive category implementation (IMP B), it forms a selector chain (SEL A -> **IMP B** -> SEL B -> **IMP A**). So when you send a message A to the object, it actually first executes implementation B before implementation A.

You can append lots of method definitions into the selector chain. For example, if you swap implementation of B, C, and D sequentially with method A, the selector chain will start execution at the last implementation you swapped (SEL A -> **IMP D** -> SEL D -> **IMP C** -> SEL C -> **IMP B** -> SEL B -> **IMP A**).

![selector chain with more aspects][figure 3]

With XAspect, you can follow the [OCP (open-closed principle)][OCP] when you need to add [advices][advice] into your project wihout modifying the original method implementations. Because the loading sequence of Obj-C categories cannot be predetermined, you should not rely on a specific executing sequence when there are multiple advices. All aspects should be independent of each other.

How To Use XAspect
-----------------

Using XAspect is very easy. The core of XAspect is just method swizzling. You only need to do the following (with only XAspectCore):

1. Create a Obj-C category of the target class. You may delete the header file (.h).
2. Implement a recursive method with the same method signature to the target method except the method name in the class category (you can simply add a prefix to it). You can add [advice][advice] code before and/or after the recursive invocation.
3. Override `+load` method of the class category. Exchange the implementations of the recursive method with the target method (use `SwapClassMethod()` or `SwapInstanceMethod()`).
4. Be sure the original implementation of the target method exists (especially when the target method is an optional delegate method).
5. That's it. Now you can run your code to check that the XAspect works.

Think of writing XAspect as writing **target-action**. The **target** is the class of the category, and the **action** is the aspect method. The **aspect** is the class category name and the prefix of the aspect methods.

After swapping the implementations to form a selector chain, your aspect implementations in the selector chain will be invoked when the target message is sent.


### XAspectExtension

XAspectExtension defines some convenient C macros to use XAspect easily. It's recommanded to use these C macros when writing XAspect code.

In your aspect file, after importing the XAspect library, you need to redefine the keyword `AtAspect`:

	// redefine `AtAspect`
	#import "XSpect.h"
	#undef AtAspect
	#define AtAspect TheAspectName

XAspectExtension use this macro variable keyword as the category name and the prefix of aspect method. You can add as many aspect category below as you need. It is recommanded that there is only one redefined `AtAspect` in an aspect file.

Now you can write XAspect (Obj-C categories) with the following style:

	AspectOfClass(User)
	WeaveAspectInstanceMethods(@selector(userName));

	AspectImplementation
	- (NSString *) Aspect(userName){
	    // Add before advice here
	    NSLog(@"Mary ----> Hello, what's your name?");
	    // Invoke recursively
	    NSString *userName = [self Aspect(userName)];
	    // After advice
	    NSLog(@"Mary ----> Greeting, %@.", userName);
	    return userName;
	}
	EndAspect
	
The `AspectOfClass()...AspectImplementation...EndAspect` defines two fields:

1. The first field is inside of `+load` and invoked only once.
2. The second field is where you implement the aspect methods.

In the field between `AspectOfClass()` and `AspectImplementation`, use `WeaveAspectClassMethods()` and `WeaveAspectInstanceMethods()` to swap implementations of multiple target selectors with associated aspect methods (beginning with the aspect name prefix). 

In the field between `AspectImplementation` and `EndAspect`, use `Aspect()` to enclose the method name of implmementation and the recursive invocation. It will add a prefix to the method with the `AtAspect` keyword. `WeaveAspectClassMethods()` and `WeaveAspectInstanceMethods()` will swap the target methods with those prefixed methods.

### Conventions

Here are some conventions using XAspect:

1. The file name should be the *aspect name* (the `AtAspect` macro variable you will redefine) plus a prefix *Aspect-*. For example, if you write an aspect named *Logging*, the file name should be *Aspect-Logging*.
2. If you don't need the header file, just delete it.
3. One aspect file should only contain one aspect. You should redefine the `AtAspect` macro variable at the beginning of the aspect file (just below the `#import "XSpect.h"`).
4. Implement all aspect methods of the same aspect in the same file. No matter how many class categories are your aspect targets.


XAspect Demo I – Greeting
-------------------------

> You can find the code in the *XSpectDemo xcode project* from the github.

Let's look at the following code in the `-application:didFinishLaunchingWithOptions:`:

	// In the AppDelegate's -application:didFinishLaunchingWithOptions:
	User *user = [User new];
    NSLog(@"The user is: %@", [user userName]);

It creates an instance of `User` and print the value returned from `-userName` on the console. The `-userName` inside just simply prints the value on the console before returning.

	- (NSString*)userName{
	    NSString *userName = @"Xaree Lee";
	    NSLog(@"My name? I'm %@", userName);
	    return userName;
	}

If you run this app, you can see the following messages on the Xcode console:
	
	> My name? I'm Xaree Lee
	> The user is: Xaree Lee
	
Now, add the two files, `Aspect-Mary.m` and `Aspect-Jason.m` (in the `<Project_Path>/XSpectDemo/Aspects Demo/`), into the project. Then run the app again. You can see the following messages on the Xcode console:

	> Jason ----> I see you before. I know you are...
	> Mary ----> Hello, what's your name?
	> My name? I'm Xaree Lee
	> Mary ----> Greeting, Xaree Lee.
	> Jason ----> Yeah, yeah. You are Xaree Lee!
	> The user is: Xaree Lee

You didn't change or write any code in either `[AppDelegate -application:didFinishLaunchingWithOptions:]` or `[User -userName]`, but you did add advices to the `-userName`.

This demo shows how you can add additional code before and/or after the target method while obeying the open-closed principle.

XAspect Demo II – Local Notification
------------------------------------

> You can find the code in the *XSpectDemo xcode project* from GitHub.

Now, let's do something more realistic. Assume that you want to add  local notification to you app, and there are many buttons which should send the local notifications with time delays (or some specific firing times).

There are three buttons in `XLViewController` (button 1, button 2, and 'share' button) and one button in `XLFormatViewController` ('remind me 5 sec later' button) should send the local notifications, and when any one local notifiaiton fires, `AppDelegate` can handle it. 

Those methods in the project nearly do nothing (you can try to click them). Let's add some code to implement the feature. Add `Aspect-LocalNotification.m` (in the `<Project_Path>/XSpectDemo/Aspects Demo/`) into the project, and run the app again. Try to click those buttons again, and you will find you launch local notifications and the `AppDelegate` handles them.

With object-oriented programming, you may modify four action methods of the four buttons and one delegate method of `AppDelegate`. That means you would modify at least three classes to accomplish the purpose.

But with aspect-oriented programming, the XAspect way, you can write all the code in a file. It's more reusable and maintainable.

Another example is to write your logs (`NSLog`) in an aspect file for a submodule. With aspect-oriented programming, you can find those log code easily, and choose to turn on/off some logs or all of them (comment out or delete them).

XAspect makes your code more decoupling from other aspect code.

XAspect Demo III – ShareKit
---------------------------

> You can find the code in the *XSpectDemo xcode project* from the github.

XAspect is a design-pattern-like library. You can think of it as decorating the original methods. Also, XAspect can be a mediator to glue other 3rd party libraries to your project. It makes submodules decouple from each other. 

For example, [ShareKit][ShareKit] is library for sharing. All you need to do with ShareKit are only a few steps:

1. Install ShareKit and include it into your project.
2. Subclass `DefaultSHKConfigurator` to set your API keys.
3. Register the configurator when the app did launch.
4. Create a share item and use action sheet to present it.

It's time to show you how XAspect glues those code. Add `Aspect-ShareKit.m` (in the `<Project_Path>/XSpectDemo/Aspects Demo/`) into the project, and run the app again. Now, the 'share' button will trigger an action sheet to let the user choose how to share the content.

`Aspect-ShareKit.m` is a reusable file for other projects also using ShareKit. You just need to reset the API keys and the aspect target-actions (aspect classes and aspect methods) for share event.


<a id="XIntrospect">[XIntrospect](#XIntrospect)</a>
===========

> This section only demonstrates a brief introduction of XIntrospect and how to use it.
> For more information about using XIntrospect, you should read the documentation of XIntrospect.

XIntrospect is another lightweight library of XSpect using the **Block-in-Block** technique. With XIntrospect, you can easily add/remove chunks of code to/from the main task in the method. The main purpose of XIntrospect is to encapsulate code and flow controls in the blocks to make them more reusable than traditional functions. 

For example, considering you implement a registration page to let users fill in the info for registration, after a user presses the "register" navigation bar button, it triggers the method showed below:

	- (IBAction)registerAnAccount:(id)sender{
		...
		
		// If the user didn't fill out the name field, show an alert view, and avoid to continue registration.
	    if (! self.nameField.text ||
	        [self.nameField.text length] == 0) {
        
	        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill in the name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	        [alertView show];
	        return;
	    }
	    
		...	
	}

There are many those checking tasks in the registration page before you send a registration request, and the checking tasks should be easy to read and reuse. Unfortunately, you can't simply use a function to checking a text field like this:

	BOOL guardStringShouldHasValue(NSString *aString, NSString *alertMessage){
		
		if (! aString ||
			[aString length] == 0){
			
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			return NO;
		}
		return YES;
	}

	- (IBAction)registerAnAccount:(id)sender{
		...
		
		guardStringShouldHasValue(self.nameField, @"Please fill up the name");
	    
		...	
	}

The problem of using only this function is that you can't stop executing the rest of code of the method. You should add `if` block and `return` to deal with it:

	...
	
	if (guardStringShouldHasValue(self.nameField, @"Please fill up the name")){
		return;
	}
	
	...

#### XIntrospect comes to rescue this situation.

XIntrospect encapsulates not only subtask code but also the flow controls in blocks. And you can reuse them in an elegant way:

	Introspect		// the C macro to start describing your introspection.
	...
	Guard_StringShouldContainCharacters(self.nameField.text, @"Please fill up the name"),
	...

	MainTask		// the C macro to start describing your main task.
	...
	
	EndIntrospection		// the C macro ot end using the instrospection.

The function `Guard_StringShouldContainCharacters()` actually returns a `XIntrospectBlock` (a block type), and the C macro style sheet `Introspect...MainTask...EndIntrospection` will assemble those blocks in the list into a block and execute it. 

With XIntrospect, your code will be more descriptive, cleaner, and readable.

The Core of XIntrospect –– Block-in-Block 
-----------------------------------------

The concept of XIntrospect is easy: encapsulate the logic code in a block, and decide how and when to invoke the next block.

### Matryoshka and IntrospectBlock

XIntrospect defines two block types: `Matryoshka` and `IntrospectBlock`.

	typedef void (^Matryoshka)();
	typedef Matryoshka (^IntrospectBlock)(Matryoshka innerMatryoshka);

`Matryoshka` is a block type just like a [matryoshka doll][matryoshka doll]. Each matryoshka may contain another smaller matryoshka inside, and each matryoshka has its own implementation which may differs from others. You don't create a `Matryoshka` directly. Instead, you create a `Matryoshka` inside an `IntrospectBlock`.

`IntrospectBlock` is a block type which takes an inner `Matryoshka` and returns a `Matryoshka`. It is the place where you decide how to use the inner `Matryoshka`. The following shows an example to demonstrate how to create a `Matryoshka` inside an `IntrospectBlock`:

	IntrospectBlock introspect = ^Matryoshka(Matryoshka innerMatryoshka){
		// Define and return a Matryoshka using innerMatryoshka
	    return ^(){
	        NSLog(@"before advice");
	        // Invoke the inner Matryoshka
			if (innerMatryoshka) {innerMatryoshka();}
	        NSLog(@"after advice");
	    };
	};


There are four kinds of `Matryoshka` which an `IntrospectBlock` can return (that is how you can control the flow of the implementation):

`IntrospectBlock` returns | With additional implementation | Without additional implementation
--------------------------| ------------------------------ | ---------------------------------
With executing the inner `Matryoshka` | A `Matryoshka` containing the inner `Matryoshka` | Just the inner `Matryoshka`
Without executing the inner `Matryoshka` | A new `Matryoshka` without the inner `Matryoshka` | `nil`  (or an empty `Matryoshka`)

### Assemble a large Matryoshka

XIntrospect use a variadic function to assemble IntrospectBlock(s) into a large `Matryoshka`:

	// The list of IntrospectBlock(s) should be terminated with nil.
	Matryoshka assembleMatryoshka(IntrospectBlock introspection, ... );

You may pass as many `IntrospectBlock` as you want to the `assembleMatryoshka()` function. It will start to create a `Matryoshka` at the last `IntrospectBlock` just before the first `nil`, and pass the `Matryoshka` to the previous one `IntrospectBlock` to another `Matryoshka` until through the list to the first `IntrospectBlock`. 

For example, you can compose a `Matryoshka` as following (you can find the code in the [demo project][demo project link]): 

	Matryoshka matryoshka = assembleMatryoshka(introspect1,
											   introspect2,
											   introspect3,
											   mainTask,
											   nil);


XIntrospectExtension
--------------------

XIntrospectExtension defines many C macros for ease-of-use. You can define a `IntrospectBlock` as follows:

	IntrospectBlock introspect = DescribeIntrospection   // Start to define an IntrospectBlock
	NSLog(@"before advice");
	ContinueNextIntrospection	// Invoke the inner Matryoshka
	NSLog(@"after advice");
	EndDescribeIntrospection	// End to define an IntrospectBlock

And use `IntrospectBlock` as follows:

	Introspect
	introspect1,	
	introspect2,
	introspect3,
	
	MainTask
	NSLog(@"Here's the main task");
	
	EndIntrospection
	
It makes code more descriptive, cleaner and readable.
	
XIntrospect Demo I – Using XIntrospect with XIntrospectExtension
---------------------

> You can find the code in the *XSpectDemo xcode project* from the github.

When the App launched, it will send a message to `[MatryoshkaDemo +introspectDemo]`. Take a look at the following implementation using XIntrospectExtension:

	// This is XIntrospectExtension style sheet (Introspect...MainTask...EndIntrospection).
	Introspect
	introspect1,	// You may add more introspect blocks here (between Introspect...MainTask).
	introspect2,
	introspect3,
	
	MainTask
	NSLog(@"Here's the main task");
	
	EndIntrospection

This is equivalent to:

	Matryoshka matryoshka = ^(){
        NSLog(@"before advice 1");
		
		
		Matryoshka matryoshka_2 = ^(){
			NSLog(@"before advice 2");
			
			
			Matryoshka matryoshka_3 = ^(){
				NSLog(@"before advice 3");
				
				
				Matryoshka matryoshka_main = ^(){
					NSLog(@"Here's the main task");
				};
				if (matryoshka_main) { matryoshka_main(); }
				
				
				NSLog(@"after advice 3");
			};
			if (matryoshka_3) { matryoshka_3(); }
			
			
			NSLog(@"after advice 2");
		};
		if (matryoshka_2) { matryoshka_2(); }
		
		
        NSLog(@"after advice 1");
    };
	if (matryoshka) { matryoshka(); }

Take time to understand the code inside of `+introspectDemo` of the demo project. Some of the code has been demonstrated in the previous section. Make sure you understand how to use XIntrospect to add code before and after the main task. I'll demonstrate how to use XIntrospect to do flow controls in the next section.


XIntrospect Demo II – Registration Page
---------------------------------------

> You can find the code in the *XSpectDemo xcode project* from the github.

A Registration page is common for a multi-user system. After a user fills up the form, the user presses the 'done' button to send the registration request. But before the app sends the request, the state of UI and the integrity of data should be checked. It's a tedious job to do the numerous validation.

With XIntrospect, you encapsulate each subtask (and flow controls) into a block, and reuse them easily. Take the time to look at the `-registerAnAccount:` of `XLFormatViewController`. There are two implementations to do the same thing (you may change the `Demo_Tag_Block_in_Block` variable to 2 to use XIntrospect way).

For example, the following implementation can be encapsulated into a IntrospectBlock for reuse:

    if (! self.nameField.text ||
        [self.nameField.text length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill up the name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }

The IntrospectBlock should be implemented as:

	IntrospectBlock Guard_StringShouldContainCharacters(NSString *string, NSString *alertMessage){
	    
	    if (! string || [string length] == 0) {
	        return ^ Matryoshka(Matryoshka innerMatryoshka){
				return ^(){
					if (alertMessage) {
						UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
						[alertView show];
					}
				};
			};
	    }
	    
	    return ^ Matryoshka(Matryoshka innerMatryoshka){
	        return innerMatryoshka;
	    };
	}

And use this IntrospectBlock in just one line:

	...
	Guard_StringShouldContainCharacters(self.nameField.text, @"Please fill up the name"),
	...

The `Guard_StringShouldContainCharacters()` functions returns two kinds of `IntrospectBlock`:

1. If the test is not passed, it returns an `IntrospectBlock` which only shows an alert and will not invoke the `innerMatryoshka` (stop executing the next block).
2. If the test is passed, it returns an `IntrospectBlock` which does nothing but only invoke the `innerMatryoshka` (continue executing the next block).

Using functions which create `IntrospectBlock` could control the flow (procedure) at three different levels:

1. Function execution level: the place to decide which `IntrospectBlock` to be returned.
2. IntrospectBlock execution level: the place to decide which `Matryoshka` to be returned.
3. Matryoshka execution level: the place to decide whether the inner `Matryoshka` to be invoked or not (a `Matryoshka` should be created inside of an `IntrospectBlock`).

This tutorial only demonstrates the basic use of XIntrospect. XIntrospect could be powerful if all the highly reusable code has been encapsulated in the `IntrospectBlocks` (or their associated functions). XIntrospect help maintains [SRP principle][SRP] to make the chunks of code more reusable.

Summary
=======

XSpect contains two independent lightweight libraries to let you add code to target task/method easily. The methodologies obey OCP and SRP principles, and it makes your code more reusable and maintainable. 

Hope you enjoy this brief tutorial on XSpect.


[CocoaPods]: http://cocoapods.org
[matryoshka doll]: http://en.wikipedia.org/wiki/Matryoshka_doll
[advice]: http://en.wikipedia.org/wiki/Advice_in_aspect-oriented_programming
[ShareKit]: http://getsharekit.com
[AOP]: http://en.wikipedia.org/wiki/Aspect-oriented_programming
[spect]: http://www.prefixsuffix.com/rootsearch.php?field=root&find=spect&searching=yes
[OCP]: http://en.wikipedia.org/wiki/Open/closed_principle
[advice]: https://en.wikipedia.org/wiki/Advice_in_aspect-oriented_programming
[SRP]: http://en.wikipedia.org/wiki/Single_responsibility_principle

[demo project link]: ../XSpectDemo/

[figure 1]: images/XSpect_illustration.png
[figure 2]: images/Selector_Chain.png
[figure 3]: images/Selector_Chain_with_more_aspects.png