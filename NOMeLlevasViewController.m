//
//  NOMeLlevasViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 10/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOMeLlevasViewController.h"

@interface NOMeLlevasViewController ()

@end

@implementation NOMeLlevasViewController
@synthesize seleccionada;
-(id) initWithDestino:(CLLocationCoordinate2D) destino
              Empresa:(NSString *)empresa
               Oferta:(NSString *)oferta
               Imagen:(NSString *) imagen
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.destino       = destino;
        self.nombreempresa = empresa;
        self.nombreoferta  = oferta;
        self.imagenempresa = imagen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Por defecto, seleccionamos la primera pestaña
    seleccionada = 1;
    
    // Inicializamos las indicaciones
    self.indicaciones = [[NSArray alloc] init];
    
    // Inicializamos la vista
    [self initUI];
}

/////////////////////////
// Inicializa la vista //
/////////////////////////
-(void) initUI
{
    // Establecemos el background de la vista
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Crearemos un panel donde meteremos las pestañas
    self.panelTabs = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 30)];
    [self.panelTabs setBackgroundColor:RGB(97, 168, 221)];
    self.panelTabs.hidden = YES;
    [self.view addSubview:self.panelTabs];
    
    // Creamos las pestañas (SegmentedController)
    NSArray *itemArray                    = [NSArray arrayWithObjects: @"Mapa", @"Indicaciones", nil];
    UISegmentedControl *segmentedControl  = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame                = CGRectMake(10, 0, self.view.frame.size.width - 20, 25);
    [segmentedControl addTarget:self action:@selector(TabSeleccionada:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor            = [UIColor whiteColor];
    [self.panelTabs addSubview:segmentedControl];
    
    // Configuramos las fuentes para las pestañas
    UIFont *normal           = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:normal forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    UIFont *bold             = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    attributes               = [NSDictionary dictionaryWithObject:bold forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    // Colocamos el mapa
    self.mapa          = [[MKMapView alloc] initWithFrame: CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50)];
    self.mapa.delegate = self;
    [self.mapa setMapType:MKMapTypeStandard];
    [self.mapa setZoomEnabled:YES];
    [self.mapa setScrollEnabled:YES];
    [self.view addSubview:self.mapa];
    
    // Creamos la zona donde se mostrará la distancia
    self.distancia = [[SPLabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 40, self.view.frame.size.width - 120, 30)
                                               Text:@""
                                               Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]
                                          TextColor:[UIColor whiteColor]
                                          Alignment:NSTextAlignmentCenter
                                            Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                              Padre:self.view];
    // Establecemos el color de fondo
    self.distancia.backgroundColor = [RGB(97, 168, 221) colorWithAlphaComponent:0.9f];
    // Indicamos el borde
    self.distancia.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.distancia.layer.borderWidth = 1.0f;
    self.distancia.hidden = YES;
    
    // Creamos el botón
    self.coche         = [[UIButton alloc] initWithFrame:CGRectMake(self.distancia.frame.origin.x + self.distancia.frame.size.width + 10, self.distancia.frame.origin.y, 35, 30)];
    self.coche.layer.borderColor  = [[UIColor whiteColor] CGColor];
    self.coche.layer.borderWidth  = 2.0f;
    self.coche.layer.cornerRadius = 3;
    self.coche.backgroundColor    = [RGB(97, 168, 221) colorWithAlphaComponent:1.0f];
    [self.coche setImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"cars.png"] scaledToSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    [self.coche setImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"cars.png"] scaledToSize:CGSizeMake(25, 25)] forState:UIControlStateHighlighted];
    [self.coche addTarget:self action:@selector(rutaCoche) forControlEvents:UIControlEventTouchDown];
    self.coche.hidden = YES;
    [self.view addSubview:self.coche];
    
    // Creamos el botón
    self.andando         = [[UIButton alloc] initWithFrame:CGRectMake(self.distancia.frame.origin.x + self.distancia.frame.size.width + 47, self.distancia.frame.origin.y, 35, 30)];
    self.andando.layer.borderColor  = [[UIColor whiteColor] CGColor];
    self.andando.layer.borderWidth  = 2.0f;
    self.andando.layer.cornerRadius = 3;
    self.andando.backgroundColor    = [RGB(97, 168, 221) colorWithAlphaComponent:0.5f];
    [self.andando setImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"walking.png"] scaledToSize:CGSizeMake(23, 23)] forState:UIControlStateNormal];
    [self.andando setImage:[SPUtilidades imageWithImage:[UIImage imageNamed:@"walking.png"] scaledToSize:CGSizeMake(23, 23)] forState:UIControlStateHighlighted];
    [self.andando addTarget:self action:@selector(rutaPie) forControlEvents:UIControlEventTouchDown];
    self.andando.hidden = YES;
    [self.view addSubview:self.andando];
    
    // Creamos la tabla donde aparecerán las ofertas
    self.tabla                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80) style:UITableViewStylePlain];
    // Establecemos la fuente de datos
    self.tabla.dataSource      = self;
    self.tabla.delegate        = self;
    // Quitamos los separadores
    self.tabla.separatorColor  = [UIColor clearColor];
    self.tabla.backgroundColor = [UIColor clearColor];
    self.tabla.opaque          = NO;
    self.tabla.allowsSelection = YES;
    self.tabla.userInteractionEnabled = YES;
    self.tabla.showsVerticalScrollIndicator = NO;
    self.tabla.hidden = YES;
    // Añadimos la tabla a la vista
    [self.view addSubview:self.tabla];
    
    // Creamos la barra de navegación
    [SPUtilidades crearBarraNavegacion:self Titulo:@"¿Te llevo?" MenuIzquierdo:NO MenuDerecho:NO SelectorIzquierdo:@selector(volverAtras:)];
    
    // Incluimos un evento que controla cuando se ha cambiado la localización
    [[LocationService sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    [[LocationService sharedInstance] startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////////
// Obtiene la pestaña seleccionada //
/////////////////////////////////////
-(void) TabSeleccionada:(UISegmentedControl *)segment
{
    seleccionada = (int) segment.selectedSegmentIndex + 1;
    
    // Refrescamos los datos
    [self refrescarPestanya];
}

///////////////////////////////////////////////////
// Evento que gestiona el cambio de localización //
///////////////////////////////////////////////////
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentLocation"])
    {
        // Obtenemos la ubicación
        self.origen = [[[LocationService sharedInstance] currentLocation] coordinate];
        
        // Paramos la captura de más datos
        [[LocationService sharedInstance] stopUpdatingLocation];
        [[LocationService sharedInstance] removeObserver:self forKeyPath:@"currentLocation"];
        
        // Mostramos la ruta
        [self mostrarRuta];
    }
}

/////////////////////
// Muestra la ruta //
/////////////////////
-(void) mostrarRuta
{
    // Creamos la ruta a mostrar
    self.directionsRequest = [MKDirectionsRequest new];
    
    // Establecemos el inicio
    MKPlacemark * inicio = [[MKPlacemark alloc] initWithCoordinate:self.origen
                                                 addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil]];
    MKMapItem * iteminicio = [[MKMapItem alloc] initWithPlacemark:inicio];
    [self.directionsRequest setSource:iteminicio];
    
    // Establecemos el fin
    MKPlacemark * fin = [[MKPlacemark alloc] initWithCoordinate:self.destino
                                              addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil]];
    MKMapItem * itemfin = [[MKMapItem alloc] initWithPlacemark:fin];
    [self.directionsRequest setDestination:itemfin];
    
    // Creamos la anotación de inicio
    JPSThumbnail *thumbnaili   = [[JPSThumbnail alloc] init];
    thumbnaili.image           = [SPUtilidades leerImagen:@"Noctua" Archivo:@"fotoNoctua.jpg"];
    thumbnaili.title           = [SPUtilidades leerDatosUsuario];
    thumbnaili.subtitle        = @"Tú ubicación";
    thumbnaili.coordinate      = self.origen;
    thumbnaili.disclosureBlock = ^{ };
    
    // Creamos la anotación de fin
    JPSThumbnail *thumbnailf   = [[JPSThumbnail alloc] init];
    thumbnailf.title           = self.nombreoferta;
    thumbnailf.subtitle        = self.nombreempresa;
    thumbnailf.coordinate      = self.destino;
    thumbnailf.disclosureBlock = ^{ };
    
    // Establecemos la imagen de la empresa
    if (self.imagenempresa == nil || [self.imagenempresa isEqual:@""])
        thumbnailf.image = [UIImage imageNamed:@"logo.png"];
    else thumbnailf.image = [SPUtilidades leerImagen:@"Noctua/temp" Archivo:self.imagenempresa];
    
    // Añadimos las anotaciones al mapa
    [self.mapa addAnnotation:[JPSThumbnailAnnotation annotationWithThumbnail:thumbnaili]];
    [self.mapa addAnnotation:[JPSThumbnailAnnotation annotationWithThumbnail:thumbnailf]];
    
    // Mostramos las direcciones de la ruta
    [self dibujarRuta:MKDirectionsTransportTypeAutomobile];
}

///////////////////////////////////
// Dibuja una ruta según el tipo //
///////////////////////////////////
-(void) dibujarRuta: (MKDirectionsTransportType) tipo
{
    // Indicamos que vamos en coche
    [self.directionsRequest setTransportType:tipo];
    
    // Realizamos el proceso de mostrar la ruta
    MKDirections *direction = [[MKDirections alloc]initWithRequest:self.directionsRequest];
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Mostramos las pestañas
            self.panelTabs.hidden = NO;
            
            // Redimensionamos los elementos
            self.mapa.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80);
            
            // Mostramos los iconos
            self.coche.hidden   = NO;
            self.andando.hidden = NO;
            
            // Refrescamos las pestañas
            [self refrescarPestanya];
            
            // Limpiamos el mapa
            for (id<MKOverlay> overlayToRemove in self.mapa.overlays)
            {
                [self.mapa removeOverlay:overlayToRemove];
            }
            
            // Valores por defecto
            MKCoordinateRegion region;
            CLLocationDegrees maxLat = self.destino.latitude;
            CLLocationDegrees maxLon = self.destino.longitude;
            CLLocationDegrees minLat = self.destino.latitude;
            CLLocationDegrees minLon = self.destino.longitude;
            
            // Recalculamos la región a dibujar
            if(self.origen.latitude > maxLat)
                maxLat = self.origen.latitude;
            if(self.origen.latitude < minLat)
                minLat = self.origen.latitude;
            if(self.origen.longitude > maxLon)
                maxLon = self.origen.longitude;
            if(self.origen.longitude < minLon)
                minLon = self.origen.longitude;
            
            NSArray *arrRoutes = [response routes];
            [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
             {
                 MKRoute *rout = obj;
                 
                 MKPolyline *line = [rout polyline];
                 [self.mapa addOverlay:line];
                 
                 // Actualizamos la distancia
                 if (rout.distance >= 1000)
                     self.distancia.text = [NSString stringWithFormat:@"%.02f kms.", rout.distance / 1000];
                 else self.distancia.text = [NSString stringWithFormat:@"%i mts.", (int) rout.distance];
                 
                 self.indicaciones = [rout steps];
                 
                 // Recargamos la tabla
                 [self.tabla reloadData];
             }];
            
            if ([arrRoutes count] == 0)
            {
                // Redimensionamos los elementos
                self.mapa.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50);
                
                self.indicaciones = nil;
                [self.tabla reloadData];
                
                // Ocultamos el panel de pestañas
                self.panelTabs.hidden = YES;
            }
            
            // Posicionamos el centro
            float lonDelta = maxLat - minLat;
            float latDelta = maxLon - minLon;
            float scale = 1;
            
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
    }];
}

////////////////////////
// Vuelve hacia atrás //
////////////////////////
-(void) volverAtras: (id) sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

//////////////////////////////
// Muestra la ruta en coche //
//////////////////////////////
-(void) rutaCoche
{
    // Cambiamos la selección
    self.coche.backgroundColor   = [RGB(97, 168, 221) colorWithAlphaComponent:1.0f];
    self.andando.backgroundColor = [RGB(97, 168, 221) colorWithAlphaComponent:0.5f];
    
    // Dibujamos la ruta
    [self dibujarRuta:MKDirectionsTransportTypeAutomobile];
}

-(void) rutaPie
{
    // Cambiamos la selección
    self.coche.backgroundColor   = [RGB(97, 168, 221) colorWithAlphaComponent:0.5f];
    self.andando.backgroundColor = [RGB(97, 168, 221) colorWithAlphaComponent:1.0f];
    
    // Dibujamos la ruta
    [self dibujarRuta:MKDirectionsTransportTypeWalking];
}

#pragma Delegado de UITableView
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.indicaciones count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NOIndicacionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Indicacion"];
    
    if (!cell)
    {
        cell = [[NOIndicacionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"Indicacion"];
    }
    
    // Establecemos la descripción
    cell.descripcion.text = [[self.indicaciones objectAtIndex:indexPath.row] instructions];
    
    // Obtenemos la distancia a mostrar
    NSString * distancia = @"";
    
    // Si es superior a kilómetros
    if ([[self.indicaciones objectAtIndex:indexPath.row] distance] > 1000)
        distancia = [NSString stringWithFormat:@"Distancia: %.02f kms.", [[self.indicaciones objectAtIndex:indexPath.row] distance] / 1000];
    else distancia = [NSString stringWithFormat:@"Distancia: %i mts.", (int)[[self.indicaciones objectAtIndex:indexPath.row] distance]];
    
    // Establecemos el tamaño del texto de la descripción
    [cell.descripcion CambiarAlto:[SPUtilidades TamanyoTexto:cell.descripcion.text Tamanyo:cell.descripcion.frame.size Fuente:cell.descripcion.font] + 5];
    
    // Cambiamos la posición de la distancia
    [cell.distancia CambiarPosicionY:cell.descripcion.frame.origin.y + cell.descripcion.frame.size.height - 3];
    
    // Establecemos la distancia
    cell.distancia.text = distancia;
    
    return cell;
}

////////////////////////////
// Actualiza las pestañas //
////////////////////////////
-(void) refrescarPestanya
{
    // Ocultamos todo
    self.mapa.hidden      = YES;
    self.distancia.hidden = YES;
    self.tabla.hidden     = YES;
    
    // Según el elemento seleccionado
    switch (seleccionada)
    {
        // Si es la primera pestaña (Mapa)
        case 1:
            {
                // Mostramos el mapa
                self.mapa.hidden = NO;
                
                // Mostramos la distancia
                self.distancia.hidden = NO;
            }; break;
        
        // Si son las indicaciones
        case 2:
            {
                // Mostramos la tabla
                self.tabla.hidden = NO;
            }; break;
    }
}

////////////////////////////////
// Dibuja las líneas del mapa //
////////////////////////////////
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 10;
        return aView;
    }
    return nil;
}

//////////////////////////////////////////////
// Limpia la memoria al salir de la ventana //
//////////////////////////////////////////////
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    switch (self.mapa.mapType)
    {
        case MKMapTypeHybrid:
        {
            self.mapa.mapType = MKMapTypeStandard;
        } break;
        case MKMapTypeStandard:
        {
            self.mapa.mapType = MKMapTypeHybrid;
        }
            
            break;
        default:
            break;
    }
    
    [self.mapa removeAnnotations:self.mapa.annotations];
    [self.mapa.layer removeAllAnimations];
    self.mapa.showsUserLocation = NO;
    self.mapa.delegate = nil;
    [self.mapa removeFromSuperview];
    self.mapa = nil;
}

@end
