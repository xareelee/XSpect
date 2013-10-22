

//  Copyright (c) 2013 Xaree Lee. All rights reserved.



#import "XIntrospectCore.h"


#define Introspect Matryoshka matryoshka = assembleMatryoshka(
#define MainTask     ^ Matryoshka(Matryoshka innerMatryoshka){ \
return ^(){

#define EndIntrospection }; \
},nil);     \
if (matryoshka) {matryoshka();}
