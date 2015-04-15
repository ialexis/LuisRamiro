//
//  Funciones_Fechas.m
//  Gumcam
//
//  Created by Ivan on 07/04/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "Funciones_Fechas.h"

@implementation Funciones_Fechas
- (NSString *) SacarMes: (int) mes
{
    
    switch (mes) {
        case 1:
            return @"enero";
            break;
        case 2:
            return @"febrero";
            break;
        case 3:
            return @"marzo";
            break;
        case 4:
            return @"abril";
            break;
        case 5:
            return @"mayo";
            break;
        case 6:
            return @"junio";
            break;
        case 7:
            return @"julio";
            break;
        case 8:
            return @"agosto";
            break;
        case 9:
            return @"septiembre";
            break;
        case 10:
            return @"octubre";
            break;
        case 11:
            return @"noviembre";
            break;
        case 12:
            return @"diciembre";
            break;
            
        default:
            return @"indeterminado";
            break;
    } 

    
}
@end
