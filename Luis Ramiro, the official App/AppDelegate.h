//
//  AppDelegate.h
//  Luis Ramiro, the official App
//
//  Created by Ivan on 11/10/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,NSXMLParserDelegate>

{
    // Variables de la base de datos
	NSString *databaseName;
	NSString *databasePath;
    // Variables de la base de datos
	NSString *databaseName2;
	NSString *databasePath2;
    NSString *PulgadasDispositivo;
    NSString *UsuarioActual;
    NSString *url_cancion_actual;
    NSMutableArray *noticias;
    //Variable para saber si hay internet
    NSString *hayInternet;
    AVPlayer *reproductor;
    NSString *CargadaTablaConciertos;
    NSString *CargadaTablaDiscos;
    NSString *CargadaTablaCanciones;
    NSString *CargadaTablaDiscosCanciones;
    NSString *CargadaTablaImagenesGaleria;
    NSString *CargadaTablaPoemas;
    NSString *CargadaTablaSedes;
    sqlite3 *database;
    
    
}

// Variables de la base de datos
@property (nonatomic, retain) NSString *databaseName;
@property (nonatomic, retain) NSString *databasePath;
@property (nonatomic, retain) NSString *databaseName2;
@property (nonatomic, retain) NSString *databasePath2;
@property (nonatomic, retain) NSString *PulgadasDispositivo;
@property (nonatomic, retain) NSString *UsuarioActual;
@property (nonatomic)  sqlite3 *database;
@property (nonatomic) sqlite3_stmt *compiledStatement;
/*@property (nonatomic, retain) NSString *CargadaTablaConciertos;
@property (nonatomic, retain) NSString *CargadaTablaDiscos;
@property (nonatomic, retain) NSString *CargadaTablaCanciones;
@property (nonatomic, retain) NSString *CargadaTablaImagenesGaleria;
@property (nonatomic, retain) NSString *CargadaTablaPoemas;
@property (nonatomic, retain) NSString *CargadaTablaSedes;*/

@property (nonatomic, retain) NSString *url_cancion_actual;
@property (nonatomic, retain) NSMutableArray *noticias;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain)AVPlayer *reproductor;

-(void) CargarBaseDatos;
-(void) RellenarBD;
-(void) ActualizaPoemas;
-(void) ActualizaGaleria;
-(void) UpdateCamposDB;
-(void) ActualizaCanciones;
-(void) ActualizaGeneral;

-(void) ActualizaDiscosCanciones;
-(void) cargarImagenesGaleria;


@end
