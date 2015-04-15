//
//  Cancion.m
//  Luis Ramiro
//
//  Created by Ivan on 06/11/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "Cancion.h"

@implementation Cancion

-(id) initWithId: (NSString *) aID_Cancion
          titulo: (NSString *) aTitulo
     descripcion: (NSString *) aDuracion
    discografica: (NSString *) aEnlace
{
    if (self=[super init])
    {
        _ID_Cancion=aID_Cancion;
        _Titulo=aTitulo;
        _Duracion=aDuracion;
        _Enlace=aEnlace;
    }
    return self;
    
}

@end
