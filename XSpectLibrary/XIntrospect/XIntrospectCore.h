

//  Copyright (c) 2013 Xaree Lee. All rights reserved.

#import <Foundation/Foundation.h>

/** A block type which will be synthesized by IntrospectionBlock. */
typedef void (^Matryoshka)();

/** 
 A block type which decides how to synthesize Matryoshka(s) and which one is returned.
 
 There are four kinds of Matryoshka which an IntrospectBlock can return:
 
 1. nil
 2. just the innerMatryoshka
 3. a new Matryoshka with an innerMatryoshka
 4. a new Matryoshka without an innerMatryoshka
 
 */
typedef Matryoshka (^IntrospectBlock)(Matryoshka innerMatryoshka);

/** This function will assemble a Matryoshka according to the IntrospectionBlock(s) in the list. It should be terminated with nil. */
Matryoshka assembleMatryoshka(IntrospectBlock introspection, ... )NS_REQUIRES_NIL_TERMINATION;



