//
//  SPScrollViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 28/6/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "SPScrollViewController.h"

@interface SPScrollViewController ()

@end

@implementation SPScrollViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
}

/////////////////////////////////////////
// Inicializa la ventana con un título //
/////////////////////////////////////////
-(void)viewDidLoad:(NSString *)titulo
{
    [super viewDidLoad];
    
    // Establecemos el título
    [self setTitle:titulo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Nos damos de alta en la notificación del teclado para adaptar la Text View
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(apareceTeclado:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(desapareceTeclado:) name:UIKeyboardWillHideNotification object:nil];
}

////////////////////////////////////
// Inicializa el interfaz gráfico //
////////////////////////////////////
-(void) initUI:(CGRect) framescroll
   ContentSize:(CGSize) sizescroll
{
    // Establecemos el background
    [SPUtilidades setBackground:@"logobackground.png"
                       Posicion:45
                          Vista:self.view
                          Alpha:0.7f];
    
    
    // Creamos el scroll
    self.scroll = [[UIScrollView alloc] initWithFrame:framescroll];
    [self.view addSubview:self.scroll];
    // Establecemos el tamaño del scroll
    [self.scroll setContentSize:sizescroll];
    // No habrá "bounce"
    [self.scroll setBounces:NO];
    
    
    // Configuramos el identificador de gestos al scroll
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(scrollViewPulsado)];
    [self.scroll setCanCancelContentTouches:NO];
    [self.scroll addGestureRecognizer:tapRecognizer];
    
    // Establecemos el background de la vista
    self.view.backgroundColor = [UIColor whiteColor];
}

////////////////////////////////////
// Inicializa el interfaz gráfico //
////////////////////////////////////
-(void) initUI:(CGRect) framescroll
   ContentSize:(CGSize) sizescroll
    Background:(NSString *) background
{
    // Establecemos el background
    [SPUtilidades setBackground:background
                       Posicion:45
                          Vista:self.view
                          Alpha:1.0f];
    
    
    // Creamos el scroll
    self.scroll = [[UIScrollView alloc] initWithFrame:framescroll];
    [self.view addSubview:self.scroll];
    // Establecemos el tamaño del scroll
    [self.scroll setContentSize:sizescroll];
    // No habrá "bounce"
    [self.scroll setBounces:NO];
    
    
    // Configuramos el identificador de gestos al scroll
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(scrollViewPulsado)];
    [self.scroll setCanCancelContentTouches:NO];
    [self.scroll addGestureRecognizer:tapRecognizer];
    
    // Establecemos el background de la vista
    self.view.backgroundColor = [UIColor whiteColor];
}

////////////////////////////////////
// Inicializa el interfaz gráfico //
////////////////////////////////////
-(void) initUI:(CGRect) framescroll
   ContentSize:(CGSize) sizescroll
      Posicion:(int) posicion
    Background:(NSString *) background
{
    // Establecemos el background
    [SPUtilidades setBackground:background
                       Posicion:posicion
                          Vista:self.view
                          Alpha:1.0f];
    
    
    // Creamos el scroll
    self.scroll = [[UIScrollView alloc] initWithFrame:framescroll];
    [self.view addSubview:self.scroll];
    // Establecemos el tamaño del scroll
    [self.scroll setContentSize:sizescroll];
    self.scroll.backgroundColor = [UIColor clearColor];
    // No habrá "bounce"
    [self.scroll setBounces:NO];
    
    
    // Configuramos el identificador de gestos al scroll
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(scrollViewPulsado)];
    [self.scroll setCanCancelContentTouches:NO];
    [self.scroll addGestureRecognizer:tapRecognizer];
    
    // Establecemos el background de la vista
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Nos damos de baja en la notificación del teclado para adaptar la Text View
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

#pragma mark - Notificaciones del teclado
//////////////////////////////////////////////////
// Evento que se produce al aparecer el teclado //
//////////////////////////////////////////////////
-(void) apareceTeclado:(NSNotification *)notification
{
    // Obtenemos el tamaño del teclado
    NSDictionary *infoNotificacion = [notification userInfo];
    CGSize tamanyoTeclado          = [[infoNotificacion objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Modificamos el tamaño de la 'ventana' de nuestro scroll view
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanyoTeclado.height + self.navigationController.navigationBar.frame.size.height, 0);
    [self.scroll setContentInset:edgeInsets];
    [self.scroll setScrollIndicatorInsets:edgeInsets];
    
    [self.scroll scrollRectToVisible:self.campoActivo.frame
                            animated:YES];
}

///////////////////////////////////////////////////////////
// Evento que se produce al hacer desaparecer el teclado //
///////////////////////////////////////////////////////////
-(void) desapareceTeclado:(NSNotification *)notification
{
    [UIView beginAnimations:nil
                    context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [self.scroll setContentInset:edgeInsets];
    [self.scroll setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}


#pragma mark - Métodos de UITextFieldDelegate
-(BOOL) textFieldDidBeginEditing:(UITextField *)textField
{
    self.campoActivo = (SPTextField *) textField;
    
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    self.campoActivo = nil;
}


#pragma mark - Métodos de acción adicionales
-(void) scrollViewPulsado
{   
    [self.view endEditing:YES];
}

@end
