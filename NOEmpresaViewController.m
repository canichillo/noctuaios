//
//  NOEmpresaViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 31/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOEmpresaViewController.h"
#import "AFImagePager.h"

@interface NOEmpresaViewController ()  <AFImagePagerDelegate, AFImagePagerDataSource>

@end

@implementation NOEmpresaViewController
@synthesize datosempresa;

// Constructor por defecto
-(id) initWithEmpresa: (int) empresa
               Llevas:(BOOL)llevas
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.empresa  = empresa;
        self.mellevas = llevas;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // Inicializamos el interfaz gráfico
    [self initUI];
    
    // Cargamos los datos
    [self cargarDatos];
}

////////////////////////////////////
// Inicializa el interfaz gráfico //
////////////////////////////////////
-(void) initUI
{
    // Configuramos el background
    self.view.backgroundColor = [UIColor whiteColor];
    [SPUtilidades setBackground:@"logobackground.png" Posicion:0 Vista:self.view Alpha:1.0f];
    
    // Creamos la barra de navegación
    [SPUtilidades crearBarraNavegacion:self Titulo:@"Empresa" MenuIzquierdo:NO MenuDerecho:NO SelectorIzquierdo:@selector(volverAtras:)];
    
    // Creamos el texto vacío
    self.textocargando = [[SPLabel alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20, self.view.frame.size.height - 80) Text:@"Cargando los datos de la empresa..." Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f] TextColor:RGB(97, 168, 221) Padre:self.view];
    self.textocargando.textAlignment = NSTextAlignmentCenter;
    self.textocargando.numberOfLines = 0;
}

-(void) initInterfaz
{
    // Imagen de la empresa
    self.imagen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 140)];
    self.imagen.layer.backgroundColor = [[UIColor clearColor] CGColor];
    [self.view addSubview:self.imagen];
    
    // Creamos una vista para el background
    UIView * textoempresa        = [[UIView alloc] initWithFrame:CGRectMake(0, 165, self.view.frame.size.width, 25)];
    textoempresa.backgroundColor = [RGB(97, 168, 221) colorWithAlphaComponent:0.9f];
    [self.view addSubview:textoempresa];
    
    // Creamos el texto de la oferta
    self.nombre = [[SPLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 23)
                                            Text:@""
                                            Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]
                                       TextColor:[UIColor whiteColor]
                                       Alignment:NSTextAlignmentCenter
                                         Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                           Padre:textoempresa];
    
    // Creamos el scroll
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scroll.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.scroll.bounces      = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scroll];
    
    // Creamos el texto de la descripción
    self.descripcion = [[SPLabel alloc] initWithFrame:CGRectMake(15, 110, self.view.frame.size.width - 30, 22)
                                                 Text:@""
                                                 Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]
                                            TextColor:RGB(97, 168, 221)
                                            Alignment:NSTextAlignmentNatural
                                              Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                Padre:self.scroll];
    self.descripcion.numberOfLines = 0;
    self.descripcion.lineBreakMode = NSLineBreakByWordWrapping;
    
    // Colocamos el mapa
    self.mapa          = [[MKMapView alloc] initWithFrame: CGRectMake(20, 50, self.view.frame.size.width - 40, self.view.frame.size.height - 50)];
    self.mapa.delegate = self;
    [self.mapa setMapType:MKMapTypeStandard];
    [self.mapa setZoomEnabled:NO];
    [self.mapa setScrollEnabled:NO];
    [self.mapa setUserInteractionEnabled:NO];
    self.mapa.layer.borderWidth = 2.0f;
    self.mapa.layer.borderColor = [RGB(97, 168, 221) CGColor];
    [self.scroll addSubview:self.mapa];
    
    // Gestionamos la pulsación del mapa
    UITapGestureRecognizer *newTapMapa = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accederMeLlevas)];
    [self.mapa setUserInteractionEnabled:YES];
    [self.mapa addGestureRecognizer:newTapMapa];
    
    // Creamos el panel inferior
    self.panelInferior                 = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 35, self.view.frame.size.width, 35)];
    self.panelInferior.backgroundColor = [RGB(97, 168, 221) colorWithAlphaComponent:0.9f];
    [self.view addSubview:self.panelInferior];
    
    // Creamos el texto de la descripción
    self.numseguidores = [[SPLabel alloc] initWithFrame:CGRectMake(5, 4, self.view.frame.size.width - 20, 28)
                                                   Text:@""
                                                   Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]
                                              TextColor:[UIColor whiteColor]
                                              Alignment:NSTextAlignmentNatural
                                                Padding:UIEdgeInsetsMake(0, 30, 0, 0)
                                                  Padre:self.panelInferior];
    self.numseguidores.layer.borderColor  = [[UIColor whiteColor] CGColor];
    self.numseguidores.layer.borderWidth  = 2.0f;
    self.numseguidores.layer.cornerRadius = 6.0f;
    
    // Creamos el evento de adquisición
    UITapGestureRecognizer *newTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SeguidoresEmpresa)];
    [self.numseguidores setUserInteractionEnabled:YES];
    [self.numseguidores addGestureRecognizer:newTap3];
    
    // Establecemos la imagen
    UIImageView * imagen = [[UIImageView alloc] initWithFrame:CGRectMake(5, (self.numseguidores.frame.size.height - 22) / 2, 22, 22)];
    imagen.image         = [UIImage imageNamed:@"amigos.png"];
    [self.numseguidores addSubview:imagen];
    
    // Establecemos la adquisición
    self.seguimiento = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, 4, 40, 28)];
    self.seguimiento.layer.borderColor  = [[UIColor whiteColor] CGColor];
    self.seguimiento.layer.borderWidth  = 2.0f;
    self.seguimiento.layer.cornerRadius = 6.0f;
    [self.panelInferior addSubview:self.seguimiento];
    
    // Creamos el evento de adquisición
    UITapGestureRecognizer *newTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SeguirEmpresa:)];
    [self.seguimiento setUserInteractionEnabled:YES];
    [self.seguimiento addGestureRecognizer:newTap2];
}

///////////////////////////////////
// Carga los datos de la empresa //
///////////////////////////////////
-(void) cargarDatos
{
    // Parámetros JSON para la petición
    NSDictionary *params = @{
                             @"empresa" : [NSNumber numberWithInt:self.empresa],
                             @"token"   : [SPUtilidades leerDatosToken]
                             };
    
    // Realizamos la petición POST
    [SPUtilidades procesarPeticionPOST: @"datosempresa"
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
                                                // Posición
                                                int posicion = 0;
                                                
                                                // Obtenemos los datos de la empresa
                                                datosempresa = (Empresa *) [MTLJSONAdapter modelOfClass:[Empresa class] fromJSONDictionary:responseObject error:nil];
                                                
                                                // Escondemos el texto de cargando
                                                self.textocargando.hidden = YES;
                                                
                                                // Inicializamos el interfaz
                                                [self initInterfaz];
                                                
                                                // Cambiamos el estado del seguimiento
                                                [self cambiarEstadoSeguimiento];
                                                
                                                // Si no tenemos logo de empresa, ponemos una por defecto
                                                if (datosempresa.logo == nil || [datosempresa.logo isEqual:@"<null>"])
                                                {
                                                    self.imagen.image = [UIImage imageNamed:@"logo.png"];
                                                }
                                                else
                                                {
                                                    // Comprobamos si está almacenada anteriormente
                                                    if ([SPUtilidades existeImagen:@"Noctua/temp" Archivo:datosempresa.logo])
                                                    {
                                                        // Cargamos la imagen
                                                        self.imagen.image = [SPUtilidades leerImagen:@"Noctua/temp" Archivo:datosempresa.logo];
                                                    }
                                                    else
                                                    {
                                                        // Ahora indicamos que debemos cargar
                                                        [self.imagen sd_setImageWithURL:[SPUtilidades urlImagenes:@"empresas" Imagen:[datosempresa.logo stringByAppendingString:@".jpg"]]
                                                                             placeholderImage:[UIImage imageNamed:@"loading.png"]
                                                                                      options: SDWebImageRefreshCached
                                                                                    completed: ^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageURL)
                                                         {
                                                             // Guardamos la imagen para usarla a posteriori
                                                             [SPUtilidades guardarImagen:@"Noctua/temp" Archivo:datosempresa.logo Datos:UIImageJPEGRepresentation(image, 1.0)];
                                                         }
                                                         ];
                                                    }
                                                }
                                                
                                                // Nombre de la empresa
                                                self.nombre.text = datosempresa.nombre;
                                                
                                                // Actualizamos la posición
                                                posicion = 185;
                                                
                                                // Actualizamos el scroll
                                                CGRect frame      = self.scroll.frame;
                                                frame.origin.y    = posicion + 4;
                                                frame.size.height = self.view.frame.size.height - posicion - 4;
                                                self.scroll.frame = frame;
                                                
                                                // Establecemos la imagen de la www
                                                UIImageView * imagenwww = [[UIImageView alloc] initWithFrame:CGRectMake(35, 2, 16, 16)];
                                                imagenwww.image         = [UIImage imageNamed:@"www.png"];
                                                [self.scroll addSubview:imagenwww];
                                                
                                                // Gestionamos la pulsación de la web
                                                UITapGestureRecognizer *newTapWeb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AbrirWeb)];
                                                [imagenwww setUserInteractionEnabled:YES];
                                                [imagenwww addGestureRecognizer:newTapWeb];
                                                
                                                // Creamos el texto de la web
                                                SPLabel * web = [SPUtilidades setTextoEstaticoRtn:CGRectMake(60, 0, self.view.frame.size.width - 70, 18)
                                                                                            Texto:datosempresa.web
                                                                                           Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:15.0f]
                                                                                        TextColor:RGB(97, 168, 221)
                                                                                            Padre:self.scroll
                                                                                        Alignment:NSTextAlignmentLeft];
                                                
                                                // Gestionamos la pulsación de la web
                                                UITapGestureRecognizer *newTapWeb2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AbrirWeb)];
                                                [web setUserInteractionEnabled:YES];
                                                [web addGestureRecognizer:newTapWeb2];
                                                
                                                // Establecemos la imagen del teléfono
                                                UIImageView * imagentlf = [[UIImageView alloc] initWithFrame:CGRectMake(35, 21, 16, 16)];
                                                imagentlf.image         = [UIImage imageNamed:@"phone.png"];
                                                [self.scroll addSubview:imagentlf];
                                                
                                                // Creamos el texto de la web
                                                [SPUtilidades setTextoEstatico:CGRectMake(60, 20, self.view.frame.size.width - 70, 18)
                                                                         Texto:datosempresa.telefonos
                                                                        Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:15.0f]
                                                                     TextColor:RGB(97, 168, 221)
                                                                         Padre:self.scroll
                                                                     Alignment:NSTextAlignmentLeft];
                                                
                                                // Establecemos la imagen del teléfono
                                                UIImageView * imagenemail = [[UIImageView alloc] initWithFrame:CGRectMake(35, 41, 16, 16)];
                                                imagenemail.image         = [UIImage imageNamed:@"email.png"];
                                                [self.scroll addSubview:imagenemail];
                                                
                                                // Creamos el evento de pulsación de los emails
                                                UITapGestureRecognizer *newTapEmail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AbrirEmail)];
                                                [imagenemail setUserInteractionEnabled:YES];
                                                [imagenemail addGestureRecognizer:newTapEmail];
                                                
                                                // Creamos el texto del correo electrónico
                                                SPLabel * email = [SPUtilidades setTextoEstaticoRtn:CGRectMake(60, 39, self.view.frame.size.width - 70, 18)
                                                                                              Texto:datosempresa.email
                                                                                             Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:15.0f]
                                                                                          TextColor:RGB(97, 168, 221)
                                                                                              Padre:self.scroll
                                                                                          Alignment:NSTextAlignmentLeft];
                                                
                                                // Creamos el evento de pulsación de los emails
                                                UITapGestureRecognizer *newTapEmail2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AbrirEmail)];
                                                [email setUserInteractionEnabled:YES];
                                                [email addGestureRecognizer:newTapEmail2];
                                                
                                                // Establecemos la imagen del facebook
                                                UIImageView * imagenfcb = [[UIImageView alloc] initWithFrame:CGRectMake(35, 61, 16, 16)];
                                                imagenfcb.image         = [UIImage imageNamed:@"facebookemp.png"];
                                                [self.scroll addSubview:imagenfcb];
                                                
                                                // Creamos el evento de adquisición
                                                UITapGestureRecognizer *newTapFacebook = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AbrirFacebook)];
                                                [imagenfcb setUserInteractionEnabled:YES];
                                                [imagenfcb addGestureRecognizer:newTapFacebook];
                                                
                                                // Creamos el texto del correo electrónico
                                                SPLabel * facebook = [SPUtilidades setTextoEstaticoRtn:CGRectMake(60, 59, self.view.frame.size.width - 70, 18)
                                                                                                 Texto:datosempresa.facebook
                                                                                                Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:15.0f]
                                                                                             TextColor:RGB(97, 168, 221)
                                                                                                 Padre:self.scroll
                                                                                             Alignment:NSTextAlignmentLeft];
                                                
                                                UITapGestureRecognizer *newTapFacebook2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AbrirFacebook)];
                                                [facebook setUserInteractionEnabled:YES];
                                                [facebook addGestureRecognizer:newTapFacebook2];
                                                
                                                // Establecemos la imagen del twitter
                                                UIImageView * imagentwi = [[UIImageView alloc] initWithFrame:CGRectMake(35, 81, 16, 16)];
                                                imagentwi.image         = [UIImage imageNamed:@"twitteremp.png"];
                                                [self.scroll addSubview:imagentwi];
                                                
                                                // Creamos el evento de adquisición
                                                UITapGestureRecognizer *newTapTwitter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AbrirTwitter)];
                                                [imagentwi setUserInteractionEnabled:YES];
                                                [imagentwi addGestureRecognizer:newTapTwitter];
                                                
                                                // Creamos el texto del correo electrónico
                                                SPLabel * textoTwitter = [SPUtilidades setTextoEstaticoRtn:CGRectMake(60, 79, self.view.frame.size.width - 70, 18)
                                                                                              Texto:datosempresa.twitter
                                                                                             Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:15.0f]
                                                                                          TextColor:RGB(97, 168, 221)
                                                                                              Padre:self.scroll
                                                                                          Alignment:NSTextAlignmentLeft];
                                                
                                                // Creamos el evento de adquisición
                                                UITapGestureRecognizer *newTapTwitter2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AbrirTwitter)];
                                                [textoTwitter setUserInteractionEnabled:YES];
                                                [textoTwitter addGestureRecognizer:newTapTwitter2];
                                                
                                                // Creamos la línea de separación
                                                UIView * linea2 = [[UIView alloc] initWithFrame:CGRectMake(30, 103, self.view.frame.size.width - 60, 2)];
                                                linea2.backgroundColor = RGB(97, 168, 221);
                                                [self.scroll addSubview:linea2];
                                                
                                                // Establecemos la descripcion
                                                self.descripcion.text = datosempresa.descripcion;
                                                
                                                // Obtenemos el tamaño del nombre de la oferta
                                                [self.descripcion CambiarAlto:[SPUtilidades TamanyoTexto:self.descripcion.text Tamanyo:self.descripcion.frame.size Fuente:self.descripcion.font] + 5];

                                                // Ajustamos la posición del mapa
                                                self.mapa.frame = CGRectMake(15, self.descripcion.frame.origin.y + self.descripcion.frame.size.height + 10, self.view.frame.size.width - 30, self.view.frame.size.width - 20);
                                                
                                                // Añadimos el punto de la ubicación
                                                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                                                point.coordinate         = CLLocationCoordinate2DMake([datosempresa.latitud doubleValue], [datosempresa.longitud doubleValue]);
                                                point.title              = datosempresa.nombre;
                                                point.subtitle           = datosempresa.poblacion;
                                                [self.mapa addAnnotation:point];
                                                
                                                // Establecemos el zoom
                                                MKMapPoint annotationPoint = MKMapPointForCoordinate(point.coordinate);
                                                MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
                                                [self.mapa setVisibleMapRect:pointRect animated:YES];
                                                
                                                // Creamos el panel de los datos del mapa
                                                UIView * panelMapa = [[UIView alloc] initWithFrame:CGRectMake(self.mapa.frame.origin.x + 5, self.mapa.frame.origin.y + self.mapa.frame.size.height - 45, self.mapa.frame.size.width - 30, 38)];
                                                panelMapa.backgroundColor    = [UIColor whiteColor];
                                                panelMapa.layer.cornerRadius = 6.0f;
                                                panelMapa.layer.borderColor  = [RGB(97, 168, 221) CGColor];
                                                panelMapa.layer.borderWidth  = 2.0f;
                                                [self.scroll addSubview:panelMapa];
                                                
                                                // Mostramos la imagen de la ubicación
                                                UIImageView * imagenUbicacion = [[UIImageView alloc] initWithFrame:CGRectMake(2, 3, 30, 30)];
                                                imagenUbicacion.image         = [UIImage imageNamed:@"marker.png"];
                                                [panelMapa addSubview:imagenUbicacion];
                                                
                                                // Creamos el texto de la dirección
                                                [SPUtilidades setTextoEstatico:CGRectMake(35, 3, panelMapa.frame.size.width - 45, 16)
                                                                         Texto:datosempresa.direccion
                                                                        Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:14.0f]
                                                                     TextColor:RGB(97, 168, 221)
                                                                         Padre:panelMapa
                                                                     Alignment:NSTextAlignmentLeft];
                                                
                                                // Creamos el texto de la población
                                                [SPUtilidades setTextoEstatico:CGRectMake(35, 18, panelMapa.frame.size.width - 45, 16)
                                                                         Texto:datosempresa.poblacion
                                                                        Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:14.0f]
                                                                     TextColor:RGB(97, 168, 221)
                                                                         Padre:panelMapa
                                                                     Alignment:NSTextAlignmentLeft];
                                                
                                                // Si podemos hacer ¿me llevas?
                                                if (self.mellevas)
                                                {
                                                    // Creamos el evento
                                                    UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accederMeLlevas)];
                                                    [panelMapa setUserInteractionEnabled:YES];
                                                    [panelMapa addGestureRecognizer:newTap];
                                                }
                                                
                                                // Colocamos la posición del visualizador de imágenes
                                                self.pagerimagenes = [[AFImagePager alloc] initWithFrame:CGRectMake(15, self.mapa.frame.origin.y + self.mapa.frame.size.height + 10, self.view.frame.size.width - 30, self.view.frame.size.width - 30)];
                                                self.pagerimagenes.layer.borderColor  = [RGB(97, 168, 221) CGColor];
                                                self.pagerimagenes.layer.borderWidth  = 2.0f;
                                                [self.scroll addSubview:self.pagerimagenes];
                                                
                                                self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width, self.pagerimagenes.frame.origin.y + self.pagerimagenes.frame.size.height + 40);
                                                
                                                // Establecemos el número de seguidores
                                                self.numseguidores.text = [NSString stringWithFormat:@"%@ seguidores", datosempresa.seguidores];
                                                [self.numseguidores CambiarAncho:[SPUtilidades AnchuraTexto:self.numseguidores.text Tamanyo:self.numseguidores.frame.size Fuente:self.numseguidores.font] + 40];
                                                
                                                // Obtenemos las imágenes
                                                NSDictionary *params = @{
                                                                         @"empresa" : [NSNumber numberWithInt:self.empresa],
                                                                         };
                                                
                                                // Realizamos la petición POST
                                                [SPUtilidades procesarPeticionPOST: @"imagenesempresa"
                                                                        Parametros: params
                                                                      SuccessBlock: ^(id responseObject)
                                                                                    {
                                                                                        // Si es un array
                                                                                        if ([responseObject isKindOfClass:[NSArray class]])
                                                                                        {
                                                                                            // Si no hay elementos
                                                                                            if ([responseObject count] == 0)
                                                                                            {
                                                                                                self.pagerimagenes.hidden = YES;
                                                                                                self.scroll.contentSize  = CGSizeMake(self.scroll.frame.size.width, self.mapa.frame.origin.y + self.mapa.frame.size.height + 40);
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                // Creamos el array de datos
                                                                                                self.imagenes = [[NSMutableArray alloc] initWithCapacity:[responseObject count]];
                                                                                                self.photos   = [[NSMutableArray alloc] initWithCapacity:[responseObject count]];
                                                                                            
                                                                                                // Para cada uno de los elementos
                                                                                                for (NSDictionary *JSONData in responseObject)
                                                                                                {
                                                                                                    // Añadimos la imagen
                                                                                                    [self.imagenes addObject:[[SPUtilidades urlImagenes:@"imagenesempresa" Imagen:[[JSONData objectForKey:@"archivo"] stringByAppendingString:@".jpg"]] absoluteString]];
                                                                                                
                                                                                                    // Imagen para el gestor de imágenes
                                                                                                    MWPhoto * photo = [MWPhoto photoWithURL:[SPUtilidades urlImagenes:@"imagenesempresa" Imagen:[[JSONData objectForKey:@"archivo"] stringByAppendingString:@".jpg"]]];
                                                                                                
                                                                                                    // Descripción de la foto
                                                                                                    photo.caption = [JSONData objectForKey:@"descripcion"];
                                                                                                
                                                                                                    // Añadimos la foto
                                                                                                    [self.photos addObject:photo];
                                                                                                }
                                                                                            
                                                                                                // Recargamos los datos
                                                                                                self.pagerimagenes.dataSource = self;
                                                                                                self.pagerimagenes.delegate   = self;
                                                                                                [self.pagerimagenes reloadData];
                                                                                            }
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            // Se ha obtenido algún error
                                                                                            [SPUtilidades mostrarError:@"Error" Mensaje:[responseObject objectForKey:@"Error"] Handler:^(SIAlertView *alertView) { }];
                                                                                        }
                                                                                    }
                                                                      FailureBlock:^(NSError *error)
                                                                                    {
                                                                                        // Se ha producido un error
                                                                                        [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener las imágenes de la empresa" Handler:^(SIAlertView *alertView) { }];
                                                                                    }];
                                            }
                                        }
                          FailureBlock: ^(NSError *error)
                                        {
                                            // Se ha producido un error
                                            [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener los datos de la empresa" Handler:^(SIAlertView *alertView) { }];
                                        }
     ];
}

////////////////////////
// Vuelve hacia atrás //
////////////////////////
-(void) volverAtras: (id) sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

//////////////////////////////////////
// Accede a la ventana de me llevas //
//////////////////////////////////////
-(void) accederMeLlevas
{
    // Cargamos la ventana
    [self.navigationController pushViewController:[[NOMeLlevasViewController alloc] initWithDestino:CLLocationCoordinate2DMake([datosempresa.latitud doubleValue], [datosempresa.longitud doubleValue])
                                                                                            Empresa:datosempresa.poblacion Oferta:datosempresa.nombre Imagen:datosempresa.logo] animated:YES];
}

///////////////////////////////////////
// Accede a la ventana de seguidores //
///////////////////////////////////////
-(void) SeguidoresEmpresa
{
    // Cargamos la ventana
    [self.navigationController pushViewController:[[NOSeguidoresViewController alloc] initWithEmpresa: self.empresa] animated:YES];
}

//////////////////////////////////////
// Cambia el estado del seguimiento //
//////////////////////////////////////
-(void) cambiarEstadoSeguimiento
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Eliminamos todas las vistas del botón de adquisición
        NSArray *viewsToRemove = [self.seguimiento subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        
        // Texto del botón
        NSString * textoboton = @"";
        // Imagen del botón
        NSString * imagenboton = @"";
        // Tamaño de la imagen
        int sizeImagen = 18;
        
        // Si estamos siguiendo la empresa
        if ([datosempresa.favorito isEqual:@"S"])
        {
            // Establecemos el texto
            textoboton = @"Eliminar favorito";
            
            // Establecemos la imagen
            imagenboton = @"star.png";
            
            // Tamaño de la imagen
            sizeImagen = 18;
        }
        else
        {
            // Establecemos el texto
            textoboton = @"Agregar favorito";
            
            // Establecemos la imagen
            imagenboton = @"staroutline.png";
            
            // Tamaño de la imagen
            sizeImagen = 20;
        }
        
        // Creamos el texto
        SPLabel * texto = [[SPLabel alloc] initWithFrame:CGRectMake(0, -2, 30, 30) Text:textoboton Font:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0f] TextColor:[UIColor whiteColor] Padre:self.seguimiento];
        
        // Tamaño del texto
        int sizeText = [texto.text sizeWithAttributes:@{ NSFontAttributeName: texto.font }].width;
        
        // Ajustamos el tamaño del texto
        [texto CambiarAncho:sizeText + 5];
        
        // Ajustamos la posición del texto
        [texto CambiarPosicionX:30];
        
        // Agrandamos el campo del botón
        CGSize sizeBoton = self.seguimiento.frame.size;
        sizeBoton.width  = sizeText + 38;
        
        // Cambiamos la posición del botón
        CGPoint ptoBoton = self.seguimiento.frame.origin;
        ptoBoton.x       = self.view.frame.size.width - sizeBoton.width - 4;
        
        // Establecemos la imagen
        UIImageView * imagen = [[UIImageView alloc] initWithFrame:CGRectMake(2 + (self.seguimiento.frame.size.height - sizeImagen) / 2, (self.seguimiento.frame.size.height - sizeImagen) / 2, sizeImagen, sizeImagen)];
        imagen.image         = [UIImage imageNamed:imagenboton];
        [self.seguimiento addSubview:imagen];
        
        // Establecemos de nuevo los valores del botón
        self.seguimiento.frame = CGRectMake(ptoBoton.x, ptoBoton.y, sizeBoton.width, sizeBoton.height);
    });
}

////////////////////////////////////////////////////
// Cambia el estado del seguimiento de la empresa //
////////////////////////////////////////////////////
-(void) SeguirEmpresa: (id) sender
{
    // URL que usaremos
    NSString * url     = [datosempresa.favorito isEqual:@"S"] ? @"noseguirempresa" : @"seguirempresa";
    // Mensaje de confirmación
    NSString * mensaje = [datosempresa.favorito isEqual:@"S"] ? @"¿Desea eliminar esta empresa de sus favoritas?" : @"¿Desea agregar esta empresa a sus favoritas?";
    
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
                                  @"empresa" : [NSNumber numberWithInt:self.empresa],
                                  @"token"   : [SPUtilidades leerDatosToken]
                                  };
         
         // Realizamos la petición POST
         [SPUtilidades procesarPeticionPOST: url
                                 Parametros: params
                               SuccessBlock: ^(id responseObject)
          {
              // Si está correcto
              if ([responseObject objectForKey:@"Mensaje"]) {
                  // Cambiamos el estado
                  datosempresa.favorito = [datosempresa.favorito isEqual:@"S"] ? @"N" : @"S";
                  
                  // Mostramos el mensaje de que es correcto
                  [SPUtilidades mostrarInformacion:@"Información" Mensaje:[datosempresa.favorito isEqual:@"S"] ? @"Has agregado esta empresa a tus favoritas." : @"Has eliminado esta empresa de tus favoritas." Handler:^(SIAlertView *alertView) { }];
                  
                  // Cambiamos el estado del botón de seguimiento
                  [self cambiarEstadoSeguimiento];
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

///////////////////
// Abre el email //
///////////////////
-(void) AbrirEmail
{
    // Si tenemos web
    if (![datosempresa.email isEqual:@""])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", datosempresa.email]]];
    }
}

/////////////////
// Abre la web //
/////////////////
-(void) AbrirWeb
{
    // Si tenemos web
    if (![datosempresa.web isEqual:@""])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:datosempresa.web]];
    }
}

//////////////////////
// Abre el facebook //
//////////////////////
-(void) AbrirFacebook
{
    // Si tenemos facebook
    if (![datosempresa.facebook isEqual:@""])
    {
        NSString * url = [NSString stringWithFormat:@"fb://profile/%@", datosempresa.facebook];
        NSURL *twitterURL = [NSURL URLWithString:url];
        if ([[UIApplication sharedApplication] canOpenURL:twitterURL])
            [[UIApplication sharedApplication] openURL:twitterURL];
        else
        {
            url = [NSString stringWithFormat:@"https://www.facebook.com/%@", datosempresa.facebook];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}

/////////////////////
// Abre el twitter //
/////////////////////
-(void) AbrirTwitter
{
    // Si tenemos twitter
    if (![datosempresa.twitter isEqual:@""])
    {
        NSString * url = [[NSString stringWithFormat:@"twitter://user?screen_name=%@", datosempresa.twitter] stringByReplacingOccurrencesOfString:@"@" withString:@""];
        NSURL *twitterURL = [NSURL URLWithString:url];
        if ([[UIApplication sharedApplication] canOpenURL:twitterURL])
            [[UIApplication sharedApplication] openURL:twitterURL];
        else
        {
            url = [[NSString stringWithFormat:@"http://www.twitter.com/%@", datosempresa.twitter] stringByReplacingOccurrencesOfString:@"@" withString:@""];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}

#pragma mark - AFImagePager DataSource
- (NSArray *) arrayWithImageUrlStrings
{
    return self.imagenes;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleToFill;
}

/////////////////////////////////////
// Cuando seleccionamos una imagen //
/////////////////////////////////////
- (void) imagePager:(AFImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    // Creamos el gestor de imágenes
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Opciones
    browser.displayActionButton     = NO;
    browser.displayNavArrows        = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill        = YES;
    browser.alwaysShowControls      = YES;
    browser.enableGrid              = NO;
    browser.startOnGrid             = NO;
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
       
    // Indicamos la imagen que hemos seleccionado
    [browser setCurrentPhotoIndex:index];
    
    // Present
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - MWPhotoBrowser delegates
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

////////////////////////////////////////////////////////////////////
// Evento que gestiona la visualización de los elementos del mapa //
////////////////////////////////////////////////////////////////////
-(MKAnnotationView *)mapView: (MKMapView *) mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *SFAnnotationIdentifier = @"SFAnnotationIdentifier";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
    if (!pinView)
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:SFAnnotationIdentifier];
        annotationView.image = [SPUtilidades crearMarcador:self.imagen.image];
        return annotationView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
