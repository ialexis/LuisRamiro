//
//  Disco.h
//  Luis Ramiro
//
//  Created by Ivan on 06/11/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Disco : NSObject
{
        AppDelegate *appDelegate;
       NSMutableArray *aCanciones;
}

@property(nonatomic, strong) NSString *ID_Disco;
@property(nonatomic, strong) NSString *Titulo;
@property(nonatomic, strong) NSString *Descripcion;
@property(nonatomic, strong) NSString *Discografica;
@property(nonatomic, strong) NSString *Fecha;
@property(nonatomic, strong) NSString *Url_Imagen;
@property(nonatomic, strong) NSMutableArray *aCanciones;



-(id) initWithId: (NSString *) aID_Disco
          titulo: (NSString *) aTitulo
     descripcion: (NSString *) aDescripcion
    discografica: (NSString *) aDiscografica
           fecha: (NSString *) aFecha
      url_imagem: (NSString *) aUrl_Imagen;

-(NSMutableArray *) CargarCanciones;

@end
