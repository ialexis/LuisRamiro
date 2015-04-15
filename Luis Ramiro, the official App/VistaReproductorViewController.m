//
//  VistaReproductorViewController.m
//  Social Podcaster 2
//
//  Created by Ivan on 28/02/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "VistaReproductorViewController.h"
@import MediaPlayer;

@interface VistaReproductorViewController ()

@end

NSString *kTracksKey		= @"tracks";
NSString *kStatusKey		= @"status";
NSString *kRateKey			= @"rate";
NSString *kPlayableKey		= @"playable";
NSString *kCurrentItemKey	= @"currentItem";
NSString *kTimedMetadataKey	= @"currentItem.timedMetadata";
NSData *datos ;
NSString *estadoReproductor;
Cancion *cancion_reproduciendose;
NSData *DatosimagenDisco;
AVURLAsset* audioAsset ;
CMTime audioDuration;

@implementation VistaReproductorViewController
@synthesize BotonPlayPausa,SliderTiempo,LabelTiempoRecorrido,LabelTiempoRestante;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Turn on remote control event delivery
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // Set itself as the first responder
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    // Turn off remote control event delivery
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    // Resign as first responder
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self PulsarPlayPausa: nil];
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                [self PulsarPlayPausa: nil];
                break;

            case UIEventSubtypeRemoteControlPause:
                [self PulsarPlayPausa: nil];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self AdelantarCancion:nil];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self RetrocederCancion:nil];
                break;
     

            default:
                break;
        }
     //   NSLog(receivedEvent.subtype);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
	// Do any additional setup after loading the view.
    //cargamos la imagen del disco
    NSURL *url=[NSURL URLWithString:self.Album.Url_Imagen];
    NSData *data=Nil;
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory=[paths objectAtIndex:0];
    
    
    NSString *nombreFichero = [[[self.Album.Url_Imagen stringByReplacingOccurrencesOfString:@"/"withString:@"_"]stringByReplacingOccurrencesOfString:@":" withString:@"_"]stringByReplacingOccurrencesOfString:@"www." withString:@"www_"];
    
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
    
    DatosimagenDisco=data;
    
    self.ImagenDisco.image=[UIImage imageWithData:data];
    
    
    
    [self ReproducirCancion:self.Num_Pista];
    
}

-(void) ReproducirCancion:(NSInteger) Num_Cancion
{
    
    
    //miramos que tenga una cancion valida
    if (Num_Cancion<0)
    {
        return;
    }
    if (Num_Cancion>=[self.Album.aCanciones count])
    {
                         
        return;
    }
    
    NSString *accion = @"Avanzar";
    if (Num_Cancion<self.Num_Pista)
    {
        accion = @"Retroceder";
        
    }

    
    cancion_reproduciendose=[self.Album.aCanciones objectAtIndex:Num_Cancion];
    
    if (![cancion_reproduciendose.Enlace isEqualToString:@""])
    {
        
        if (![[cancion_reproduciendose.Enlace substringWithRange:NSMakeRange(0,4)] isEqualToString:@"http"])
        {
            cancion_reproduciendose.Enlace = [NSString stringWithFormat:@"http://%@", cancion_reproduciendose.Enlace];
        }
        
        self.Num_Pista=Num_Cancion;
        
        appDelegate.url_cancion_actual=cancion_reproduciendose.Enlace;
  
        //ponemos la letra de la cancion
        self.TextoLetraCancion.text=cancion_reproduciendose.letra;
        self.TextoLetraCancion.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:14.0];
        self.TextoLetraCancion.textAlignment=NSTextAlignmentCenter;
        
        UIImage * pausa = [UIImage imageNamed:@"17-pause.png"];
        
        NSURL *urlfichero = [NSURL URLWithString:appDelegate.url_cancion_actual];
        
        AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:urlfichero options:nil];
        audioDuration= audioAsset.duration;
        
        
        [BotonPlayPausa setImage:pausa forState:UIControlStateNormal];
        [BotonPlayPausa setImage:pausa forState:UIControlStateSelected];
        // BotonPlayPausa.imageView.image=[UIImage imageNamed:@"17-pause.png"];
        estadoReproductor=@"play";
        
        
        appDelegate.reproductor=[[AVPlayer alloc]initWithURL:urlfichero];
        
        [appDelegate.reproductor play];
        
        
        
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(PonerTiempos)
                                       userInfo:nil
                                        repeats:YES];
        
        
        
        
        
        SliderTiempo.minimumValue=0;
        //  SliderTiempo.maximumValue=[self.DatosEpisodio.DuracionCapitulo floatValue];
        
        //    [BotonPlayPausa setSelected:NO];
        //  [BotonPlayPausa setBackgroundImage:pausa forState:UIControlStateNormal];
        estadoReproductor=@"play";
        
        
        
        //  [BotonPlayPausa setSelected:YES];
        
        
        NSString *TituloCancion= cancion_reproduciendose.Titulo;
        
        if ([MPNowPlayingInfoCenter class])
        {
            // Step 2: image and track name
            //   UIImage *musicImage = [UIImage imageNamed:@"fondo2.png"];
            UIImage *musicImage = [UIImage imageWithData:DatosimagenDisco];
            MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc]
                                            initWithImage:musicImage];
            
            NSString *trackName = TituloCancion;
            NSString *Autor=@"Luis Ramiro";
            
            // Step 3: Create arrays
            NSArray *objs = [NSArray arrayWithObjects:
                             trackName,
                             albumArt,
                             Autor,
                             nil];
            
            NSArray *keys = [NSArray arrayWithObjects:
                             MPMediaItemPropertyTitle,
                             MPMediaItemPropertyArtwork,
                             MPMediaItemPropertyAlbumArtist,
                             MPMusicPlaybackStateStopped,nil];
            
            // Step 4: Create dictionary.
            NSDictionary *currentTrackInfo = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
            
            // Step 5: Set now playing info
            [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = currentTrackInfo;
            
        }
  
        
    }
    else
    {
        //si la siguiente cancion a reproducir no tiene url
        if ([accion isEqualToString:@"Avanzar"])
        {
            [self ReproducirCancion:Num_Cancion+1];
        }
        else
        {
            [self ReproducirCancion:Num_Cancion-1];
        }
        
    }
    
   
}

-(void) PonerTiempos
{
    CMTime durationV = appDelegate.reproductor.currentTime;
    
    NSUInteger dTotalSegundosReproducidos = CMTimeGetSeconds(durationV);
    NSUInteger dTotalSegundos = CMTimeGetSeconds(audioDuration);
    NSUInteger dTotalSegundosRestantes=dTotalSegundos-dTotalSegundosReproducidos;
    
    NSUInteger dHours = floor(dTotalSegundosReproducidos / 3600);
    NSUInteger dMinutes = floor(dTotalSegundosReproducidos % 3600 / 60);
    NSUInteger dSeconds = floor(dTotalSegundosReproducidos % 3600 % 60);
    
   self.LabelTiempoRecorrido.text = [NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds];
   
    
    
    dHours = floor(dTotalSegundosRestantes / 3600);
    dMinutes = floor(dTotalSegundosRestantes % 3600 / 60);
    dSeconds = floor(dTotalSegundosRestantes % 3600 % 60);
    
    self.LabelTiempoRestante.text = [NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds];

    //self.LabelTiempoRecorrido.text= appDelegate.reproductor.currentTime;
 //   self.LabelTiempoRestante=[appDelegate.reproductor.
    
    //self.SliderTiempoProgreso.progress
   
    if ([MPNowPlayingInfoCenter class])
    {
        // Step 2: image and track name
        //   UIImage *musicImage = [UIImage imageNamed:@"fondo2.png"];
        UIImage *musicImage = [UIImage imageWithData:DatosimagenDisco];
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc]
                                        initWithImage:musicImage];
        
        NSString *TituloCancion= cancion_reproduciendose.Titulo;
        NSString *trackName = TituloCancion;
        NSString *Autor=@"Luis Ramiro";
        
        // Step 3: Create arrays
        NSArray *objs = [NSArray arrayWithObjects:
                         trackName,
                         albumArt,
                        Autor,
                         [NSString stringWithFormat:@"%lu",(unsigned long)dTotalSegundosRestantes],
                         [NSString stringWithFormat:@"%lu",(unsigned long)dTotalSegundosReproducidos],
                         nil];
        
        
        NSArray *keys = [NSArray arrayWithObjects:
                         MPMediaItemPropertyTitle,
                         MPMediaItemPropertyArtwork,
                         MPMediaItemPropertyAlbumArtist,
                         MPMediaItemPropertyPlaybackDuration,
                         MPNowPlayingInfoPropertyElapsedPlaybackTime,
                         nil
            ];
        
        // Step 4: Create dictionary.
        NSDictionary *currentTrackInfo = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
        
        // Step 5: Set now playing info
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = currentTrackInfo;
        
    }
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)PulsarPlayPausa:(id)sender {
   /*
    if (BotonPlayPausa.selected)
    {
        [reproductor pause];
        [BotonPlayPausa setSelected:NO];
        BotonPlayPausa.imageView.image=[UIImage imageNamed:@"17-pause.png"];
        NSLog(@"Play Selected");
    }
    else
    {
        [reproductor play];
        [BotonPlayPausa setSelected:YES];
        BotonPlayPausa.imageView.image=[UIImage imageNamed:@"16-play.png"];
        NSLog(@"pause Selected");
        
        
    }

    */
    UIImage * pausa = [UIImage imageNamed:@"17-pause.png"];
    UIImage * play = [UIImage imageNamed:@"16-play.png"];
    
    if ([estadoReproductor isEqualToString:@"play"])
    {
        [appDelegate.reproductor pause];
        [BotonPlayPausa setImage:play forState:UIControlStateNormal];
        [BotonPlayPausa setImage:play forState:UIControlStateSelected];
        [BotonPlayPausa setAccessibilityValue:@"Pausa"];
        //BotonPlayPausa.imageView.image=[UIImage imageNamed:@"16-play.png"];
        estadoReproductor=@"pausa";
        NSLog(@"pausada");
    
    }
    else
    {
         
        [appDelegate.reproductor play];
       // [BotonPlayPausa setBackgroundImage:pausa forState:UIControlStateNormal];
        [BotonPlayPausa setImage:pausa forState:UIControlStateNormal];
        [BotonPlayPausa setImage:pausa forState:UIControlStateSelected];
        [BotonPlayPausa setAccessibilityValue:@"Play"];
       // BotonPlayPausa.imageView.image=[UIImage imageNamed:@"17-pause.png"];
        estadoReproductor=@"play";
        NSLog(@"play");
    }



}

- (IBAction)CambiarTiempoRestante:(id)sender {
    //reproductor.currentItem set
}

- (IBAction)AdelantarCancion:(id)sender {
    [self ReproducirCancion:self.Num_Pista+1];
}

- (IBAction)RetrocederCancion:(id)sender {
     [self ReproducirCancion:self.Num_Pista-1];
}
@end
