//
//  Concierto.m
//  Gumcam
//
//  Created by Ivan on 01/04/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "Concierto.h"

@implementation Concierto
-(id) initWithId: (NSString *) aId_concierto
     fecha_desde: (NSString *) aFecha_desde
     fecha_hasta: (NSString *) aFecha_hasta
      hora_desde: (NSString *) aHora_desde
      hora_hasta: (NSString *) aHora_hasta
          titulo: (NSString *) aTitulo
     descripcion: (NSString *) aDescripcion
     sede_nombre: (NSString *) aSede_nombre
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
   sede_longitud: (NSString *) aSede_longitud
   sede_imagen: (NSString *) aSede_imagen
venta_anticipada:(NSString *)aVenta_Anticipada
          precio: (NSString *)aPrecio
{
    if (self=[super init])
    {
        _id_concierto=aId_concierto;
        _fecha_desde=aFecha_desde;
        _fecha_hasta=aFecha_hasta;
        _hora_desde=aHora_desde;
        _hora_hasta=aHora_hasta;
        _titulo=aTitulo;
        _descripcion=aDescripcion;
        _sede_nombre=aSede_nombre;
        _sede_calle=aSede_calle;
        _sede_numero=aSede_numero;
        _sede_piso=aSede_piso;
        _sede_cp=aSede_cp;
        _sede_localidad=aSede_localidad;
        _sede_provincia=aSede_provincia;
        _sede_pais=aSede_pais;
        _sede_logo=aSede_logo;
        _sede_aforo=aSede_aforo;
        _sede_latitud=aSede_latitud;
        _sede_longitud=aSede_longitud;
        _sede_imagen=aSede_imagen;
        _venta_anticipada=aVenta_Anticipada;
        _precio=aPrecio;
    }
    return self;

}

@end
