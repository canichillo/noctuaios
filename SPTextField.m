//
//  LA.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 28/02/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "SPTextField.h"
#import "SPUtilidades.h"

@implementation SPTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

///////////////////////////////////////
// Inicializa nuestro campo de texto //
///////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
         Background:(NSString *) background
          TextColor:(UIColor *) textcolor
        DefaultText:(NSString *) defecto
   DefaultTextColor:(UIColor *) defaultcolor
            Padding:(CGRect) padding
               Font:(UIFont *) font
            Enabled:(BOOL) enabled
         IsPassword:(BOOL) espassword
              Texto:(NSString *) texto
              Padre:(UIView *) padre
{
    if (self = [super initWithFrame:frame])
    {
        // Establecemos el texto por defecto
        self.placeholder = defecto;
        
        // Si hemos establecido el background
        if (![SPUtilidades isEmpty:background])
        {
            // Establecemos el background
            self.background = [UIImage imageNamed:background];
 
            // Como establecemos el background, debemos quitar el borde del campo
            self.borderStyle = UITextBorderStyleNone;
        }
        
        // Si hemos establecido el color del texto
        if (textcolor != Nil)
        {
            self.textColor = textcolor;
        }
        
        // Si hemos establecido el texto por defecto
        if (defaultcolor != Nil)
        {
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:defecto
                                                                         attributes:@{NSForegroundColorAttributeName: defaultcolor}];
        }
        
        // Si hemos establecido la fuente
        if (font != Nil)
        {
            self.font = font;
        }
        
        // Establecemos el padding
        self.padding = padding;
        
        // Por defecto la imagen no está mostrada
        self.mostradoImagen = NOMOSTRADO;
        
        // Establecemos el estado del campo de texto
        self.enabled = enabled;
        
        // Establece si es o no de tipo contraña
        self.secureTextEntry = espassword;
        
        // Establecemos el texto
        self.text = texto;        
        
        // Añadimos el objeto a la vista padre
        [padre addSubview:self];
    }
    
    // Devolvemos el campo de texto creado
    return self;
}

// Constructores de conveniencia
- (id)initWithFrame:(CGRect)frame
         Background:(NSString *) background
          TextColor:(UIColor *) textcolor
        DefaultText:(NSString *) defecto
   DefaultTextColor:(UIColor *) defaultcolor
            Padding:(CGRect) padding
               Font:(UIFont *) font
            Enabled:(BOOL) enabled
              Padre:(UIView *) padre
{
    return [self initWithFrame:frame
                    Background:background
                     TextColor:textcolor
                   DefaultText:defecto
              DefaultTextColor:defaultcolor
                       Padding:padding
                          Font:font
                       Enabled:enabled
                    IsPassword:FALSE
                         Texto:@""
                         Padre:padre];
}

- (id)initWithFrame:(CGRect)frame
         Background:(NSString *) background
          TextColor:(UIColor *) textcolor
        DefaultText:(NSString *) defecto
   DefaultTextColor:(UIColor *) defaultcolor
            Padding:(CGRect) padding
               Font:(UIFont *) font
              Padre:(UIView *) padre
{
    return [self initWithFrame:frame
                    Background:background
                     TextColor:textcolor
                   DefaultText:defecto
              DefaultTextColor:defaultcolor
                       Padding:padding
                          Font:font
                       Enabled:YES
                         Padre:padre];
}

- (id)initWithFrame:(CGRect)frame
         Background:(NSString *) background
          TextColor:(UIColor *) textcolor
        DefaultText:(NSString *) defecto
   DefaultTextColor:(UIColor *) defaultcolor
            Padding:(CGRect) padding
               Font:(UIFont *) font
         IsPassword:(BOOL)espassword
              Padre:(UIView *) padre
{
    return [self initWithFrame:frame
                    Background:background
                     TextColor:textcolor
                   DefaultText:defecto
              DefaultTextColor:defaultcolor
                       Padding:padding
                          Font:font
                       Enabled:YES
                    IsPassword:espassword
                         Texto:@""
                         Padre:padre];
}

-(id)initWithFrame:(CGRect)frame
        Background:(NSString *) background
         TextColor:(UIColor *) textcolor
             Padre:(UIView *) padre
{
    return [self initWithFrame:frame
                    Background:background
                     TextColor:textcolor
                   DefaultText:@""
              DefaultTextColor:Nil
                       Padding:CGRectMake(0, 0, 0, 0)
                          Font:Nil
                       Enabled:YES
                         Padre:padre];
}

-(id)initWithFrame:(CGRect)frame
         TextColor:(UIColor *) textcolor
              Font:(UIFont *) font
             Texto:(NSString *) texto
             Padre:(UIView *) padre
{
    return [self initWithFrame:frame
                    Background:@""
                     TextColor:textcolor
                   DefaultText:@""
              DefaultTextColor:Nil
                       Padding:CGRectMake(0, 0, 0, 0)
                          Font:font
                       Enabled:YES
                    IsPassword:NO
                         Texto:texto
                         Padre:padre];
}

-(id)initWithFrame:(CGRect)frame
         TextColor:(UIColor *) textcolor
  DefaultTextColor:(UIColor *) defaultcolor
              Font:(UIFont *) font
             Texto:(NSString *) texto
       DefaultText:(NSString *) defaultext
             Padre:(UIView *) padre
{
    return [self initWithFrame:frame
                    Background:@""
                     TextColor:textcolor
                   DefaultText:defaultext
              DefaultTextColor:defaultcolor
                       Padding:CGRectMake(0, 0, 0, 0)
                          Font:font
                       Enabled:YES
                    IsPassword:NO
                         Texto:texto
                         Padre:padre];
}

///////////////////////////////////////////////////
// Sobreescribimos las funciones para el padding //
///////////////////////////////////////////////////
- (CGRect)textRectForBounds:(CGRect)bounds {
    // Si hemos establecido el padding
    if (!CGRectIsNull(self.padding))
    {
        // Si no hemos mostrado la imagen
        if (self.mostradoImagen == NOMOSTRADO)
        {
            return CGRectMake(bounds.origin.x + self.padding.origin.x, bounds.origin.y + self.padding.origin.y,
                              bounds.size.width - self.padding.size.width, bounds.size.height - self.padding.size.height);
        }
        // Si estamos mostrando la imagen
        else
        {
            // Si está en la parte derecha
            if (self.mostradoImagen == DERECHA)
            {
                return CGRectMake(bounds.origin.x + self.padding.origin.x, bounds.origin.y + self.padding.origin.y,
                                  bounds.size.width - (1.5 * self.padding.size.width) - self.rightView.frame.size.width, bounds.size.height - self.padding.size.height);
            }
            
            // Si está en la parte izquierda
            if (self.mostradoImagen == IZQUIERDA)
            {
                return CGRectMake(bounds.origin.x + (1.5 * self.padding.origin.x) + self.leftView.frame.size.width, bounds.origin.y + self.padding.origin.y,
                                  bounds.size.width - self.padding.size.width, bounds.size.height - self.padding.size.height);
            }
        }
    }
    
    // Si no hemos establecido el padding
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

/////////////////////////////////////////////////
// Sobreescribe el padding de la parte derecha //
/////////////////////////////////////////////////
-(CGRect) rightViewRectForBounds:(CGRect)bounds
{
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= self.padding.origin.x;
    return textRect;
}

///////////////////////////////////////////////////
// Sobreescribe el padding de la parte izquierda //
///////////////////////////////////////////////////
-(CGRect) leftViewRectForBounds:(CGRect)bounds
{
    CGRect textRect = [super leftViewRectForBounds:bounds];
    textRect.origin.x += self.padding.origin.x;
    return textRect;
}

///////////////////////////////////////////////
// Comprueba si el campo de texto está vacío //
///////////////////////////////////////////////
-(BOOL) EstaVacio
{
    return [SPUtilidades isEmpty:self.text];
}

///////////////////////////////////////////////////////////
// Muestra una imagen en una posición del campo de texto //
///////////////////////////////////////////////////////////
-(void) MostrarImagen:(UIImage *) imagen
             Posicion:(NSString *) posicion
           SizeImagen:(int)size
{
    // Si queremos que la imagen esté a la derecha
    if ([posicion isEqualToString:@"D"])
    {
        // Indicamos cual será el modo
        self.rightViewMode = UITextFieldViewModeAlways;
 
        // Creamos una nueva imagen (UIImageView)
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
        imageView.image = imagen;
        
        // Establecemos la imagen
        self.rightView = imageView;
        
        // Indicamos que estamos mostramos la imagen
        self.mostradoImagen = DERECHA;
    }
    
    // Si queremos que la imagen esté a la izquierda
    if ([posicion isEqualToString:@"I"])
    {
        // Indicamos cual será el modo
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // Creamos una nueva imagen (UIImageView)
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
        imageView.image = imagen;
        
        // Establecemos la imagen
        self.leftView = imageView;
        
        // Indicamos que estamos mostramos la imagen
        self.mostradoImagen = IZQUIERDA;
    }
}

/////////////////////////////////
// Cambia el ancho de un texto //
/////////////////////////////////
-(void) CambiarAncho:(int)ancho
{
    // Obtenemos el tamaño actual y demás parámetros
    CGRect tamanyo = self.frame;
    
    // Actualizamos la anchura
    tamanyo.size.width = ancho;
    [self setFrame:tamanyo];
}

///////////////////////
// Oculta una imagen //
///////////////////////
-(void) OcultarImagen
{
    // Eliminamos las vistas del campo de texto
    self.rightView = Nil;
    self.leftView = Nil;
    
    // Indicamos que no estamos mostrando imagen
    self.mostradoImagen = NOMOSTRADO;
}
@end
