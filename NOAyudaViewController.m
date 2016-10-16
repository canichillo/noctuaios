//
//  NOAyudaViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 24/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOAyudaViewController.h"

@interface NOAyudaViewController ()

@end

@implementation NOAyudaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configuramos la ayuda
    [self configurarAyuda];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////
// Configuramos la ayuda //
///////////////////////////
-(void) configurarAyuda
{
    // Tamaño imágenes
    int sizeImagen = [UIScreen mainScreen].bounds.size.width * 0.5f;
    int heightAyuda = (int) [UIScreen mainScreen].bounds.size.height;
    
    // Ajustamos para 4s
    if (heightAyuda <= 480)
    {
        heightAyuda = heightAyuda - 30;
        sizeImagen  = [UIScreen mainScreen].bounds.size.width * 0.41f;
    }
    
    // Creamos las páginas
    EAIntroPage *page1  = [EAIntroPage page];
    page1.title         = @"Bienvenido a Noctua";
    page1.desc          = @"Durante el transcurso de este tutorial le guiaremos a través de la aplicación Noctúa y de su funcionalidad.";
    page1.bgImage       = [SPUtilidades imageWithColor:RGB(97, 168, 221)];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"splash.png"] scaledToSize:CGSizeMake(sizeImagen, sizeImagen)]];
    page1.titleIconPositionY = -20.0f + (heightAyuda - sizeImagen) / 2.0f;
    page1.titlePositionY += 10.0f;
    page1.descPositionY  += 10.0f;
    
    EAIntroPage *page2  = [EAIntroPage page];
    page2.title         = @"Registro";
    page2.desc          = @"Antes de empezar a usar la aplicación deberá registrarse.";
    page2.bgImage       = [SPUtilidades imageWithColor:RGB(97, 168, 221)];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"registrar.png"] scaledToSize:CGSizeMake(sizeImagen, sizeImagen)]];
    page2.titleIconPositionY = -20.0f + (heightAyuda - sizeImagen) / 2.0f;
    page2.titlePositionY += 10.0f;
    page2.descPositionY  += 10.0f;
    
    EAIntroPage *page3  = [EAIntroPage page];
    page3.title         = @"Seguridad";
    page3.desc          = @"Por favor, rellene correctamente los datos de registro. Estos serán usados de una manera anónima por las empresas a modo de estadísticas, así ofrecerán mejores servicios a sus usuarios.";
    page3.bgImage       = [SPUtilidades imageWithColor:RGB(97, 168, 221)];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"dataprotection.png"] scaledToSize:CGSizeMake(sizeImagen, sizeImagen)]];
    page3.titleIconPositionY = -20.0f + (heightAyuda - sizeImagen) / 2.0f;
    page3.titlePositionY += 35.0f;
    page3.descPositionY  += 35.0f;
    
    EAIntroPage *page4  = [EAIntroPage page];
    page4.title         = @"Redes Sociales";
    page4.desc          = @"Si lo desea puede registrarse a través de Facebook, Twitter o Google+. No accederemos a información personal ni compartiremos información con personas ajenas.";
    page4.bgImage       = [SPUtilidades imageWithColor:RGB(97, 168, 221)];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"ayudafacebook.png"] scaledToSize:CGSizeMake(sizeImagen, sizeImagen)]];
    page4.titleIconPositionY = -20.0f + (heightAyuda - sizeImagen) / 2.0f;
    page4.titlePositionY += 35.0f;
    page4.descPositionY  += 35.0f;
    
    EAIntroPage *page5  = [EAIntroPage page];
    page5.title         = @"Menú";
    page5.desc          = @"En la parte izquierda de la aplicación se encuentra un menú.";
    page5.bgImage       = [SPUtilidades imageWithColor:RGB(97, 168, 221)];
    page5.titleIconView = [[UIImageView alloc] initWithImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"swiperight.png"] scaledToSize:CGSizeMake(sizeImagen, sizeImagen)]];
    page5.titleIconPositionY = -20.0f + (heightAyuda - sizeImagen) / 2.0f;
    page5.titlePositionY += 10.0f;
    page5.descPositionY  += 10.0f;
    
    EAIntroPage *page6  = [EAIntroPage page];
    page6.title         = @"Opciones";
    page6.desc          = @"En la parte inferior de las ofertas verá distintas opciones para seleccionar o filtrar, en un futuro se irá ampliando los tipos de ofertas: Tapas, Eventos, etc.";
    page6.bgImage       = [SPUtilidades imageWithColor:RGB(97, 168, 221)];
    page6.titleIconView = [[UIImageView alloc] initWithImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"options.png"] scaledToSize:CGSizeMake(sizeImagen, sizeImagen)]];
    page6.titleIconPositionY = -20.0f + (heightAyuda - sizeImagen) / 2.0f;
    page6.titlePositionY += 35.0f;
    page6.descPositionY  += 35.0f;
    
    EAIntroPage *page7  = [EAIntroPage page];
    page7.title         = @"Favoritos";
    page7.desc          = @"Podrá seleccionar que empresas son sus favoritas, así podrá acceder a las ofertas de estas empresas de una forma más rápida y recibir notificaciones cuando dichas empresas lancen nuevas ofertas.";
    page7.bgImage       = [SPUtilidades imageWithColor:RGB(97, 168, 221)];
    page7.titleIconView = [[UIImageView alloc] initWithImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"favoritos.png"] scaledToSize:CGSizeMake(sizeImagen, sizeImagen)]];
    page7.titleIconPositionY = -20.0f + (heightAyuda - sizeImagen) / 2.0f;
    page7.titlePositionY += 35.0f;
    page7.descPositionY  += 35.0f;
    
    EAIntroPage *page8  = [EAIntroPage page];
    page8.title         = @"Desactivación de ofertas";
    page8.desc          = @"Las ofertas cuentan con un sistema de desactivación que debe ser utilizado únicamente por los trabajadores de las empresas. El cupón no podrá ser reactivado, por lo que si lo desactivas tú, perderás la posibilidad de usar de dicha oferta";
    page8.bgImage       = [SPUtilidades imageWithColor:RGB(97, 168, 221)];
    page8.titleIconView = [[UIImageView alloc] initWithImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"ticket.png"] scaledToSize:CGSizeMake(sizeImagen, sizeImagen)]];
    page8.titleIconPositionY = -20.0f + (heightAyuda - sizeImagen) / 2.0f;
    page8.titlePositionY += 45.0f;
    page8.descPositionY  += 45.0f;
    
    EAIntroPage *page9  = [EAIntroPage page];
    page9.title         = @"Chat";
    page9.desc          = @"Podrás conversar con aquellos usuarios que comparten tus gustos e incluso añadirlos a tus amigos para conocer las ofertas que son de su interés y mantenerte en contacto con ellos.";
    page9.bgImage       = [SPUtilidades imageWithColor:RGB(97, 168, 221)];
    page9.titleIconView = [[UIImageView alloc] initWithImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"chatblanco.png"] scaledToSize:CGSizeMake(sizeImagen, sizeImagen)]];
    page9.titleIconPositionY = -20.0f + (heightAyuda - sizeImagen) / 2.0f;
    page9.titlePositionY += 35.0f;
    page9.descPositionY  += 35.0f;
    
    EAIntroPage *page10  = [EAIntroPage page];
    page10.title         = @"Familiarízate";
    page10.desc          = @"¡Nuestros cupones descuento se llaman Noctúas!";
    page10.bgImage       = [SPUtilidades imageWithColor:RGB(97, 168, 221)];
    page10.titleIconView = [[UIImageView alloc] initWithImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"splash.png"] scaledToSize:CGSizeMake(sizeImagen, sizeImagen)]];
    page10.titleIconPositionY = -20.0f + (heightAyuda - sizeImagen) / 2.0f;
    page10.titlePositionY += 35.0f;
    page10.descPositionY  += 35.0f;
    
    EAIntroPage *page11  = [EAIntroPage page];
    page11.title         = @"Gracias";
    page11.desc          = @"Gracias por su tiempo, ahora puede comenzar la aplicación.";
    page11.bgImage       = [SPUtilidades imageWithColor:RGB(97, 168, 221)];
    page11.titleIconView = [[UIImageView alloc] initWithImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"iphone.png"] scaledToSize:CGSizeMake(sizeImagen, sizeImagen)]];
    page11.titleIconPositionY = -20.0f + (heightAyuda - sizeImagen) / 2.0f;
    page11.titlePositionY += 10.0f;
    page11.descPositionY  += 10.0f;
    
    // Creamos la ayuda
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1, page2, page3, page4, page5, page6, page7, page8, page9, page10, page11]];
    
    // Establecemos el delegado
    [intro setDelegate:self];
    
    // Creamos el botón
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 230) / 2, [UIScreen mainScreen].bounds.size.height - 60, 230, 40)];
    [btn setTitle:NSLocalizedString(@"Skip", "Comenzar") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.borderWidth  = 2.0f;
    btn.layer.cornerRadius = 10;
    btn.layer.borderColor  = [[UIColor whiteColor] CGColor];
    intro.skipButton       = btn;
    // Fuente del botón
    btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue"
                                          size:19.0f];
    
    // Colocamos el control al final
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [pageControl sizeToFit];
    intro.pageControl  = pageControl;
    intro.pageControlY = 90.0f;
    
    // Mostramos la ayuda
    [intro showInView:self.view animateDuration:0.0];
}

///////////////////////////////////
// Escondemos la barra de estado //
///////////////////////////////////
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)introDidFinish:(EAIntroView *)introView
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
    
    // Configuramos el menú de la aplicación
    window.backgroundColor = RGB(97, 168, 221);
    menuApp.delegate        = ((NOAppDelegate *)[UIApplication sharedApplication].delegate);
    
    // Mostramos la vista
    window.rootViewController = menuApp;
}

@end
