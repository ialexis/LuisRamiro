//
//  DetalleAlbumViewController.h
//  Luis Ramiro
//
//  Created by Ivan on 10/04/14.
//  Copyright (c) 2014 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Disco.h"
#import "Cancion.h"

@interface DetalleAlbumViewController : UIViewController
{
     AppDelegate *appDelegate;
}
@property (strong) Disco *Album;


@end
