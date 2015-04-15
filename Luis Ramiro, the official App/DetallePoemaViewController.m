//
//  DetallePoemaViewController.m
//  Luis Ramiro
//
//  Created by Ivan on 02/11/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "DetallePoemaViewController.h"


@interface DetallePoemaViewController ()

@end

@implementation DetallePoemaViewController

@synthesize poema;


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
    self.TituloPoema.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:17.0];
    self.TituloPoema.text=poema.Titulo;
    
    
    self.TextoPoema.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:14.0];
    self.TextoPoema.text=poema.Poema;
    

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
