//
//  VistaSobreMiViewController.m
//  Luis Ramiro
//
//  Created by Ivan on 14/10/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "VistaSobreMiViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface VistaSobreMiViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imagenLuisRamiro;

@end

@implementation VistaSobreMiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    
  //  NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
   // NSString *cachesDirectory=[paths objectAtIndex:0];
    //NSString *writetableDBPath = [cachesDirectory stringByAppendingPathComponent:@"LuisRamiro.sql"];
    
    //recorremos las imagenes que tenemos en la base de datos
    
    
    sqlite3 *database;
    
    
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_open([appDelegate.databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        
        NSLog(@"abrimos la base de datos %@ - %@",@"hola",appDelegate.databasePath2);
        
        
        NSString *sqlStatement = [NSString stringWithFormat:@"SELECT Distinct valor FROM General Where atributo='bio'"];
        
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            NSLog(@"lanzamos la consulta la base de datos");
            
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                
                self.Bio.text = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
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
    
    if ([appDelegate.PulgadasDispositivo isEqualToString:@"3.5R"])
    {
        [self.UIindicador startAnimating];
      //  [appDelegate ActualizaPoemas];
       // [appDelegate ActualizaGaleria];
       // [appDelegate cargarImagenesGaleria];
      
        
        //    [appDelegate ActualizaCanciones];
        
        //    [appDelegate ActualizaDiscosCanciones];
        
    }
  [self.UIindicador stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  //  UIImageView * roundedView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"wood.jpg"]];
    // Get the Layer of any view
    CALayer * l = [self.imagenLuisRamiro layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:39.0];
    
    // You can even add a border
    [l setBorderWidth:2.0];
    [l setBorderColor:[[UIColor blackColor] CGColor]];
    
    self.Bio.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:18.0];
    
    [self viewDidAppear:TRUE];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
