//
//  NOMapaViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 26/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOMapaViewController.h"
#import "CCHNearCenterMapClusterer.h"
#import "CCHFadeInOutMapAnimator.h"

@interface NOMapaViewController ()

@end

@implementation NOMapaViewController
@synthesize atras;

// Constructor
-(id) initWithAtras: (BOOL) back
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        atras = back;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Cargamos la vista
    [self initUI];
}

///////////////////////////////////
// Configura el interfaz gráfico //
///////////////////////////////////
-(void) initUI
{
    // Configuramos el background
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Colocamos el mapa
    self.mapa          = [[MKMapView alloc] initWithFrame: CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50)];
    self.mapa.delegate = self;
    [self.mapa setMapType:MKMapTypeStandard];
    [self.mapa setZoomEnabled:YES];
    [self.mapa setScrollEnabled:YES];
    [self.view addSubview:self.mapa];
    
    // Configuramos la barra de navegación según la opción seleccionada
    if (atras)
        // Creamos la barra de navegación
        [SPUtilidades crearBarraNavegacion:self Titulo:@"Mapa" MenuIzquierdo:NO MenuDerecho:NO SelectorIzquierdo:@selector(volverAtras:)];
    else [SPUtilidades crearBarraNavegacion:self Titulo:@"Mapa" MenuIzquierdo:YES MenuDerecho:NO SelectorIzquierdo:nil];
    
    // Ajustamos el cluster
    self.mapClusterController                                 = [[CCHMapClusterController alloc] initWithMapView:self.mapa];
    self.mapClusterController.cellSize                        = 30.0f;
    self.mapClusterController.minUniqueLocationsForClustering = 2;
    self.mapClusterController.delegate                        = self;
    self.mapClusterer                                         = [[CCHNearCenterMapClusterer alloc] init];
    self.mapClusterController.clusterer                       = self.mapClusterer;
    
    // Incluimos un evento que controla cuando se ha cambiado la localización
    [[LocationService sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    [[LocationService sharedInstance] startUpdatingLocation];
    
    // Establecemos las opciones
    [self opcionesNoctua];
}

///////////////////////
// Crea las opciones //
///////////////////////
-(void) opcionesNoctua
{
    // Creamos el panel
    self.panelTipos = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 63, self.view.frame.size.width, 63)];
    self.panelTipos.backgroundColor = [RGB(97, 168, 221) colorWithAlphaComponent:0.85f];
    // Añadimos el panel a la vista
    [self.view addSubview:self.panelTipos];
    
    // Creamos un UIScrollView
    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.panelTipos.frame.size.width, self.panelTipos.frame.size.height)];
    scroll.bounces        = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    [self.panelTipos addSubview:scroll];
    
    // Creamos los botones
    [self crearBoton: @"Ofertas" Posicion:CGPointMake(10, 4) Color:RGB(114, 205, 148) Imagen:@"tickets.png" Scroll:scroll Evento:@selector(mostrarOfertas)];
    [self crearBoton: @"Noctuas" Posicion:CGPointMake(60, 4) Color:RGB(239, 176, 76) Imagen:@"miscupones.png" Scroll:scroll Evento:@selector(mostrarNoctuas)];
    [self crearBoton: @"Mapa" Posicion:CGPointMake(110, 4) Color:RGB(155, 157, 255) Imagen:@"mimapa.png" Scroll:scroll Evento:nil];
    
    // Indicamos el tamaño del scroll
    scroll.contentSize = CGSizeMake(20 + (3 * 50), scroll.frame.size.height);
    
    // Reajustamos el scroll
    if (scroll.contentSize.width - 20 < self.view.frame.size.width)
        scroll.frame = CGRectMake((self.view.frame.size.width - scroll.contentSize.width + 7) / 2, 0, scroll.contentSize.width, scroll.contentSize.height);
    else scroll.frame = CGRectMake((self.view.frame.size.width - scroll.contentSize.width + 7) / 2, 0, scroll.contentSize.width, scroll.contentSize.height);
}

///////////////////////////////
// Crea un botón de opciones //
///////////////////////////////
-(void) crearBoton: (NSString *) titulo
          Posicion: (CGPoint) posicion
             Color: (UIColor *) color
            Imagen: (NSString *) imagen
            Scroll: (UIScrollView *) scroll
            Evento: (SEL) evento
{
    // Creamos el botón
    UIButton * boton         = [[UIButton alloc] initWithFrame:CGRectMake(posicion.x, posicion.y, 42, 42)];
    boton.layer.borderColor  = [[UIColor whiteColor] CGColor];
    boton.layer.borderWidth  = 2.0f;
    boton.layer.cornerRadius = 21;
    [boton setImage:[SPUtilidades imageWithImage:[UIImage imageNamed:imagen] scaledToSize:CGSizeMake(28, 28)] forState:UIControlStateNormal];
    boton.backgroundColor    = color;
    [scroll addSubview:boton];
    
    // Creamos el texto
    UILabel * etiqueta     = [[UILabel alloc] initWithFrame:CGRectMake(posicion.x - 11, posicion.y + 41, 64, 18)];
    etiqueta.text          = titulo;
    etiqueta.textColor     = [UIColor whiteColor];
    etiqueta.font          = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f];
    etiqueta.textAlignment = NSTextAlignmentCenter;
    [scroll addSubview:etiqueta];
    
    // Creamos una vista transparente
    UIButton * transparente = [[UIButton alloc] initWithFrame:CGRectMake(posicion.x - 11, posicion.y, 64, 65)];
    [scroll addSubview:transparente];
    [transparente addTarget:self action:evento forControlEvents:UIControlEventTouchDown];
}

/////////////////////////
// Muestra las ofertas //
/////////////////////////
-(void) mostrarOfertas
{
    [SPUtilidades cargarRootUIViewController:[[NOOfertasViewController alloc] init]];
}

/////////////////////////
// Muestra los Noctuas //
/////////////////////////
-(void) mostrarNoctuas
{
    [SPUtilidades cargarRootUIViewController: [[NOCuponesViewController alloc] initWithAtras:NO Internet:YES]];
}

///////////////////////////////////////////////////
// Evento que gestiona el cambio de localización //
///////////////////////////////////////////////////
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentLocation"])
    {
        // Obtenemos la ubicación
        self.ubicacion = [[LocationService sharedInstance] currentLocation];
        
        // Paramos la captura de más datos
        [[LocationService sharedInstance] stopUpdatingLocation];
        [[LocationService sharedInstance] removeObserver:self forKeyPath:@"currentLocation"];
        
        // Cargamos los datos
        [self cargarDatos];
    }
}

-(void) cargarDatos
{
    // Parámetros JSON para la petición
    NSDictionary *params = @{
                             @"ciudad" : @2
                             };
    
    // Realizamos la petición POST
    [SPUtilidades procesarPeticionPOST: @"ubicacionofertas"
                            Parametros: params
                          SuccessBlock: ^(id responseObject)
                                        {
                                            // Comprobamos si se ha producido un error
                                            if ([responseObject isKindOfClass:[NSArray class]])
                                            {
                                                // Valores por defecto
                                                CLLocationDegrees maxLat = INT32_MIN;
                                                CLLocationDegrees maxLon = INT32_MIN;
                                                CLLocationDegrees minLat = INT32_MAX;
                                                CLLocationDegrees minLon = INT32_MAX;
                                                
                                                // Listado de anotaciones
                                                NSMutableArray * annotations = [[NSMutableArray alloc] init];
                                                
                                                // Añadimos el punto del usuario
                                                // Creamos la anotación
                                                NOPointAnnotation * annotation = [[NOPointAnnotation alloc] init];
                                                // Establecemos la coordenada
                                                annotation.coordinate = self.ubicacion.coordinate;
                                                // Etablecemos la empresa
                                                annotation.idEmpresa = -1;
                                                // Nombre de la empresa
                                                annotation.title = [SPUtilidades leerDatosUsuario];
                                                
                                                // Añadimos la anotación
                                                [annotations addObject:annotation];
                                                
                                                // Recalculamos la región a dibujar
                                                if(annotation.coordinate.latitude > maxLat)
                                                    maxLat = annotation.coordinate.latitude;
                                                if(annotation.coordinate.latitude < minLat)
                                                    minLat = annotation.coordinate.latitude;
                                                if(annotation.coordinate.longitude > maxLon)
                                                    maxLon = annotation.coordinate.longitude;
                                                if(annotation.coordinate.longitude < minLon)
                                                    minLon = annotation.coordinate.longitude;
                                                
                                                // Para cada uno de los elementos
                                                for (NSDictionary *JSONData in responseObject)
                                                {
                                                    // Creamos la anotación
                                                    NOPointAnnotation * annotation = [[NOPointAnnotation alloc] init];
                                                    // Establecemos la coordenada
                                                    annotation.coordinate = CLLocationCoordinate2DMake([[JSONData objectForKey:@"latitud"] doubleValue], [[JSONData objectForKey:@"longitud"] doubleValue]);
                                                    // Etablecemos la empresa
                                                    annotation.idEmpresa = (int) [[JSONData objectForKey:@"empresa"] integerValue];
                                                    // Tipo de la oferta
                                                    annotation.tipo      = [JSONData objectForKey:@"tipo"];
                                                    // Nombre de la empresa
                                                    annotation.title     = [JSONData objectForKey:@"nombre"];
                                                    
                                                    // Añadimos la anotación
                                                    [annotations addObject:annotation];
                                                    
                                                    // Recalculamos la región a dibujar
                                                    if(annotation.coordinate.latitude > maxLat)
                                                        maxLat = annotation.coordinate.latitude;
                                                    if(annotation.coordinate.latitude < minLat)
                                                        minLat = annotation.coordinate.latitude;
                                                    if(annotation.coordinate.longitude > maxLon)
                                                        maxLon = annotation.coordinate.longitude;
                                                    if(annotation.coordinate.longitude < minLon)
                                                        minLon = annotation.coordinate.longitude;
                                                }
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self.mapClusterController addAnnotations:annotations withCompletionHandler:nil];
                                                    MKCoordinateRegion region;
                                                    // Posicionamos el centro
                                                    float lonDelta = maxLat - minLat;
                                                    float latDelta = maxLon - minLon;
                                                    float scale = 1.0;
                                                    
                                                    if ((lonDelta / latDelta) > scale)
                                                    {
                                                        region.span.latitudeDelta  = lonDelta * 29.0 / 16.0;
                                                        region.span.longitudeDelta = lonDelta * 29.0 / 16.0;
                                                    }
                                                    else
                                                    {
                                                        region.span.latitudeDelta  = latDelta * 29.0 / 24.0;
                                                        region.span.longitudeDelta = latDelta * 29.0 / 24.0;
                                                    }
                                                    
                                                    region.center.latitude     = (maxLat + minLat) / 2.0;
                                                    region.center.longitude    = (maxLon + minLon) / 2.0;
                                                    
                                                    [self.mapa setRegion:region animated:YES];
                                                });
                                            }
                                            else
                                            {
                                                // Se ha obtenido algún error
                                                [SPUtilidades mostrarError:@"Error" Mensaje:[responseObject objectForKey:@"Error"] Handler:^(SIAlertView *alertView) { }];
                                            }
                                        }
                          FailureBlock: ^(NSError *error)
                                        {
                                            [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener la ubicación de las empresas" Handler:^(SIAlertView *alertView) { }];
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

////////////////////////////////////////////////////////
// Establece el color del texto de la barra de estado //
////////////////////////////////////////////////////////
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView;
  
    if ([annotation isKindOfClass:CCHMapClusterAnnotation.class]) {
        static NSString *identifier = @"clusterAnnotation";
        
        NOClusterAnnotationView *clusterAnnotationView = (NOClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (clusterAnnotationView)
        {
            clusterAnnotationView.annotation = annotation;
        }
        else
        {
            clusterAnnotationView                = [[NOClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            clusterAnnotationView.canShowCallout = YES;
            UIButton* rightButton                = [UIButton buttonWithType:UIButtonTypeInfoLight];
            clusterAnnotationView.rightCalloutAccessoryView = rightButton;
        }
        
        CCHMapClusterAnnotation *clusterAnnotation = (CCHMapClusterAnnotation *)annotation;
        clusterAnnotationView.count          = clusterAnnotation.annotations.count;
        clusterAnnotationView.uniqueLocation = clusterAnnotation.isUniqueLocation;
        clusterAnnotationView.idEmpresa      = ((NOPointAnnotation *) clusterAnnotation.annotations.allObjects[0]).idEmpresa;
        clusterAnnotationView.tipo           = ((NOPointAnnotation *) clusterAnnotation.annotations.allObjects[0]).tipo;
        annotationView = clusterAnnotationView;
    }
    
    return annotationView;
}

////////////////////////////////////////////////////////////////////
// Evento que gestiona la pulsación sobre el botón de información //
////////////////////////////////////////////////////////////////////
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:CCHMapClusterAnnotation.class])
    {
        // Anotación
        CCHMapClusterAnnotation * anotacion = (CCHMapClusterAnnotation *) view.annotation;
        
        // Si es 1 elemento (Es la empresa)
        if (anotacion.annotations.count == 1)
        {
            // ID de la empresa
            self.empresa = ((NOPointAnnotation *) anotacion.annotations.allObjects[0]).idEmpresa;
            
            // Si somos una empresa hacemos cosas
            if (self.empresa != -1)
            {
                // Parámetros JSON para la petición
                NSDictionary *params = @{
                                         @"empresa" : [NSNumber numberWithInt:self.empresa]
                                         };
                
                // Realizamos la petición POST
                [SPUtilidades procesarPeticionPOST: @"numeroofertasempresa"
                                        Parametros: params
                                      SuccessBlock: ^(id responseObject)
                                                    {
                                                        // Si no tiene error
                                                        if ([responseObject isKindOfClass:[NSArray class]])
                                                        {
                                                            // Comprobamos si tenemos una oferta o varias
                                                            int ofertas = (int) ((NSArray *) responseObject).count;
                                                            
                                                            // Si sólo hay una oferta
                                                            if (ofertas == 1)
                                                            {
                                                                NSDictionary * datosoferta = (NSDictionary *)((NSArray *) responseObject)[0];
                                                                
                                                                // Mostramos los datos de la oferta
                                                                [self.navigationController pushViewController:[[NOOfertaViewController alloc] initWithOferta:[[datosoferta objectForKey:@"oferta"] intValue] Llevas:NO] animated:YES];
                                                            }
                                                            else
                                                            {
                                                                // Mostramos las ofertas de la empresa
                                                                [self.navigationController pushViewController:[[NOOfertasEmpresaViewController alloc] initWithEmpresa:self.empresa Ubicacion:self.ubicacion.coordinate] animated:YES];
                                                            }
                                                        }
                                                        else
                                                        {
                                                            [SPUtilidades mostrarError:@"Error" Mensaje:[responseObject objectForKey:@"Error"] Handler:^(SIAlertView *alertView) { }];
                                                        }
                                                    }
                                      FailureBlock: ^(NSError *error)
                                                    {
                                                        [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener los datos de las ofertas" Handler:^(SIAlertView *alertView) { }];
                                                    }
                 ];
            }
        }
        else
        {
            CCHMapClusterAnnotation *clusterAnnotation = (CCHMapClusterAnnotation *)view.annotation;
            MKMapRect mapRect = [clusterAnnotation mapRect];
            UIEdgeInsets edgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
            [self.mapa setVisibleMapRect:mapRect edgePadding:edgeInsets animated:YES];
        }
    }
}

- (NSString *)mapClusterController:(CCHMapClusterController *)mapClusterController titleForMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation
{
    if (mapClusterAnnotation.annotations.count == 1)
    {
        return ((NOPointAnnotation *) mapClusterAnnotation.annotations.allObjects[0]).title;
    }
    else
    {
        NSUInteger numAnnotations = mapClusterAnnotation.annotations.count;
        return [NSString stringWithFormat:@"%tu empresas", numAnnotations];
    }
}

- (NSString *)mapClusterController:(CCHMapClusterController *)mapClusterController subtitleForMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation
{
    // Si sólo hay un elemento
    if (mapClusterAnnotation.annotations.count == 1)
    {
        if (((NOPointAnnotation *) mapClusterAnnotation.annotations.allObjects[0]).idEmpresa == -1) return @"Tú posición";
        else return @"Acceder a las ofertas";
    }
    else
    {
        NSUInteger numAnnotations = MIN(mapClusterAnnotation.annotations.count, 5);
        NSArray *annotations = [mapClusterAnnotation.annotations.allObjects subarrayWithRange:NSMakeRange(0, numAnnotations)];
        NSArray *titles = [annotations valueForKey:@"title"];
        return [titles componentsJoinedByString:@", "];
    }
}

- (void)mapClusterController:(CCHMapClusterController *)mapClusterController willReuseMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation
{
    NOClusterAnnotationView *clusterAnnotationView = (NOClusterAnnotationView *)[self.mapa viewForAnnotation:mapClusterAnnotation];
    clusterAnnotationView.count = mapClusterAnnotation.annotations.count;
    clusterAnnotationView.uniqueLocation = mapClusterAnnotation.isUniqueLocation;
}

@end
