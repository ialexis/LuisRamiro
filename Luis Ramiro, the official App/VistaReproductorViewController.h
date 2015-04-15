//
//  VistaReproductorViewController.h
//  Social Podcaster 2
//
//  Created by Ivan on 28/02/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cancion.h"
#import "Disco.h"


@interface VistaReproductorViewController : UIViewController
{
    AppDelegate *appDelegate;
}
@property (strong) Disco *Album;
@property (strong) Cancion *Cancion;
@property (nonatomic) NSInteger Num_Pista;


   // AVAudioPlayer *Reproductor;
//@property (nonatomic,strong)AVAudioPlayer *reproductor;

//@property (strong)  NSDictionary *DatosEpisodio;

@property (retain, nonatomic) IBOutlet UIButton *BotonPlayPausa;
@property (retain, nonatomic) IBOutlet UIButton *BotonSiguiente;
@property (retain, nonatomic) IBOutlet UIButton *BotonAnterior;
@property (retain, nonatomic) IBOutlet UISlider *SliderTiempo;
@property (retain, nonatomic) IBOutlet UILabel *LabelTiempoRestante;
@property (retain, nonatomic) IBOutlet UILabel *LabelTiempoRecorrido;
@property (weak, nonatomic) IBOutlet UIImageView *ImagenDisco;
@property (weak, nonatomic) IBOutlet UITextView *TextoLetraCancion;
@property (weak, nonatomic) IBOutlet UIProgressView *SliderTiempoProgreso;


- (IBAction)PulsarPlayPausa:(id)sender;
- (IBAction)CambiarTiempoRestante:(id)sender;
- (IBAction)AdelantarCancion:(id)sender;
- (IBAction)RetrocederCancion:(id)sender;


@end
