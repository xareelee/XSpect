

//  Copyright (c) 2013 Xaree Lee. All rights reserved.



#import "XIntrospectCore.h"


/**
 To define a IntrospectBlock easily, you can use the following macros.
 */
#define DescribeIntrospection ^Matryoshka(Matryoshka innerMatryoshka){ return ^(){

#define EndDescribeIntrospection };};

#define ContinueNextIntrospection if (innerMatryoshka) {innerMatryoshka();}



/**
 
 To use IntrospectBlock(s) with those macros, you should put the IntrospectBlock(s) in one of the following format.
 
 1. Just using defined IntrospectBlock(s):
	
         Introspect
         // List IntrospectBlock(s) here. Every IntrospectBlock(s) should end with a comma (,).
         // ...
 
         EndIntrospect
 
 2. Using defined IntrospectBlock(s) and a block to do addtional code:
 
		 Introspect
		 // List IntrospectBlock(s) here. Every IntrospectBlock(s) should end with a comma (,).
		 // ...
		 
		 MainTask
		 // Add code here. This is inside a Matryoshka block.
 
		 EndIntrospection

 
 */
#define Introspect Matryoshka matryoshka = assembleMatryoshka(

#define MainTask DescribeIntrospection

#define FurtherIntrospect };},

#define EndIntrospectio1 nil);  \
if (matryoshka) {matryoshka();}

#define EndIntrospection FurtherIntrospect EndIntrospectio1	// Combine FurtherIntrospect and EndIntrospectio1



