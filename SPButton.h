//
//  SPButton.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 03/03/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPButton : UIButton

// Constructor por defecto
-(id) initWithFrame:(CGRect) frame
            Caption:(NSString *) caption
          TextColor:(UIColor *) textcolor
               Font:(UIFont *) font
         Background:(UIImage *) background
          Alignment:(UIControlContentHorizontalAlignment) alignment
            Padding:(UIEdgeInsets) padding;

// Cambia el ancho del botón
-(void) CambiarAncho: (int) ancho;
@end
