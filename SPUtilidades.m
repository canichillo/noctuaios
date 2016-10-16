//
//  LAUtilidades.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 28/02/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import "SIAlertView.h"

@implementation SPUtilidades
///////////////////////////////////////
// Comprueba si la cadena está vacía //
///////////////////////////////////////
+(BOOL) isEmpty:(NSString *) string
{
    if ([string length] == 0 || ![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
        return YES;
    else return NO;
}

////////////////////////////////////////////
// Obtiene el máximo tamaño para el texto //
////////////////////////////////////////////
+(CGFloat) TamanyoTexto: (NSString *) texto
                Tamanyo: (CGSize) tamanyo
                 Fuente: (UIFont *) fuente
{
    CGSize maximumLabelSize = CGSizeMake(tamanyo.width, CGFLOAT_MAX);
    CGRect textRect         = [texto boundingRectWithSize:maximumLabelSize
                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes:@{NSFontAttributeName:fuente}
                                                  context:nil];
    return textRect.size.height;
}

/////////////////////////////////
// Obtiene el tamaño del texto //
/////////////////////////////////
+(CGFloat) AnchuraTexto: (NSString *) texto
                Tamanyo: (CGSize) tamanyo
                 Fuente: (UIFont *) fuente
{
    CGSize maximumLabelSize = CGSizeMake(tamanyo.width, CGFLOAT_MAX);
    CGRect textRect         = [texto boundingRectWithSize:maximumLabelSize
                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes:@{NSFontAttributeName:fuente}
                                                  context:nil];
    
    return textRect.size.width;
}

////////////////////////////////
// Devuelve el nombre del día //
////////////////////////////////
+(NSString *) nombreDia: (int) dia
{
    NSArray *weekdays = @[@"Lunes", @"Mar", @"Miércoles", @"Jueves", @"Viernes", @"Sábado", @"Domingo"];
    return [weekdays objectAtIndex:dia];
}

////////////////////////////////
// Devuelve el nombre del mes //
////////////////////////////////
+(NSString *) nombreMes: (int) mes
{
    NSArray *meses = @[@"ene", @"feb", @"mar", @"abr", @"may", @"jun", @"jul", @"ago", @"sep", @"oct", @"nov", @"dic"];
    return [meses objectAtIndex:mes];
}

////////////////////////////////
// Devuelve el nombre del mes //
////////////////////////////////
+(NSString *) nombreMesCompleto: (int) mes
{
    NSArray *meses = @[@"Enero", @"Febrero", @"Marzo", @"Abril", @"Mayo", @"Junio", @"Julio", @"Agosto", @"Septiembre", @"Octubre", @"Noviembre", @"Diciembre"];
    return [meses objectAtIndex:mes];
}

//////////////////////////////////////////
// Establece un background de una vista //
//////////////////////////////////////////
+(void) setBackground: (NSString *) fondo
             Posicion: (int) posicion
                Vista: (UIView *) vista
                Alpha: (float) alpha
{
    // Creamos la imagen que mostrará el logo como máscara
    UIImageView* imagenFondo = [[UIImageView alloc] initWithFrame:CGRectMake(0, posicion, vista.frame.size.width, vista.frame.size.height)];
    imagenFondo.image        = [UIImage imageNamed: fondo];
    imagenFondo.contentMode  = UIViewContentModeScaleToFill;
    imagenFondo.alpha        = alpha;
        
    // Añadimos la imagen a la vista principal
    [vista addSubview:imagenFondo];
}

////////////////////////////
// Crea un campo estático //
////////////////////////////
+(void) setTextoEstatico:(CGRect) frame
                   Texto:(NSString *) texto
                  Fuente:(UIFont *) fuente
               TextColor:(UIColor *) color
                   Padre:(UIView *) padre
               Alignment:(NSTextAlignment) alineacion
{
    SPLabel* estatico = [[SPLabel alloc] initWithFrame:frame
                                                  Text:texto
                                                  Font:fuente
                                             TextColor:color
                                             Alignment:alineacion
                                               Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                 Padre:padre];
    
    estatico.lineBreakMode = NSLineBreakByWordWrapping;
    estatico.numberOfLines = 0;
}

////////////////////////////
// Crea un campo estático //
////////////////////////////
+(SPLabel*) setTextoEstaticoRtn:(CGRect) frame
                          Texto:(NSString *) texto
                         Fuente:(UIFont *) fuente
                      TextColor:(UIColor *) color
                          Padre:(UIView *) padre
                      Alignment:(NSTextAlignment) alineacion
{
    SPLabel* estatico = [[SPLabel alloc] initWithFrame:frame
                                                  Text:texto
                                                  Font:fuente
                                             TextColor:color
                                             Alignment:alineacion
                                               Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                 Padre:padre];
    
    estatico.lineBreakMode = NSLineBreakByWordWrapping;
    estatico.numberOfLines = 0;
    
    return estatico;
}

////////////////////////////////////////
// Establece una máscara a una imagen //
////////////////////////////////////////
+(UIImage *) maskImage:(UIImage *) image
              withMask:(UIImage *) maskImage
{
    CGImageRef imageReference = image.CGImage;
    CGImageRef maskReference = maskImage.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    return maskedImage;
}

/////////////////////////////
// Redimensiona una imagen //
/////////////////////////////
+(UIImage *) imageWithImage:(UIImage *)image
               scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//////////////////////////////////
// Crea un botón con una imagen //
//////////////////////////////////
+(UIButton *) buttonWithButton:(CGRect) frame
                        Titulo:(NSString *) titulo
                          Font:(UIFont *) font
                        Imagen:(NSString *) imagen
                    SizeImagen:(CGSize) sizeimagen
               TitleEdgeInsets:(UIEdgeInsets) titleedgeinsets
               ImageEdgeInsets:(UIEdgeInsets) imageedgeinsets
{
    // Creamos un botón
    UIButton* boton = [UIButton buttonWithType:UIButtonTypeCustom];
    boton.frame     = frame;
    
    // Título del botón
    [boton setTitle:titulo
           forState:UIControlStateNormal];
    
    // Fuente del botón
    boton.titleLabel.font = font;
    
    // Redimensionamos la imagen
    UIImage* image = [SPUtilidades imageWithImage:[UIImage imageNamed:imagen]
                                     scaledToSize:sizeimagen];
    [boton setImage: image
           forState: UIControlStateNormal];
    [boton setImage: image
           forState: UIControlStateHighlighted];
        
    // Establecemos la posición del texto
    boton.titleEdgeInsets = titleedgeinsets;
    
    // Establecemos la posición de la imagen
    boton.imageEdgeInsets = imageedgeinsets;
    
    
    // Devolvemos el botón creado
    return boton;
}

/////////////////////////////////////
// Establece una imagen a un botón //
/////////////////////////////////////
+(void) setImagenBoton:(UIButton *) boton
                 Image:(NSString *) imagen
            SizeImagen:(CGSize) sizeimagen
{
    // Redimensionamos la imagen
    UIImage* image = [SPUtilidades imageWithImage:[UIImage imageNamed:imagen]
                                     scaledToSize:sizeimagen];
    [boton setImage: image
           forState: UIControlStateNormal];
    [boton setImage: image
           forState: UIControlStateHighlighted];
}

/////////////////////////////////////////
// Usa un color para crear una UIImage //
/////////////////////////////////////////
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

///////////////////////
// Desactiva el menú //
///////////////////////
+(void) desactivarMenu
{
    // Desactivamos el menú
    RESideMenu * menu = (RESideMenu *) [[[UIApplication sharedApplication] keyWindow] rootViewController];
    menu.panGestureEnabled = NO;
}

////////////////////
// Activa el menú //
////////////////////
+(void) activarMenu
{
    // Desactivamos el menú
    RESideMenu * menu = (RESideMenu *) [[[UIApplication sharedApplication] keyWindow] rootViewController];
    menu.panGestureEnabled = YES;
}

//////////////////////
// Devuelve el menú //
//////////////////////
+(RESideMenu *) getResideMenu
{
    return (RESideMenu *) [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

////////////////////////////////////////
// Devuelve el UINavigationController //
////////////////////////////////////////
+(UINavigationController *) getNavigationController
{
    return (UINavigationController *) [[SPUtilidades getResideMenu] contentViewController];
}

///////////////////////////////
// Busca la ventana del Chat //
///////////////////////////////
+(UIViewController *) encontrarChat: (NSNumber *) codigo
{
    // Recorremos todos las ventanas
    for (UINavigationController * ventana in [[SPUtilidades getNavigationController] viewControllers])
    {
        // Si es una ventana de Chat
        if ([ventana isKindOfClass:[NOChatViewController class]])
        {
            // Si es la ventana de chat
            if (((NOChatViewController *) ventana).codigo == codigo)
            {
                return ventana;
            }
        }
    }
    
    return nil;
}

/////////////////////////
// Crea un botón vacío //
/////////////////////////
+(UIBarButtonItem*)negativeSpacerWithWidth:(NSInteger)width
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                             target:nil
                             action:nil];
    item.width = (width >= 0 ? -width : width);
    return item;
}

//////////////////////////////////////////////
// Carga una vista como actividad principal //
//////////////////////////////////////////////
+(void) cargarRootUIViewController: (UIViewController *) vista
{
    UINavigationController * controladorVistas  = [[UINavigationController alloc] initWithRootViewController:vista];
    controladorVistas.navigationBar.hidden      = YES;
    
    [[SPUtilidades getResideMenu] setContentViewController: controladorVistas];
    [SPUtilidades getResideMenu].menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    [[SPUtilidades getResideMenu] hideMenuViewController];
}

/////////////////////////////////
// Crea la barra de navegación //
/////////////////////////////////
+(UILabel *) crearBarraNavegacion: (UIViewController *) vista
                           Titulo: (NSString *) titulo
                    MenuIzquierdo: (BOOL) menuizquierdo
                      MenuDerecho: (BOOL) menuderecho
{
    return [SPUtilidades crearBarraNavegacion:vista Titulo:titulo MenuIzquierdo:menuizquierdo MenuDerecho:menuderecho SelectorIzquierdo:nil];
}

/////////////////////////////////
// Crea la barra de navegación //
/////////////////////////////////
+(UILabel *) crearBarraNavegacion: (UIViewController *) vista
                           Titulo: (NSString *) titulo
                    MenuIzquierdo: (BOOL) menuizquierdo
                      MenuDerecho: (BOOL) menuderecho
                SelectorIzquierdo: (SEL) selector
{
    // Definimos la vista
    UIView * navegacion = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vista.view.frame.size.width, 50)];
    // Definimos el color
    navegacion.backgroundColor = RGB(97, 168, 221);
    // Añadimos la barra de navegación a la vista
    [vista.view addSubview:navegacion];
    
    // Creamos el texto de la ventana
    UILabel * txttitulo = [[UILabel alloc] initWithFrame:CGRectMake(75, 6, vista.view.frame.size.width - 150, 50)];
    // Establecemos las características
    txttitulo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    // Establecemos el texto
    txttitulo.text = titulo;
    // Establecemos el color del texto
    txttitulo.textColor = [UIColor whiteColor];
    // Establecemos la alineación
    txttitulo.textAlignment = NSTextAlignmentCenter;
    // Añadimos el texto a la barra de navegación
    [vista.view addSubview:txttitulo];
    
    // Si hemos indicado que tenemos menú
    if (menuizquierdo)
    {
        // Nuestro menú
        UIButton * menu = [UIButton buttonWithType:UIButtonTypeCustom];
        menu.frame      = CGRectMake(8, 20, 24, 24);
        [menu setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [menu setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateSelected];
        menu.adjustsImageWhenHighlighted = NO;
        [navegacion addSubview:menu];
        [menu addTarget:vista action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchDown];
        
        // Activamos el menú
        [SPUtilidades activarMenu];
    }
    else
    {
        if (selector != nil)
        {
            // Creamos el logo con máscara redonda
            UIImageView* back        = [[UIImageView alloc] initWithFrame:CGRectMake(10, 22, 12, 20)];
            back.image               = [UIImage imageNamed:@"back.png"];
            // Añadimos la imagen a la vista
            [navegacion addSubview:back];
            // Añadimos el evento
            UIButton* atras = [[UIButton alloc] initWithFrame:CGRectMake(10, 22, 70, 23)];
            [navegacion addSubview:atras];
            
            [SPUtilidades setTextoEstatico:CGRectMake(22, 22, 50, 20)
                                     Texto:@"Atrás"
                                    Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:17.0f]
                                 TextColor:[UIColor whiteColor]
                                     Padre:navegacion
                                 Alignment:NSTextAlignmentCenter];
            [atras addTarget:vista action:selector forControlEvents:UIControlEventTouchDown];
        }
        
        // Desactivamos el menú
        [SPUtilidades desactivarMenu];
    }
    
    // Si hay menú derecho
    if (menuderecho)
    {
        // Nuestro menú
        UIButton * menu = [UIButton buttonWithType:UIButtonTypeCustom];
        menu.frame      = CGRectMake(vista.view.frame.size.width - 30, 20, 26, 26);
        [menu setImage:[UIImage imageNamed:@"opciones.png"] forState:UIControlStateNormal];
        [menu setImage:[UIImage imageNamed:@"opciones.png"] forState:UIControlStateSelected];
        menu.adjustsImageWhenHighlighted = NO;
        [navegacion addSubview:menu];
        [menu addTarget:vista action:@selector(presentRightMenuViewController:) forControlEvents:UIControlEventTouchDown];
    }
    
    return txttitulo;
}

/////////////////////////////////
// Muestra un mensaje de error //
/////////////////////////////////
+(void) mostrarError:(NSString *) titulo
             Mensaje:(NSString *) mensaje
             Handler:(SIAlertViewHandler) manejador
{
    [SPUtilidades mostrarError:titulo Mensaje:mensaje Handler:manejador Retraso:NO];
}

/////////////////////////////////
// Muestra un mensaje de error //
/////////////////////////////////
+(void) mostrarError:(NSString *) titulo
             Mensaje:(NSString *) mensaje
             Handler:(SIAlertViewHandler) manejador
             Retraso:(BOOL)delay
{
    // Configuramos la apariencia del botón
    [[SIAlertView appearance] setMessageFont:[UIFont fontWithName:@"HelveticaNeue-Medium"
                                                             size:13.0f]];
    [[SIAlertView appearance] setTitleColor:RGB(63, 157, 217)];
    [[SIAlertView appearance] setMessageColor:RGB(121, 132, 142)];
    [[SIAlertView appearance] setCornerRadius:12];
    [[SIAlertView appearance] setShadowRadius:20];
    [[SIAlertView appearance] setViewBackgroundColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setButtonColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setCancelButtonColor:RGB(63, 157, 217)];
    [[SIAlertView appearance] setDestructiveButtonColor:[UIColor blueColor]];
    
    // Establecemos el color del botón por defecto
    [[SIAlertView appearance] setDefaultButtonImage:[SPUtilidades imageWithColor:RGB(63, 157, 217)] forState:UIControlStateNormal];
    
    // Creamos la alerta
    SIAlertView *alertError = [[SIAlertView alloc] initWithTitle:titulo andMessage:mensaje];
    [alertError addButtonWithTitle:@"Aceptar"
                              type:SIAlertViewButtonTypeDefault
                           handler:manejador];
    
    // Si es con retraso
    if (delay) [alertError performSelector:@selector(show) withObject:nil afterDelay:0.0];
    else [alertError show];
}

///////////////////////////////////////
// Muestra un mensaje de información //
///////////////////////////////////////
+(void) mostrarInformacion:(NSString *) titulo
                   Mensaje:(NSString *) mensaje
                   Handler:(SIAlertViewHandler) manejador
{
    // Configuramos la apariencia del botón
    [[SIAlertView appearance] setMessageFont:[UIFont fontWithName:@"HelveticaNeue-Medium"
                                                             size:13.0f]];
    [[SIAlertView appearance] setTitleColor:RGB(63, 157, 217)];
    [[SIAlertView appearance] setMessageColor:RGB(121, 132, 142)];
    [[SIAlertView appearance] setCornerRadius:12];
    [[SIAlertView appearance] setShadowRadius:20];
    [[SIAlertView appearance] setViewBackgroundColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setButtonColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setCancelButtonColor:RGB(63, 157, 217)];
    [[SIAlertView appearance] setDestructiveButtonColor:[UIColor blueColor]];
    
    // Establecemos el color del botón por defecto
    [[SIAlertView appearance] setDefaultButtonImage:[SPUtilidades imageWithColor:RGB(63, 157, 217)] forState:UIControlStateNormal];
    
    // Creamos la alerta
    SIAlertView *alertError = [[SIAlertView alloc] initWithTitle:titulo andMessage:mensaje];
    [alertError addButtonWithTitle:@"Aceptar"
                              type:SIAlertViewButtonTypeDefault
                           handler:manejador];
    [alertError show];
}

////////////////////////////////////////////////////////////
// Crea la política de seguridad SSL para el AFNetworking //
////////////////////////////////////////////////////////////
+(AFSecurityPolicy*) politicaSeguridadSSL: (NSString *) archivo
{
    // Ruta y contenido del SSL
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:archivo ofType:@"cer"];
    NSData *certData  = [NSData dataWithContentsOfFile:cerPath];
    
    // Creamos la política de seguridad
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setPinnedCertificates:@[certData]];
    securityPolicy.validatesCertificateChain = NO;
    
    return securityPolicy;
}

//////////////////////////////
// Realiza una petición GET //
//////////////////////////////
+(AFHTTPSessionManager *) procesarPeticionGET: (NSString *) url
                                 SuccessBlock: (void (^)(id responseObject)) exito
                                 FailureBlock: (void (^)(NSError *error)) fallo
{
    // Sesión actual
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Creamos el objecto para realizar la operación de la petición GET
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    // Indicamos la seguridad SSL
    [manager setSecurityPolicy:[SPUtilidades politicaSeguridadSSL:@"noctua"]];
    
    // Realizamos la petición
    [manager GET:[@"" stringByAppendingString:url]
       parameters:nil
          success:^(NSURLSessionDataTask * task, id responseObject)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          // Ejecutamos el bloque de finalización
                          exito(responseObject);
                      });
                  }
         failure:^(NSURLSessionDataTask * task, NSError *error)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                         // Ejecutamos el bloque de fallo
                         fallo(error);
                     });
                  }
         ];
    
    // Devolvemos el objeto de la petición
    return manager;
}

///////////////////////////////
// Realiza una petición POST //
///////////////////////////////
+(AFHTTPSessionManager *) procesarPeticionPOST: (NSString *) url
                                    Parametros: (NSDictionary *) parametros
                                  SuccessBlock: (void (^)(id responseObject)) exito
                                  FailureBlock: (void (^)(NSError *error)) fallo
{
    // Sesión actual
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Creamos el objecto para realizar la operación de la petición POST
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    // Indicamos la seguridad SSL
    [manager setSecurityPolicy:[SPUtilidades politicaSeguridadSSL:@"noctua"]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // Realizamos la petición
    [manager POST:[@"" stringByAppendingString:url]
       parameters:parametros
          success:^(NSURLSessionDataTask * task, id responseObject)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          // Ejecutamos el bloque de finalización
                          exito(responseObject);
                      });
                  }
          failure:^(NSURLSessionDataTask * task, NSError *error)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          // Ejecutamos el bloque de fallo
                          fallo(error);
                      });
                  }
     ];
    
    // Devolvemos el objeto de la petición
    return manager;
}

///////////////////////////////////////////////
// Obtiene la URL para una imagen solicitada //
///////////////////////////////////////////////
+(NSURL *) urlImagenes: (NSString *) tipo
                Imagen: (NSString *) imagen
{
    return [NSURL URLWithString:[[[@"" stringByAppendingString:tipo]
                                  stringByAppendingString:@"/"]
                                 stringByAppendingString:[imagen stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]]];
}

////////////////////////////////////
// Guarda una imagen a un archivo //
////////////////////////////////////
+(void) guardarImagen: (NSString *) directorio
              Archivo: (NSString *) archivo
                Datos: (NSData *) datos
{
    // Generamos la ruta
    NSError * error = nil;
    NSArray *paths               = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath           = [documentsDirectory stringByAppendingPathComponent:directorio];
    
    // Si no existe el directorio
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&error];

    // Generamos la ruta
    paths              = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    dataPath           = [[documentsDirectory stringByAppendingPathComponent:directorio] stringByAppendingPathComponent:archivo];
    
    // Save it into file system
    [datos writeToFile:dataPath atomically:YES];
}

/////////////////////////////////////
// Lee una imagen desde un archivo //
/////////////////////////////////////
+ (UIImage*) leerImagen: (NSString *) directorio
                Archivo: (NSString *) archivo
{
    // Generamos el directorio si no existe
    NSError * error = nil;
    NSArray *paths               = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath           = [documentsDirectory stringByAppendingPathComponent:directorio];
    
    // Si no existe el directorio
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    // Generamos la ruta
    paths              = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    dataPath           = [[documentsDirectory stringByAppendingPathComponent:directorio] stringByAppendingPathComponent:archivo];

    // Leemos la imagen
    UIImage* image = [UIImage imageWithContentsOfFile:dataPath];
      
    // Devolvemos la imagen
    return image;
}

////////////////////////////////////
// Comprueba si existe una imagen //
////////////////////////////////////
+(BOOL) existeImagen: (NSString *) directorio
             Archivo: (NSString *) archivo
{
    // Generamos el directorio si no existe
    NSArray *paths               = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath           = [documentsDirectory stringByAppendingPathComponent:directorio];
    
    // Si no existe el directorio
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) return NO;
    
    // Generamos la ruta
    paths              = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    dataPath           = [[documentsDirectory stringByAppendingPathComponent:directorio] stringByAppendingPathComponent:archivo];
    
    // Si no existe el directorio
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) return NO;
    
    // En cualquier otro caso, si existe
    return YES;
}

////////////////////////
// Elimina una imagen //
////////////////////////
+(void) eliminarImagen: (NSString *) directorio
               Archivo: (NSString *) archivo
{
    // Generamos el directorio si no existe
    NSError * error              = nil;
    NSArray *paths               = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath           = [documentsDirectory stringByAppendingPathComponent:directorio];
    
    // Si no existe el directorio
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
        // Generamos la ruta
        paths              = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        dataPath           = [[documentsDirectory stringByAppendingPathComponent:directorio] stringByAppendingPathComponent:archivo];
    
        // Eliminamos el archivo
        [[NSFileManager defaultManager] removeItemAtPath:dataPath error:&error];
    }
}

///////////////////////////
// Elimina un directorio //
///////////////////////////
+(void) eliminarDirectorio: (NSString *) directorio
{
    // Generamos el directorio si no existe
    NSError * error              = nil;
    NSArray *paths               = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath           = [documentsDirectory stringByAppendingPathComponent:directorio];
    
    // Eliminamos el directorio
    [[NSFileManager defaultManager] removeItemAtPath:dataPath error:&error];
}

//////////////////////////////////////////
// Obtenemos el nombre de la plataforma //
//////////////////////////////////////////
+(NSString *) plataformaIOS
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

//////////////////////////////////
// Guarda los datos del usuario //
//////////////////////////////////
+(void) guardarDatosUsuario: (NSString *) nombre
                      Token: (NSString *) token
                     Imagen: (NSString *) imagen
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nombre forKey:@"nombre"];
    [defaults setObject:token forKey:@"token"];
    [defaults setObject:imagen forKey:@"imagen"];
    [defaults synchronize];
}

/////////////////////////////
// Guarda los datos de APN //
/////////////////////////////
+(void) guardarDatosAPN: (NSString *) apn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:apn forKey:@"apn"];
    [defaults synchronize];
}

/////////////////////////////////////
// Guardamos los datos de la fecha //
/////////////////////////////////////
+(void) guardarFechaChats: (NSString *) fecha
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:fecha forKey:@"fechachats"];
    [defaults synchronize];
}

////////////////////////////////////////
// Lee los datos del usuario guardado //
////////////////////////////////////////
+(NSString *) leerDatosUsuario
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"nombre"];
}

+(NSString *) leerDatosToken
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"token"];
}

+(NSString *) leerDatosImagen
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"imagen"];
}

+(NSString *) leerDatosAPN
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"apn"];
}

+(NSString *) leerFechaChats
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"fechachats"] == nil)
    {
        return @"01/01/2014";
    }
    return [defaults objectForKey:@"fechachats"];
}

//////////////////////////////////////////////////////////////////////////
// Convierte un NSString a un NSDate con un formato específico de fecha //
//////////////////////////////////////////////////////////////////////////
+(NSDate *) NSStringToNSDate: (NSString *) fecha
                     Formato: (NSString *) formato
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formato];
    NSDate *date = [dateFormat dateFromString:fecha];
    return date;
}

//////////////////////////////////////////////
// Comprueba si tiene conexión con Internet //
//////////////////////////////////////////////
+(BOOL) conectadoInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

+(UIImage *)round:(UIImage *)image
               to:(float)radius;
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CALayer *layer = [CALayer layer];
    layer = [imageView layer];
    
    layer.masksToBounds = YES;
    layer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(imageView.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

//////////////////////////
// Combina dos imágenes //
//////////////////////////
+(UIImage*) combinarImagen: (UIImage *) firstImage
                 withImage: (UIImage *) secondImage
                  Position: (CGPoint) posicion
{
    UIImage *image = nil;
    
    CGSize newImageSize = CGSizeMake(MAX(firstImage.size.width, secondImage.size.width), MAX(firstImage.size.height, secondImage.size.height));
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(newImageSize);
    }
    [firstImage drawAtPoint:CGPointMake(roundf((newImageSize.width-firstImage.size.width)/2),
                                        roundf((newImageSize.height-firstImage.size.height)/2))];
    [secondImage drawAtPoint:posicion];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//////////////////////
// Crea un marcador //
//////////////////////
+(UIImage *) crearMarcador: (UIImage *) imagen
{
    return [SPUtilidades combinarImagen:[SPUtilidades imageWithImage:[UIImage imageNamed:@"markermap.png"] scaledToSize:CGSizeMake(42, 42)]
                              withImage:[SPUtilidades round:[SPUtilidades imageWithImage:imagen scaledToSize:CGSizeMake(30, 30)] to:15.0f]
                               Position:CGPointMake(4, 3)];
}

////////////////////////
// Registramos el APN //
////////////////////////
+(void) registrarAPN
{
    // Si hay APN, continuamos
    if ([SPUtilidades leerDatosAPN] != nil)
    {
        // Parámetros JSON para la petición
        NSDictionary *params = @{
                                 @"token" : [SPUtilidades leerDatosToken],
                                 @"apn"   : [SPUtilidades leerDatosAPN],
                                 };
        
        // Realizamos una petición POST
        [SPUtilidades procesarPeticionPOST:@"registrarapn"
                                Parametros:params
                              SuccessBlock:^(id responseObject)
                                            {
                                                // Si no hay error
                                                if ([responseObject objectForKey:@"Error"])
                                                {
                                                    [SPUtilidades mostrarError:@"Error" Mensaje:[responseObject objectForKey:@"Error"] Handler:^(SIAlertView *alertView) { }];
                                                }
                                            }
                              FailureBlock:^(NSError *error)
                                            {
                                                [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido acceder al servidor de Noctua" Handler:^(SIAlertView *alertView) { }];
                                            }];
    }
}

//////////////////////
// Refresca el menú //
//////////////////////
+(void) refrescarMenu
{
    NOMenuIzquierdaViewController * menu = (NOMenuIzquierdaViewController *) [SPUtilidades getResideMenu].leftMenuViewController;
    [menu.tableView reloadData];
}
@end
