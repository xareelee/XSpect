

//  Copyright (c) 2013 Xaree Lee. All rights reserved.

#import <Foundation/Foundation.h>

/** A block type which will be synthesized by IntrospectionBlock. */
typedef void (^Matryoshka)();

/** A block type which decides how to synthesize AdviceBlock(s) and which one is returned. */
// 3 choices: nil, innerMatryoshka, or a new Matryoshka containing an innerMatryoshka or not.
typedef Matryoshka (^IntrospectBlock)(Matryoshka innerMatryoshka);

/** This function will compose an AdviceBlock according to the serial of IntrospectionBlock(s). It should be terminated with nil. */
Matryoshka assembleMatryoshka(IntrospectBlock introspection, ... )NS_REQUIRES_NIL_TERMINATION;



