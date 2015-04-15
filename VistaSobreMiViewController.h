//
//  VistaSobreMiViewController.h
//  Luis Ramiro
//
//  Created by Ivan on 14/10/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface VistaSobreMiViewController : UIViewController
{
    AppDelegate *appDelegate;
    
}
@property (weak, nonatomic) IBOutlet UITextView *Bio;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *UIindicador;
@end
