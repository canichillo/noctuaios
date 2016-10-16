//
//  NOLoginViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 07/06/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOLoginViewController.h"
#import "SPUtilidades.h"
#import "SPButton.h"
#import "NORegistrarViewController.h"

@interface NOLoginViewController ()
@property (nonatomic, strong) M13ProgressHUD * progreso;
@end

@implementation NOLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad:@"Login"];
    
    // Desactivamos el menú
    [SPUtilidades desactivarMenu];
    
    // Inicializamos el interfaz gráfico
    [self initUI];
    
    // Configuramos la ventana de progreso
    self.progreso                  = [[M13ProgressHUD alloc] initWithProgressView:[[M13ProgressViewRing alloc] init]];
    self.progreso.indeterminate    = YES;
    self.progreso.progressViewSize = CGSizeMake(60.0, 60.0);
    self.progreso.animationPoint   = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    UIWindow *window = ((NOAppDelegate *)[UIApplication sharedApplication].delegate).window;
    [window addSubview:self.progreso];
    
    NOAppDelegate * appDelegate = (NOAppDelegate *) [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen)
    {
        // Crea una sesión de Facebook
        appDelegate.session = [[FBSession alloc] initWithPermissions:@[@"public_profile", @"email"]];
        
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error)
            {
            }];
        }
    }
}

////////////////////////////////////
// Inicializa el interfaz gráfico //
////////////////////////////////////
-(void) initUI
{
    // Configuramos el tamaño del scroll
    [super initUI:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
      ContentSize:CGSizeMake(self.view.frame.size.width, 568)
         Posicion:0
       Background:@""];
    
    self.view.backgroundColor = RGB(97, 168, 221);
    
    // Imagen del título de Noctua
    UIImageView * Noctua = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 105)];
    Noctua.contentMode   = UIViewContentModeScaleAspectFit;
    Noctua.image         = [UIImage imageNamed:@"letras.png"];
    [self.scroll addSubview:Noctua];
    
    // Creamos el título "Te estamos esperando"
    [SPUtilidades setTextoEstatico:CGRectMake(0, 157, self.view.frame.size.width, 40)
                             Texto:@"Bienvenido a Noctua"
                            Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:22.0f]
                         TextColor:[UIColor whiteColor]
                             Padre:self.scroll
                         Alignment:NSTextAlignmentCenter];
    
    // Creamos el usuario
    self.usuario = [[SPTextField alloc] initWithFrame:CGRectMake(20, 210, self.view.frame.size.width - 40, 45)
                                            TextColor:RGB(0, 0, 0)
                                     DefaultTextColor:RGB(74, 84, 94)
                                                 Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]
                                                Texto:@""
                                          DefaultText:@"Usuario"
                                                Padre:self.scroll];
    // Configuramos el color del campo de texto y los bordes
    [self.usuario setBackgroundColor:[RGB(247, 248, 250) colorWithAlphaComponent:0.6f]];
    [self.usuario.layer setCornerRadius:3.0f];
    // Establecemos el padding
    self.usuario.padding = CGRectMake(5, 5, 20, 10);
    [self.usuario MostrarImagen:[UIImage imageNamed:@"usuario.png"] Posicion:@"I" SizeImagen: 30];
    
    
    // Creamos la contraseña
    self.password = [[SPTextField alloc] initWithFrame:CGRectMake(20, 263, self.view.frame.size.width - 40, 45)
                                             TextColor:RGB(0, 0, 0)
                                      DefaultTextColor:RGB(74, 84, 94)
                                                  Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]
                                                 Texto:@""
                                           DefaultText:@"Contraseña"
                                                 Padre:self.scroll];
    // Configuramos el color del campo de texto y los bordes
    [self.password setBackgroundColor:[RGB(247, 248, 250) colorWithAlphaComponent:0.6f]];
    [self.password.layer setCornerRadius:3.0f];
    // Establecemos el padding
    self.password.padding = CGRectMake(5, 5, 20, 10);
    // Es de tipo contraseña
    self.password.secureTextEntry = YES;
    [self.password MostrarImagen:[UIImage imageNamed:@"password.png"] Posicion:@"I" SizeImagen: 28];
    
    
    // Creamos un botón para acceder
    SPButton* acceder = [[SPButton alloc] initWithFrame:CGRectMake(20, 328, self.view.frame.size.width - 40, 45)];
    // Título del botón
    [acceder setTitle:@"Acceder"
             forState:UIControlStateNormal];
    // Background del botón
    [acceder setBackgroundColor:RGB(67, 75, 85)];
    [acceder.layer setCornerRadius:3.0f];
    // Fuente del botón
    acceder.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue"
                                              size:20.0f];
    [acceder setTitleColor:RGB(57, 170, 214) forState:UIControlStateNormal];
    // Establecemos el evento para el botón de acceder
    [acceder addTarget:self action:@selector(eventoAcceder:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:acceder];
    
    
    // Creamos el título "¿No tienes cuenta?"
    [SPUtilidades setTextoEstatico:CGRectMake(0, 375, self.view.frame.size.width, 45)
                             Texto:@"¿No tienes cuenta?"
                            Fuente:[UIFont fontWithName: @"HelveticaNeue-Medium" size:15.0f]
                         TextColor:[UIColor whiteColor]
                             Padre:self.scroll
                         Alignment:NSTextAlignmentCenter];
    
    
    // Creamos un botón para registrar
    SPButton* registrar = [[SPButton alloc] initWithFrame:CGRectMake(60, 410, self.view.frame.size.width - 120, 35)];
    // Título del botón
    [registrar setTitle:@"Registrar"
               forState:UIControlStateNormal];
    // Background del botón
    [registrar.layer setCornerRadius:3.0f];
    // Color del borde
    [registrar.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    // Fuente del botón
    registrar.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium"
                                              size:18.0f];
    // Color del texto
    [registrar setTitleColor:RGB(69, 175, 217)
                    forState:UIControlStateNormal];
    // Añadimos el evento para registrarse en Noctua
    [registrar addTarget:self action:@selector(eventoRegistrar:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:registrar];
    
    // Creamos el título "¿No tienes cuenta?"
    [SPUtilidades setTextoEstatico:CGRectMake(0, 455, self.view.frame.size.width, 45)
                             Texto:@"ACCEDER CON"
                            Fuente:[UIFont fontWithName: @"HelveticaNeue-Medium" size:18.0f]
                         TextColor:[UIColor whiteColor]
                             Padre:self.scroll
                         Alignment:NSTextAlignmentCenter];
    
    // Creamos un botón para acceder desde facebook
    self.botonFacebook = [SPUtilidades buttonWithButton: CGRectMake((self.view.frame.size.width / 2) - 90, 493, 48, 48)
                                                 Titulo: @""
                                                   Font: [UIFont fontWithName:@"HelveticaNeue-Medium"
                                                                         size:15.0f]
                                                 Imagen: @"facebook.png"
                                             SizeImagen: CGSizeMake(48, 48)
                                        TitleEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 0)
                                        ImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 0)];
    // Añadimos el evento para el botón de facebook
    [self.botonFacebook addTarget:self action:@selector(eventoFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [self.botonFacebook setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateHighlighted];
    // Añadimos el botón
    [self.scroll addSubview:self.botonFacebook];
    
    // Creamos un botón para acceder desde twitter
    self.botonTwitter = [SPUtilidades buttonWithButton: CGRectMake((self.view.frame.size.width / 2) - 24, 495, 48, 48)
                                                 Titulo: @""
                                                   Font: [UIFont fontWithName:@"HelveticaNeue-Medium"
                                                                         size:15.0f]
                                                 Imagen: @"twitter.png"
                                             SizeImagen: CGSizeMake(48, 48)
                                        TitleEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 0)
                                        ImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 0)];
    // Añadimos el evento para el botón de facebook
    [self.botonTwitter addTarget:self action:@selector(eventoFacebook:) forControlEvents:UIControlEventTouchUpInside];
    // Añadimos el botón
    [self.scroll addSubview:self.botonTwitter];
    
    // Creamos un botón para acceder desde google
    self.botonGoogle = [SPUtilidades buttonWithButton: CGRectMake((self.view.frame.size.width / 2) + 42, 495, 48, 48)
                                                Titulo: @""
                                                  Font: [UIFont fontWithName:@"HelveticaNeue-Medium"
                                                                        size:15.0f]
                                                Imagen: @"google.png"
                                            SizeImagen: CGSizeMake(48, 48)
                                       TitleEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 0)
                                       ImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 0)];
    // Añadimos el evento para el botón de facebook
    [self.botonGoogle addTarget:self action:@selector(eventoFacebook:) forControlEvents:UIControlEventTouchUpInside];
    // Añadimos el botón
    [self.scroll addSubview:self.botonGoogle];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Escondemos la barra superior
    self.navigationController.navigationBar.hidden = YES;
}

////////////////////////////////////////////////////////////
// Evento que gestiona el acceso con usuario y contraseña //
////////////////////////////////////////////////////////////
- (IBAction) eventoAcceder:(id) sender
{
    // Parámetros JSON para la petición
    NSDictionary *params = @{
                             @"usuario"    : self.usuario.text,
                             @"password"   : self.password.text,
                             @"so"         : @"I",
                             @"dispositivo": [SPUtilidades plataformaIOS]
                            };
 
    // Realizamos la petición POST
    [SPUtilidades procesarPeticionPOST: @"usuariopassword"
                            Parametros: params
                          SuccessBlock: ^(id responseObject)
                                        {
                                            // Comprobamos si se ha producido un error
                                            if ([responseObject objectForKey:@"Error"] == nil)
                                            {
                                                // Obtenemos los datos del usuario
                                                NSDictionary * datosUsuario = [responseObject objectForKey:@"usuario"];
                                            
                                                // Guardamos los datos del usuario en NSDefaults
                                                [SPUtilidades guardarDatosUsuario:[datosUsuario objectForKey:@"nombre"]
                                                                            Token:[datosUsuario objectForKey:@"token"]
                                                                           Imagen:[datosUsuario objectForKey:@"imagen"]];
                                                
                                                // Registramos el APN
                                                [SPUtilidades registrarAPN];
                                                
                                                // Creamos el progreso
                                                self.progreso.status = @"Comprobando acceso";
                                                
                                                // Lo añadimos a la vista
                                                [self.progreso show:YES];
                                               
                                                // Realizamos la petición de guardado de la imagen
                                                [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[SPUtilidades urlImagenes:@"usuarios" Imagen:[[datosUsuario objectForKey:@"imagen"] stringByAppendingString:@".jpg"]]
                                                                                                    options:0
                                                                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                                                                                            {
                                                                                                            }
                                                                                                  completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                                                                                                            {
                                                                                                                // Eliminamos el progreso
                                                                                                                [self.progreso hide:YES];
                                                     
                                                                                                                // Si está finalizado
                                                                                                                if (image && finished)
                                                                                                                {
                                                                                                                    // Guardamos la imagen
                                                                                                                    [SPUtilidades guardarImagen:@"Noctua" Archivo:@"fotoNoctua.jpg" Datos:data];
                                                         
                                                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                        // Establecemos este elemento como el elemento principal
                                                                                                                        [SPUtilidades cargarRootUIViewController:[[NOOfertasViewController alloc]init]];
                                                                                                                        
                                                                                                                        // Refrescamos las imágenes
                                                                                                                        [((NOMenuIzquierdaViewController *) [SPUtilidades getResideMenu].leftMenuViewController) refrescarImagen];
                                                                                                                    });
                                                                                                                }
                                                                                                            }];
                                            }
                                            else
                                            {
                                                // Eliminamos el progreso
                                                [self.progreso hide:YES];
                                                
                                                [SPUtilidades mostrarError:@"Error" Mensaje:[responseObject objectForKey:@"Error"] Handler:^(SIAlertView *alertView) { }];
                                            }
                                        }
                          FailureBlock: ^(NSError *error)
                                        {
                                            // Eliminamos el progreso
                                            [self.progreso hide:YES];
                                            
                                            [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido comprobar los datos de acceso" Handler:^(SIAlertView *alertView) { }];
                                        }];
}

//////////////////////////////////////////////
// Evento que gestiona el login de Facebook //
//////////////////////////////////////////////
- (IBAction) eventoFacebook:(id) sender
{
    // Desactivamos el botón
    [self.botonFacebook setEnabled:NO];
    
    NOAppDelegate * appDelegate = (NOAppDelegate *) [[UIApplication sharedApplication]delegate];
    
    if (appDelegate.session.state != FBSessionStateCreated) {
        appDelegate.session = [[FBSession alloc] init];
    }
    else
    {
        [FBSession setActiveSession:appDelegate.session];
    }
    
    [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error)
    {
        // Establecemos la sesión por defecto
        [FBSession setActiveSession:session];
        
        // Creamos el progreso
        self.progreso.status = @"Comprobando Facebook";
        
        // Lo añadimos a la vista
        [self.progreso show:YES];
        
        [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
              {
                 if (!error)
                 {
                     // Datos para la comprobación del usuario
                     NSDictionary *params = @{
                                              @"email"      : [user objectForKey:@"email"],
                                              @"facebook"   : [user objectForKey:@"id"],
                                              @"usuario"    : [user objectForKey:@"email"],
                                              @"so"         : @"I",
                                              @"dispositivo": [SPUtilidades plataformaIOS]
                                              };
                     
                     // Realizamos la petición para comprobar el usuario
                     [SPUtilidades procesarPeticionPOST:@"usuariofacebook"
                                             Parametros:params
                                           SuccessBlock:^(id responseObject)
                                                        {
                                                            // Comprobamos la respuesta
                                                            if ([responseObject objectForKey:@"Mensaje"])
                                                            {
                                                                // Obtenemos los datos del usuario
                                                                NSDictionary * datosUsuario = [responseObject objectForKey:@"usuario"];
                                                                
                                                                // Guardamos los datos del usuario en NSDefaults
                                                                [SPUtilidades guardarDatosUsuario:[datosUsuario objectForKey:@"nombre"]
                                                                                            Token:[datosUsuario objectForKey:@"token"]
                                                                                           Imagen:[datosUsuario objectForKey:@"imagen"]];
                                                                
                                                                // Guardamos la imagen del Facebook
                                                                [self GetPictureFacebook:[user objectForKey:@"id"] Imagen:[datosUsuario objectForKey:@"imagen"]];
                                                            }
                                                            else
                                                            {
                                                                // No debe estar dado de baja
                                                                if (![[responseObject objectForKey:@"Error"] isEqual:@"El usuario está dado de baja"])
                                                                {
                                                                    [self registrarUsuarioFacebook:user];
                                                                }
                                                                else
                                                                {
                                                                    // Eliminamos el progreso
                                                                    [self.progreso hide:YES];
                                                                    
                                                                    // Activamos la cuenta de nuevo
                                                                    [self DarAltaFacebook:user];
                                                                }
                                                            }
                                                        }
                                           FailureBlock:^(NSError * error)
                                                        {
                                                        }];
                 }
                 else
                 {
                     // Eliminamos el progreso
                     [self.progreso hide:YES];

                     // Mostramos el error
                     [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido acceder a sus datos de Facebook" Handler:^(SIAlertView *alertView) { }];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // Volvemos a activar el botón
                         [self.botonFacebook setEnabled:YES];
                     });
                 }
             }];
    }];
}

////////////////////////////////////////////////////
// Registra el usuario con los datos del Facebook //
////////////////////////////////////////////////////
-(void) registrarUsuarioFacebook: (NSDictionary<FBGraphUser> *) user
{
    // Calculamos la edad
    NSDateComponents* agecalcul = [[NSCalendar currentCalendar]
                                   components:NSYearCalendarUnit
                                   fromDate: [SPUtilidades NSStringToNSDate:[user objectForKey:@"birthday"] Formato:@"MM/dd/yyyy"]
                                   toDate:[NSDate date]
                                   options:0];
    
    // Según la edad
    int edad = [agecalcul year];
    
    // Si está @"18-25", @"26-33", @"34-40", @">40"
    if (edad <= 25) edad = 0;
    if (edad >= 26 && edad <= 33) edad = 1;
    if (edad >= 34 && edad <= 40) edad = 2;
    if (edad > 40) edad = 3;
    
    // Datos para la creación del usuario
    NSDictionary *params = @{
                             @"nombre"     : [user objectForKey:@"name"],
                             @"usuario"    : [user objectForKey:@"email"],
                             @"password"   : [[user objectForKey:@"email"] stringByAppendingString:[user objectForKey:@"id"]],
                             @"email"      : [user objectForKey:@"email"],
                             @"so"         : @"I",
                             @"genero"     : [[user objectForKey:@"gender"] isEqual:@"male"] ? @"H" : @"M",
                             @"dispositivo": [SPUtilidades plataformaIOS],
                             @"edad"       : [NSNumber numberWithInt:edad],
                             @"facebook"   : [user objectForKey:@"id"]
                             };

    // Realizamos la petición para registrar el usuario
    [SPUtilidades procesarPeticionPOST:@"nuevousuario"
                            Parametros:params
                          SuccessBlock:^(id responseObject)
                                        {
                                            // Comprobamos la respuesta
                                            if ([responseObject objectForKey:@"Mensaje"] != nil)
                                            {
                                                // Obtenemos los datos del usuario
                                                NSDictionary * datosUsuario = [responseObject objectForKey:@"usuario"];
                                                
                                                // Guardamos los datos del usuario en NSDefaults
                                                [SPUtilidades guardarDatosUsuario:[datosUsuario objectForKey:@"nombre"]
                                                                            Token:[datosUsuario objectForKey:@"token"]
                                                                           Imagen:[datosUsuario objectForKey:@"imagen"]];
                                                
                                                // Guardamos la imagen del Facebook
                                                [self GetPictureFacebook:[user objectForKey:@"id"] Imagen:[datosUsuario objectForKey:@"imagen"]];
                                            }
                                            else
                                            {
                                                // Eliminamos el progreso
                                                [self.progreso hide:YES];
                                                
                                                // Mostramos el error
                                                [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido registrar sus datos en Noctua" Handler:^(SIAlertView *alertView) { }];
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    // Volvemos a activar el botón
                                                    [self.botonFacebook setEnabled:YES];
                                                });
                                            }
                                        }
                          FailureBlock:^(NSError * error)
                                        {
                                            // Eliminamos el progreso
                                            [self.progreso hide:YES];
                                            
                                            // Mostramos el error
                                            [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido acceder a sus datos de Facebook" Handler:^(SIAlertView *alertView) { }];
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                // Volvemos a activar el botón
                                                [self.botonFacebook setEnabled:YES];
                                            });
                                        }];
}

//////////////////////////////////////////////////
// Vuelve a dar de alta un servicio de Facebook //
//////////////////////////////////////////////////
-(void) DarAltaFacebook: (NSDictionary<FBGraphUser> *) user
{
    // Mostramos el mensaje de confirmación
    [[SIAlertView appearance] setMessageFont:[UIFont fontWithName:@"HelveticaNeue-Medium"
                                                             size:13.0f]];
    [[SIAlertView appearance] setTitleColor:RGB(63, 157, 217)];
    [[SIAlertView appearance] setMessageColor:RGB(121, 132, 142)];
    [[SIAlertView appearance] setCornerRadius:12];
    [[SIAlertView appearance] setShadowRadius:20];
    [[SIAlertView appearance] setViewBackgroundColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setButtonColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setCancelButtonColor:RGB(63, 157, 217)];
    [[SIAlertView appearance] setDestructiveButtonColor:[UIColor whiteColor]];
    
    // Establecemos el color del botón por defecto
    [[SIAlertView appearance] setDefaultButtonImage:[SPUtilidades imageWithColor:RGB(63, 157, 217)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDestructiveButtonImage:[SPUtilidades imageWithColor:RGB(255, 90, 90)] forState:UIControlStateNormal];
    
    // Creamos la alerta
    SIAlertView *alertError = [[SIAlertView alloc] initWithTitle:@"Confirmación" andMessage:@"Ya tenía una cuenta en nuestro sistema. ¿Desea activar su cuenta de nuevo?"];
    [alertError addButtonWithTitle:@"Si"
                              type:SIAlertViewButtonTypeDefault
                           handler:^(SIAlertView *alertView)
     {
         // Creamos el progreso
         self.progreso.status = @"Activando cuenta";
         
         // Lo añadimos a la vista
         [self.progreso show:YES];
         
         // Parámetros para activar la cuenta de Facebook
         NSDictionary *params = @{
                                  @"usuario"    : [user objectForKey:@"email"],
                                  @"email"      : [user objectForKey:@"email"],
                                  @"so"         : @"I",
                                  @"dispositivo": [SPUtilidades plataformaIOS],
                                  @"facebook"   : [user objectForKey:@"id"]
                                  };
         
         // Realizamos la petición para volver a dar de alta el usuario
         [SPUtilidades procesarPeticionPOST:@"usuarioaltafacebook"
                                 Parametros:params
                               SuccessBlock:^(id responseObject)
                                            {
                                                // Comprobamos la respuesta
                                                if ([responseObject objectForKey:@"Mensaje"] != nil)
                                                {
                                                    // Obtenemos los datos del usuario
                                                    NSDictionary * datosUsuario = [responseObject objectForKey:@"usuario"];
                                                    
                                                    // Guardamos los datos del usuario en NSDefaults
                                                    [SPUtilidades guardarDatosUsuario:[datosUsuario objectForKey:@"nombre"]
                                                                                Token:[datosUsuario objectForKey:@"token"]
                                                                               Imagen:[datosUsuario objectForKey:@"imagen"]];
                                                    
                                                    // Guardamos la imagen del Facebook
                                                    [self GetPictureFacebook:[user objectForKey:@"id"] Imagen:[datosUsuario objectForKey:@"imagen"]];
                                                }
                                                else
                                                {
                                                    // Eliminamos el progreso
                                                    [self.progreso hide:YES];
                                                    
                                                    // Mostramos el error
                                                    [SPUtilidades mostrarError:@"Error" Mensaje:[responseObject objectForKey:@"Error"] Handler:^(SIAlertView *alertView) { }];
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        // Volvemos a activar el botón
                                                        [self.botonFacebook setEnabled:YES];
                                                    });
                                                }
                                            }
                               FailureBlock:^(NSError * error)
                                            {
                                                // Eliminamos el progreso
                                                [self.progreso hide:YES];
                                                
                                                // Mostramos el error
                                                [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido activar tú cuenta" Handler:^(SIAlertView *alertView) { }];
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    // Volvemos a activar el botón
                                                    [self.botonFacebook setEnabled:YES];
                                                });
                                            }];
     }];
    
    [alertError addButtonWithTitle:@"No"
                              type:SIAlertViewButtonTypeDestructive
                           handler:^(SIAlertView *alertView)
                                    {
                                        // Eliminamos el progreso
                                        [self.progreso hide:YES];
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            // Volvemos a activar el botón
                                            [self.botonFacebook setEnabled:YES];
                                        });
                                    }];
    [alertError show];
}

////////////////////////////////////
// Obtiene la imagen del Facebook //
////////////////////////////////////
-(void) GetPictureFacebook: (NSString *) idFacebook
                    Imagen: (NSString *) imagen
{
    // Registramos el APN
    [SPUtilidades registrarAPN];
    
    // Descargamos la imagen del Facebook
    NSURL * urlFotoFacebook = [NSURL URLWithString:[[@"http://graph.facebook.com/" stringByAppendingString:idFacebook] stringByAppendingString:@"/picture?type=large"]];
    
    // Realizamos la petición de guardado de la imagen
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:urlFotoFacebook
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                                                {
                                                                }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                                                                {
                                                                    // Eliminamos el progreso
                                                                    [self.progreso hide:YES];
         
                                                                    // Si está finalizado
                                                                    if (image && finished)
                                                                    {
                                                                        // Guardamos la imagen
                                                                        [SPUtilidades guardarImagen:@"Noctua" Archivo:@"fotoNoctua.jpg" Datos:data];
                                                                        
                                                                        // Refrescamos las imágenes
                                                                        [((NOMenuIzquierdaViewController *) [SPUtilidades getResideMenu].leftMenuViewController) refrescarImagen];                                                                        
                                                                    }
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        // Volvemos a activar el botón
                                                                        [self.botonFacebook setEnabled:YES];
                                                                    });
                                                                }
     ];
}

////////////////////////////////////////////////
// Evento que accede a la ventana de registro //
////////////////////////////////////////////////
- (IBAction) eventoRegistrar:(id) sender
{
    // Cargamos la ventana
    [self.navigationController pushViewController:[[NORegistrarViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
