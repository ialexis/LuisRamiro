//
//  VistaPoemasViewController.m
//  Luis Ramiro
//
//  Created by Ivan on 01/11/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "VistaPoemasViewController.h"
#import "DetallePoemaViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Poema.h"


@interface VistaPoemasViewController ()

@end

@implementation VistaPoemasViewController



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
    PoemasAMostrar = [[NSMutableArray alloc] init];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate ActualizaPoemas];
    
    [self loadPoemasFromDB];
    
    [self firstUserExperience];
}


- (void)loadPoemasFromDB
{
    
    NSLog(@"entrando en loadpoemas");
    
    sqlite3 *database;
    
    
    sqlite3_stmt *compiledStatement;
    
    // Abrimos la base de datos de la ruta indicada en el delegate
    if(sqlite3_open([appDelegate.databasePath2 UTF8String], &database) == SQLITE_OK)
    {
        
        NSLog(@"abrimos la base de datos %@ - %@",@"hola",appDelegate.databasePath2);
        
        
        // Podríamos seleccionar solo algunos, o todos en el orden deseado así:
        // NSString *sqlStatement = [NSString stringWithFormat:@"seletc id_tutorial, sistema, nombre, terminado from Tutoriales"];
        NSString *sqlStatement = [NSString stringWithFormat:@"SELECT A.* FROM Poemas A order by A.Fecha Desc"];
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
                NSString *id_poema = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *titulo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *fecha = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *poema = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                
                Poema *auxPoema = [[Poema alloc]init];
                auxPoema.ID_Poema = id_poema;
                auxPoema.Titulo = titulo;
                auxPoema.Fecha = fecha;
                auxPoema.Poema=poema;
                
         //       NSString *anno = [fecha substringWithRange:NSMakeRange(0,4)];
         //       NSString *mes = [fecha substringWithRange:NSMakeRange(4,2)];
         //       NSString *dia = [fecha substringWithRange:NSMakeRange(6,2)];
                
              //  int anno_actividad = [anno intValue];
        //        int mes_actividad = [mes intValue];
              //  int dia_actividad = [dia intValue];
                
                
                //Para sacar la fecha actual
                NSDate *now = [NSDate date];
                
                NSLog(@"now: %@", now); // now: 2011-02-28 09:57:49 +0000
                
                NSString *strDate = [[NSString alloc] initWithFormat:@"%@",now];
                NSArray *arr = [strDate componentsSeparatedByString:@" "];
                NSString *str;
                str = [arr objectAtIndex:0];
                NSLog(@"strdate: %@",str); // strdate: 2011-02-28
                
                NSArray *arr_my = [str componentsSeparatedByString:@"-"];
                
                NSInteger date_actual = [[arr_my objectAtIndex:2] intValue];
                NSInteger month_actual = [[arr_my objectAtIndex:1] intValue];
                NSInteger year_actual = [[arr_my objectAtIndex:0] intValue];
                
                NSLog(@"year = %ld", (long)year_actual); // year = 2011
                NSLog(@"month = %ld", (long)month_actual); // month = 2
                NSLog(@"date = %ld", (long)date_actual); // date = 2
                
               
                
                [PoemasAMostrar addObject:auxPoema];
                
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


- (void)firstUserExperience {
 
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Numero de secciones de la tabla
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Devuelve el numero de filas de cada sección
   // NSDictionary *Actividades=[ConciertosAMostrar objectAtIndex:section];
    
    //NSMutableArray *ArrayActividades=[[NSMutableArray alloc] init];
   /// NSMutableArray *ArrayActividades=[Actividades objectForKey:@"ArrayActividades"];
    
	return [PoemasAMostrar count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
	
	static NSString *CellIdentifier = @"Cell";
    
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    
    
   // NSDictionary *Actividades=[ConciertosAMostrar objectAtIndex:indexPath.section];
    
    
    //INICIO REORDENACION (SI ES HISTORICO)
    /*actividadesAMostrar = [[NSMutableArray alloc] init ];
     NSMutableArray *actividadesTemporales = actividadesYaRealizadas;
     
     while ([actividadesTemporales count]>0)
     {
     [actividadesAMostrar addObject:[actividadesTemporales objectAtIndex:([actividadesTemporales count]-1)]];
     [actividadesTemporales removeObjectAtIndex:[actividadesTemporales count]-1];
     
     }
     //FIN REORDENACION
     */
    
    //NSMutableArray *ArrayActividades=[[NSMutableArray alloc] init];
    
   // NSMutableArray* ArrayActividades=[Actividades objectForKey:@"ArrayActividades"];
    
    Poema *poema=[PoemasAMostrar objectAtIndex:indexPath.row];
    
    
    
    
    //Actividad *actividad=[ArrayActividades objectAtIndex:indexPath.row];
    
    
    
    //NSDictionary *actividad=[actividadesAMostrar objectAtIndex:indexPath.row];
	
	// Configure the cell.
    NSString *titulo=poema.Titulo;
    NSString *fecha=poema.Fecha;
    
    if ([fecha isEqualToString:@"(null)"])
    {
       fecha=@"20140612";
    }
   // NSString *fecha_actividad;
    
    
   // NSString *anno_desde = [fecha substringWithRange:NSMakeRange(0,4)];
   // NSString *mes_desde = [fecha substringWithRange:NSMakeRange(4,2)];
  //  NSString *dia_desde = [fecha substringWithRange:NSMakeRange(6,2)];
    
    

 //   fecha_actividad=[NSString stringWithFormat:@"%@/%@/%@",dia_desde,mes_desde,anno_desde];
    
	//Poner la celda transparente [cell setBackgroundColor:[UIColor clearColor]];
    
    
   // NSString *subtitulo=[NSString stringWithFormat:@"%@ - %@",fecha_actividad, poema.Poema];
     NSString *subtitulo= poema.Poema;
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text= titulo;
    cell.textLabel.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:14.0];
    cell.detailTextLabel.text=subtitulo;
    cell.detailTextLabel.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:11.0];
    cell.imageView.image=[UIImage imageNamed:@"808-documents.png"];
    
    // cell.imageView.layer.cornerRadius = 5.0;
    // cell.imageView.layer.masksToBounds = YES;
    // cell.imageView.layer.borderColor = [UIColor brownColor].CGColor;
    // cell.imageView.layer.borderWidth = 2.0;
    
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton; //boton a la izquierda
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator; //flecha a la izquierda
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    
    //cell.accessoryType=UITableViewCellAccessoryCheckmark; //boton a la izquierda
    
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Navigation logic may go here. Create and push another view controller.
    
   // NSDictionary *Conciertos=[ConciertosAMostrar objectAtIndex:indexPath.section];
    
    //NSMutableArray *ArrayActividades=[[NSMutableArray alloc] init];
    
    
  //  NSMutableArray * ArrayConciertos=[Conciertos objectForKey:@"ArrayActividades"];
    
    
    DetallePoemaViewController *DetallePoemaVC=[self.storyboard instantiateViewControllerWithIdentifier:@"VistaDetallePoemaVC"];
    
    
    Poema *poemita =[PoemasAMostrar objectAtIndex:indexPath.row];

    DetallePoemaVC.poema=poemita;

    
    

   
    
    //[self.navigationController pushViewController:DetalleActividadVC animated:YES];
    
    [self.navigationController pushViewController:DetallePoemaVC animated:YES];
    
}

- (CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Devuelve la altura de la fila
    
    return 40;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // UIColor *altCellColor = [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1];
    
    // if (indexPath.row % 2 == 0) {
    //    altCellColor = [UIColor colorWithRed:223/255. green:223/255. blue:223/255. alpha:1];
    //}
    // cell.backgroundColor = altCellColor;
}


- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)ip
{
    return @"ñam ñam";
}



- (NSString *) SacarMes: (int) mes
{
    
    switch (mes) {
        case 1:
            return @"Enero";
            break;
        case 2:
            return @"Febrero";
            break;
        case 3:
            return @"Marzo";
            break;
        case 4:
            return @"Abril";
            break;
        case 5:
            return @"Mayo";
            break;
        case 6:
            return @"Junio";
            break;
        case 7:
            return @"Julio";
            break;
        case 8:
            return @"Agosto";
            break;
        case 9:
            return @"Septiembre";
            break;
        case 10:
            return @"Octubre";
            break;
        case 11:
            return @"Noviembre";
            break;
        case 12:
            return @"Diciembre";
            break;
            
        default:
            return @"ERROR";
            break;
    }
}
@end;
