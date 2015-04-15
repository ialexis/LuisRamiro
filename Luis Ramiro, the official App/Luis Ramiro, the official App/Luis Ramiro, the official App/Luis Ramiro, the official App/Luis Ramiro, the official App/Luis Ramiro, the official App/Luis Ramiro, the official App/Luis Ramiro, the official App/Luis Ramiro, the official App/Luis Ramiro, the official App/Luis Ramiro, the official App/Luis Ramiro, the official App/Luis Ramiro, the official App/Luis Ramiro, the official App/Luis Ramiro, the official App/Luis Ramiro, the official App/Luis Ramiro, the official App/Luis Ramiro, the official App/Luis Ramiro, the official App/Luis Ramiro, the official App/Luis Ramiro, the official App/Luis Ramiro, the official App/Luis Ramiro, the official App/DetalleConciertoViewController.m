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
    
    
/*
    [self loadPonentesFromDB];
    
    [scroll setScrollEnabled:YES];
    [scroll setContentSize:CGSizeMake(320, 1000)];
    
 */
 //NSString *extension_imagen_icono =[[concierto tipo_actividad_imagen] substringWithRange:NSMakeRange([actividad tipo_actividad_imagen].length-4,4)];
    
    //2.-saco el nuevo final de la imagen
  //  NSString *nuevo_fin_extension_imagen=[extension_imagen_icono stringByReplacingOccurrencesOfString:@"."withString:@"_grande."];
    
    //3.-reemplazo el finl de la imagen por el nuevo
   // NSString *imagen_icono_grande= [[actividad tipo_actividad_imagen] stringByReplacingOccurrencesOfString:extension_imagen_icono withString:nuevo_fin_extension_imagen];
    
   /*
    self.Titulo_Actividad.text=[self.concierto titulo];
    self.Tipo_Actividad.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    self.Tipo_Actividad.textColor=[UIColor redColor];
  //  self.IconoActividad.image=[UIImage imageNamed:imagen_icono_grande];
    self.Detalle_Actividad.text=self.concierto.descripcion;
  
    
    self.Detalle_Actividad.text = [[self.concierto.descripcion stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n\n"]stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    NSString *fecha_desde=concierto.fecha_desde;
    NSString *fecha_hasta=concierto.fecha_hasta;
    NSString *hora_desde=concierto.hora_desde;
    NSString *hora_hasta=concierto.hora_hasta;
    NSString *fecha_actividad;
    NSString *horario_actividad;
    
    
    NSString *anno_desde = [fecha_desde substringWithRange:NSMakeRange(0,4)];
    NSString *mes_desde = [fecha_desde substringWithRange:NSMakeRange(4,2)];
    NSString *dia_desde = [fecha_desde substringWithRange:NSMakeRange(6,2)];

    
    NSString *hh_desde;
    NSString *mm_desde;
    NSString *hhmm_desde;
    
    NSString *hh_hasta;
    NSString *mm_hasta;
    NSString *hhmm_hasta;
    
    
    if (![hora_desde isEqualToString:@""])
    {

        hh_desde = [hora_desde substringWithRange:NSMakeRange(0,2)];
        mm_desde = [hora_desde substringWithRange:NSMakeRange(2,2)];
        hhmm_desde = [NSString stringWithFormat:@"%@:%@",hh_desde,mm_desde];
    }
    else
    {
        hhmm_desde =@"sin asignar";
       
    }
    if (![hora_hasta isEqualToString:@""])
    {
        hh_hasta = [hora_hasta substringWithRange:NSMakeRange(0,2)];
        mm_hasta = [hora_hasta substringWithRange:NSMakeRange(2,2)];
        hhmm_hasta = [NSString stringWithFormat:@"%@:%@",hh_hasta,mm_hasta];
    }
    else
    {
        hhmm_hasta =@"sin asignar";

    }
 
    if ([fecha_desde isEqualToString:fecha_hasta])
    {
        int iMes;
        
        iMes = [mes_desde intValue];
        fecha_actividad=[NSString stringWithFormat:@"%@ de %@ de %@",dia_desde,[self SacarMes:iMes],anno_desde];
    }
    else
    {
        
        NSString *anno_hasta = [fecha_hasta substringWithRange:NSMakeRange(0,4)];
        NSString *mes_hasta = [fecha_hasta substringWithRange:NSMakeRange(4,2)];
        NSString *dia_hasta = [fecha_hasta substringWithRange:NSMakeRange(6,2)];
        
        
        fecha_actividad=[NSString stringWithFormat:@"%@/%@/%@ - %@/%@/%@",dia_desde,mes_desde,anno_desde,dia_hasta,mes_hasta,anno_hasta];
        
    }
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
    self.Hora_Actividad.text=horario_actividad;
//    [self.Lugar setTitle:self.concierto.sede forState:UIControlStateNormal];
//    [self.Lugar setTitle:self.concierto.sede forState:UIControlStateSelected];
    
    
    //se ajusta el tamaño de detalle actividad para que ocupe el espacio necesario
    CGRect frame = self.Detalle_Actividad.frame;
    frame.size.height = self.Detalle_Actividad.contentSize.height;
    self.Detalle_Actividad.frame = frame;
    
    //se ajustan los titulos de "me apunto" y el switch para apuntarse en funcion del nuevo tamaño del frame
    self.etiquetaMeApunto.frame=CGRectMake(self.etiquetaMeApunto.frame.origin.x, self.Detalle_Actividad.frame.origin.y+self.Detalle_Actividad.frame.size.height+10, self.etiquetaMeApunto.frame.size.width, self.etiquetaMeApunto.frame.size.height);
    self.MeApunto.frame=CGRectMake(self.MeApunto.frame.origin.x, self.Detalle_Actividad.frame.origin.y+self.Detalle_Actividad.frame.size.height+10, self.MeApunto.frame.size.width, self.MeApunto.frame.size.height);
    

    //se ajusta la tabla de ponentes para que quede en la posicion y tamaño adecuados
    float puntoX;
    float puntoY;
    float Ancho;
    float Alto;
    
    //puntoX=self.SeparadorPonentes.frame.origin.x+self.SeparadorPonentes.frame.size.height;
    puntoX=0.0;
    
    if (([appDelegate.PulgadasDispositivo isEqualToString:@"3.5"]))
    {
        puntoY=self.MeApunto.frame.origin.y+5;
    }
    else if  ([appDelegate.PulgadasDispositivo isEqualToString:@"3.5R"])
    {
        puntoY=self.MeApunto.frame.origin.y+10;
     
    }
    else
    {
        //mapa.frame  = CGRectMake(0.0, 100, 320.0, 400.0);
        puntoY=self.MeApunto.frame.origin.y+15;

    }


    //puntoY=self.MeApunto.frame.origin.y+10;
    Ancho=323;
    Alto=(44*([miembrosPonentes count]+5));
    self.tableView.frame = CGRectMake(puntoX,puntoY,Ancho,Alto);
    self.SeparadorPonentes.frame=CGRectMake(puntoX,puntoY-10,Ancho,5);
 
    [scroll setContentSize:CGSizeMake(323, self.tableView.frame.origin.y+ self.tableView.frame.size.height-62)];
    */

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
