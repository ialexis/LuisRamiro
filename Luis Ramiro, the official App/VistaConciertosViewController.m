//
//  VistaConciertosViewController.m
//  Gumcam
//
//  Created by Ivan on 30/03/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "VistaConciertosViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Concierto.h"

@implementation VistaConciertosViewController

@synthesize segment;

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
    ConciertosPendientes = [[NSMutableArray alloc] init];
    ConciertosYaRealizados = [[NSMutableArray alloc] init];
    ConciertosAMostrar = [[NSMutableArray alloc] init];
    
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    [self loadConciertosFromDB];

    [self firstUserExperience];
}


- (void)loadConciertosFromDB
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
        //NSString *sqlStatement = [NSString stringWithFormat:@"SELECT A.* FROM Conciertos A order by A.Fecha_Desde"];
        //NSString *sqlStatement = [NSString stringWithFormat:@"select * from Personas"];
        
        
         NSString *sqlStatement = [NSString stringWithFormat:@"SELECT ID_CONCIERTO,FECHA,FECHA,HORA,HORA,SEDE_PROVINCIA,SEDE_CALLE,SEDE_NUMERO,SEDE_PISO,SEDE_CP,SEDE_LOCALIDAD,SEDE_PROVINCIA,SEDE_PAIS,SEDE_LATITUD,SEDE_LONGITUD,PRECIO,SEDE_NOMBRE,SEDE_IMAGEN,DESCRIPCION,VENTA_ANTICIPADA FROM Conciertos A,Sedes S where a.ID_SEDE = S.ID_SEDE order by FECHA"];
        
        
        
        NSString *anyoActual=@"";
        NSString *mesActual=@"";
        
        NSString *mes_anyo_concierto =@"";
        
        NSString *anyoYaRealizadas=@"";
        NSMutableArray *actividades=[[NSMutableArray alloc] init];
        NSMutableArray *actividades_ya_realizadas=[[NSMutableArray alloc] init];

        // Lanzamos la consulta y recorremos los resultados si todo ha ido OK
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            NSLog(@"lanzamos la consulta la base de datos");
            
            // Recorremos los resultados. En este caso no habrá.
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                // Leemos las columnas necesarias. Aunque algunos valores son numéricos, prefiero recuperarlos en string y convertirlos luego, porque da menos problemas.
                NSString *id_concierto = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *fecha_desde = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *fecha_hasta = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *hora_desde = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *hora_hasta = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *titulo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
             //   NSString *descripcion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *sede_calle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *sede_numero = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *sede_piso = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString *sede_cp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString *sede_localidad = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                NSString *sede_provincia = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                NSString *sede_pais = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                NSString *sede_latitud = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                NSString *sede_longitud = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                NSString *precio = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                NSString *sede_nombre = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)];
                NSString *sede_imagen = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 17)];
                NSString *descripcion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 18)];
                NSString *venta_Anticipada = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 19)];


                Concierto *auxConcierto = [[Concierto alloc]init];
                auxConcierto.id_concierto = id_concierto;
                auxConcierto.fecha_desde = fecha_desde;
                auxConcierto.fecha_hasta = fecha_hasta;
                auxConcierto.hora_desde=hora_desde;
                auxConcierto.hora_hasta=hora_hasta;
                auxConcierto.titulo=titulo;
                //auxConcierto.descripcion=descripcion;
                auxConcierto.sede_nombre=sede_nombre;
                auxConcierto.sede_calle=sede_calle;
                auxConcierto.sede_numero=sede_numero;
                auxConcierto.sede_piso=sede_piso;
                auxConcierto.sede_cp=sede_cp;
                auxConcierto.sede_localidad=sede_localidad;
                auxConcierto.sede_provincia=sede_provincia;
                auxConcierto.sede_pais=sede_pais;
                auxConcierto.sede_latitud=sede_latitud;
                auxConcierto.sede_longitud=sede_longitud;
                auxConcierto.precio=precio;
                auxConcierto.sede_imagen=sede_imagen;
                auxConcierto.venta_anticipada=venta_Anticipada;
                auxConcierto.descripcion=descripcion;
               
                NSString *anno = [fecha_desde substringWithRange:NSMakeRange(0,4)];
                NSString *mes = [fecha_desde substringWithRange:NSMakeRange(4,2)];
                NSString *dia = [fecha_desde substringWithRange:NSMakeRange(6,2)];
                
                int anno_actividad = [anno intValue];
                int mes_actividad = [mes intValue];
                int dia_actividad = [dia intValue];
                
                
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
                
                Boolean bHistorico=false;
                
                if (year_actual > anno_actividad)
                {
                    bHistorico=true;
                }
                else if ((month_actual > mes_actividad) &&  (year_actual == anno_actividad))
                {
                    bHistorico=true;
                }
                else if ((date_actual>dia_actividad) &&  (year_actual == anno_actividad) && (month_actual == mes_actividad))
                {
                    bHistorico=true;
                }
                
                
                
                if (bHistorico==false)
                {
                    if ([anno isEqualToString:anyoActual] && [mes isEqualToString:mesActual])
                    {
                        //Si es el mismo año le añado la actividad al array de actividades
                        [actividades addObject:auxConcierto];
                    
                    }
                    else
                    {
                        //cambia el año
                        if ([anyoActual isEqualToString:@""] ||[mesActual isEqualToString:@""])
                        {
                            //si es la primera vez solo se asigna año
                            anyoActual=anno;
                            mesActual=mes;
                            NSString *mes_concierto=[self SacarMes:mes_actividad];
                            mes_anyo_concierto = [NSString stringWithFormat:@"%@ - %@",mes_concierto, anno];

                            [actividades addObject:auxConcierto];
                        }
                        else
                        {
                            
                            
                            
                            NSDictionary *actividadesanyo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:mes_anyo_concierto,actividades, Nil] forKeys:[NSArray arrayWithObjects:@"año",@"ArrayActividades",Nil]];
                            
                            [ConciertosPendientes addObject:actividadesanyo];
                            
                            
                            anyoActual=anno;
                            mesActual=mes;
                            NSString *mes_concierto=[self SacarMes:mes_actividad];
                            mes_anyo_concierto = [NSString stringWithFormat:@"%@ - %@",mes_concierto, anno];
                            actividades=[[NSMutableArray alloc] init];
                            [actividades addObject:auxConcierto];

                        }

                    }
                //[miembrosJunta addObject:auxMiembro];
                //NSLog(@"miembros junta count = %@",foto_bio);
                }
                else
                {
                    if ([anno isEqualToString:anyoYaRealizadas])
                    {
                        //Si es el mismo año le añado la actividad al array de actividades
                        [actividades_ya_realizadas addObject:auxConcierto];
                        
                    }
                    else
                    {
                        //cambia el año
                        if ([anyoYaRealizadas isEqualToString:@""])
                        {
                            //si es la primera vez solo se asigna año
                            anyoYaRealizadas=anno;
                            [actividades_ya_realizadas addObject:auxConcierto];
                        }
                        else
                        {
                            
                            NSDictionary *actividadesanyo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:mes_anyo_concierto,actividades, Nil] forKeys:[NSArray arrayWithObjects:@"año",@"ArrayActividades",Nil]];
                            
                            [ConciertosYaRealizados addObject:actividadesanyo];
                            
                            
                            anyoYaRealizadas=anno;
                            actividades_ya_realizadas=[[NSMutableArray alloc] init];
                            [actividades_ya_realizadas addObject:auxConcierto];
                            
                        }
                        
                    }
                }
                
            }

            NSDictionary *actividadesanyo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:mes_anyo_concierto,actividades, Nil] forKeys:[NSArray arrayWithObjects:@"año",@"ArrayActividades",Nil]];
            
            [ConciertosPendientes addObject:actividadesanyo];
            
            NSDictionary *actividadesanyoyarealizadas = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:anyoYaRealizadas,actividades_ya_realizadas, Nil] forKeys:[NSArray arrayWithObjects:@"año",@"ArrayActividades",Nil]];
            
            [ConciertosYaRealizados addObject:actividadesanyoyarealizadas];

            
        } else {
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
    self.segment.selectedSegmentIndex = 0;
    ConciertosAMostrar=ConciertosPendientes;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Numero de secciones de la tabla
	return [ConciertosAMostrar count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Devuelve el numero de filas de cada sección
    NSDictionary *Actividades=[ConciertosAMostrar objectAtIndex:section];
    
    //NSMutableArray *ArrayActividades=[[NSMutableArray alloc] init];
    NSMutableArray *ArrayActividades=[Actividades objectForKey:@"ArrayActividades"];

	return [ArrayActividades count];
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
    
    
    NSDictionary *Actividades=[ConciertosAMostrar objectAtIndex:indexPath.section];
    
    
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
    
    NSMutableArray* ArrayActividades=[Actividades objectForKey:@"ArrayActividades"];
    
    Concierto *concierto=[ArrayActividades objectAtIndex:indexPath.row];
    
    //si se ha seleccionado el historico, se muestra todo invertido
    if ([segment selectedSegmentIndex]==1)
    {
         concierto=[ArrayActividades objectAtIndex:([ArrayActividades count]-1-indexPath.row)];
    }
       
    
    
    //Actividad *actividad=[ArrayActividades objectAtIndex:indexPath.row];
   
    
    
    //NSDictionary *actividad=[actividadesAMostrar objectAtIndex:indexPath.row];
	
	// Configure the cell.
    //NSString *nombreActividad=concierto.titulo;
    NSString *fecha_desde=concierto.fecha_desde;
    NSString *fecha_hasta=concierto.fecha_hasta;
    NSString *fecha_actividad;
    NSString *horaconcierto;
    
    if ([concierto.hora_desde length]>0)
    {
        if( [[concierto.hora_desde substringWithRange:NSMakeRange(2,1)] isEqualToString:@":" ])
        {
            horaconcierto=concierto.hora_desde;
        }
        else
        {
            NSString *horas_desde = [concierto.hora_desde substringWithRange:NSMakeRange(0,2)];
            NSString *minutos_desde = [concierto.hora_desde substringWithRange:NSMakeRange(2,2)];
        
            horaconcierto=[NSString stringWithFormat:@"%@:%@",horas_desde,minutos_desde];
        }
    

        NSString *anno_desde = [fecha_desde substringWithRange:NSMakeRange(0,4)];
        NSString *mes_desde = [fecha_desde substringWithRange:NSMakeRange(4,2)];
        NSString *dia_desde = [fecha_desde substringWithRange:NSMakeRange(6,2)];

    
        if ([fecha_desde isEqualToString:fecha_hasta]) {
        //fecha_actividad=fecha_desde;
            fecha_actividad=[NSString stringWithFormat:@"%@/%@/%@",dia_desde,mes_desde,anno_desde];
        }
        else
        {
        
            NSString *anno_hasta = [fecha_hasta substringWithRange:NSMakeRange(0,4)];
            NSString *mes_hasta = [fecha_hasta substringWithRange:NSMakeRange(4,2)];
            NSString *dia_hasta = [fecha_hasta substringWithRange:NSMakeRange(6,2)];
        
        
            fecha_actividad=[NSString stringWithFormat:@"%@/%@/%@ - %@/%@/%@",dia_desde,mes_desde,anno_desde,dia_hasta,mes_hasta,anno_hasta];
    
        }
    }
    else
    {
        fecha_actividad=@"Sin fecha";
        horaconcierto=@"";
    }
    
    
	//Poner la celda transparente [cell setBackgroundColor:[UIColor clearColor]];
    
  //  NSString *sede_provincia= [concierto.sede_provincia stringByPaddingToLength:10 withString:@" " startingAtIndex:1];

    NSString *sede_localidad= concierto.sede_localidad;
    
    while ([sede_localidad length]<15) {
        sede_localidad=[NSString stringWithFormat:@"%@ ",sede_localidad];
    }

    //NSString *sede_Concierto= [concierto.sede_nombre stringByPaddingToLength:10 withString:@" " startingAtIndex:1];
    NSString *sede_Concierto= concierto.sede_nombre;
    
   // NSString *precio_concierto;
    if ([concierto.precio length]>0)
    {
    //    precio_concierto=[NSString stringWithFormat:@"%@ €",concierto.precio];
//         precio_concierto=concierto.precio;
    }
    else
    {
 //       precio_concierto=concierto.precio;
    }
    
    NSString *subtitulo=[NSString stringWithFormat:@"%@     %@     %@    %@     %@",fecha_actividad,sede_localidad, sede_Concierto, horaconcierto,concierto.precio];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text= [subtitulo uppercaseString];
    cell.textLabel.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:13.0];
    //cell.detailTextLabel.text=nombreActividad;
    //cell.detailTextLabel.font=[UIFont fontWithName:@"Lucida Grande" size:10.0];
  //  cell.imageView.image=[UIImage imageNamed:@"825-microphoneg.png"];
   
    
    
    
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
        
    NSDictionary *Conciertos=[ConciertosAMostrar objectAtIndex:indexPath.section];
    
    //NSMutableArray *ArrayActividades=[[NSMutableArray alloc] init];
    
 
    NSMutableArray * ArrayConciertos=[Conciertos objectForKey:@"ArrayActividades"];
   
  

    
    // DetalleActividadViewController2 *DetalleActividadVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DetalleActividadVC"];
    
    
 //   DetalleActividadVC.actividad=[ArrayActividades objectAtIndex:indexPath.row];
    
    // VistaDetalleConciertoViewController *DetalleConciertoVC=[self.storyboard instantiateViewControllerWithIdentifier:@"VistaDetalleConciertoVC"];
    
    DetalleConciertoViewController *DetalleConciertoVC=[self.storyboard instantiateViewControllerWithIdentifier:@"VistaDetalleConciertoVC"];
    
    if ([segment selectedSegmentIndex]==1)
    {
       DetalleConciertoVC.concierto=[ArrayConciertos objectAtIndex:([ArrayConciertos count]-1-indexPath.row)];
    }
    else
    {
        DetalleConciertoVC.concierto=[ArrayConciertos objectAtIndex:indexPath.row];
    }
    //[self.navigationController pushViewController:DetalleActividadVC animated:YES];
    
    [self.navigationController pushViewController:DetalleConciertoVC animated:YES];
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



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *vistaHeader = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 23.0)];
    vistaHeader.backgroundColor = [UIColor blackColor];
    
    UILabel *labelTitulo = [[UILabel alloc] initWithFrame:CGRectZero];
    labelTitulo.backgroundColor = [UIColor clearColor];
    labelTitulo.opaque = NO;
    labelTitulo.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:15.0];
    labelTitulo.textColor = [UIColor whiteColor];
    labelTitulo.frame = CGRectMake(10.0, 0.0, 280.0, 23.0);
    
    
    
    NSDictionary *Actividades=[ConciertosAMostrar objectAtIndex:section];

   labelTitulo.text =  [Actividades objectForKey:@"año"];
    
    /*
    if (section == 0){
        labelTitulo.text = @"Tareas pendientes";
    }else{
        labelTitulo.text = @"Tareas completadas";
    }
    */
    [vistaHeader addSubview:labelTitulo];
    
    return vistaHeader;
}


- (IBAction)CambiarValorSegment:(UISegmentedControl *)sender {
   
    NSUInteger index = sender.selectedSegmentIndex;
    if (index==0)
    {
        ConciertosAMostrar=ConciertosPendientes;
        NSLog(@"He cambiado el segment, ahora estoy en el 0");

    }else
    {
        ConciertosAMostrar=ConciertosYaRealizados;
        NSLog(@"He cambiado el segment, ahora estoy en el 1");
        
    }
    [self.tableView reloadData];
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



@end
