//
//  Concierto.h
//  Gumcam
//
//  Created by Ivan on 01/04/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Concierto : NSObject

@property(nonatomic, strong) NSString *id_concierto;
@property(nonatomic, strong) NSString *fecha_desde;
@property(nonatomic, strong) NSString *fecha_hasta;
@property(nonatomic, strong) NSString *hora_desde;
@property(nonatomic, strong) NSString *hora_hasta;
@property(nonatomic, strong) NSString *titulo;
@property(nonatomic, strong) NSString *descripcion;
@property(nonatomic, strong) NSString *sede_calle;
@property(nonatomic, strong) NSString *sede_numero;
@property(nonatomic, strong) NSString *sede_piso;
@property(nonatomic, strong) NSString *sede_cp;
@property(nonatomic, strong) NSString *sede_localidad;
@property(nonatomic, strong) NSString *sede_provincia;
@property(nonatomic, strong) NSString *sede_pais;
@property(nonatomic, strong) NSString *sede_logo;
@property(nonatomic, strong) NSString *sede_aforo;
@property(nonatomic, strong) NSString *sede_latitud;
@property(nonatomic, strong) NSString *sede_longitud;

-(id) initWithId: (NSString *) aId_concierto
     fecha_desde: (NSString *) aFecha_desde
     fecha_hasta: (NSString *) aFecha_hasta
      hora_desde: (NSString *) aHora_desde
      hora_hasta: (NSString *) aHora_hasta
          titulo: (NSString *) aTitulo
     descripcion: (NSString *) aDescripcion
      sede_calle: (NSString *) aSede_calle
     sede_numero: (NSString *) aSede_numero
       sede_piso: (NSString *) aSede_piso
         sede_cp: (NSString *) aSede_cp
  sede_localidad: (NSString *) aSede_localidad
  sede_provincia: (NSString *) aSede_provincia
       sede_pais: (NSString *) aSede_pais
       sede_logo: (NSString *) aSede_logo
      sede_aforo: (NSString *) aSede_aforo
   sede_latitude: (NSString *) aSede_latitud
   sede_longitud: (NSString *) aSede_longitud;

@end
