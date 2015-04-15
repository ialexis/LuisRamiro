//
//  VistaReproductorCancion.h
//  Luis Ramiro
//
//  Created by Ivan on 13/04/14.
//  Copyright (c) 2014 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VistaReproductorCancion : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong) NSString        *url;
@end
