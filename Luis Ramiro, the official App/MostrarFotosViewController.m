//
//  MostrarFotosViewController.m
//  PruebaGaleriaFotos
//
//  Created by Ivan on 20/10/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "MostrarFotosViewController.h"
#import "AppDelegate.h"

@interface MostrarFotosViewController ()
{
      AppDelegate *appDelegate;
}


@end

@implementation MostrarFotosViewController

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
    //self.imagenAMostrar.image=self.imagen;
     appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSInteger Ancho=0;
    NSInteger Alto=0;
    if ([appDelegate.PulgadasDispositivo isEqualToString:@"3.5"])
        {
            Ancho=320;
            Alto=480;
        }
    if ([appDelegate.PulgadasDispositivo isEqualToString:@"3.5R"])
    {
        Ancho=320;
        Alto=480;
    }
    if ([appDelegate.PulgadasDispositivo isEqualToString:@"4.0"])
    {
        Ancho=320;
       // Alto=568;
        Alto=480;
    }
    

    for (int i=1; i<=[self.dataArray count];i++)
    {
        NSData *data = [NSData dataWithContentsOfFile:self.dataArray[i-1]];
        //cell.ImagenNoticia.image=[UIImage imageWithData:data];


         // UIImageView *imagen=[[UIImageView alloc] initWithImage:[UIImage imageNamed:self.dataArray[i-1]]];
        UIImageView *imagen=[[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
        
        
        imagen.frame=CGRectMake((i-1)*Ancho, 0, Ancho, Alto);
        imagen.contentMode=UIViewContentModeScaleAspectFit;
                             
        [self.scrollView addSubview:imagen];
        
    }
    self.scrollView.contentSize=CGSizeMake(([self.dataArray count])*Ancho, Alto);
                                           
    self.scrollView.pagingEnabled=YES;
    [self.scrollView setDirectionalLockEnabled:YES];
    
    CGRect frame =self.scrollView.frame;
    frame.origin.x=frame.size.width*self.posIniArray-1;
    //frame.origin.y=-300;
    
    [self.scrollView scrollRectToVisible:frame animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
