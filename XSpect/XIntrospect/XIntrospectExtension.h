

//  Copyright (c) 2013 Xaree Lee. All rights reserved.



#import "XIntrospectCore.h"


#define Introspect Matryoshka matryoshka = assembleMatryoshka(
#define MainTask     ^ Matryoshka(Matryoshka innerBlock){ \
return ^(){

#define EndIntrospection }; \
},nil);     \
if (matryoshka) {matryoshka();}
