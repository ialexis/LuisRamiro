//
//  DetallePoemaViewController.h
//  Luis Ramiro
//
//  Created by Ivan on 02/11/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Poema.h"
@interface DetallePoemaViewController : UIViewController
@property (strong) Poema *poema;
@property (weak, nonatomic) IBOutlet UITextView *TextoPoema;
@property (weak, nonatomic) IBOutlet UILabel *TituloPoema;

@end
