//
//  SPScrollViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 28/6/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPTextField.h"
#import "SPUtilidades.h"

@interface SPScrollViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) UIScrollView* scroll;
@property (strong, nonatomic) SPTextField* campoActivo;

// Inicia la ventana con un título
- (void)viewDidLoad: (NSString *) titulo;

// Inicializa el interfaz gráfico
-(void) initUI:(CGRect) framescroll
   ContentSize:(CGSize) sizescroll;

// Inicializa el interfaz gráfico
-(void) initUI:(CGRect) framescroll
   ContentSize:(CGSize) sizescroll
    Background:(NSString *) background;

// Inicializa el interfaz gráfico
-(void) initUI:(CGRect) framescroll
   ContentSize:(CGSize) sizescroll
      Posicion:(int) posicion
    Background:(NSString *) background;

-(BOOL) textFieldDidBeginEditing:(UITextField *)textField;
-(void) textFieldDidEndEditing:(UITextField *)textField;
@end
