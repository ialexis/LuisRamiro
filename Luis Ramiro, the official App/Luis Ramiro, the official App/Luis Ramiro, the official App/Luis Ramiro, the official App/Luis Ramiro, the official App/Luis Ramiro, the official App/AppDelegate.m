//
//  AppDelegate.m
//  Luis Ramiro, the official App
//
//  Created by Ivan on 11/10/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
{
    // NSString *DatabaseName;
    // NSString *DatabasePath;
    NSMutableArray *capitulos;
    NSMutableDictionary *currentDic;
    NSMutableDictionary *currentDic2;
    NSMutableString *currentNode;
    Boolean descripcionAsignada;
    Boolean tituloAsignado;
    NSMutableArray *noticias_publicas;
    NSMutableArray *noticias_privadas;
    NSString *tipofeed;
}

// Variables para que el resto de clases encuentren la base de datos.
@synthesize databaseName, databasePath,PulgadasDispositivo,noticias,UsuarioActual;

-(void) CargarBaseDatos
{
    BOOL Exito;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *Error;
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory=[paths objectAtIndex:0];
    NSString *writetableDBPath = [libraryDirectory stringByAppendingPathComponent:@"LuisRamiro.sql"];
    
    Exito=[fileManager fileExistsAtPath:writetableDBPath];
    if (Exito) {
        NSLog(@"Todo bueno al cargar BD,ya existia el fichero");
        return;
    }
    
    NSString *defaultDBPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LuisRamiro.sql"];
    
    Exito = [fileManager copyItemAtPath:defaultDBPath toPath:writetableDBPath error:&Error];
    
    if (!Exito)
    {
        NSLog(@"Erroraco al cargar BD%@",[Error localizedDescription]);
    }
    else{
        NSLog(@"Todo bueno al cargar BD,se ha copiado el fichero");
        
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Override point for customization after application launch.
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    
    self.DatabasePath=[documentsDirectory stringByAppendingPathComponent:@"LuisRamiro.sql"];

    [self CargarBaseDatos];
    
    return YES;
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

@end
