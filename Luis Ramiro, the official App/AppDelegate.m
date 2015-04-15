//
//  AppDelegate.m
//  Luis Ramiro, the official App
//
//  Created by Ivan on 11/10/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation AppDelegate
{
    // NSString *DatabaseName;
    // NSString *DatabasePath;

    NSMutableArray *aCanciones;
    NSMutableArray *aConciertos;
    NSMutableArray *aPoemas;
    NSMutableArray *aDiscos;
    NSMutableArray *aSedes;
    NSMutableArray *aGaleriaFotos;
    NSMutableArray *aDiscosCanciones;
    NSMutableArray *aGeneral;
    NSMutableArray *aBajas;
    
    
    NSString *statusActual;
    
    
    NSMutableDictionary *currentDic;
    
    NSMutableString *currentNode;
    Boolean descripcionAsignada;
    Boolean tituloAsignado;
    NSMutableArray *noticias_publicas;
    NSMutableArray *noticias_privadas;
    NSString *tipofeed;
    
}

// Variables para que el resto de clases encuentren la base de datos.
@synthesize databaseName, databasePath,databaseName2, databasePath2,PulgadasDispositivo,noticias,UsuarioActual,url_cancion_actual,reproductor,database;


-(void) CargarBaseDatos
{
    BOOL Exito;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *Error;
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory=[paths objectAtIndex:0];
    NSString *writetableDBPath = [libraryDirectory stringByAppendingPathComponent:@"LuisRamiro2.sqlite"];
    
    Exito=[fileManager fileExistsAtPath:writetableDBPath];
    if (Exito) {
        NSLog(@"Todo bueno al cargar BD2,ya existia el fichero");
        //return;
    }
    else
    {
        
        NSString *defaultDBPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LuisRamiro2.sqlite"];
        
        Exito = [fileManager copyItemAtPath:defaultDBPath toPath:writetableDBPath error:&Error];
        
        if (!Exito)
        {
            NSLog(@"Erroraco al cargar BD%@",[Error localizedDescription]);
        }
        else{
            NSLog(@"Todo bueno al cargar BD2,se ha copiado el fichero");
            
        }
    }
}

-(void) RellenarBD
{
    
#define kSITIO_WEB "www.google.com"
    
    
    SCNetworkReachabilityRef referencia = SCNetworkReachabilityCreateWithName (kCFAllocatorDefault, kSITIO_WEB);
      SCNetworkReachabilityFlags resultado;
    
    SCNetworkReachabilityGetFlags ( referencia, &resultado );
    
    CFRelease(referencia);
    
    if (resultado & kSCNetworkReachabilityFlagsReachable) {
        hayInternet=@"SI";
        //Creamos un hilo para importar la base de datos desde el WS
        
      /*  NSOperationQueue *queue=[NSOperationQueue new];
        NSInvocationOperation *operacion=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(ImportarBaseDatosDesdeFeed) object:nil];
        [queue addOperation:operacion];
        */
       
        //Creamos un hilo para importar la base de datos desde el WS
        [self ImportarBaseDatosDesdeFeed];
        
        //Creamos un hilo para importar las imagenes de la galeria
        
         //NSOperationQueue *queue=[NSOperationQueue new];
    //     NSInvocationOperation *operacion2=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(cargarImagenesGaleria) object:nil];
    //     [queue addOperation:operacion2];
        
    }
    else
    {
        hayInternet=@"NO";
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Override point for customization after application launch.
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    
    //self.DatabasePath=[documentsDirectory stringByAppendingPathComponent:@"LuisRamiro.sql"];
    
    self.DatabasePath2=[documentsDirectory stringByAppendingPathComponent:@"LuisRamiro2.sqlite"];
    
    
    
    if (([[UIDevice currentDevice].model rangeOfString:@"iPad"].location!=NSNotFound))
    {
		//iPad
	}
	else
	{
		CGFloat scale = 1.0;
		UIScreen* screen = [UIScreen mainScreen];
        
		if ([UIScreen instancesRespondToSelector:@selector(scale)])
		{
			scale = [screen scale];
		}
        
		if (2.0 == scale)
		{
			//iPhone o iPod Touch con RETINA DISPLAY
            if (_window.frame.size.height == 480) {
                PulgadasDispositivo=@"3.5R";
                
            } else if (_window.frame.size.height == 568) {
                PulgadasDispositivo=@"4.0";
                
            }
            
		}
        else
        {
			//iPhone o iPod Touch sin RETINA DISPLAY
            PulgadasDispositivo=@"3.5";
            
		}
	}

   // [self PersonalizarApariencia];
    
   // [self CargarBaseDatos];

   // [self InicializarVariablesDeCarga];
    [self CargarBaseDatos];
    [self UpdateCamposDB];
    [self RellenarBD];
    
    
    //para poder escuchar musica en segundo plano
    
    NSError *sessionError = nil;
    NSError *activationError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&sessionError];
    [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    // fin musica en segundo plano
    
    return YES;
}
-(void) UpdateCamposDB
{

    sqlite3_stmt *compiledStatement;
    // Abrimos la base de datos de la ruta indicada en el delegate
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        
        
        
        //table GENERAL
        //LETRA=[LETRA stringByReplacingOccurrencesOfString:@"\""withString:@"'"];
        NSString *sqlStatement = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS `General` (`atributo` varchar(256) NOT NULL,`valor` varchar(5000),`FECHAMOD` varchar(20) NOT NULL,                                  PRIMARY KEY  (`atributo`))"];
        
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
            }
            //            NSLog(sqlStatement);
            NSLog(@"tabla general creada");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
            
            
            //   NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        
        
        
        
        //Campo "VentaAnticipada" en "Conciertos"
        sqlStatement = [NSString stringWithFormat:@"SELECT Venta_Anticipada FROM Conciertos"];
        
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
            }
            NSLog(@"Ya existe el campo VentaAnticipada");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"No existe el campo VentaAnticipada, se procede a crearlo");
            
            
      
             sqlStatement = [NSString stringWithFormat:@"ALTER TABLE Conciertos ADD COLUMN Venta_Anticipada VARCHAR(100)"];
            
            
            // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
            if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                // Recorremos los resultados. En este caso no habrá.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    
                }
                NSLog(@"Creado el campo correctamente");
            }
            else
            {
                // Informo si ha habido algún error
                NSLog(@"Error al crear el campo");
                
            }
            
            
            
            
            //   NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        
        
        
        //Creamos un registro en General por cada tabla
        
        //tabla Canciones
        sqlStatement = [NSString stringWithFormat:@"SELECT * FROM General where atributo='Canciones'"];
        Boolean Encontrado=FALSE;
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                Encontrado=TRUE;
                NSLog(@"Ya existe el valor");
            }
            
        }
        
        if (!Encontrado)
        {
            // Informo si ha habido algún error
            NSLog(@"No existe el valor, se procede a crearlo");
            
            
            //Campo "VentaAnticipada" en "Conciertos"
            sqlStatement = [NSString stringWithFormat:@"INSERT INTO General (atributo,valor,FECHAMOD) VALUES ('Canciones','20140101000000','20140101000000')"];
            
            // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
            if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                // Recorremos los resultados. En este caso no habrá.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    
                }
                NSLog(@"Creado el campo correctamente");
            }
            else
            {
                // Informo si ha habido algún error
                NSLog(@"Error al crear el campo");
                
            }
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        Encontrado=false;
        
        //tabla Canciones
        sqlStatement = [NSString stringWithFormat:@"SELECT * FROM General where atributo='Conciertos'"];
        
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                Encontrado=TRUE;
                NSLog(@"Ya existe el valor");
            }
            
        }
        
        if (!Encontrado)
        {
            // Informo si ha habido algún error
            NSLog(@"No existe el valor, se procede a crearlo");
            
            
            //Campo "VentaAnticipada" en "Conciertos"
            sqlStatement = [NSString stringWithFormat:@"INSERT INTO General (atributo,valor,FECHAMOD) VALUES ('Conciertos','20140101000000','20140101000000')"];
            
            // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
            if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                // Recorremos los resultados. En este caso no habrá.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    
                }
                NSLog(@"Creado el campo correctamente");
            }
            else
            {
                // Informo si ha habido algún error
                NSLog(@"Error al crear el campo");
                
            }
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        Encontrado=false;

        //tabla Discos_Cancion
        sqlStatement = [NSString stringWithFormat:@"SELECT * FROM Disco_Cancion where atributo='Canciones'"];
        
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                Encontrado=TRUE;
                NSLog(@"Ya existe el valor");
            }
            
        }
        
        if (!Encontrado)
        {
            // Informo si ha habido algún error
            NSLog(@"No existe el valor, se procede a crearlo");
            
            
            //Campo "VentaAnticipada" en "Conciertos"
            sqlStatement = [NSString stringWithFormat:@"INSERT INTO General (atributo,valor,FECHAMOD) VALUES ('Disco_Cancion','20140101000000','20140101000000')"];
            
            // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
            if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                // Recorremos los resultados. En este caso no habrá.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    
                }
                NSLog(@"Creado el campo correctamente");
            }
            else
            {
                // Informo si ha habido algún error
                NSLog(@"Error al crear el campo");
                
            }
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        Encontrado=false;

        
        //tabla GaleriaFotos
        sqlStatement = [NSString stringWithFormat:@"SELECT * FROM General where atributo='GaleriaFotos'"];
        
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                Encontrado=TRUE;
                NSLog(@"Ya existe el valor");
            }
            
        }
        
        if (!Encontrado)
        {
            // Informo si ha habido algún error
            NSLog(@"No existe el valor, se procede a crearlo");
            
            
            //Campo "VentaAnticipada" en "Conciertos"
            sqlStatement = [NSString stringWithFormat:@"INSERT INTO General (atributo,valor,FECHAMOD) VALUES ('GaleriaFotos','20140101000000','20140101000000')"];
            
            // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
            if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                // Recorremos los resultados. En este caso no habrá.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    
                }
                NSLog(@"Creado el campo correctamente");
            }
            else
            {
                // Informo si ha habido algún error
                NSLog(@"Error al crear el campo");
                
            }
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        Encontrado=false;
        
        //tabla Poemas
        sqlStatement = [NSString stringWithFormat:@"SELECT * FROM General where atributo='Poemas'"];
        
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                Encontrado=TRUE;
                NSLog(@"Ya existe el valor");
            }
            
        }
        
        if (!Encontrado)
        {
            // Informo si ha habido algún error
            NSLog(@"No existe el valor, se procede a crearlo");
            
            
            //Campo "VentaAnticipada" en "Conciertos"
            sqlStatement = [NSString stringWithFormat:@"INSERT INTO General (atributo,valor,FECHAMOD) VALUES ('Poemas','20140101000000','20140101000000')"];
            
            // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
            if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                // Recorremos los resultados. En este caso no habrá.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    
                }
                NSLog(@"Creado el campo correctamente");
            }
            else
            {
                // Informo si ha habido algún error
                NSLog(@"Error al crear el campo");
                
            }
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        Encontrado=false;

        //tabla Sedes
        sqlStatement = [NSString stringWithFormat:@"SELECT * FROM General where atributo='Sedes'"];
        
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                Encontrado=TRUE;
                NSLog(@"Ya existe el valor");
            }
            
        }
        
        if (!Encontrado)
        {
            // Informo si ha habido algún error
            NSLog(@"No existe el valor, se procede a crearlo");
            
            
            //Campo "VentaAnticipada" en "Conciertos"
            sqlStatement = [NSString stringWithFormat:@"INSERT INTO General (atributo,valor,FECHAMOD) VALUES ('Sedes','20140101000000','20140101000000')"];
            
            // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
            if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                // Recorremos los resultados. En este caso no habrá.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    
                }
                NSLog(@"Creado el campo correctamente");
            }
            else
            {
                // Informo si ha habido algún error
                NSLog(@"Error al crear el campo");
                
            }
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        Encontrado=false;

        //tabla discos
        sqlStatement = [NSString stringWithFormat:@"SELECT * FROM General where atributo='discos'"];
        
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                Encontrado=TRUE;
                NSLog(@"Ya existe el valor");
            }
            
        }
        
        if (!Encontrado)
        {
            // Informo si ha habido algún error
            NSLog(@"No existe el valor, se procede a crearlo");
            
            
            //Campo "VentaAnticipada" en "Conciertos"
            sqlStatement = [NSString stringWithFormat:@"INSERT INTO General (atributo,valor,FECHAMOD) VALUES ('discos','20140101000000','20140101000000')"];
            
            // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
            if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                // Recorremos los resultados. En este caso no habrá.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    
                }
                NSLog(@"Creado el campo correctamente");
            }
            else
            {
                // Informo si ha habido algún error
                NSLog(@"Error al crear el campo");
                
            }
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        Encontrado=false;
        
        
        
        
        
    }
    // Cierro la base de datos
    sqlite3_close(database);
    //[self.navigationController popViewControllerAnimated:YES];
    

}

-(void) PersonalizarApariencia
{
  //  [[UITextView appearance] setFont:[UIFont fontWithName:@"Helvetica Neue" size:10.0]];
  //  [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
  //  [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
   /*
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily){
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
    */
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma Importar Base de datos 

-(void) cargarImagenesGaleria
{
    
    NSString *rutaArchivoImagen = @"";
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory=[paths objectAtIndex:0];
    //NSString *writetableDBPath = [cachesDirectory stringByAppendingPathComponent:@"LuisRamiro.sql"];
    
    //recorremos las imagenes que tenemos en la base de datos
    sqlite3_stmt *compiledStatement;
  
    
    if(sqlite3_open([self.databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        
        NSLog(@"abrimos la base de datos %@ - %@",@"hola",self.databasePath);
        
        
       // NSString *sqlStatement = [NSString stringWithFormat:@"SELECT Distinct A.Url_Foto FROM GaleriaFotos A"];
        NSString *sqlStatement = [NSString stringWithFormat:@"SELECT Distinct A.Url_Foto FROM GaleriaFotos A UNION ALL SELECT Distinct D.Url_Imagen FROM Discos D"];

        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            NSLog(@"lanzamos la consulta la base de datos");
            
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                // Leemos las columnas necesarias. Aunque algunos valores son numéricos, prefiero recuperarlos en string y convertirlos luego, porque da menos problemas.
                NSString *url_Foto = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                NSURL *url=[NSURL URLWithString:url_Foto];
                
                NSString *nombreFichero = [[[url_Foto stringByReplacingOccurrencesOfString:@"/"withString:@"_"]stringByReplacingOccurrencesOfString:@":" withString:@"_"]stringByReplacingOccurrencesOfString:@"www." withString:@"www_"];
                
                NSString *fileName = [NSString stringWithFormat:@"%@/%@",cachesDirectory,nombreFichero];
                NSFileManager *gestorArchivos = [NSFileManager defaultManager];
                    
                rutaArchivoImagen = [NSString stringWithFormat:@"%@/%@",cachesDirectory,nombreFichero];
                    
                if (![gestorArchivos fileExistsAtPath: rutaArchivoImagen])
                {

                    NSData *data = [NSData dataWithContentsOfURL:url];
                    [data writeToFile:fileName atomically:TRUE];
                    NSLog(@"grabando la imagen");
                }
                else
                {
                    NSLog(@"Ya teniamos la imagen");
                }
            }
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"No hay registros en la base de datos");
        }
        
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
    }
}


- (void) InicializarArraysDeTablas
{
    aCanciones = [[NSMutableArray alloc] init ];
    aDiscos= [[NSMutableArray alloc] init ];
    aDiscosCanciones =[[NSMutableArray alloc] init ];
    aPoemas=[[NSMutableArray alloc] init ];
    aConciertos=[[NSMutableArray alloc] init ];
    aSedes=[[NSMutableArray alloc] init ];
    aGaleriaFotos=[[NSMutableArray alloc] init ];
    aGeneral=[[NSMutableArray alloc] init ];
    aBajas=[[NSMutableArray alloc] init ];

    
}
-(void) InicializarVariablesDeCarga
{
    CargadaTablaCanciones=@"NO";
    CargadaTablaConciertos=@"NO";
    CargadaTablaDiscosCanciones=@"NO";
    CargadaTablaImagenesGaleria=@"NO";
    CargadaTablaPoemas=@"NO";
    CargadaTablaSedes=@"NO";
    CargadaTablaDiscos=@"NO";
}
- (void)BorrarTablaBD: (NSString *)tabla
{
    
    sqlite3_stmt *compiledStatement;
    // Abrimos la base de datos de la ruta indicada en el delegate
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        NSString *sqlStatement = [NSString stringWithFormat:@"DELETE FROM %@",tabla];
        //  mes_anyo_concierto = [NSString stringWithFormat:@"%@ - %@",mes_concierto, anno];
        
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
            }
            NSLog(@"Registros borrados");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
            //   NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        
    }
    // Cierro la base de datos
    sqlite3_close(database);
    //[self.navigationController popViewControllerAnimated:YES];
    
}
-(void) ImportarBaseDatosDesdeFeed
{
    
    //Se importa el contenido desde el WS
    
    
    //se inicializan los arrays de las distintas tablas
    [self InicializarArraysDeTablas];
    
    
    sqlite3_stmt *compiledStatement;
        NSString *fecha;
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        NSString *sqlStatement = [NSString stringWithFormat:@"SELECT min(valor) FROM General where atributo !='(null)'"];

    
            // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
    if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement       , NULL) == SQLITE_OK)
    {
        // Recorremos los resultados. En este caso no habrá.
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            fecha = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
        }
        //           NSLog(sqlStatement);
        NSLog(@"general almacenada");
    }
    else
    {
        // Informo si ha habido algún error
        NSLog(@"Error en sentencia SQL");
    //              NSLog(sqlStatement);
        
        // NSLog(sqlStatement);
        
    }
    // Libero la consulta
    sqlite3_finalize(compiledStatement);
    }

    //se importa el feed a los arrays
    NSURL *urlfeed;
   if (!fecha)
   {
       urlfeed=[NSURL URLWithString:@("http://www.luisramiro.com/devuelveBDFecha.php")];
   }
   else
   {
     NSString *urlFeedLuisRamiro = [NSString stringWithFormat:@"http://www.luisramiro.com/devuelveBDFecha.php?fecha=%@",fecha];
       
      
       //urlfeed=[NSURL URLWithString:@("http://www.luisramiro.com/devuelveBDFecha.php?fecha=20140708000000")];
       
       urlfeed=[NSURL URLWithString:urlFeedLuisRamiro];
   
   }
    NSXMLParser *parseador = [[NSXMLParser alloc] initWithContentsOfURL:urlfeed];
    parseador.delegate=self;
    [parseador parse];

    
    


    [self EjecutarBajas];
    [self ActualizaGeneral];
    [self ActualizaConciertos];
    [self ActualizaSedes];
    [self ActualizaDiscos];
    [self ActualizaCanciones];

    
 
  
    
    if (![PulgadasDispositivo isEqualToString:@"3.5R"])
    {
        [self ActualizaDiscosCanciones];
        [self ActualizaPoemas];
        NSOperationQueue *queue=[NSOperationQueue new];
        NSInvocationOperation *operacion3=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(ActualizaGaleria) object:nil];
        [queue addOperation:operacion3];
        NSInvocationOperation *operacion4=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(cargarImagenesGaleria) object:nil];
        [queue addOperation:operacion4];

        
    }
    else
    {
        //Creamos un hilo para importar la base de datos desde el WS
        NSOperationQueue *queue=[NSOperationQueue new];
        NSInvocationOperation *operacion1=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(ActualizaDiscosCanciones) object:nil];
        [queue addOperation:operacion1];
        NSInvocationOperation *operacion2=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(ActualizaPoemas) object:nil];
        [queue addOperation:operacion2];
        NSInvocationOperation *operacion3=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(ActualizaGaleria) object:nil];
        [queue addOperation:operacion3];
        NSInvocationOperation *operacion4=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(cargarImagenesGaleria) object:nil];
        [queue addOperation:operacion4];
    }
    
}


-(void) ActualizaCanciones
{
    //metemos las nuevas canciones en la base de datos
  //  if ([aCanciones count]>0)
  //  {
  //      [self BorrarTablaBD:@"Canciones"];
        
        
  //  }
    // Abrimos la base de datos de la ruta indicada en el delegate
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        while ([aCanciones count]>0)
        {
        
            [self insertarCancionDB:[aCanciones objectAtIndex:0]];
            [aCanciones removeObjectAtIndex:0];
        
        }
    }
    [self ActualizaUltimaModificaionTabla:@"Canciones"];
    // Cierro la base de datos
    sqlite3_close(database);
}

-(void) ActualizaUltimaModificaionTabla:(NSString *)Tabla
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    sqlite3_stmt *compiledStatement;
    
    NSString *sqlStatement = [NSString stringWithFormat:@"UPDATE General SET valor='%@' where atributo='%@'",dateString,Tabla];
    
    // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
    if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        // Recorremos los resultados. En este caso no habrá.
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
        }
        //NSLog(sqlStatement);
        //NSLog(@"sede almacenada");
    }
    else
    {
        // Informo si ha habido algún error
        NSLog(@"Error en sentencia SQL");
        //          NSLog(sqlStatement);
        
        //  NSLog(sqlStatement);
        
    }
    // Libero la consulta
    sqlite3_finalize(compiledStatement);
    

}
-(void) ActualizaConciertos
{
    //metemos los conciertos en la base de datos
    //if ([aConciertos count]>0)
    //{
    //    [self BorrarTablaBD:@"Conciertos"];
    //}
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        while ([aConciertos count]>0)
        {
        
            [self insertarConciertoDB:[aConciertos objectAtIndex:0]];
            [aConciertos removeObjectAtIndex:0];
        
        }
        
    }
    [self ActualizaUltimaModificaionTabla:@"Conciertos"];

    // Cierro la base de datos
    sqlite3_close(database);

}

-(void) ActualizaSedes
{
    
    //metemos las sedes en la base de datos
    //if ([aSedes count]>0)
    //{
    //    [self BorrarTablaBD:@"Sedes"];
    //}
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        while ([aSedes count]>0)
        {
            [self insertaSedeDB:[aSedes objectAtIndex:0]];
            [aSedes removeObjectAtIndex:0];
        }
    }
    [self ActualizaUltimaModificaionTabla:@"Sedes"];

    // Cierro la base de datos
    sqlite3_close(database);

 
}
-(void) ActualizaDiscos
{
    //metemos los discos en la base de datos
   /* if ([aDiscos count]>0)
    {
        [self BorrarTablaBD:@"Discos"];
        
        
    }*/
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        while ([aDiscos count]>0)
        {
        
            [self insertaDiscoDB:[aDiscos objectAtIndex:0]];
            [aDiscos removeObjectAtIndex:0];
        
        }
    }
    [self ActualizaUltimaModificaionTabla:@"discos"];

    // Cierro la base de datos
    sqlite3_close(database);
}

-(void) ActualizaDiscosCanciones
{
    //metemos los discos_cancion en la base de datos
    /*if ([aDiscosCanciones count]>0)
    {
        [self BorrarTablaBD:@"Disco_Cancion"];
        
        
    }*/
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        while ([aDiscosCanciones count]>0)
        {
        
            [self insertarDiscoCancionDB:[aDiscosCanciones objectAtIndex:0]];
            [aDiscosCanciones removeObjectAtIndex:0];
        }
    }
    [self ActualizaUltimaModificaionTabla:@"Disco_Cancion"];

    // Cierro la base de datos
    sqlite3_close(database);
}

-(void) ActualizaPoemas
{
    //metemos los poemas en la base de datos
    /*if ([aPoemas count]>0)
    {
        [self BorrarTablaBD:@"Poemas"];
        
        
    }*/
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        while ([aPoemas count]>0)
        {
        
            [self insertarPoemaDB:[aPoemas objectAtIndex:0]];
            [aPoemas removeObjectAtIndex:0];
        }
    }
    [self ActualizaUltimaModificaionTabla:@"Poemas"];

    // Cierro la base de datos
    sqlite3_close(database);
}

-(void) ActualizaGaleria
{
    //metemos la galeria de fotos en la base de datos
    /*if ([aGaleriaFotos count]>0)
    {
        [self BorrarTablaBD:@"GaleriaFotos"];
        
        
    }*/
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        while ([aGaleriaFotos count]>0)
        {
        
            [self insertarGaleriaFotosDB:[aGaleriaFotos objectAtIndex:0]];
            [aGaleriaFotos removeObjectAtIndex:0];
        }
    }
    [self ActualizaUltimaModificaionTabla:@"GaleriaFotos"];

    // Cierro la base de datos
    sqlite3_close(database);
}
-(void) ActualizaGeneral
{
    //metemos la galeria de fotos en la base de datos
    /*if ([aGeneral count]>0)
    {
        [self BorrarTablaBD:@"General"];
        
        
    }*/
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        while ([aGeneral count]>0)
        {
            [self insertarGeneralDB:[aGeneral objectAtIndex:0]];
            [aGeneral removeObjectAtIndex:0];
        }
    }
    [self ActualizaUltimaModificaionTabla:@"General"];

    // Cierro la base de datos
    
    sqlite3_close(database);
}

-(void) EjecutarBajas
{
    //metemos los discos en la base de datos
    /* if ([aDiscos count]>0)
     {
     [self BorrarTablaBD:@"Discos"];
     
     
     }*/
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        while ([aBajas count]>0)
        {
            
            [self EjecutarBaja:[aBajas objectAtIndex:0]];
            [aBajas removeObjectAtIndex:0];
            
        }
    }
    // Cierro la base de datos
    sqlite3_close(database);
}

- (void)EjecutarBaja:(NSMutableDictionary *)Baja
{
    NSString *IDTABLA=[Baja objectForKey:@"IDTABLA"];
    NSString *IDENTRADA=[Baja objectForKey:@"IDENTRADA"];

    NSString *TABLA=nil;
    NSString *ID_TABLA=nil;
    NSString *ID_TABLA2=nil;
    
    sqlite3_stmt *compiledStatement;
    
    if ([IDTABLA isEqualToString:@"poemas"])
    {
        TABLA = @"Poemas";
        ID_TABLA=@"ID_POEMA";
    }
    if ([IDTABLA isEqualToString:@"conciertos"])
    {
        TABLA = @"Conciertos";
        ID_TABLA=@"ID_CONCIERTO";
    }
    if ([IDTABLA isEqualToString:@"galeriafotos"])
    {
        TABLA = @"GaleriaFotos";
        ID_TABLA=@"ID_FOTO";
    }
    if ([IDTABLA isEqualToString:@"sedes"])
    {
        TABLA = @"Sedes";
        ID_TABLA=@"ID_SEDE";
    }
    if ([IDTABLA isEqualToString:@"disco_cancion"])
    {
        TABLA = @"Disco_Cancion";
        ID_TABLA=@"ID_DISCO";
        ID_TABLA2=@"ID_CANCION";
    }
    if ([IDTABLA isEqualToString:@"canciones"])
    {
        TABLA = @"Canciones";
        ID_TABLA=@"ID_CANCION";
    }
    if ([IDTABLA isEqualToString:@"discos"])
    {
        TABLA = @"Discos";
        ID_TABLA=@"ID_DISCO";
    }
    if ([IDTABLA isEqualToString:@"general"])
    {
        TABLA = @"General";
        ID_TABLA=@"atributo";
    }

    NSString *sqlStatement ;
    
    //si es disco cancion separamos los 2 valores clave
    if ([IDTABLA isEqualToString:@"disco_cancion"])
    {
        NSArray* partes_disco_cancion = [IDENTRADA componentsSeparatedByString: @";"];
        NSString* parte_disco = [partes_disco_cancion objectAtIndex: 0];
        NSString* parte_cancion = [partes_disco_cancion objectAtIndex: 1];
        sqlStatement = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = \"%@\" and %@ = \"%@\" ",TABLA,ID_TABLA,parte_disco,ID_TABLA2,parte_cancion];
    }
    else
    {
        sqlStatement = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = \"%@\"",TABLA,ID_TABLA,IDENTRADA];
    }
    
    
    
    // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
    if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        // Recorremos los resultados. En este caso no habrá.
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
        }
                  // NSLog(sqlStatement);
        NSLog(@"registro borrado");
    }
    else
    {
        // Informo si ha habido algún error
        NSLog(@"Error en sentencia SQL");

        
       //  NSLog(sqlStatement);
        
    }
    // Libero la consulta
    sqlite3_finalize(compiledStatement);
    
}


- (void)insertarGeneralDB:(NSMutableDictionary *)general
{
    NSString *ATRIBUTO=[general objectForKey:@"atributo"];
    NSString *VALOR=[general objectForKey:@"valor"];
    NSString *FECHAMOD=[general objectForKey:@"FECHAMOD"];
    

sqlite3_stmt *compiledStatement;
    
        
        VALOR=[VALOR stringByReplacingOccurrencesOfString:@"\""withString:@"'"];
        
       NSString *sqlStatement = [NSString stringWithFormat:@"INSERT INTO General (atributo,valor,FECHAMOD) VALUES (\"%@\",\"%@\",\"%@\")",
                                  ATRIBUTO,VALOR,FECHAMOD];


        
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
            }
 //           NSLog(sqlStatement);
            NSLog(@"general almacenada");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
  //          NSLog(sqlStatement);
            
              // NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        
    }

    


- (void)insertaSedeDB:(NSMutableDictionary *)sede
{
    NSString *ID_SEDE=[sede objectForKey:@"ID_SEDE"];
    NSString *SEDE_NOMBRE=[sede objectForKey:@"NOMBRE"];
    NSString *SEDE_CALLE=[sede objectForKey:@"CALLE"];
    NSString *SEDE_NUMERO=[sede objectForKey:@"NUMERO"];
    NSString *SEDE_PISO=[sede objectForKey:@"PISO"];
    NSString *SEDE_CP=[sede objectForKey:@"CP"];
    NSString *SEDE_LOCALIDAD=[sede objectForKey:@"CIUDAD"];
    NSString *SEDE_PROVINCIA=[sede objectForKey:@"PROVINCIA"];
    NSString *SEDE_PAIS=[sede objectForKey:@"PAIS"];
    NSString *SEDE_IMAGEN=[sede objectForKey:@"IMAGEN"];
    NSString *SEDE_LATITUD=[sede objectForKey:@"LATITUD"];
    NSString *SEDE_LONGITUD=[sede objectForKey:@"LONGITUD"];
    
    
    
    sqlite3_stmt *compiledStatement;

        
        
        //LETRA=[LETRA stringByReplacingOccurrencesOfString:@"\""withString:@"'"];
       
        
        
        NSString *sqlStatement = [NSString stringWithFormat:@"DELETE FROM Sedes WHERE ID_SEDE=\"%@\"",ID_SEDE];
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
            }
         //               NSLog(sqlStatement);
            //NSLog(@"sede almacenada");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
            //          NSLog(sqlStatement);
            
            //  NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);

        
        
        sqlStatement = [NSString stringWithFormat:@"INSERT INTO Sedes (ID_SEDE,SEDE_NOMBRE,SEDE_CALLE,SEDE_NUMERO,SEDE_PISO,SEDE_CP,ID_SEDE,SEDE_LOCALIDAD,SEDE_PROVINCIA,SEDE_PAIS,SEDE_IMAGEN,SEDE_LATITUD,SEDE_LONGITUD) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                                  ID_SEDE,SEDE_NOMBRE,SEDE_CALLE,SEDE_NUMERO,SEDE_PISO,SEDE_CP,SEDE_CP,SEDE_LOCALIDAD,SEDE_PROVINCIA,SEDE_PAIS,SEDE_IMAGEN,SEDE_LATITUD,SEDE_LONGITUD];
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
            }
//            NSLog(sqlStatement);
            NSLog(@"sede almacenada");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
  //          NSLog(sqlStatement);
            
             //  NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        
    

    CargadaTablaSedes=@"SI";
    

}

- (void)insertaDiscoDB:(NSMutableDictionary *)disco
{
    NSString *ID_DISCO=[disco objectForKey:@"ID_DISCO"];
    NSString *TITULO=[disco objectForKey:@"TITULO"];
    NSString *DISCOGRAFICA=[disco objectForKey:@"DISCOGRAFICA"];
    NSString *FECHA=[disco objectForKey:@"FECHA"];
    NSString *DESCRIPCION=[disco objectForKey:@"DESCRIPCION"];
    NSString *URL_IMAGEN=[disco objectForKey:@"IMAGEN"];
    
    sqlite3_stmt *compiledStatement;

        
        
        NSString *sqlStatement = [NSString stringWithFormat:@"DELETE FROM Discos WHERE ID_DISCO=\"%@\"",ID_DISCO];
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
            }
           // NSLog(sqlStatement);
            //NSLog(@"sede almacenada");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
            //          NSLog(sqlStatement);
            
            //  NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        
        sqlStatement = [NSString stringWithFormat:@"INSERT INTO Discos ( ID_DISCO,TITULO,DISCOGRAFICA,FECHA,DESCRIPCION,URL_IMAGEN) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                                  ID_DISCO,TITULO,DISCOGRAFICA,FECHA,DESCRIPCION,URL_IMAGEN];
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
            }
    //        NSLog(sqlStatement);
            NSLog(@"disco almacenado");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
    //        NSLog(sqlStatement);
            
            //   NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        

    
}

- (void)insertarConciertoDB:(NSMutableDictionary *)concierto
{
    NSString *ID_CONCIERTO=[concierto objectForKey:@"ID_CONCIERTO"];
    NSString *TITULO=[concierto objectForKey:@"TITULO"];
    NSString *DESCRIPCION=[concierto objectForKey:@"DESCRIPCION"];
    NSString *IMAGEN=[concierto objectForKey:@"IMAGEN"];
    NSString *FECHA=[concierto objectForKey:@"FECHA"];
    NSString *HORA=[concierto objectForKey:@"HORA"];
    NSString *ID_SEDE=[concierto objectForKey:@"SEDE_CONCIERTO"];
    NSString *PRECIO=[concierto objectForKey:@"PRECIO"];
    NSString *VENTA_ANTICIPADA=[concierto objectForKey:@"VENTA_ANTICIPADA"];
    
    

sqlite3_stmt *compiledStatement;
        
        
        //LETRA=[LETRA stringByReplacingOccurrencesOfString:@"\""withString:@"'"];
        NSString *sqlStatement = [NSString stringWithFormat:@"DELETE FROM Conciertos WHERE ID_CONCIERTO=\"%@\"",ID_CONCIERTO];
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
            }
        //    NSLog(sqlStatement);
            //NSLog(@"sede almacenada");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
            //          NSLog(sqlStatement);
            
            //  NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        
        sqlStatement = [NSString stringWithFormat:@"INSERT INTO Conciertos (ID_CONCIERTO,TITULO,DESCRIPCION,IMAGEN,FECHA,HORA,ID_SEDE,PRECIO,VENTA_ANTICIPADA) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                                  ID_CONCIERTO,TITULO,DESCRIPCION,IMAGEN,FECHA,HORA,ID_SEDE,PRECIO,VENTA_ANTICIPADA];
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
            }
 //           NSLog(sqlStatement);
            NSLog(@"concierto almacenado");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
 //           NSLog(sqlStatement);
            
           //    NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        

    
}

- (void)insertarDiscoCancionDB:(NSMutableDictionary *)cancion
{
    NSString *ID_CANCION=[cancion objectForKey:@"ID_CANCION"];
    // NSString *fechaPublicacion=[noticia objectForKey:@"pubDate"];
    NSString *ID_DISCO=[cancion objectForKey:@"ID_DISCO"];
    NSString *NUM_CANCION=[cancion objectForKey:@"NUM_CANCION"];
    
    sqlite3_stmt *compiledStatement;

    NSString *sqlStatement = [NSString stringWithFormat:@"DELETE FROM Disco_Cancion WHERE ID_DISCO=\"%@\" AND ID_CANCION=\"%@\"",ID_DISCO,ID_CANCION];
    
    // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
    if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        // Recorremos los resultados. En este caso no habrá.
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
        }
    //    NSLog(sqlStatement);
        //NSLog(@"sede almacenada");
    }
    else
    {
        // Informo si ha habido algún error
        NSLog(@"Error en sentencia SQL");
        //          NSLog(sqlStatement);
        
        //  NSLog(sqlStatement);
        
    }
    // Libero la consulta
    sqlite3_finalize(compiledStatement);

    
    

    
    
     sqlStatement = [NSString stringWithFormat:@"INSERT INTO Disco_Cancion (ID_DISCO,ID_CANCION,NUM_CANCION) VALUES (\"%@\",\"%@\",\"%@\")",
                                                         ID_DISCO,ID_CANCION,NUM_CANCION];
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
            }
   //         NSLog(sqlStatement);
            NSLog(@"registro disco_cancion almacenado");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
 //           NSLog(sqlStatement);
            
          //     NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        
   
}


- (void)insertarCancionDB:(NSMutableDictionary *)cancion
{
    NSString *ID_CANCION=[cancion objectForKey:@"ID_CANCION"];
    // NSString *fechaPublicacion=[noticia objectForKey:@"pubDate"];
    NSString *TITULO=[cancion objectForKey:@"TITULO"];
    NSString *DURACION=[cancion objectForKey:@"DURACION"];
    NSString *LETRA=[cancion objectForKey:@"LETRA"];
    NSString *ENLACE=[cancion objectForKey:@"ENLACE"];
    
    sqlite3_stmt *compiledStatement;
    
    ENLACE = [ENLACE stringByReplacingOccurrencesOfString:@" "withString:@"%20"];
    LETRA=[LETRA stringByReplacingOccurrencesOfString:@"\""withString:@"'"];
    
    NSString *sqlStatement = [NSString stringWithFormat:@"DELETE FROM Canciones WHERE ID_CANCION=\"%@\"",ID_CANCION];
    
    // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
    if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        // Recorremos los resultados. En este caso no habrá.
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
        }
      //  NSLog(sqlStatement);
        //NSLog(@"sede almacenada");
    }
    else
    {
        // Informo si ha habido algún error
        NSLog(@"Error en sentencia SQL");
        //          NSLog(sqlStatement);
        
        //  NSLog(sqlStatement);
        
    }
    // Libero la consulta
    sqlite3_finalize(compiledStatement);
    
    
    sqlStatement = [NSString stringWithFormat:@"INSERT INTO Canciones (ID_CANCION,TITULO,DURACION,LETRA,URL) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                                  ID_CANCION,TITULO,DURACION,LETRA,ENLACE];
        
    // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
    if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        // Recorremos los resultados. En este caso no habrá.
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
                
        }
        // NSLog(sqlStatement);
        // NSLog(@"registro almacenado");
    }
    else
    {
            // Informo si ha habido algún error
            //NSLog(@"Error en sentencia SQL");
            //NSLog(sqlStatement);
            
            //   NSLog(sqlStatement);
            
    }
        // Libero la consulta
    sqlite3_finalize(compiledStatement);
    
}

- (void)insertarPoemaDB:(NSMutableDictionary *)poema
{
    NSString *ID_POEMA=[poema objectForKey:@"ID_POEMA"];
    // NSString *fechaPublicacion=[noticia objectForKey:@"pubDate"];
    NSString *TITULO=[poema objectForKey:@"TITULO"];
    NSString *FECHA=[poema objectForKey:@"FECHA"];
    NSString *POEMA=[poema objectForKey:@"TEXTO"];

    sqlite3_stmt *compiledStatement;
    
    NSString *sqlStatement = [NSString stringWithFormat:@"DELETE FROM Poemas WHERE ID_POEMA=\"%@\"",ID_POEMA];
    
    // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
    if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        // Recorremos los resultados. En este caso no habrá.
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
        }
      //  NSLog(sqlStatement);
        //NSLog(@"sede almacenada");
    }
    else
    {
        // Informo si ha habido algún error
        NSLog(@"Error en sentencia SQL");
        //          NSLog(sqlStatement);
        
        //  NSLog(sqlStatement);
        
    }
    // Libero la consulta
    sqlite3_finalize(compiledStatement);
    
    

        
        POEMA=[POEMA stringByReplacingOccurrencesOfString:@"\""withString:@"'"];
        
        sqlStatement = [NSString stringWithFormat:@"INSERT INTO Poemas (ID_POEMA,TITULO,FECHA,POEMA) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",
                                  ID_POEMA,TITULO,FECHA,POEMA];
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
            }
//             NSLog(sqlStatement);
             NSLog(@"registro de poema almacenado");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
  //          NSLog(sqlStatement);
            
            //   NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        

    //[self.navigationController popViewControllerAnimated:YES];
    
}

- (void)insertarGaleriaFotosDB:(NSMutableDictionary *)foto
{
    NSString *ID_FOTO=[foto objectForKey:@"ID_FOTO"];
    // NSString *fechaPublicacion=[noticia objectForKey:@"pubDate"];
    NSString *URL_FOTO=[foto objectForKey:@"URL_FOTO"];
    NSString *ULTIMA_MOD=[foto objectForKey:@"ULTIMA_MOD"];

    sqlite3_stmt *compiledStatement;
    
    NSString *sqlStatement = [NSString stringWithFormat:@"DELETE FROM GaleriaFotos WHERE ID_FOTO=\"%@\"",ID_FOTO];
    
    // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
    if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        // Recorremos los resultados. En este caso no habrá.
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
        }
      //  NSLog(sqlStatement);
        //NSLog(@"sede almacenada");
    }
    else
    {
        // Informo si ha habido algún error
        NSLog(@"Error en sentencia SQL");
               //   NSLog(sqlStatement);
        
        //  NSLog(sqlStatement);
        
    }
    // Libero la consulta
    sqlite3_finalize(compiledStatement);
    
      sqlStatement = [NSString stringWithFormat:@"INSERT INTO GaleriaFotos (ID_FOTO,URL_FOTO,FECHA_ULTIMA_MODIFICACION) VALUES (\"%@\",\"%@\",\"%@\")",
                                  ID_FOTO,URL_FOTO,ULTIMA_MOD];
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
            }
   //         NSLog(sqlStatement);
            NSLog(@"registro de galeria fotografica almacenado");
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
     //       NSLog(sqlStatement);
            
            //   NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        

    //[self.navigationController popViewControllerAnimated:YES];
    
}

- (void)BorrarTablaDB:(NSString *)tabla

{
    sqlite3_stmt *compiledStatement;

    // Abrimos la base de datos de la ruta indicada en el delegate
    if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        //NSString *sqlStatement = [NSString stringWithFormat:@"",];
        NSString *sqlStatement = [NSString stringWithFormat:@"DELETE FROM %@",
                                  tabla];

        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
            }
   //         NSLog([NSString stringWithFormat:@"Registros de %@ borrados",tabla]);
        }
        else
        {
            // Informo si ha habido algún error
            NSLog(@"Error en sentencia SQL");
            //   NSLog(sqlStatement);
            
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
        
    }
    // Cierro la base de datos
    sqlite3_close(database);
    //[self.navigationController popViewControllerAnimated:YES];
    
}


- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:@"conciertos"])
    {
        
        NSLog(@"entrando en conciertos ");
        currentNode=[[NSMutableString alloc] init];
        statusActual=@"conciertos";
        
    }
    else if ([elementName isEqualToString:@"canciones"])
    {
        //currentDic= [[NSMutableDictionary alloc] init];
        currentNode=[[NSMutableString alloc] init];
        NSLog(@"entrando en canciones ");
        statusActual=@"canciones";
        
    }
    
    else if ([elementName isEqualToString:@"poemas"]){
        //currentDic= [[NSMutableDictionary alloc] init];
        currentNode=[[NSMutableString alloc] init];
        NSLog(@"entrando en poemas ");
        statusActual=@"poemas";
    }
    
    
    else if ([elementName isEqualToString:@"sedes"]){
        //currentDic= [[NSMutableDictionary alloc] init];
        currentNode=[[NSMutableString alloc] init];
        NSLog(@"entrando en sedes ");
        statusActual=@"sedes";
    }
    
    else if ([elementName isEqualToString:@"discos"]){
        //currentDic= [[NSMutableDictionary alloc] init];
        currentNode=[[NSMutableString alloc] init];
        NSLog(@"entrando en discos ");
        statusActual=@"discos";
    }
    else if ([elementName isEqualToString:@"disco_cancion"]){
        //currentDic= [[NSMutableDictionary alloc] init];
        currentNode=[[NSMutableString alloc] init];
        NSLog(@"entrando en discos_canciones ");
        statusActual=@"discos_canciones";
    }
    else if ([elementName isEqualToString:@"galeriafotos"]){
        //currentDic= [[NSMutableDictionary alloc] init];
        currentNode=[[NSMutableString alloc] init];
        NSLog(@"entrando en galeria_fotos ");
        statusActual=@"galeriafotos";
    }
    else if ([elementName isEqualToString:@"general"]){
        //currentDic= [[NSMutableDictionary alloc] init];
        currentNode=[[NSMutableString alloc] init];
        NSLog(@"entrando en general ");
        statusActual=@"general";
    }
    else if ([elementName isEqualToString:@"bajas"]){
        //currentDic= [[NSMutableDictionary alloc] init];
        currentNode=[[NSMutableString alloc] init];
        NSLog(@"entrando en Bajas ");
        statusActual=@"BAJAS";
    }
    else if ([elementName isEqualToString:@"Registro"])
    {
        currentDic= [[NSMutableDictionary alloc] init];
        currentNode=[[NSMutableString alloc] init];
        
        
        if ([statusActual isEqualToString:@"discos"])
        {
           
            NSLog(@"abriendo disco");
        }
        if ([statusActual isEqualToString:@"discos_canciones"])
        {
            
            NSLog(@"abriendo disco_cancion");
        }
        if ([statusActual isEqualToString:@"galeria_fotos"])
        {
            
            NSLog(@"abriendo galeria_foto");
        }
        if ([statusActual isEqualToString:@"sedes"])
        {
            NSLog(@"abriendo sede");
        }
        if ([statusActual isEqualToString:@"poemas"])
        {
            NSLog(@"abriendo poema");
        }
        if ([statusActual isEqualToString:@"canciones"])
        {
            NSLog(@"abriendo cancion");
        }
        if ([statusActual isEqualToString:@"conciertos"])
        {
            NSLog(@"abriendo concierto");
        }
        if ([statusActual isEqualToString:@"general"])
        {
            NSLog(@"abriendo general");
        }
        if ([statusActual isEqualToString:@"BAJAS"])
        {
            NSLog(@"abriendo Baja");
        }
    }
    else
    {
    //     NSLog(elementName);
        currentNode=[[NSMutableString alloc] init];

    }
    
}



- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"ID_CANCION"])
    {
        [currentDic setValue:currentNode forKey:@"ID_CANCION"];
        
    }
    if ([elementName isEqualToString:@"TITULO"])
    {
        [currentDic setValue:currentNode forKey:@"TITULO"];
        
    }
    
    if ([elementName isEqualToString:@"DURACION"])
    {
        [currentDic setValue:currentNode forKey:@"DURACION"];
        
    }
    
    if ([elementName isEqualToString:@"ENLACE"])
    {
        [currentDic setValue:currentNode forKey:@"ENLACE"];
        
        
    }
    
    if ([elementName isEqualToString:@"LETRA"])
    {
        [currentDic setValue:currentNode forKey:@"LETRA"];
        
        
    }
    
    if ([elementName isEqualToString:@"ID_CONCIERTO"])
    {
        [currentDic setValue:currentNode forKey:@"ID_CONCIERTO"];
        
    }
    
    
    if ([elementName isEqualToString:@"DESCRIPCION"])
    {
        [currentDic setValue:currentNode forKey:@"DESCRIPCION"];
    }
    
    
    if ([elementName isEqualToString:@"IMAGEN"])
    {
        [currentDic setValue:currentNode forKey:@"IMAGEN"];
        
    }

    if ([elementName isEqualToString:@"SEDE_CONCIERTO"])
    {
        [currentDic setValue:currentNode forKey:@"SEDE_CONCIERTO"];
    }
    
    if ([elementName isEqualToString:@"FECHA"])
    {
        [currentDic setValue:currentNode forKey:@"FECHA"];
        
    }
    if ([elementName isEqualToString:@"HORA"])
    {
        [currentDic setValue:currentNode forKey:@"HORA"];
        
    }
    if ([elementName isEqualToString:@"PRECIO"])
    {
        [currentDic setValue:currentNode forKey:@"PRECIO"];
        
    }
    if ([elementName isEqualToString:@"ID_DISCO"])
    {
        [currentDic setValue:currentNode forKey:@"ID_DISCO"];
        
    }
    if ([elementName isEqualToString:@"ID_CANCION"])
    {
        [currentDic setValue:currentNode forKey:@"ID_CANCION"];
        
    }
    if ([elementName isEqualToString:@"NUM_CANCION"])
    {
        [currentDic setValue:currentNode forKey:@"NUM_CANCION"];
        
    }
    if ([elementName isEqualToString:@"ID_FOTO"])
    {
        [currentDic setValue:currentNode forKey:@"ID_FOTO"];
        
    }
    if ([elementName isEqualToString:@"ULTIMA_MOD"])
    {
        [currentDic setValue:currentNode forKey:@"ULTIMA_MOD"];
        
    }
    if ([elementName isEqualToString:@"FECHAMOD"])
    {
        [currentDic setValue:currentNode forKey:@"FECHAMOD"];
        
    }

    if ([elementName isEqualToString:@"URL_FOTO"])
    {
        [currentDic setValue:currentNode forKey:@"URL_FOTO"];
        
    }
    if ([elementName isEqualToString:@"DESC_FOTO"])
    {
        [currentDic setValue:currentNode forKey:@"DESC_FOTO"];
        
    }
    if ([elementName isEqualToString:@"ID_POEMA"])
    {
        [currentDic setValue:currentNode forKey:@"ID_POEMA"];
        
    }

    if ([elementName isEqualToString:@"TEXTO"])
    {
        [currentDic setValue:currentNode forKey:@"TEXTO"];
        
    }
    
    if ([elementName isEqualToString:@"IMAGEN"])
    {
        [currentDic setValue:currentNode forKey:@"IMAGEN"];
        
    }
    
    if ([elementName isEqualToString:@"ID_SEDE"])
    {
        [currentDic setValue:currentNode forKey:@"ID_SEDE"];
        
    }
    
    if ([elementName isEqualToString:@"NOMBRE"])
    {
        [currentDic setValue:currentNode forKey:@"NOMBRE"];
        
    }
    
    if ([elementName isEqualToString:@"PAIS"])
    {
        [currentDic setValue:currentNode forKey:@"PAIS"];
        
    }
    if ([elementName isEqualToString:@"CIUDAD"])
    {
        [currentDic setValue:currentNode forKey:@"CIUDAD"];
        
    }
    if ([elementName isEqualToString:@"CALLE"])
    {
        [currentDic setValue:currentNode forKey:@"CALLE"];
        
    }
    if ([elementName isEqualToString:@"NUMERO"])
    {
        [currentDic setValue:currentNode forKey:@"NUMERO"];
        
    }
    if ([elementName isEqualToString:@"LONGITUD"])
    {
        [currentDic setValue:currentNode forKey:@"LONGITUD"];
        
    }
    if ([elementName isEqualToString:@"LATITUD"])
    {
        [currentDic setValue:currentNode forKey:@"LATITUD"];
        
    }
    if ([elementName isEqualToString:@"PROVINCIA"])
    {
        [currentDic setValue:currentNode forKey:@"PROVINCIA"];
        
    }
    if ([elementName isEqualToString:@"DISCOGRAFICA"])
    {
        [currentDic setValue:currentNode forKey:@"DISCOGRAFICA"];
        
    }
    if ([elementName isEqualToString:@"FECHA"])
    {
        [currentDic setValue:currentNode forKey:@"FECHA"];
    }
    
    if ([elementName isEqualToString:@"ONLINE"])
    {
        [currentDic setValue:currentNode forKey:@"VENTA_ANTICIPADA"];
    }
    if ([elementName isEqualToString:@"atributo"])
    {
        [currentDic setValue:currentNode forKey:@"atributo"];
        
    }
    if ([elementName isEqualToString:@"valor"])
    {
        [currentDic setValue:currentNode forKey:@"valor"];
        
    }
    if ([elementName isEqualToString:@"IDTABLA"])
    {
        [currentDic setValue:currentNode forKey:@"IDTABLA"];
        
    }
    if ([elementName isEqualToString:@"IDENTRADA"])
    {
        [currentDic setValue:currentNode forKey:@"IDENTRADA"];
        
    }
    if ([elementName isEqualToString:@"Registro"])
    {
        if ([statusActual isEqualToString:@"discos"])
        {
            [aDiscos addObject:currentDic];
            NSLog(@"cerrando disco");
        }
        else if ([statusActual isEqualToString:@"sedes"])
        {
            [aSedes addObject:currentDic];
            NSLog(@"cerrando sede");
        }
        else if ([statusActual isEqualToString:@"poemas"])
        {
            [aPoemas addObject:currentDic];
            NSLog(@"cerrando poema");
        }
        else if ([statusActual isEqualToString:@"discos_canciones"])
        {
           [aDiscosCanciones addObject:currentDic];
            NSLog(@"cerrando disco_cancion");
        }
        else if ([statusActual isEqualToString:@"galeriafotos"])
        {
            [aGaleriaFotos addObject:currentDic];
            NSLog(@"cerrando galeria_fotos");
        }
        else if ([statusActual isEqualToString:@"canciones"])
        {
            [aCanciones addObject:currentDic];
            NSLog(@"cerrando cancion");
        }
        else if ([statusActual isEqualToString:@"conciertos"])
        {
            [aConciertos addObject:currentDic];
            NSLog(@"cerrando concierto");
        }
        else if ([statusActual isEqualToString:@"general"])
        {
            [aGeneral addObject:currentDic];
            NSLog(@"cerrando general");
        }
        else if ([statusActual isEqualToString:@"BAJAS"])
        {
            [aBajas addObject:currentDic];
            NSLog(@"cerrando Baja");
        }
       
    }
    
    if ([elementName isEqualToString:@"discos"])
    {

        NSLog(@"cerrando discos");
        
    }
    
    
    if ([elementName isEqualToString:@"sedes"])
    {
        NSLog(@"cerrando sedes");
        
    }
    
    if ([elementName isEqualToString:@"poemas"])
    {
        
        NSLog(@"cerrando poemas");
        
    }
    
    
    if ([elementName isEqualToString:@"conciertos"])
    {
        
        NSLog(@"cerrando conciertos");
        
    }
    
    if ([elementName isEqualToString:@"canciones"])
    {
        
        NSLog(@"cerrando canciones");
        
    }
    if ([elementName isEqualToString:@"general"])
    {
        NSLog(@"cerrando general");
        
    }
    if ([elementName isEqualToString:@"BAJAS"])
    {
        NSLog(@"cerrando BAJAS");
        
    }
    
    currentNode=nil;
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSLog(string);
    if (!currentNode)
    {
        currentNode=[[NSMutableString alloc] initWithString:string];
        
    }
    else{
        [currentNode appendString:string];
        
    }
}


@end
