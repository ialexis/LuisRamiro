//
//  Disco.m
//  Luis Ramiro
//
//  Created by Ivan on 06/11/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "Disco.h"
#import "Cancion.h"

@implementation Disco
{
    
}
@synthesize aCanciones;

-(id) initWithId: (NSString *) aID_Disco
          titulo: (NSString *) aTitulo
     descripcion: (NSString *) aDescripcion
    discografica: (NSString *) aDiscografica
           fecha: (NSString *) aFecha
      url_imagem: (NSString *) aUrl_Imagen
{
    if (self=[super init])
    {
        _ID_Disco=aID_Disco;
        _Titulo=aTitulo;
        _Descripcion=aDescripcion;
        _Discografica=aDiscografica;
        _Fecha=aFecha;
        _Url_Imagen=aUrl_Imagen;
        
        [self CargarCanciones];
        aCanciones=self.aCanciones;
    }


    return self;
    
}


-(NSMutableArray *) CargarCanciones
{
    NSLog(@"entrando en loadConciertos");
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    aCanciones = [[NSMutableArray alloc] init ];
    
    sqlite3 *database;
    
    
    sqlite3_stmt *compiledStatement;
    
    // Abrimos la base de datos de la ruta indicada en el delegate
    if(sqlite3_open([appDelegate.databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        
        NSLog(@"abrimos la base de datos %@ - %@",@"hola",appDelegate.databasePath2);
        
        
        // Podríamos seleccionar solo algunos, o todos en el orden deseado así:
        // NSString *sqlStatement = [NSString stringWithFormat:@"seletc id_tutorial, sistema, nombre, terminado from Tutoriales"];
        NSString *sqlStatement = [NSString stringWithFormat:@"SELECT  D.NUM_CANCION, C.TITULO, C.DURACION, C.URL,C.LETRA FROM Discos A, Disco_Cancion D, Canciones C Where D.ID_Disco=A.ID_Disco and C.ID_Cancion=D.ID_Cancion and A.ID_Disco=%@ order by NUM_CANCION",self.ID_Disco];
        //NSString *sqlStatement = [NSString stringWithFormat:@"select * from Personas"];
        
        //   NSString *anyoActual=@"";
        //   NSString *mesActual=@"";
        
        //   NSString *mes_anyo_concierto =@"";
        
        //   NSString *anyoYaRealizadas=@"";
        //   NSMutableArray *actividades=[[NSMutableArray alloc] init];
        //   NSMutableArray *actividades_ya_realizadas=[[NSMutableArray alloc] init];
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            NSLog(@"lanzamos la consulta la base de datos");
            
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                // Leemos las columnas necesarias. Aunque algunos valores son numéricos, prefiero recuperarlos en string y convertirlos luego, porque da menos problemas.
                NSString *id_cancion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *titulo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *duracion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *URL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *letra = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];

                
                Cancion *auxCancion = [[Cancion alloc]init];
                auxCancion.ID_Cancion = id_cancion;
                auxCancion.Titulo = titulo;
                auxCancion.Duracion = duracion;
                auxCancion.Enlace=URL;
                auxCancion.letra=letra;
                
                [aCanciones addObject:auxCancion];
                
                //NSLog(@"miembros junta count = %@",foto_bio);
                
                
            }
            
            
        }
        else {
            // Informo si ha habido algún error
            NSLog(@"No hay registros en la base de datos");
            
            
        }
        
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        
    }
    // Cierro la base de datos
    sqlite3_close(database);
    return aCanciones;

}
@end
