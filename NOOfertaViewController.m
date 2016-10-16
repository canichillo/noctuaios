//
//  NOOfertaViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 29/7/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOOfertaViewController.h"

@interface NOOfertaViewController ()

@end

@implementation NOOfertaViewController
@synthesize datosoferta;

// Constructor por defecto
-(id) initWithOferta: (int) oferta
              Llevas:(BOOL)llevas
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.oferta = oferta;
        self.llevas = llevas;
    }
    return self;
}

- (void)viewDidLoad {
    // Inicializamos la vista
    [self initUI];
    
    // Cargamos los datos
    [self CargarDatos];
}

-(void) initUI
{
    // Configuramos el background
    self.view.backgroundColor = [UIColor whiteColor];
    [SPUtilidades setBackground:@"logobackground.png" Posicion:0 Vista:self.view Alpha:1.0f];
    
    // Creamos la barra de navegación
    [SPUtilidades crearBarraNavegacion:self Titulo:@"Oferta" MenuIzquierdo:NO MenuDerecho:NO SelectorIzquierdo:@selector(volverAtras:)];
    
    // Creamos el texto vacío
    self.textocargando = [[SPLabel alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20, self.view.frame.size.height - 80) Text:@"Cargando los datos de la oferta..." Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f] TextColor:RGB(97, 168, 221) Padre:self.view];
    self.textocargando.textAlignment = NSTextAlignmentCenter;
    self.textocargando.numberOfLines = 0;
}

////////////////////////////
// Inicializa el interfaz //
////////////////////////////
-(void) initInterfaz
{
    // Imagen de la oferta
    self.imagen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 140)];
    [self.view addSubview:self.imagen];
    
    // Creamos una vista para el background
    UIView * textoempresa        = [[UIView alloc] initWithFrame:CGRectMake(0, 165, self.view.frame.size.width, 25)];
    textoempresa.backgroundColor = [RGB(97, 168, 221) colorWithAlphaComponent:0.95f];
    [self.view addSubview:textoempresa];
    
    // Creamos el texto de la oferta
    self.nombreoferta = [[SPLabel alloc] initWithFrame:CGRectMake(10, 193, self.view.frame.size.width - 20, 15)
                                                  Text:@""
                                                  Font:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f]
                                             TextColor:RGB(97, 168, 221)
                                             Alignment:NSTextAlignmentCenter
                                               Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                 Padre:self.view];
    // Es multilínea
    self.nombreoferta.numberOfLines = 0;
    self.nombreoferta.lineBreakMode = NSLineBreakByWordWrapping;
    
    // Creamos el texto de la empresa
    self.nombreempresa = [[SPLabel alloc] initWithFrame:CGRectMake(53, 0, self.view.frame.size.width - 53, 25)
                                                   Text:@""
                                                   Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]
                                              TextColor:[UIColor whiteColor]
                                              Alignment:NSTextAlignmentCenter
                                                Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                  Padre:textoempresa];
    
    // Es multilínea
    self.nombreempresa.numberOfLines = 0;
    self.nombreempresa.lineBreakMode = NSLineBreakByWordWrapping;
    
    // Imagen de la empresa
    self.logo = [[UIImageView alloc] initWithFrame:CGRectMake(3, 150, 50, 50)];
    self.logo.layer.cornerRadius = 25.0f;
    self.logo.layer.masksToBounds = YES;
    [self.view addSubview:self.logo];
    UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accederEmpresa)];
    [self.logo setUserInteractionEnabled:YES];
    [self.logo addGestureRecognizer:newTap];
    
    // Creamos el texto de la fecha
    self.fecha = [[SPLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)
                                           Text:@""
                                           Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:19.0f]
                                      TextColor:RGB(97, 168, 221)
                                      Alignment:NSTextAlignmentLeft
                                        Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                          Padre:self.view];
    
    // Creamos el texto de la hora
    self.hora = [[SPLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)
                                          Text:@""
                                          Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]
                                     TextColor:RGB(97, 168, 221)
                                     Alignment:NSTextAlignmentLeft
                                       Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                         Padre:self.view];
    
    // Creamos el scroll
    self.scroll                              = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scroll.contentInset                 = UIEdgeInsetsMake(5, 0, 0, 0);
    self.scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scroll];
    
    // Creamos el texto de la descripción
    self.descripcion = [[SPLabel alloc] initWithFrame:CGRectMake(10, -5, self.view.frame.size.width - 20, 22)
                                                 Text:@""
                                                 Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]
                                            TextColor:RGB(97, 168, 221)
                                            Alignment:NSTextAlignmentNatural
                                              Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                Padre:self.scroll];
    self.descripcion.numberOfLines = 0;
    self.descripcion.lineBreakMode = NSLineBreakByWordWrapping;
    
    // Si debemos mostrar el botón de ¿Me Llevas?
    if (self.llevas)
    {
        // Creamos el botón de ¿Me llevas?
        self.mellevas                    = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 90) / 2, 0, 90, 30)];
        self.mellevas.backgroundColor    = RGB(97, 168, 221);
        self.mellevas.layer.cornerRadius = 6.0f;
        self.mellevas.titleLabel.font    = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f];
        // Establecemos el color del botón
        [self.mellevas setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.mellevas setTitle:@"¿Te llevo?" forState:UIControlStateNormal];
        self.mellevas.contentEdgeInsets  = UIEdgeInsetsMake(5, 5, 5, 5);
        [self.mellevas addTarget:self action:@selector(accederMeLlevas:) forControlEvents:UIControlEventTouchDown];
        [self.scroll addSubview:self.mellevas];
    }
    
    // Creamos el panel inferior
    self.panelInferior                 = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 35, self.view.frame.size.width, 35)];
    self.panelInferior.backgroundColor = [RGB(97, 168, 221) colorWithAlphaComponent:0.9f];
    [self.view addSubview:self.panelInferior];
    
    // Creamos el texto de la descripción
    self.numdescargas = [[SPLabel alloc] initWithFrame:CGRectMake(8, 4, self.view.frame.size.width - 20, 28)
                                                  Text:@""
                                                  Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]
                                             TextColor:[UIColor whiteColor]
                                             Alignment:NSTextAlignmentNatural
                                               Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                 Padre:self.panelInferior];
    self.numdescargas.layer.borderColor  = [[UIColor whiteColor] CGColor];
    self.numdescargas.layer.borderWidth  = 2.0f;
    self.numdescargas.layer.cornerRadius = 6.0f;
    self.numdescargas.lineBreakMode = NSLineBreakByWordWrapping;
    self.numdescargas.numberOfLines = 0;
    self.numdescargas.hidden = YES;
    
    // Creamos el evento de mostrar los usuarios que han descargado
    UITapGestureRecognizer *newTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DescargasEmpresa)];
    [self.numdescargas setUserInteractionEnabled:YES];
    [self.numdescargas addGestureRecognizer:newTap3];
    
    // Establecemos la adquisición
    self.adquisicion = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, 4, 40, 28)];
    self.adquisicion.layer.borderColor  = [[UIColor whiteColor] CGColor];
    self.adquisicion.layer.borderWidth  = 2.0f;
    self.adquisicion.layer.cornerRadius = 6.0f;
    [self.panelInferior addSubview:self.adquisicion];
    
    // Creamos el evento de adquisición
    UITapGestureRecognizer *newTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AdquisicionNoctua:)];
    [self.adquisicion setUserInteractionEnabled:YES];
    [self.adquisicion addGestureRecognizer:newTap2];
}

//////////////////////////////////////
// Accede a los datos de la empresa //
//////////////////////////////////////
-(void) accederEmpresa
{
    // Cargamos la ventana
    [self.navigationController pushViewController:[[NOEmpresaViewController alloc] initWithEmpresa:[datosoferta.idempresa intValue] Llevas:self.llevas] animated:YES];
}

////////////////////////
// Vuelve hacia atrás //
////////////////////////
-(void) volverAtras: (id) sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

////////////////////////////////////////
// Accede a la sección de ¿Me Llevas? //
////////////////////////////////////////
-(void) accederMeLlevas: (id) sender
{
    // Cargamos la ventana
    [self.navigationController pushViewController:[[NOMeLlevasViewController alloc] initWithDestino:self.ubicacionempresa
                                                                                            Empresa:datosoferta.empresa
                                                                                             Oferta:datosoferta.nombre
                                                                                             Imagen:datosoferta.logo] animated:YES];
}

//////////////////////////////////////
// Accede a la ventana de descargas //
//////////////////////////////////////
-(void) DescargasEmpresa
{
    // Cargamos la ventana
    [self.navigationController pushViewController:[[NODescargasViewController alloc] initWithOferta: self.oferta] animated:YES];
}

//////////////////////////////////////
// Cambia la adquisición del Noctua //
//////////////////////////////////////
-(void) AdquisicionNoctua: (id) sender
{
    // URL que usaremos
    NSString * url     = [datosoferta.adquirida isEqual:@"S"] ? @"noadquiriroferta" : @"adquiriroferta";
    // Mensaje de confirmación
    NSString * mensaje = [datosoferta.adquirida isEqual:@"S"] ? @"¿Desea eliminar este Noctúa?" : @"¿Desea descargar este Noctúa?";
    
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
    [[SIAlertView appearance] setDestructiveButtonColor:[UIColor whiteColor]];
    
    // Establecemos el color del botón por defecto
    [[SIAlertView appearance] setDefaultButtonImage:[SPUtilidades imageWithColor:RGB(63, 157, 217)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDestructiveButtonImage:[SPUtilidades imageWithColor:RGB(255, 90, 90)] forState:UIControlStateNormal];
    
    // Creamos la alerta
    SIAlertView *alertError = [[SIAlertView alloc] initWithTitle:@"Confirmación" andMessage:mensaje];
    [alertError addButtonWithTitle:@"Si"
                              type:SIAlertViewButtonTypeDefault
                           handler:^(SIAlertView *alertView)
     {
         // Parámetros JSON para la petición
         NSDictionary *params = @{
                                  @"oferta" : [NSNumber numberWithInt:self.oferta],
                                  @"token"  : [SPUtilidades leerDatosToken]
                                  };
         
         // Realizamos la petición POST
         [SPUtilidades procesarPeticionPOST: url
                                 Parametros: params
                               SuccessBlock: ^(id responseObject)
          {
              // Si está correcto
              if ([responseObject objectForKey:@"Mensaje"])
              {
                  // Cambiamos el estado
                  datosoferta.adquirida = [datosoferta.adquirida isEqual:@"S"] ? @"N" : @"S";
                  
                  // Si hemos adquirido la oferta
                  if ([datosoferta.adquirida isEqual:@"S"])
                  {
                      // No debe existir la oferta
                      if (![CoreDataHelper existeCuponBD:[NSNumber numberWithInt:self.oferta] Tipo:@"N"])
                      {
                          // Guardamos la oferta en la base de datos
                          [CoreDataHelper crearCupon:[[Cupon alloc] initWithCodigo:[NSNumber numberWithInt:self.oferta]
                                                                            Nombre:datosoferta.nombre
                                                                           Empresa:datosoferta.empresa
                                                                         IDEmpresa:datosoferta.idempresa
                                                                              Logo:datosoferta.logo ? datosoferta.logo : @""
                                                                            Inicio:datosoferta.inicio
                                                                               Fin:datosoferta.fin
                                                                            Usados:0
                                                                       Disponibles:datosoferta.disponibles
                                                                         Consumido:@""
                                                                              Tipo:@"N"]];
                          
                          // Guardamos la imagen
                          if (datosoferta.logo)
                              [SPUtilidades guardarImagen:@"Noctua/cupones" Archivo:datosoferta.logo Datos:UIImageJPEGRepresentation(self.logo.image, 1.0)];
                      }
                  }
                  else [CoreDataHelper eliminarCupon:[NSNumber numberWithInt:self.oferta] Tipo:@"N"];
                  
                  // Mostramos el mensaje de que es correcto
                  [SPUtilidades mostrarInformacion:@"Información" Mensaje:[datosoferta.adquirida isEqual:@"S"] ? @"Has descargado el Noctúa." : @"Has eliminado el Noctúa." Handler:^(SIAlertView *alertView) { }];
                  
                  // Cambiamos el estado del botón de adquisición
                  [self cambiarEstadoAdquisicion];
              }
              else [SPUtilidades mostrarError:@"Error" Mensaje:[responseObject objectForKey:@"Error"] Handler:^(SIAlertView *alertView) { }];
          }
                               FailureBlock:^(NSError *error)
          {
              // Se ha producido un error
              [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido realizar la petición deseada" Handler:^(SIAlertView *alertView) { }];
          }];
     }];
    [alertError addButtonWithTitle:@"No"
                              type:SIAlertViewButtonTypeDestructive
                           handler:^(SIAlertView *alertView)
     {
     }];
    
    [alertError show];
}

//////////////////////////////////
// Carga los datos de la oferta //
//////////////////////////////////
-(void) CargarDatos
{
    // Parámetros JSON para la petición
    NSDictionary *params = @{
                             @"id"     : [NSNumber numberWithInt:self.oferta],
                             @"token"  : [SPUtilidades leerDatosToken],
                             @"ciudad" : @2
                             };
    
    // Realizamos la petición POST
    [SPUtilidades procesarPeticionPOST: @"datosoferta"
                            Parametros: params
                          SuccessBlock: ^(id responseObject)
     {
         // Si hay algún error
         if ([responseObject objectForKey:@"Error"])
         {
             // Se ha producido un error
             [SPUtilidades mostrarError:@"Error" Mensaje:[responseObject objectForKey:@"Error"] Handler:^(SIAlertView *alertView) { }];
         }
         else
         {
             // Quitamos el texto de cargando
             self.textocargando.hidden = YES;
             
             // Inicializamos el interfaz
             [self initInterfaz];
             
             // Posición actual del texto
             int posicion = 195;
             
             // Obtenemos los datos de la ubicación de la empresa
             self.ubicacionempresa = CLLocationCoordinate2DMake([[responseObject objectForKey:@"latitud"] doubleValue], [[responseObject objectForKey:@"longitud"] doubleValue]);
             
             // Obtenemos los datos de la oferta
             datosoferta = (Oferta *) [MTLJSONAdapter modelOfClass:[Oferta class] fromJSONDictionary:responseObject error:nil];
             
              // Si no tenemos logo de empresa, ponemos una por defecto
             if (datosoferta.logo == nil || [datosoferta.logo isEqual:@""])
             {
                 self.logo.image = [UIImage imageNamed:@"logo.png"];
             }
             else
             {
                 // Comprobamos si está almacenada anteriormente
                 if ([SPUtilidades existeImagen:@"Noctua/temp" Archivo:datosoferta.logo])
                 {
                     // Cargamos la imagen
                     self.logo.image = [SPUtilidades leerImagen:@"Noctua/temp" Archivo:datosoferta.logo];
                 }
                 else
                 {
                     // Ahora indicamos que debemos cargar
                     [self.logo sd_setImageWithURL:[SPUtilidades urlImagenes:@"empresas" Imagen:[datosoferta.logo stringByAppendingString:@".jpg"]]
                                  placeholderImage:[UIImage imageNamed:@"loading.png"]
                                           options:SDWebImageRefreshCached
                                         completed: ^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageURL)
                                                    {
                                                      // Guardamos la imagen para usarla a posteriori
                                                      [SPUtilidades guardarImagen:@"Noctua/temp" Archivo:datosoferta.logo Datos:UIImageJPEGRepresentation(image, 1.0)];
                                                    }
                      ];
                 }
             }
             
             // Cargamos la imagen de la oferta
             [self.imagen sd_setImageWithURL:[SPUtilidades urlImagenes:@"ofertas" Imagen:[datosoferta.imagen stringByAppendingString:@".jpg"]]
                            placeholderImage:[UIImage imageNamed:@"loading.png"]
                                     options:SDWebImageRefreshCached];
             
             // Establecemos el nombre de la oferta
             self.nombreoferta.text = datosoferta.nombre;
             
             // Obtenemos el tamaño del nombre de la oferta
             [self.nombreoferta CambiarAlto:[SPUtilidades TamanyoTexto:self.nombreoferta.text Tamanyo:self.nombreoferta.frame.size Fuente:self.nombreoferta.font] + 5];
             
             // Actualizamos la posición actual
             posicion += self.nombreoferta.frame.size.height;
             
             // Establecemos el nombre de la empresa
             self.nombreempresa.text = datosoferta.empresa;
             
             // Nos permitirá trocear la fecha
             NSDateComponents *componentsInicio = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:datosoferta.inicio];
             NSDateComponents *componentsFin    = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:datosoferta.fin];
             
             // Establecemos la fecha
             self.fecha.text = [NSString stringWithFormat:@"%@ %ld de %@", [SPUtilidades nombreDia:(int)[componentsInicio weekday] - 1], (long)[componentsInicio day], [SPUtilidades nombreMesCompleto:(int)[componentsInicio month] - 1]];
             
             // Tamaño del texto
             int sizeText = [self.fecha.text sizeWithAttributes:@{ NSFontAttributeName: self.fecha.font }].width;
             
             // Posición de la imagen
             int posicionimagen = (self.view.frame.size.width - 43 - sizeText) / 2;
             
             // Establecemos la posición
             [self.fecha CambiarPosicion:CGPointMake(posicionimagen + 28, posicion)];
             
             // Establecemos la imagen de la fecha
             UIImageView * imagenfecha = [[UIImageView alloc] initWithFrame:CGRectMake(posicionimagen, posicion + 1, 20, 20)];
             imagenfecha.image         = [UIImage imageNamed:@"fecha.png"];
             [self.view addSubview:imagenfecha];
             
             // Actualizamos la posición actual
             posicion += self.fecha.frame.size.height;
             
             // Establecemos la hora
             self.hora.text = [NSString stringWithFormat:@"%02d:%02d - %02d:%02d", (int)[componentsInicio hour], (int)[componentsInicio minute], (int)[componentsFin hour], (int)[componentsFin minute]];
             
             // Tamaño del texto
             sizeText = [self.hora.text sizeWithAttributes:@{ NSFontAttributeName: self.hora.font }].width;
             
             // Posición de la imagen
             posicionimagen = (self.view.frame.size.width - 43 - sizeText) / 2;
             
             // Establecemos la posición
             [self.hora CambiarPosicion:CGPointMake(posicionimagen + 28, posicion + 1)];
             
             // Establecemos la imagen de la fecha
             UIImageView * imagenhora = [[UIImageView alloc] initWithFrame:CGRectMake(posicionimagen, posicion + 2, 20, 20)];
             imagenhora.image         = [UIImage imageNamed:@"hora.png"];
             [self.view addSubview:imagenhora];
             
             // Actualizamos la posición actual
             posicion += self.fecha.frame.size.height;
             
             // Creamos la línea de separación
             UIView * linea = [[UIView alloc] initWithFrame:CGRectMake(30, posicion + 8, self.view.frame.size.width - 60, 2)];
             linea.backgroundColor = RGB(97, 168, 221);
             [self.view addSubview:linea];
             
             // Actualizamos la posición actual
             posicion += 12;
             
             // Establecemos la descripción
             self.descripcion.text = datosoferta.descripcion;
             
             // Obtenemos el tamaño del nombre de la oferta
             [self.descripcion CambiarAlto:[SPUtilidades TamanyoTexto:self.descripcion.text Tamanyo:self.descripcion.frame.size Fuente:self.descripcion.font] + 5];
             
             // Actualizamos el scroll
             CGRect frame            = self.scroll.frame;
             frame.origin.y          = posicion;
             frame.size.height       = self.view.frame.size.height - posicion;
             self.scroll.frame       = frame;
             self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width, self.descripcion.frame.size.height + 75);
             
             // Si tenemos el botón de ¿Me Llevas?
             if (self.llevas)
             {
                 // Establecemos la posición del botón de me llevas
                 frame               = self.mellevas.frame;
                 frame.origin.y      = self.descripcion.frame.size.height;
                 self.mellevas.frame = frame;
             }
             
             // Cambiamos el estado del botón de adquisición
             [self cambiarEstadoAdquisicion];
             
             // Parámetros JSON para la petición
             NSDictionary *params = @{
                                      @"oferta" : [NSNumber numberWithInt:self.oferta]
                                      };
             
             // Realizamos la petición POST
             [SPUtilidades procesarPeticionPOST: @"numerodescargasoferta"
                                     Parametros: params
                                   SuccessBlock: ^(id responseObject)
              {
                  // Si está correcto
                  if ([responseObject objectForKey:@"descargas"])
                  {
                      self.numdescargas.text = [NSString stringWithFormat:@"  %@ descargas ", [responseObject objectForKey:@"descargas"]];
                      
                      // Cambiamos el texto del número de descargas
                      self.numdescargas.frame = CGRectMake(8, 4, 6 + [self.numdescargas.text length] * 7, 28);
                      
                      // Mostramos el número de descargas
                      self.numdescargas.hidden = NO;
                  }
              }
                                   FailureBlock:^(NSError *error)
              {
                  // Se ha producido un error
                  [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener el número de descargas" Handler:^(SIAlertView *alertView) { }];
              }];
         }
     }
                          FailureBlock: ^(NSError *error)
     {
         // Se ha producido un error
         [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener los datos de la oferta" Handler:^(SIAlertView *alertView) { }];
     }
     ];
}

////////////////////////////////////////
// Cambia el estado de la adquisición //
////////////////////////////////////////
-(void) cambiarEstadoAdquisicion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Eliminamos todas las vistas del botón de adquisición
        NSArray *viewsToRemove = [self.adquisicion subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        
        // Texto del botón
        NSString * textoboton = @"";
        // Imagen del botón
        NSString * imagenboton = @"";
        // Tamaño de la imagen
        int sizeImagen = 18;
        
        // Si ha sido adquirida
        if ([datosoferta.adquirida isEqual:@"S"])
        {
            // Establecemos el texto
            textoboton = @"Ya no lo quiero";
            
            // Establecemos la imagen
            imagenboton = @"eliminar.png";
            
            // Tamaño de la imagen
            sizeImagen = 18;
        }
        else
        {
            // Establecemos el texto
            textoboton = @"¡Lo quiero!";
            
            // Establecemos la imagen
            imagenboton = @"descargar.png";
            
            // Tamaño de la imagen
            sizeImagen = 20;
        }
        
        // Creamos el texto
        SPLabel * texto = [[SPLabel alloc] initWithFrame:CGRectMake(0, -2, 30, 30) Text:textoboton Font:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0f] TextColor:[UIColor whiteColor] Padre:self.adquisicion];
        
        // Tamaño del texto
        int sizeText = [texto.text sizeWithAttributes:@{ NSFontAttributeName: texto.font }].width;
        
        // Ajustamos el tamaño del texto
        [texto CambiarAncho:sizeText + 5];
        
        // Ajustamos la posición del texto
        [texto CambiarPosicionX:30];
        
        // Agrandamos el campo del botón
        CGSize sizeBoton = self.adquisicion.frame.size;
        sizeBoton.width  = sizeText + 38;
        
        // Cambiamos la posición del botón
        CGPoint ptoBoton = self.adquisicion.frame.origin;
        ptoBoton.x       = self.view.frame.size.width - sizeBoton.width - 4;
        
        // Establecemos la imagen
        UIImageView * imagen = [[UIImageView alloc] initWithFrame:CGRectMake(2 + (self.adquisicion.frame.size.height - sizeImagen) / 2, (self.adquisicion.frame.size.height - sizeImagen) / 2, sizeImagen, sizeImagen)];
        imagen.image         = [UIImage imageNamed:imagenboton];
        [self.adquisicion addSubview:imagen];
        
        // Establecemos de nuevo los valores del botón
        self.adquisicion.frame = CGRectMake(ptoBoton.x, ptoBoton.y, sizeBoton.width, sizeBoton.height);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
