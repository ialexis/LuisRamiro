//
//  MostrarFotosViewController.h
//  PruebaGaleriaFotos
//
//  Created by Ivan on 20/10/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MostrarFotosViewController : UIViewController
{

}
//@property (weak, nonatomic) IBOutlet UIImageView *imagenAMostrar;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong) UIImage *imagen;
@property (strong) NSArray *dataArray;
@property int posIniArray;
@property (strong, nonatomic) UIWindow *window;
@end
