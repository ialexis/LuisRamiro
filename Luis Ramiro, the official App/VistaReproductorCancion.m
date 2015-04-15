//
//  VistaReproductorCancion.m
//  Luis Ramiro
//
//  Created by Ivan on 13/04/14.
//  Copyright (c) 2014 Ivan. All rights reserved.
//

#import "VistaReproductorCancion.h"

@interface VistaReproductorCancion ()

@end

@implementation VistaReproductorCancion

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
    // Do any additional setup after loading the view.
//     NSURLRequest *loadURL = [NSURL URLWithString:@"http://www.maestrosdelweb.com"];
//    NSURLRequest *loadURL   = [[NSURLRequest alloc] initWithURL:self.url];
    
  //  [self.webView loadRequest:loadURL];
    
    
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *loadURL = [[NSURLRequest alloc] initWithURL:url];
    
    [self.webView loadRequest:loadURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
