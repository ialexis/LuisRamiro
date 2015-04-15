//
//  AppDelegate.h
//  Luis Ramiro, the official App
//
//  Created by Ivan on 11/10/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    // Variables de la base de datos
	NSString *databaseName;
	NSString *databasePath;
    NSString *PulgadasDispositivo;
    NSString *UsuarioActual;
    NSMutableArray *noticias;
}

// Variables de la base de datos
@property (nonatomic, retain) NSString *databaseName;
@property (nonatomic, retain) NSString *databasePath;
@property (nonatomic, retain) NSString *PulgadasDispositivo;
@property (nonatomic, retain) NSString *UsuarioActual;
@property (nonatomic, retain) NSMutableArray *noticias;
@property (strong, nonatomic) UIWindow *window;

-(void) CargarBaseDatos;


@end
