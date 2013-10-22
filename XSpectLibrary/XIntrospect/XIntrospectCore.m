

//  Copyright (c) 2013 Xaree Lee. All rights reserved.

#import "XIntrospectCore.h"


Matryoshka __composeIntrospection(IntrospectBlock headBlock, va_list tailBlocks){
    if (headBlock == nil) { return nil; }
    return headBlock(__composeIntrospection(va_arg(tailBlocks, IntrospectBlock), tailBlocks));
}

Matryoshka assembleMatryoshka(IntrospectBlock introspection, ...){
    va_list introspection_list;
    va_start(introspection_list, introspection);
    Matryoshka composedBlock = __composeIntrospection(introspection, introspection_list);
    va_end(introspection_list);
    return composedBlock;
}

