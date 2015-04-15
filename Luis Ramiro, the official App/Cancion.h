//
//  Cancion.h
//  Luis Ramiro
//
//  Created by Ivan on 06/11/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cancion : NSObject

@property(nonatomic, strong) NSString *ID_Cancion;
@property(nonatomic, strong) NSString *Titulo;
@property(nonatomic, strong) NSString *Duracion;
@property(nonatomic, strong) NSString *Enlace;
@property(nonatomic, strong) NSString *letra;



-(id) initWithId: (NSString *) aID_Cancion
          titulo: (NSString *) aTitulo
     descripcion: (NSString *) aDuracion
    discografica: (NSString *) aEnlace;

@end
