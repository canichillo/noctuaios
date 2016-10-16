//
//  SPButton.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 03/03/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "SPButton.h"

@implementation SPButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Constructor por defecto
-(id) initWithFrame:(CGRect) frame
            Caption:(NSString *) caption
          TextColor:(UIColor *) textcolor
               Font:(UIFont *)font
         Background:(UIImage *) background
          Alignment:(UIControlContentHorizontalAlignment) alignment
            Padding:(UIEdgeInsets) padding
{
    if (self = [super initWithFrame:frame])
    {
        // Establecemos el título del botón
        [self setTitle:caption forState:UIControlStateNormal];
        
        // Establecemos la fuente
        self.titleLabel.font = font;
        
        // Si hemos establecido el background
        if (background != Nil)
        {
            // Establecemos la imagen del background
            [self setBackgroundImage:background forState:UIControlStateNormal];
        }
        
        // Establecemos el color del botón
        [self setTitleColor:textcolor forState:UIControlStateNormal];
    
        // Establecemos la orientación horizontal
        self.contentHorizontalAlignment = alignment;
        
        // Establecemos el padding
        self.contentEdgeInsets = padding;
    }
    return self;
}

///////////////////////////////
// Cambia el ancho del botón //
///////////////////////////////
-(void) CambiarAncho:(int)ancho
{
    // Obtenemos el tamaño actual y demás parámetros
    CGRect tamanyo = self.frame;
    
    // Actualizamos la anchura
    tamanyo.size.width = ancho;
    [self setFrame:tamanyo];
}
@end
