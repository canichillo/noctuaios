//
//  SPLabel.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 19/03/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "SPLabel.h"

@implementation SPLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//////////////////////////////////
// Inicializa el campo de texto //
//////////////////////////////////
-(id) initWithFrame:(CGRect) frame
               Text:(NSString *) texto
               Font:(UIFont *) fuente
          TextColor:(UIColor *) colortexto
          Alignment:(NSTextAlignment) alineacion
            Padding:(UIEdgeInsets ) padding
              Padre:(UIView *) padre
{
    // Si inicializamos correctamente
    if (self = [super initWithFrame:frame])
    {
        // Esablecemos el texto
        [self setText: texto];
        
        // Si hemos establecido la fuente
        if (fuente != nil)
        {
            // Establecemos la fuente
            [self setFont:fuente];
        }
        
        // Establecemos la alineación del texto
        self.textAlignment = alineacion;
        
        // Si hemos establecido el color de la fuente
        if (colortexto != nil)
        {
            // Establecemos el color del texto
            self.textColor = colortexto;
        }
        
        // Establecemos el padding
        self.padding = padding;
        
        // Añadimos el elemento al padre
        [padre addSubview:self];
    }
    
    return self;
}

/////////////////////////////////////
// Inicializadores de conveniencia //
/////////////////////////////////////
-(id) initWithFrame:(CGRect) frame
               Text:(NSString *) texto
              Padre:(UIView *) padre
{
    return [self initWithFrame:frame
                          Text:texto
                          Font:nil
                     TextColor:nil
                     Alignment:NSTextAlignmentLeft
                       Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                         Padre:padre];
}

// Inicializador de conveniencia
-(id) initWithFrame:(CGRect) frame
               Text:(NSString *) texto
               Font:(UIFont *) fuente
          TextColor:(UIColor *) colortexto
              Padre:(UIView *)padre
{
    return [self initWithFrame:frame
                          Text:texto
                          Font:fuente
                     TextColor:colortexto
                     Alignment:NSTextAlignmentLeft
                       Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                         Padre:padre];
}

/////////////////////////////////////////////////////
// Sobreescribe el label y le establece el padding //
/////////////////////////////////////////////////////
-(void) drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.padding)];
}

//////////////////////////////////
// Cambiamos el ancho del label //
//////////////////////////////////
-(void) CambiarAncho:(int)ancho
{
    // Obtenemos el tamaño actual y demás parámetros
    CGRect tamanyo = self.frame;
    
    // Actualizamos la anchura
    tamanyo.size.width = ancho;
    [self setFrame:tamanyo];
}

//////////////////////////////////
// Cambiamos el alto del label //
//////////////////////////////////
-(void) CambiarAlto:(int)alto
{
    // Obtenemos el tamaño actual y demás parámetros
    CGRect tamanyo = self.frame;
    
    // Actualizamos la anchura
    tamanyo.size.height = alto;
    [self setFrame:tamanyo];
}

//////////////////////////////////
// Cambia la posición del texto //
//////////////////////////////////
-(void) CambiarPosicion: (CGPoint) pos
{
    // Posición actual
    CGRect tamanyo = self.frame;
    
    // Actualizamos la posición
    tamanyo.origin = pos;
    self.frame = tamanyo;
}

//////////////////////////////////
// Cambia la posición del texto //
//////////////////////////////////
-(void) CambiarPosicionX: (int) posX
{
    // Posición actual
    CGRect tamanyo = self.frame;
    
    // Actualizamos la posición
    tamanyo.origin.x = posX;
    self.frame = tamanyo;
}

//////////////////////////////////
// Cambia la posición del texto //
//////////////////////////////////
-(void) CambiarPosicionY: (int) posY
{
    // Posición actual
    CGRect tamanyo = self.frame;
    
    // Actualizamos la posición
    tamanyo.origin.y = posY;
    self.frame = tamanyo;
}
@end
