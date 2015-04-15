//
//  VistaAlbumsViewController.m
//  Luis Ramiro
//
//  Created by Ivan on 06/11/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "VistaAlbumsViewController.h"
#import "Disco.h"

@interface VistaAlbumsViewController ()

@end

@implementation VistaAlbumsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    DiscosAMostrar = [[NSMutableArray alloc] init];
    
    [appDelegate ActualizaDiscosCanciones];
    [self loadAlbumsFromDB];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAlbumsFromDB
{
    
    NSLog(@"entrando en loadConciertos");
    
    sqlite3 *database;
    
    
    sqlite3_stmt *compiledStatement;
    
    // Abrimos la base de datos de la ruta indicada en el delegate
    if(sqlite3_open([appDelegate.databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        
        NSLog(@"abrimos la base de datos %@ - %@",@"hola",appDelegate.databasePath2);
        
        
        // Podríamos seleccionar solo algunos, o todos en el orden deseado así:
        // NSString *sqlStatement = [NSString stringWithFormat:@"seletc id_tutorial, sistema, nombre, terminado from Tutoriales"];
        NSString *sqlStatement = [NSString stringWithFormat:@"SELECT A.* FROM Discos A order by A.Fecha Desc"];
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
                NSString *id_disco = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *titulo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *discografica = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *fecha = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *descripcion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *url_imagen = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                
                Disco *auxDisco = [[Disco alloc]init];
                auxDisco.ID_Disco = id_disco;
                auxDisco.Titulo = titulo;
                auxDisco.Fecha = fecha;
                auxDisco.Discografica=discografica;
                auxDisco.Descripcion=descripcion;
                auxDisco.Url_Imagen=url_imagen;
                [auxDisco CargarCanciones];
                
                
                [DiscosAMostrar addObject:auxDisco];
                
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
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [DiscosAMostrar count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       
	//static NSString *CellIdentifier = @"Cell";
    
    CeldaDiscos *cell = [tableView dequeueReusableCellWithIdentifier:@"CeldaDisco"];
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
   /* UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    */

    
    // Configure the cell...
    
    Disco *disco=[DiscosAMostrar objectAtIndex:indexPath.row];
    
    //Actividad *actividad=[ArrayActividades objectAtIndex:indexPath.row];
    
    //NSDictionary *actividad=[actividadesAMostrar objectAtIndex:indexPath.row];
	
	// Configure the cell.
    NSString *titulo=disco.Titulo;
    NSString *fecha=disco.Fecha;
    NSString *fecha_disco;
    
    NSString *Num_canciones = [NSString stringWithFormat:@"%lu canciones",(unsigned long)[[[DiscosAMostrar objectAtIndex:indexPath.row] CargarCanciones] count]];

    
    NSString *anno_desde =@"0000";
    NSString *mes_desde = @"00";
    NSString *dia_desde = @"00";
    
    anno_desde = [fecha substringWithRange:NSMakeRange(0,4)];
    
    if ([anno_desde isEqualToString:@"0000"]==FALSE)
    {
        fecha_disco = [NSString stringWithFormat:@"%@",anno_desde];

    }
    if ([fecha length]>4)
    {
        mes_desde = [fecha substringWithRange:NSMakeRange(4,2)];
    }
    
    
     if ([fecha length]>6)
     {
        dia_desde = [fecha substringWithRange:NSMakeRange(6,2)];
         
     }
   
    
    
  //  fecha_actividad=[NSString stringWithFormat:@"%@/%@/%@",dia_desde,mes_desde,anno_desde];
    
    
    //Sacamos la imagen
    
    NSURL *url=[NSURL URLWithString:disco.Url_Imagen];
    NSData *data=Nil;
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory=[paths objectAtIndex:0];
    
    
    NSString *nombreFichero = [[[disco.Url_Imagen stringByReplacingOccurrencesOfString:@"/"withString:@"_"]stringByReplacingOccurrencesOfString:@":" withString:@"_"]stringByReplacingOccurrencesOfString:@"www." withString:@"www_"];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",cachesDirectory,nombreFichero];
    NSFileManager *gestorArchivos = [NSFileManager defaultManager];
    NSString *rutaArchivoImagen = @"";
    
    rutaArchivoImagen = [NSString stringWithFormat:@"%@/%@",cachesDirectory,nombreFichero];
    
    if (![gestorArchivos fileExistsAtPath: rutaArchivoImagen])
    {
        
        data = [NSData dataWithContentsOfURL:url];
        [data writeToFile:fileName atomically:TRUE];
        NSLog(@"grabando la imagen");
    }
    else
    {
        data = [NSData dataWithContentsOfFile:rutaArchivoImagen];

        NSLog(@"Ya teniamos la imagen");
    }
    //[self.dataArray addObject:nombreFichero];
  //  [self.dataArray addObject:rutaArchivoImagen];

    
	//Poner la celda transparente [cell setBackgroundColor:[UIColor clearColor]];
    
    
  //  NSString *subtitulo=[NSString stringWithFormat:@"%@ - %@",fecha_actividad, poema.Poema];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.TituloDisco.text= titulo;
    cell.TituloDisco.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:18.0];
    cell.AnnoDisco.text=fecha_disco;
    cell.AnnoDisco.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:13.0];
    cell.Num_PistasDisco.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:13.0];
    cell.Num_PistasDisco.text=Num_canciones;
    //cell.imageView.image=[UIImage imageNamed:@"808-documents.png"];
   
    cell.ImagenDisco.image=[UIImage imageWithData:data];

    // cell.imageView.layer.cornerRadius = 5.0;
    // cell.imageView.layer.masksToBounds = YES;
    // cell.imageView.layer.borderColor = [UIColor brownColor].CGColor;
    // cell.imageView.layer.borderWidth = 2.0;
    
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton; //boton a la izquierda
   // cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator; //flecha a la izquierda
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Devuelve la altura de la fila
    
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Navigation logic may go here. Create and push another view controller.
    
  //  NSDictionary *Discos=[DiscosAMostrar objectAtIndex:indexPath.section];
    
    //NSMutableArray *ArrayActividades=[[NSMutableArray alloc] init];
    
    
   // NSMutableArray * ArrayDiscos=[Discos objectForKey:@"ArrayActividades"];
    
    
    
    
    // DetalleActividadViewController2 *DetalleActividadVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DetalleActividadVC"];
    
    
    //   DetalleActividadVC.actividad=[ArrayActividades objectAtIndex:indexPath.row];
    
    // VistaDetalleConciertoViewController *DetalleConciertoVC=[self.storyboard instantiateViewControllerWithIdentifier:@"VistaDetalleConciertoVC"];
    
    DetalleAlbumViewController *DetalleAlbumVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DetalleAlbumVC"];
    
   // DetalleAlbumVC.Album=[ArrayDiscos objectAtIndex:indexPath.row];
    
    DetalleAlbumVC.Album=[DiscosAMostrar objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:DetalleAlbumVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
