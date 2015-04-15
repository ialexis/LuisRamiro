//
//  VistaPoemasViewController.h
//  Luis Ramiro
//
//  Created by Ivan on 01/11/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DetallePoemaViewController.h"

@interface VistaPoemasViewController : UIViewController
{
    
    NSMutableArray *PoemasAMostrar;
    UIImageView *imagenmiembro;
    AppDelegate *appDelegate;
    //DetalleConciertoViewController *DetalleConciertoVC;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)loadPoemasFromDB;
@end
