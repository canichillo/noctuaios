//
//  LA.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 28/02/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
// Indica si está siendo mostrada o no la imagen
enum ImagenTextField
{
    NOMOSTRADO,
    DERECHA,
    IZQUIERDA
};

@interface SPTextField : UITextField
// Variables
@property (nonatomic) CGRect padding;
@property (nonatomic) enum ImagenTextField mostradoImagen;

// Constructor por defecto
- (id)initWithFrame:(CGRect)frame
         Background:(NSString *) background
          TextColor:(UIColor *) textcolor
        DefaultText:(NSString *) defecto
   DefaultTextColor:(UIColor *) defaultcolor
            Padding:(CGRect) padding
               Font:(UIFont *) font
            Enabled:(BOOL) enabled
         IsPassword:(BOOL) espassword
              Texto:(NSString *)texto
              Padre:(UIView *) padre;

// Constructores de conveniencia
- (id)initWithFrame:(CGRect)frame
         Background:(NSString *) background
          TextColor:(UIColor *) textcolor
        DefaultText:(NSString *) defecto
   DefaultTextColor:(UIColor *) defaultcolor
            Padding:(CGRect) padding
               Font:(UIFont *) font
            Enabled:(BOOL) enabled
              Padre:(UIView *) padre;

- (id)initWithFrame:(CGRect)frame
         Background:(NSString *) background
          TextColor:(UIColor *) textcolor
        DefaultText:(NSString *) defecto
   DefaultTextColor:(UIColor *) defaultcolor
            Padding:(CGRect) padding
               Font:(UIFont *) font
              Padre:(UIView *) padre;

- (id)initWithFrame:(CGRect)frame
         Background:(NSString *) background
          TextColor:(UIColor *) textcolor
        DefaultText:(NSString *) defecto
   DefaultTextColor:(UIColor *) defaultcolor
            Padding:(CGRect) padding
               Font:(UIFont *) font
         IsPassword:(BOOL) espassword
              Padre:(UIView *) padre;

- (id)initWithFrame:(CGRect)frame
         Background:(NSString *) background
          TextColor:(UIColor *) textcolor
              Padre:(UIView *) padre;

-(id)initWithFrame:(CGRect)frame
         TextColor:(UIColor *) textcolor
              Font:(UIFont *) font
             Texto:(NSString *) texto
             Padre:(UIView *) padre;

-(id)initWithFrame:(CGRect)frame
         TextColor:(UIColor *) textcolor
  DefaultTextColor:(UIColor *) defaultcolor
              Font:(UIFont *) font
             Texto:(NSString *) texto
       DefaultText:(NSString *) defaulttext
             Padre:(UIView *) padre;

// Comprueba si el campo de texto está vacío
-(BOOL) EstaVacio;

// Muestra una imagen en una posición del campo de texto
-(void) MostrarImagen:(UIImage *) imagen
             Posicion:(NSString *) posicion
           SizeImagen:(int) size;

// Cambia el ancho del texto
-(void) CambiarAncho: (int) ancho;

// Ocultamos la imagen
-(void) OcultarImagen;
@end
