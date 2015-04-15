//
//  GaleriaFotosViewController.m
//  PruebaGaleriaFotos
//
//  Created by Ivan on 20/10/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "GaleriaFotosViewController.h"
#import "CeldaGaleria.h"
#import "MostrarFotosViewController.h"
#import "AppDelegate.h"

@interface GaleriaFotosViewController ()
{
      AppDelegate *appDelegate;
}
@end

@implementation GaleriaFotosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    //[appDelegate cargarImagenesGaleria];
    [appDelegate ActualizaGaleria];
    //[appDelegate CargadaTablaImagenesGaleria];
    [self cargarImagenesGaleria];
    //inicializamos las fotos
   // self.dataArray=@[@"fondo1.png",@"fondo2.png",@"fondo3.png",@"fondo4.png"];
    self.collectionView.delegate=self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma metodos delegados de la celda
-(NSInteger)    numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CeldaGaleria * aCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CeldaGaleria" forIndexPath:indexPath];
    
    
    
    NSData *data = [NSData dataWithContentsOfFile:self.dataArray[indexPath.row]];
    aCell.imagenCelda.image=[UIImage imageWithData:data];
    
    
   // aCell.imagenCelda.image=[UIImage imageNamed:self.dataArray[indexPath.row]];
    return aCell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MostrarFotosViewController *VistaFotosVC=[self.storyboard instantiateViewControllerWithIdentifier:@"VistaFotosVC"];
  
    VistaFotosVC.imagen=[UIImage imageNamed:self.dataArray[indexPath.row]];
    VistaFotosVC.dataArray=self.dataArray;
    VistaFotosVC.posIniArray=(int)indexPath.row;
    
    [self.navigationController pushViewController:VistaFotosVC animated:YES];
}
#pragma Cargar Galeria
-(void) cargarImagenesGaleria
{
    
    NSString *rutaArchivoImagen = @"";
    
    self.dataArray= [[NSMutableArray alloc] init];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory=[paths objectAtIndex:0];
    //NSString *writetableDBPath = [cachesDirectory stringByAppendingPathComponent:@"LuisRamiro.sql"];
    
    //recorremos las imagenes que tenemos en la base de datos
    
    
    sqlite3 *database;
    
    
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_open([appDelegate.databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        
        NSLog(@"abrimos la base de datos %@ - %@",@"hola",appDelegate.databasePath2);
        
        
        NSString *sqlStatement = [NSString stringWithFormat:@"SELECT Distinct A.Url_Foto FROM GaleriaFotos A"];
        
        
        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            NSLog(@"lanzamos la consulta la base de datos");
            
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                

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
                //[self.dataArray addObject:nombreFichero];
                [self.dataArray addObject:rutaArchivoImagen];
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
@end
