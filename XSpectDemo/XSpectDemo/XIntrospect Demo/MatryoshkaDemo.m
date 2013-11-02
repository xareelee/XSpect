

#import "MatryoshkaDemo.h"

#import "XSpect.h"
#import "XLIntrospectDemoCode.h"

@implementation MatryoshkaDemo

+ (void)introspectDemo{
	
	
	// ==================
	// You can change the value of `Demo_Tag_Matryoshka` macro varialbe to choose the implementation to be compiled.
	// Those implementations should be logically the same.
	#define Demo_Tag_Matryoshka 1
	// ==================
	
#if Demo_Tag_Matryoshka == 1
	NSLog(@"Demo_Tag_Matryoshka (1)");
	NSLog(@"----");
	
	// This is XIntrospectStyleSheet style sheet (Introspect...MainTask...EndIntrospection).
	Introspect
	introspect1,	// You may add more introspect blocks here (between Introspect...MainTask).
	introspect2,
	introspect3,
	
	MainTask
	NSLog(@"Here's the main task");
	
	EndIntrospection
	
	return;
	
#endif
	
	// ==========================
#if Demo_Tag_Matryoshka == 2
	NSLog(@"Demo_Tag_Matryoshka (2)");
	NSLog(@"----");
	// This implementation removes C macros.
	Matryoshka matryoshka = assembleMatryoshka(introspect1,
											   introspect2,
											   introspect3,
											   
											   // mainTask
											   ^ Matryoshka(Matryoshka innerMatryoshka){
												   return ^(){
													   NSLog(@"Here's the main task");
												   };
											   },
											   
											   nil);
	
	if (matryoshka) {
		matryoshka();
	}
	
	return;
#endif
	
	// ==========================
#if Demo_Tag_Matryoshka == 3
	NSLog(@"Demo_Tag_Matryoshka (3)");
	NSLog(@"----");
	// Without using `assembleMatryoshka()` function to assemble a matryoshk block by a serial of introspect block invocations.
	Matryoshka matryoshka = introspect1(introspect2(introspect3(mainTask(nil))));
	
	if (matryoshka) {
		matryoshka();
	}
	
	return;
	
#endif
	
	// ==========================
#if Demo_Tag_Matryoshka == 4
	NSLog(@"Demo_Tag_Matryoshka (4)");
	NSLog(@"----");
	// Assemble into a large Matryoshka step by step.
	
	Matryoshka matryoshka;
	matryoshka = mainTask(nil);
	matryoshka = introspect3(matryoshka);
	matryoshka = introspect2(matryoshka);
	matryoshka = introspect1(matryoshka);
	
	if (matryoshka) { matryoshka(); }
	
	return;
	
#endif
	
	// ==========================
#if Demo_Tag_Matryoshka == 5
	NSLog(@"Demo_Tag_Matryoshka (5)");
	NSLog(@"----");
	// Brief results after IntrospectBlock invocation.

	Matryoshka matryoshka_main = ^(){
        NSLog(@"Here's the main task");
	};
	
	Matryoshka matryoshka_3 = ^(){
		NSLog(@"before advice 3");
		matryoshka_main();
		NSLog(@"after advice 3");
	};
	
	Matryoshka matryoshka_2 = ^(){
		NSLog(@"before advice 2");
		matryoshka_3();
		NSLog(@"after advice 2");
	};
	
	Matryoshka matryoshka = ^(){
		NSLog(@"before advice 1");
		matryoshka_2();
		NSLog(@"after advice 1");
	};

	if (matryoshka) { matryoshka(); }

	return;

#endif

	// ==========================
#if Demo_Tag_Matryoshka == 6
	NSLog(@"Demo_Tag_Matryoshka (6)");
	NSLog(@"----");
	// Without using IntrospectBlock/Matryoshka to encapsulate code.
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
	
	return;
	
#endif
}

@end
