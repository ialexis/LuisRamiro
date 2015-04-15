//
//  CeldaDiscos.h
//  Luis Ramiro
//
//  Created by Ivan on 13/04/14.
//  Copyright (c) 2014 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CeldaDiscos : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImagenDisco;
@property (weak, nonatomic) IBOutlet UILabel *TituloDisco;
@property (weak, nonatomic) IBOutlet UILabel *Num_PistasDisco;
@property (weak, nonatomic) IBOutlet UILabel *AnnoDisco;
@end
