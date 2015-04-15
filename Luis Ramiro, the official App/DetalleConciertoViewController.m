    //
//  DetalleConciertoViewController.m
//  Gumcam
//
//  Created by Ivan on 05/04/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "DetalleConciertoViewController.h"
#import "Funciones_Fechas.h"
#import <QuartzCore/QuartzCore.h>

@interface DetalleConciertoViewController ()
{
    NSString *hh_desde;
    NSString *mm_desde;
    NSString *hhmm_desde;
    
    NSString *hh_hasta;
    NSString *mm_hasta;
    NSString *hhmm_hasta;
    
    NSString *Hora_Inicio;
    NSString *Fecha_Inicio;

}
@end

@implementation DetalleConciertoViewController
@synthesize concierto;




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //como el tamaño que hay que mostrar del icono es mayor, se coge un tamaño grande
    //1.-cojo los ultimos 4 caracteres (el punto y las 3 letras del formato)
     appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [self SacarFechasYHoras];
    
    [self setTitle:[concierto titulo]];
    
    
    NSString *Direccion=[NSString stringWithFormat:@"%@,%@",concierto.sede_calle,concierto.sede_numero];
    
    NSString *Direccion2=[NSString stringWithFormat:@"%@ - %@",concierto.sede_localidad,concierto.sede_provincia];

    
    self.TextHora.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:13.0];
    self.TextFecha.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:13.0];
    self.TextLugar.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:13.0];
    self.TextDireccion.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:13.0];
    self.TextDireccion2.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:13.0];
    self.TextDescripcion.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:13.0];
    self.TextPrecio.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:13.0];
    
    
    self.TextHora.text=[Hora_Inicio uppercaseString];
    self.TextFecha.text=[Fecha_Inicio uppercaseString];
    self.TextLugar.text=[concierto.sede_nombre uppercaseString];
    self.TextDireccion.text=[Direccion uppercaseString];
    self.TextDireccion2.text=[Direccion2 uppercaseString];
    //self.TextDescripcion.text=[concierto.venta_anticipada uppercaseString];
    
    concierto.descripcion = [concierto.descripcion stringByReplacingOccurrencesOfString:@"&quot;"withString:@"'"];
    
    //si no hay url de venta anticipada, se oculta el boton
    NSUInteger length =[concierto.venta_anticipada length];
    if (length==0)
    {
        [self.BotonVentaAnticipada setHidden:TRUE];
    }
    else
    {
        [self.BotonVentaAnticipada setHidden:FALSE];
    }
    // fin ¿ocultar? boton venta anticipada
    
   
    
    self.TextDescripcion.text=[concierto.descripcion uppercaseString];
    self.TextPrecio.text=[concierto.precio uppercaseString];
    
/*    if (([appDelegate.PulgadasDispositivo isEqualToString:@"3.5"]) ||  ([appDelegate.PulgadasDispositivo isEqualToString:@"3.5R"]))
    {
        //mapa.frame  = CGRectMake(0.0, 100, 320.0, 281.0);
        
        mapa.frame  = CGRectMake(mapa.frame.origin.x, mapa.frame.origin.y,mapa.frame.size.width,350.0);
    }
    else if  ([appDelegate.PulgadasDispositivo isEqualToString:@"4.0"])
    {
        //mapa.frame  = CGRectMake(0.0, 100, 320.0, 400.0);
        mapa.frame  = CGRectMake(mapa.frame.origin.x, mapa.frame.origin.y, mapa.frame.size.width, 430.0);
    }

  */
    
    mapa.showsUserLocation=YES;
    mapa.delegate=self;
    CLLocationCoordinate2D SedeActividad;

    SedeActividad.latitude = [self.concierto.sede_latitud doubleValue];
    SedeActividad.longitude = [self.concierto.sede_longitud doubleValue];
 
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = SedeActividad;
    annotationPoint.title = self.concierto.sede_nombre;
    annotationPoint.subtitle = [NSString stringWithFormat:@"%@,%@,%@,%@",self.concierto.sede_calle,self.concierto.sede_numero,self.concierto.sede_localidad,self.concierto.sede_provincia];

   [mapa addAnnotation:annotationPoint];
    /*-------------------------------------------*/
    
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(SedeActividad, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [mapa regionThatFits:viewRegion];
    [mapa setRegion:adjustedRegion animated:YES];
    [mapa selectAnnotation:annotationPoint animated:YES];
    
    /*/
    
    //Control User Location on Map
    [CLLocationManager requestWhenInUseAuthorization];

    if ([CLLocationManager locationServicesEnabled])
    {
        mapa.showsUserLocation = YES;
        [mapa setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
    else
    {
        mapa.showsUserLocation = NO;
    }
    */
   
}

- (IBAction)PulsarVentaAnticipada:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:concierto.venta_anticipada]];
    
    
}

- (IBAction)startInDirectionsMode:(id)sender
{
    
    
   // CLLocationCoordinate2D bigBenLocation = CLLocationCoordinate2DMake(51.50065200, -0.12483300);
    
    /*
    CLLocationCoordinate2D bigBenLocation = mapa.userLocation.coordinate;
    
    MKPlacemark *bigBenPlacemark = [[MKPlacemark alloc]
                                    initWithCoordinate:bigBenLocation addressDictionary:nil];
    MKMapItem *bigBenItem = [[MKMapItem alloc] initWithPlacemark:bigBenPlacemark];
    bigBenItem.name = @"Ubicación Actual";
   */
    
    
    CLLocationCoordinate2D ConciertoLocation =
    CLLocationCoordinate2DMake([concierto.sede_latitud doubleValue], [concierto.sede_longitud doubleValue]);
    MKPlacemark *ConciertoPlacemark = [[MKPlacemark alloc]
                                         initWithCoordinate:ConciertoLocation addressDictionary:nil];
    MKMapItem *ConciertoItem = [[MKMapItem alloc]
                                  initWithPlacemark:ConciertoPlacemark];
    ConciertoItem.name = concierto.sede_nombre;
    
//    NSArray *items = [[NSArray alloc] initWithObjects:bigBenItem, westminsterItem, nil];

    NSArray *items = [[NSArray alloc] initWithObjects:ConciertoItem, nil];

    NSDictionary *options =
    @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving};
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"curr"];
    
    pinView.animatesDrop=YES;
    pinView.pinColor=MKPinAnnotationColorGreen;
    pinView.canShowCallout=YES;
    
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory=[paths objectAtIndex:0];
    
    NSData *data = nil;
    
    NSString *url_Foto = concierto.sede_imagen;
    
    NSURL *url=[NSURL URLWithString:url_Foto];
    
    NSString *nombreFichero = [[[url_Foto stringByReplacingOccurrencesOfString:@"/"withString:@"_"]stringByReplacingOccurrencesOfString:@":" withString:@"_"]stringByReplacingOccurrencesOfString:@"www." withString:@"www_"];
    
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
    
    
    UIImageView *imagenLuisRamiro=[[UIImageView alloc]initWithImage:[UIImage imageWithData:data]];
    //UIImageView *imagenLuisRamiro=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LuisRamiro.png"]];
    
    
    
    
    
    
    [imagenLuisRamiro setFrame:CGRectMake(0, 0, 45, 45)];
    
    CALayer * l = [imagenLuisRamiro layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[[UIColor blackColor] CGColor]];
    
    pinView.leftCalloutAccessoryView=imagenLuisRamiro;
    //pinView.rightCalloutAccessoryView=imagenLuisRamiro;
    UIButton *botonPin=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    [botonPin addTarget:self action:@selector(startInDirectionsMode:) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView=botonPin;
    
    
    return pinView;

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
   // MyLocation *location = (MyLocation*)view.annotation;
    
  //  NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
   // [pinview.mapItem openInMapsWithLaunchOptions:launchOptions];
}
  
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) SacarMes: (int) mes
{
    
    switch (mes) {
        case 1:
            return @"enero";
            break;
        case 2:
            return @"febrero";
            break;
        case 3:
            return @"marzo";
            break;
        case 4:
            return @"abril";
            break;
        case 5:
            return @"mayo";
            break;
        case 6:
            return @"junio";
            break;
        case 7:
            return @"julio";
            break;
        case 8:
            return @"agosto";
            break;
        case 9:
            return @"septiembre";
            break;
        case 10:
            return @"octubre";
            break;
        case 11:
            return @"noviembre";
            break;
        case 12:
            return @"diciembre";
            break;
            
        default:
            return @"ERROR";
            break;
    }
}

-(void) SacarFechasYHoras
{
    NSString *anno_desde = [concierto.fecha_desde substringWithRange:NSMakeRange(0,4)];
    NSString *mes_desde = [concierto.fecha_desde substringWithRange:NSMakeRange(4,2)];
    NSString *dia_desde = [concierto.fecha_desde substringWithRange:NSMakeRange(6,2)];
    
    Fecha_Inicio = [NSString stringWithFormat:@"%@/%@/%@",dia_desde,mes_desde,anno_desde];

    
    
    
    if (![concierto.hora_desde isEqualToString:@""])
    {
        
        if( [[concierto.hora_desde substringWithRange:NSMakeRange(2,1)] isEqualToString:@":" ])
        {
            
            hhmm_desde=concierto.hora_desde;
        }
        else
        {
            hh_desde = [concierto.hora_desde substringWithRange:NSMakeRange(0,2)];
            mm_desde = [concierto.hora_desde substringWithRange:NSMakeRange(2,2)];
            hhmm_desde = [NSString stringWithFormat:@"%@:%@",hh_desde,mm_desde];        }
        

        
       
    }
    else
    {
        hhmm_desde =@"sin asignar";
        
    }
    if (![concierto.hora_hasta isEqualToString:@""])
    {
        hh_hasta = [concierto.hora_hasta substringWithRange:NSMakeRange(0,2)];
        mm_hasta = [concierto.hora_hasta substringWithRange:NSMakeRange(2,2)];
        hhmm_hasta = [NSString stringWithFormat:@"%@:%@",hh_hasta,mm_hasta];
    }
    else
    {
        hhmm_hasta =@"sin asignar";
        
    }
    Hora_Inicio=hhmm_desde;
    
    
    /*
    self.fecha_actividad.text=fecha_actividad;
    
    
    if ((![hhmm_desde isEqualToString:@"sin asignar"]) && (![hhmm_hasta isEqualToString:@"sin asignar"]))
    {
        horario_actividad=[NSString stringWithFormat:@"%@ - %@",hhmm_desde,hhmm_hasta];
    }
    else if ((![hhmm_desde isEqualToString:@"sin asignar"]) && ([hhmm_hasta isEqualToString:@"sin asignar"]))
    {
        horario_actividad=hhmm_desde;
    }
    else
    {
        horario_actividad=@"sin asignar";
        
    }
     */

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 /*   if ([segue.identifier isEqualToString:@"VerSedeActividad"])
    {
        DetalleSedeViewController *dsvc = segue.destinationViewController;
        dsvc.actividad=self.actividad;
    }
    if ([segue.identifier isEqualToString:@"VerPeli"])
    {
        VideoActividadViewController *vavc = segue.destinationViewController;
        vavc.url=[NSURL URLWithString:@"http://www.gumcam.org/VideoMoviles.php"];
        //vavc.url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"NSCodeCenter" ofType:@"html"]];
                 
    
    }
  */
}
- (void)viewDidUnload {
    
    [super viewDidUnload];
}
@end
