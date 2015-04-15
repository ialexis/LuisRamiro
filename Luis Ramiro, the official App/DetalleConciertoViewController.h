//
//  DetalleConciertoViewController.h
//  Gumcam
//
//  Created by Ivan on 05/04/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Concierto.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>

@interface DetalleConciertoViewController : UIViewController <MKMapViewDelegate>
{
//    IBOutlet UIScrollView *scroll;
    AppDelegate *appDelegate;
    IBOutlet MKMapView *mapa;
}
@property (weak, nonatomic) IBOutlet UITextField *TextHora;
@property (weak, nonatomic) IBOutlet UITextField *TextFecha;
@property (weak, nonatomic) IBOutlet UITextField *TextLugar;

@property (weak, nonatomic) IBOutlet UITextField *TextDireccion;
@property (weak, nonatomic) IBOutlet UITextField *TextPrecio;
@property (weak, nonatomic) IBOutlet UITextView *TextDescripcion;
@property (weak, nonatomic) IBOutlet UITextField *TextDireccion2;
@property (weak, nonatomic) IBOutlet UIButton *BotonVentaAnticipada;


/*
@property (weak, nonatomic) IBOutlet UIImageView *IconoActividad;
@property (weak, nonatomic) IBOutlet UILabel *Tipo_Actividad;
@property (weak, nonatomic) IBOutlet UITextView *Titulo_Actividad;
@property (weak, nonatomic) IBOutlet UIButton *Lugar;
@property (weak, nonatomic) IBOutlet UILabel *fecha_actividad;
@property (weak, nonatomic) IBOutlet UILabel *Hora_Actividad;
@property (weak, nonatomic) IBOutlet UITextView *Detalle_Actividad;
*/
 @property (strong) Concierto *concierto;

/*@property (weak, nonatomic) IBOutlet UISwitch *MeApunto;
@property (weak, nonatomic) IBOutlet UILabel *etiquetaMeApunto;

@property (weak, nonatomic) IBOutlet UIView *SeparadorPonentes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
*/
- (NSString *) SacarMes: (int) mes;
- (IBAction)PulsarVentaAnticipada:(id)sender;
@end
