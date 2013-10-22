

#import "XLIntrospectDemoCode.h"

IntrospectBlock introspect = ^Matryoshka(Matryoshka innerMatryoshka){
    // Define and return a Matryoshka
	static NSInteger counter = 1;
	NSInteger currentCount = counter++;
	// NSLog(@"create introspect, counter: %d", currentCount);
    return ^(){
        NSLog(@"before advice, counter: %d", currentCount);
		if (innerMatryoshka) {innerMatryoshka();}
        NSLog(@"after advice, counter %d", currentCount);
    };
};

IntrospectBlock introspect1 = ^Matryoshka(Matryoshka innerMatryoshka){
    /// Define and return a Matryoshka
	// NSLog(@"create introspect 1");
    return ^(){
        NSLog(@"before advice 1");
        if (innerMatryoshka) {innerMatryoshka();}
        NSLog(@"after advice 1");
    };
};

// A fancy style to describe an introspection (IntrospectBlock) using XIntrospectExtension
IntrospectBlock introspect2 = DescribeIntrospection
NSLog(@"before advice 2");
ContinueNextIntrospection
NSLog(@"after advice 2");
EndDescribeIntrospection

// A fancy style to describe an introspection (IntrospectBlock) using XIntrospectExtension
IntrospectBlock introspect3 = DescribeIntrospection
NSLog(@"before advice 3");
ContinueNextIntrospection
NSLog(@"after advice 3");
EndDescribeIntrospection

IntrospectBlock mainTask = ^Matryoshka(Matryoshka innerMatryoshka){
	// Define and return a Matryoshka
    return ^(){
        NSLog(@"Here's the main task");
    };
};

