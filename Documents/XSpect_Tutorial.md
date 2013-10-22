XSpect Tutorial
===============

> This article only cover brief introductions and demo code for XSpect. 
> For full information, you should read other documentations.

> You can find all the sample code in the [XSpectDemo xcode project][demo project link]. This project using CocoaPods and you should use the `XSpectDemo.xcworkspace` to run the app.

**XSpect** is an open-source library which makes code reusable and maintainable. It contains two independent sub-libraries: 

* [**XApesct**](#XAspect): a way to do [aspect-oriented programming (AOP)][1] for Obj-C using a technique I call **Selector Chain**.
* [**XIntrospect**](#XIntrospect): a way to encapsulate code in the Obj-C blocks for higher reusability and readablity using a technique I call **Block-in-Block**

The purposes of the two libraries are the same: to separate the subtasks from the main task of the code and assembles them when you need. The main difference between XAspect and XIntrospect is how to **"spect"** ([look/see][2]) the chunks of code (advices/subtasks): XAspect spects them from outside of a method; XIntrospect spects them from inside of a method. 

![selector chain][figure 1]

Here is the comparison between XApesct and XIntrospect:

Comparison    | XApesct                       | XIntrospect
------------- | ----------------------------- | --------------------------------------------
Spect         | outside of a method (aspects) | inside of a method (introspection)
Dependency    | independent to the main task  | high relative to main task
Technique     | Selector Chain 	               | Block-in-Block
Reusable unit | Obj-C Categories              | IntrospectBlock (or a function which returns the block)

XApesct and XIntrospect are independent libraries. You can choose only one to use.

<a id="XAspect">XAspect</a>
=======

> This section only demonstrates a brief introduction of XAspect and how to use it.
> For more information about using XAspect, you should read the documentation of XAspect.

XAspect is lightweight library to add code to a method from outside. With XAspect, you can encapsulate all *cross-cutting concerns* in a file for aspect-oriented programming. 

The core idea is simple: redirect the selector of a Obj-C message to your custom implementations to form a "selector chain".

![selector chain][figure 2]

After swapping the original implementation (IMP A) with a recursive category implementation (IMP B), it forms a selector chain (SEL A -> **IMP B** -> SEL B -> **IMP A**). So when you send a message A to the object, it actually executes implementation B just before implementation A.

You can add lots of implementation into the selector chain. For example, if you swap implementation B, C, and D sequentially with method A, the selector chain will start execution at the last implementation you swapped (SEL A -> **IMP D** -> SEL D -> **IMP C** -> SEL C -> **IMP B** -> SEL B -> **IMP A**).

![selector chain with more aspects][figure 3]

With XAspect, you can keep the OCP (open-closed principle) when you need to add aspect code to your project. Because the loading sequence of Obj-C categories may not be easy to predicted, you should not expect that the mutliple aspects depend on specific loading sequence. All aspects should be independent to each others.

How To Use XAspect
-----------------

Using XAsepct is quite easy. You only need to do the following (with only XAspectCore):

1. Create a Obj-C category of the target class. You may delete the header file (.h).
2. Implement a recursive method with the same method signature to the target method excepting the method name in the class category (you can simply add a prefix to it). You can add advice code before and/or after the recursive invocation.
3. Override `+load` method of the class category. Exchange the implementation of the recursive method with the target method (use `SwapClassMethod()` or `SwapInstanceMethod()`).
4. Make sure the original implementation of the target method exists (especially the target method is an optional delegate method).
5. It's Done. Now you can run your app to check that the XAspect works.

XAspectExtension defines some convenient C macros to use XAspect easily. It's recommanded to use those C macros to write XAspect code.

In your aspect file, after importing the XAspect library, you need to redefine the keyword `AtAspect`:

	#import "XAspect.h"			// or #import "XSpect.h"	#undef AtAspect
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

1. The first field is inside of `+load` and only invoked once.
2. The second field is where you implement aspect methods.


XAspect Demo I – Greeting
-------------------------

> You can find the code in the *XSpectDemo xcode project* from the github.

Let's look at the following code in the `-application:didFinishLaunchingWithOptions:`:

	// In the AppDelegate's -application:didFinishLaunchingWithOptions:
	User *user = [User new];
    NSLog(@"The user is: %@", [user userName]);

It creates an instance of User and print the `-userName` on the console. The `-userName` just simply print the string value on the console before returning.

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

You didn't change or write any code in either `AppDelegate`'s `-application:didFinishLaunchingWithOptions:` or `User`'s `-userName`, but you add advices to the `-userName`.

This demo shows how you can add addtional code before and/or after the target method with keeping open-closed principle .

XAspect Demo II – Local Notificaiton
------------------------------------

> You can find the code in the *XSpectDemo xcode project* from the github.

Now, let's do something more progmatic. Assume that you want to add the local notification feature to you app, and there are many buttons which should send the local notification with delay time (or specific fire date).

There are three buttons in `XLViewController` (button 1, button 2, and 'share' button) and one button in `XLFormatViewController` ('remind me 5 sec later' button) should send the local notifications, and when any one local notifiaiton fires, `AppDelegate` can handle it. 

Those methods in the project nearly do nothing (you can try to click them). Let's add some code to implement the feature. Add `Aspect-LocalNotification.m` (in the `<Project_Path>/XSpectDemo/Aspects Demo/`) into the project, and run the app again. Try to click those buttons again, and you will find you launch local notificaitons and the `AppDelegate` handles them.

With object-oriented programming, you may modify four action methods of the four buttons and one delegate method of `AppDelegate`. That means you would modify at least three classes to accomplish the purpose.

But with aspect-oriented programming, the XAspect way, you can write all the code in a file. It's more reusable and maintainable.

XAspect makes those changes in a file, and you can manage them easier. Another example is to write your logs (`NSLog` or **CocoaLumberjack**) in an aspect file for a submodule. With aspect-oriented programming, you can find those log code easily, and choose to turn on/off some logs or all of them (comment out or delete them).

XAspect makes your code more decoupling.

XAspect Demo III – ShareKit
---------------------------

> You can find the code in the *XSpectDemo xcode project* from the github.

XAspect is a design-pattern-like library. You can think XAspect decorates methods. Also, XAspect can be a mediator to glue other 3rd party libraries to your project. It makes submodules decouple from each other. 

For example, [ShareKit][5] is library for sharing. All you need to do with ShareKit are only a few steps:

1. Install ShareKit and include it into your project (you can don)
2. Subclass `DefaultSHKConfigurator` to set your API keys.
3. Register the configurator when app did launch.
4. Create a share item and use action sheet to present it.

It's time to show you how XAspect glues those code. Add `Aspect-ShareKit.m` (in the `<Project_Path>/XSpectDemo/Aspects Demo/`) into the project, and run the app again. Now, the 'share' button will trigger an action sheet to let the user how to share the content.

`Aspect-ShareKit.m` is a reusable file for other projects which also use ShareKit. You just need to reset the API keys and the aspect classes and aspect methods for share event.


<a id="XIntrospect">XIntrospect</a>
===========

> This section only demonstrates a brief introduction of XIntrospect and how to use it.
> For more information about using XIntrospect, you should read the documentation of XIntrospect.

XIntrospect is another lightweight library of XSpect using the **Block-in-Block** technique. With XIntrospect, you can easily add chunks of code to (also, remove from) the main task in the method. The main purpose of XIntrospect is to encapsulate code and flow controls in the blocks to make them more reusable than traditional functions. 

For example, considering you implement a registration page to let users fill in the info for registration, after a user presses the upper-right "register" button, it triggers the method showed below:

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

There are many those checking tasks in a registration page before you send a registration request, and the checking tasks should be easy to read and reuse. Unfortunately, you can't simply use a function to checking a text field like this:

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
		
		// If the user didn't fill out the name field, show an alert view, and avoid to continue registration.
		guardStringShouldHasValue(self.nameField, @"Please fill up the name");
	    
		...	
	}

The problem of using only this function is that you can't stop executing the rest of code of the method. You should add `if` and `return` to deal with it:

	if (guardStringShouldHasValue(self.nameField, @"Please fill up the name")){
		return;
	}

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

The Core of XIntrospect –– Block-in-Block 
-----------------------------------------

The concept of XIntrospect is easy: encapsulate the logic code in a block, and decide how/when to invoke the next block.

### Matryoshka and IntrospectBlock

XIntrospect defines two block types: `Matryoshka` and `IntrospectBlock`.

	typedef void (^Matryoshka)();
	typedef Matryoshka (^IntrospectBlock)(Matryoshka innerMatryoshka);

`Matryoshka` is a block type just like a [matryoshka doll][4]. Each matryoshka may contain another smaller matryoshka inside, and each matryoshka has its own implementation which may differ from others. You don't create a `Matryoshka` directly. Instead, you create a `Matryoshka` inside an `IntrospectBlock`.

`IntrospectBlock` is a block type which takes an inner `Matryoshka` and returns a `Matryoshka`. It is the place where you decide how to use the inner `Matryoshka`. The following shows how to create a `Matryoshka` inside an `IntrospectBlock`:

	IntrospectBlock introspect = ^Matryoshka(Matryoshka innerMatryoshka){
		// Define and return a Matryoshka using innerMatryoshka
	    return ^(){
	        NSLog(@"before advice");
	        // Invoke the inner Matryoshka
			if (innerMatryoshka) {innerMatryoshka();}
	        NSLog(@"after advice");
	    };
	};


There are four kinds of `Matryoshka` which an `IntrospectBlock` can return (that is how you can control the flow of implementation):

`IntrospectBlock` returns | With additional implementation | Without additional implementation
--------------------------| ------------------------------ | ---------------------------------
With executing the inner Matryoshka | A new Matryoshka with the inner Matryoshka | Just the inner Matryoshka
Without executing the inner Matryoshka | A new Matryoshka without the inner Matryoshka | A nil Matryoshka (or an empty Matryoshka)

### Assemble a large Matryoshka

XIntrospect use a variadic function to assemble a large Matryoshka:

	// The list of IntrospectBlock(s) should be terminated with nil.
	Matryoshka assembleMatryoshka(IntrospectBlock introspection, ... );

You may pass as many `IntrospectBlock` as you want to the `assembleMatryoshka()` function. It will start to create a `Matryoshka` at the last `IntrospectBlock` just before the first `nil`, and pass the `Matryoshka` to the previous one `IntrospectBlock` to another `Matryoshka` until through the list to the first `IntrospectBlock`. For example, you can compose a `Matryoshka` as following (you can find the code in the [demo project][demo project link]): 

	Matryoshka matryoshka = assembleMatryoshka(introspect1,
											   introspect2,
											   introspect3,
											   mainTask,
											   nil);


XIntrospectExtension
--------------------

XIntrospectExtension defines many C macros for the ease-of-use of XIntrospect. You can define a `IntrospectBlock` as following:

	IntrospectBlock introspect = DescribeIntrospection   // Start to define an IntrospectBlock
	NSLog(@"before advice");
	ContinueNextIntrospection	// Invoke the inner Matryoshka
	NSLog(@"after advice");
	EndDescribeIntrospection	// End to define an IntrospectBlock

And using IntrospectBlock as following:

	Introspect
	introspect1,	
	introspect2,
	introspect3,
	
	MainTask
	NSLog(@"Here's the main task");
	
	EndIntrospection
	
XIntrospect Demo I – Using XIntrospect with XIntrospectExtension
---------------------

> You can find the code in the *XSpectDemo xcode project* from the github.

The code has been demonstrated in the previous section. When the App launched, the `+introspectDemo` of `MatryoshkaDemo` will be invoked.

You may look into the method, and change the `Demo_Tag_Matryoshka` variable to see different level of XIntrospect execution to do the same thing.

XIntrospect Demo II – Registration Page
---------------------------------------

> You can find the code in the *XSpectDemo xcode project* from the github.

A Registration page is common for a multiple users system. After a user fills up the format, the user will press the 'done' button to send the registration request. But before the app sends the request, the state of UI and the integrity of data should be checked. It's a tedious job to do the numerous validation.

With XIntrospect, you encapsulate each subtask (and flow controls) into a block, and reuse them easily. Take time to look at the `-registerAnAccount:` of `XLFormatViewController`. There are two implementations to do the same thing (you may change the `Demo_Tag_Block_in_Block` variable to 2 to use XIntrospect way).

There are some advantages using XIntrospect:

1. Those IntrospectBlock(s) (or the functions which return IntrospectBlock(s)) are highly reusable. 
2. Your code is cleaner. 
3. Your code is more readable. 


Summary
=======

XSpect is a lightweight library to let you add code to target task/method easily. It keeps OCP and SRP principles, and it makes your code more reusable and maintainable. 

Hope you enjoy this breif tutorial about XSpect.


[demo project link]: ../XSpectDemo/

[1]: http://en.wikipedia.org/wiki/Aspect-oriented_programming
[2]: http://www.prefixsuffix.com/rootsearch.php?field=root&find=spect&searching=yes
[3]: http://en.wikipedia.org/wiki/Open/closed_principle
[4]: http://en.wikipedia.org/wiki/Matryoshka_doll
[5]: http://getsharekit.com

[figure 1]: images/XSpect_illustration.png
[figure 2]: images/Selector_Chain.png
[figure 3]: images/Selector_Chain_with_more_aspects.png