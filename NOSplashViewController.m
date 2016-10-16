//
//  NOSplashViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 24/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOSplashViewController.h"
#import "NOMapaViewController.h"

@interface NOSplashViewController ()

@end

@implementation NOSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Establecemos el color de fondo
    self.view.backgroundColor = RGB(97, 168, 221);
    
    // Ancho y alto
    int ancho = self.view.frame.size.width * 0.5f;
    int alto  = self.view.frame.size.height * 0.5f;
    
    // Cargamos la imagen del Splash
    UIImageView * imagen = [[UIImageView alloc] initWithFrame:CGRectMake(0, -90 + (self.view.frame.size.height - alto) / 2, ancho, alto)];
    imagen.contentMode   = UIViewContentModeScaleAspectFit;
    imagen.image         = [UIImage imageNamed:@"splash.png"];
    [self.view addSubview:imagen];
    
    // Imagen del título de Noctua
    UIImageView * Noctua = [[UIImageView alloc] initWithFrame:CGRectMake(0, 125 + (self.view.frame.size.height - alto) / 2, self.view.frame.size.width, 120)];
    Noctua.contentMode   = UIViewContentModeScaleAspectFit;
    Noctua.image         = [UIImage imageNamed:@"letras.png"];
    [self.view addSubview:Noctua];
    
    // Comprobamos si tenemos token
    if ([SPUtilidades leerDatosToken] == nil || [[SPUtilidades leerDatosToken] isEqual:@""])
    {
       // Mostramos la ayuda
       UIWindow *window = ((NOAppDelegate *)[UIApplication sharedApplication].delegate).window;
            
       // Mostramos la vista
       window.rootViewController = [[NOAyudaViewController alloc] init];
    }
    else
    {
        if (![SPUtilidades conectadoInternet]) [self cargarCupones];
        else [self comprobarAcceso];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////
// Escondemos la barra de estado //
///////////////////////////////////
- (BOOL)prefersStatusBarHidden {
    return YES;
}

//////////////////////////////////////////
// Comprueba el acceso de la aplicación //
//////////////////////////////////////////
-(void) comprobarAcceso
{
    // Parámetros JSON para la petición
    NSDictionary *params = @{
                             @"token"      : [SPUtilidades leerDatosToken],
                             @"so"         : @"I",
                             @"dispositivo": [SPUtilidades plataformaIOS],
                            };
    
    // Realizamos una petición POST
    [SPUtilidades procesarPeticionPOST:@"accesotoken"
                            Parametros:params
                          SuccessBlock:^(id responseObject)
                                       {
                                           // Si no hay error
                                           if ([responseObject objectForKey:@"Error"] == nil)
                                           {
                                               // Registramos el APN
                                               [SPUtilidades registrarAPN];
     
                                               // Cargamos las ofertas
                                               [self cargarOfertas];
                                           }
                                           else
                                           {
                                               // Cargamos el login
                                               [self cargarLogin];
                                           }
                                       }
                          FailureBlock:^(NSError *error)
                                       {
                                           [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido acceder al servidor de Noctua" Handler:nil];
                                       }];
}

/////////////////////////////////
// Carga el registro del login //
/////////////////////////////////
-(void) cargarLogin
{
    // Creamos el controlador
    NOLoginViewController *loginVC = [[NOLoginViewController alloc] init];
    
    // Creamos una UINavigationController que controle la aplicación
    // Apila las vistas o 'stack'
    UINavigationController *controladorVistas = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    // Cambiamos el color del texto de la barra de estado
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
     
    // Establecemos el UINavigationController como transparent
    controladorVistas.navigationBar.hidden = YES;
     
    // Creamos el menú
    RESideMenu *menuApp = [[RESideMenu alloc] initWithContentViewController:controladorVistas
    leftMenuViewController:[[NOMenuIzquierdaViewController  alloc] init]
    rightMenuViewController:nil];
    
    // Ventana principal
    UIWindow *window = ((NOAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    // Color preferido para la barra de estado
    menuApp.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
     
    // Configuramos el menú de la aplicación
    window.backgroundColor = RGB(97, 168, 221);
    menuApp.delegate       = ((NOAppDelegate *)[UIApplication sharedApplication].delegate);
     
    // Mostramos la vista
    window.rootViewController = menuApp;
}

///////////////////////
// Carga las ofertas //
///////////////////////
-(void) cargarOfertas
{
    // Creamos el controlador
    NOOfertasViewController *ofertasVC = [[NOOfertasViewController alloc] init];
    
    // Creamos una UINavigationController que controle la aplicación
    // Apila las vistas o 'stack'
    UINavigationController *controladorVistas = [[UINavigationController alloc] initWithRootViewController:ofertasVC];
    
    // Cambiamos el color del texto de la barra de estado
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    // Establecemos el UINavigationController como transparent
    controladorVistas.navigationBar.hidden = YES;
    
    // Creamos el menú
    RESideMenu *menuApp = [[RESideMenu alloc] initWithContentViewController:controladorVistas
                                                     leftMenuViewController:[[NOMenuIzquierdaViewController  alloc] init]
                                                    rightMenuViewController:nil];
    
    // Color preferido para la barra de estado
    menuApp.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    
    // Ventana principal
    UIWindow *window = ((NOAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    // Configuramos el menú de la aplicación
    menuApp.delegate = ((NOAppDelegate *)[UIApplication sharedApplication].delegate);
    window.backgroundColor = RGB(97, 168, 221);
    
    // Mostramos la vista
    window.rootViewController = menuApp;
}

///////////////////////
// Carga los cupones //
///////////////////////
-(void) cargarCupones
{
    // Creamos el controlador
    NOCuponesViewController *cuponesVC = [[NOCuponesViewController alloc] init];
    
    // Creamos una UINavigationController que controle la aplicación
    // Apila las vistas o 'stack'
    UINavigationController *controladorVistas = [[UINavigationController alloc] initWithRootViewController:cuponesVC];
    
    // Cambiamos el color del texto de la barra de estado
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    // Establecemos el UINavigationController como transparent
    controladorVistas.navigationBar.hidden = YES;
    
    // Creamos el menú
    RESideMenu *menuApp = [[RESideMenu alloc] initWithContentViewController:controladorVistas
                                                     leftMenuViewController:[[NOMenuIzquierdaViewController  alloc] init]
                                                    rightMenuViewController:nil];
    
    // Color preferido para la barra de estado
    menuApp.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    
    // Ventana principal
    UIWindow *window = ((NOAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    // Configuramos el menú de la aplicación
    window.backgroundColor = RGB(97, 168, 221);
    menuApp.delegate       = ((NOAppDelegate *)[UIApplication sharedApplication].delegate);
    
    // Mostramos la vista
    window.rootViewController = menuApp;
}
@end
