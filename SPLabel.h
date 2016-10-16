//
//  SPLabel.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 19/03/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPLabel : UILabel
@property (nonatomic) UIEdgeInsets padding;

// Inicializa el campo de texto
-(id) initWithFrame:(CGRect) frame
               Text:(NSString *) texto
               Font:(UIFont *) fuente
          TextColor:(UIColor *) colortexto
          Alignment:(NSTextAlignment) alineacion
            Padding:(UIEdgeInsets ) padding
              Padre:(UIView *) padre;

// Inicializador de conveniencia
-(id) initWithFrame:(CGRect) frame
               Text:(NSString *) texto
              Padre:(UIView *) padre;

// Inicializador de conveniencia
-(id) initWithFrame:(CGRect) frame
               Text:(NSString *) texto
               Font:(UIFont *) fuente
          TextColor:(UIColor *) colortexto
              Padre:(UIView *) padre;

// Cambia el ancho
-(void) CambiarAncho: (int) ancho;

// Cambia el alto
-(void) CambiarAlto: (int) alto;

// Cambia la posición
-(void) CambiarPosicion: (CGPoint) pos;

// Cambia la posición en X
-(void) CambiarPosicionX: (int) posX;

// Cambia la posición en Y
-(void) CambiarPosicionY: (int) posY;
@end
