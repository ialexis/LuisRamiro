//
//  Poema.m
//  Luis Ramiro
//
//  Created by Ivan on 01/11/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "Poema.h"

@implementation Poema
-(id) initWithId: (NSString *) aID_Poema
          titulo:(NSString *)aTitulo
           fecha:(NSString *)aFecha
           poema:(NSString *)aPoema
{
    if (self=[super init])
    {
        _ID_Poema=aID_Poema;
        _Titulo=aTitulo;
        _Fecha=aFecha;
        _Poema=aPoema;
    }
    return self;
    
}

@end
