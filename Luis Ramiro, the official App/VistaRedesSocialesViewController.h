//
//  VistaRedesSocialesViewController.h
//  Luis Ramiro
//
//  Created by Ivan on 19/10/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VistaRedesSocialesViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong) NSURL        *url;
@property (strong) NSString  *nombrePDF;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

-(id) initWithWebPage: (NSString *) url;
-(id) initWithPDFDocument: (NSString *) nombrePDF;
- (IBAction)CambiarValorSegment:(UISegmentedControl *)sender;
-(void) displayURL:(NSURL *) aURL;
@end
