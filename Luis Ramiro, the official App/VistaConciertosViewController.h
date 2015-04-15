//
//  VistaConciertosViewController.h
//  Gumcam
//
//  Created by Ivan on 30/03/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "VistaDetalleConciertoViewController.h"
#import "DetalleConciertoViewController.h"

@interface VistaConciertosViewController : UIViewController
{

    NSMutableArray *ConciertosPendientes;
    NSMutableArray *ConciertosYaRealizados;
    NSMutableArray *ConciertosAMostrar;
    UIImageView *imagenmiembro;
    AppDelegate *appDelegate;
    //DetalleConciertoViewController *DetalleConciertoVC;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)CambiarValorSegment:(UISegmentedControl *)sender;
- (void)loadConciertosFromDB;
@end



