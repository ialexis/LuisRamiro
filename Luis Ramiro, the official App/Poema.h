//
//  Poema.h
//  Luis Ramiro
//
//  Created by Ivan on 01/11/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Poema : NSObject

@property(nonatomic, strong) NSString *ID_Poema;
@property(nonatomic, strong) NSString *Titulo;
@property(nonatomic, strong) NSString *Fecha;
@property(nonatomic, strong) NSString *Poema;



-(id) initWithId: (NSString *) aID_Poema
          titulo: (NSString *) aTitulo
           fecha: (NSString *) aFecha
           poema: (NSString *) aPoema;

@end
