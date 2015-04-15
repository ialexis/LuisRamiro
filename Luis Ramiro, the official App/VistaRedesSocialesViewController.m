//
//  VistaRedesSocialesViewController.m
//  Luis Ramiro
//
//  Created by Ivan on 19/10/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "VistaRedesSocialesViewController.h"

@interface VistaRedesSocialesViewController ()

@end

@implementation VistaRedesSocialesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithWebPage: (NSString *) url
{
    
    if (self=[super init])
    {
        _url =[NSURL URLWithString:url];
    }
    return self;
}
-(id) initWithPDFDocument: (NSString *) nombrePDF
{
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[super viewWillAppear:YES];
    self.webView.delegate=self;
    self.url=[NSURL URLWithString:@"https://twitter.com/luisramiromusic"];
    [self displayURL:self.url];

    
}

- (IBAction)CambiarValorSegment:(UISegmentedControl *)sender {
    
    NSUInteger index = sender.selectedSegmentIndex;
    if (index==0)
    {
        //ConciertosAMostrar=ConciertosPendientes;
        self.url=[NSURL URLWithString:@"https://twitter.com/luisramiromusic"];
        NSLog(@"He cambiado el segment, ahora estoy en el twitter");
        
    }else
    {
        //ConciertosAMostrar=ConciertosYaRealizados;
        self.url=[NSURL URLWithString:@"https://www.facebook.com/luisramiromusic"];

        NSLog(@"He cambiado el segment, ahora estoy en el facebook");
        
    }
   // [self.tableView reloadData];

    //[self.webView loadRequest:[[NSURLRequest alloc] initWithURL:self.url]];
    [self displayURL:self.url];

}

-(void) displayURL:(NSURL *) aURL
{
    self.activityView.hidden=NO;
    [self.activityView startAnimating];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:aURL]];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    self.activityView.hidden=YES;
    [self.activityView stopAnimating];
}

@end
