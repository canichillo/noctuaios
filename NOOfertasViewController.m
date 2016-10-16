//
//  NOOfertasViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 22/7/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOOfertasViewController.h"
#import "NOOfertaViewController.h"

@interface NOOfertasViewController ()

@end

@implementation NOOfertasViewController
@synthesize seleccionada;
@synthesize posicionScroll;

- (void)viewDidLoad
{
    // Establecemos el título
    [super viewDidLoad];
    
    // Inicializamos algunas variables
    self.ofertas   = nil;
    seleccionada   = 1;
    self.ubicacion = nil;
    
    // Inicializamos el interfaz
    [self initUI];
}

////////////////////////////////////
// Inicializa el interfaz gráfico //
////////////////////////////////////
-(void) initUI
{
    // Obtenemos el valor debil de la misma clase
    __weak NOOfertasViewController * weakSelf = self;
    
    // Establecemos el background
    [SPUtilidades setBackground:@"logobackground.png"
                       Posicion:45
                          Vista:self.view
                          Alpha:1.0f];
    
    // Establecemos el background de la vista
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Creamos la tabla donde aparecerán las ofertas
    self.tabla                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    // Establecemos la fuente de datos
    self.tabla.dataSource      = self;
    self.tabla.delegate        = self;
    // Quitamos los separadores
    self.tabla.separatorColor  = [UIColor clearColor];
    self.tabla.backgroundColor = [UIColor clearColor];
    self.tabla.opaque          = NO;
    self.tabla.allowsSelection = YES;
    self.tabla.bounces         = YES;
    self.tabla.userInteractionEnabled = YES;
    self.tabla.showsVerticalScrollIndicator = NO;
    self.tabla.contentInset = UIEdgeInsetsMake(80, 0, 63, 0);
    // Añadimos la tabla a la vista
    [self.view addSubview:self.tabla];
    
    // Creamos el texto vacío
    self.textovacio = [[SPLabel alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20, self.view.frame.size.height - 80) Text:@"" Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f] TextColor:RGB(97, 168, 221) Padre:self.view];
    self.textovacio.textAlignment = NSTextAlignmentCenter;
    self.textovacio.numberOfLines = 0;
    // No hay ofertas seguidas
    self.textovacio.text = @"No hay ofertas seguidas";
    
    // Crearemos un panel donde meteremos las pestañas
    UIView *panelTabs = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 30)];
    [panelTabs setBackgroundColor:RGB(97, 168, 221)];
    [self.view addSubview:panelTabs];
    
    // Creamos las pestañas (SegmentedController)
    NSArray *itemArray                    = [NSArray arrayWithObjects: @"Todas", @"Favoritas", @"Activas", @"Cercanas", nil];
    UISegmentedControl *segmentedControl  = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame                = CGRectMake(10, 0, self.view.frame.size.width - 20, 25);
    [segmentedControl addTarget:self action:@selector(TabSeleccionada:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor            = [UIColor whiteColor];
    [panelTabs addSubview:segmentedControl];
    
    // Configuramos las fuentes para las pestañas
    UIFont *normal           = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:normal forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    UIFont *bold             = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    attributes               = [NSDictionary dictionaryWithObject:bold forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    // Bloque que gestiona el refresco de los datos con push
    [self.tabla addPullToRefreshWithActionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // Recargamos los datos
            [weakSelf CargarDatos];
            [weakSelf.tabla.pullToRefreshView stopAnimating];
        });
    }];
    
    // Configuramos el "Pull To Refresh"
    self.tabla.pullToRefreshView.arrowColor = RGB(63, 157, 217);
    self.tabla.pullToRefreshView.textColor  = RGB(63, 157, 217);
    [self.tabla.pullToRefreshView setTitle:@"Soltar para refrescar" forState:SVPullToRefreshStateTriggered];
    [self.tabla.pullToRefreshView setTitle:@"Cargando" forState:SVPullToRefreshStateLoading];
    [self.tabla.pullToRefreshView setTitle:@"Arrastre para refrescar" forState:SVPullToRefreshStateStopped];
    
    // Creamos la barra de navegación
    [SPUtilidades crearBarraNavegacion:self Titulo:@"Ofertas" MenuIzquierdo:YES MenuDerecho:NO];
    
    // Incluimos un evento que controla cuando se ha cambiado la localización
    [[LocationService sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    [[LocationService sharedInstance] startUpdatingLocation];
    
    // Crea el panel de opciones
    [self opcionesNoctua];
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
        [self CargarDatos];
    }
}

////////////////////////
// Cargamos los datos //
////////////////////////
-(void) CargarDatos
{
    // Si no tenemos datos de la ubicación salimos
    if (self.ubicacion == nil) return;
    
    // Parámetros JSON para la petición
    NSDictionary *params = @{
                             @"latitud"  : [NSNumber numberWithDouble: self.ubicacion.coordinate.latitude],
                             @"longitud" : [NSNumber numberWithDouble: self.ubicacion.coordinate.longitude],
                             @"token"    : [SPUtilidades leerDatosToken],
                             @"ciudad"   : @2
                            };
    
    // Realizamos la petición POST
    [SPUtilidades procesarPeticionPOST: @"ofertas"
                            Parametros: params
                          SuccessBlock: ^(id responseObject)
                                        {
                                            // Comprobamos si se ha producido un error
                                            if ([responseObject isKindOfClass:[NSArray class]])
                                            {
                                                // Creamos el array de datos
                                                self.listaofertas = [Oferta consumirLista:responseObject];
                                                
                                                // Mostramos las deseadas
                                                [self filtrarOfertas];
                                                
                                                // Recargamos los datos
                                                [self.tabla reloadData];
                                            }
                                            else
                                            {
                                                // Se ha obtenido algún error
                                                [SPUtilidades mostrarError:@"Error" Mensaje:[responseObject objectForKey:@"Error"] Handler:^(SIAlertView *alertView) { }];
                                            }
                                        }
                          FailureBlock: ^(NSError *error)
                                        {
                                            // Se ha producido un error
                                            [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener los datos de las consultas" Handler:^(SIAlertView *alertView) { }];
                                        }
     ];
}

///////////////////////////
// Filtramos las ofertas //
///////////////////////////
-(void) filtrarOfertas
{
    // Según el elemento seleccionado
    switch (seleccionada)
    {
        // Si es la primera pestaña (Todas)
        case 1:
             {
                 // No hay ofertas
                 self.textovacio.text = @"No hay ofertas";
                 
                 // Mostramos todas
                 self.ofertas = [self.listaofertas copy];
             } break;
            
        // Si son las seguidas
        case 2:
            {
                // No hay ofertas seguidas
                self.textovacio.text = @"No hay ofertas seguidas";
                
                // Filtramos por la personalizada
                NSPredicate *predicado = [NSPredicate predicateWithFormat:@"favorito==[c] %@ ", @"S"];
                
                // Establecemos el filtrado
                self.ofertas = [self.listaofertas filteredArrayUsingPredicate:predicado];
            } break;
            
        // Si son activas
        case 3:
            {
                // No hay ofertas activas
                self.textovacio.text = @"No hay ofertas activas";
                
                // Añadimos una hora a la hora de inicio
                NSDateComponents *offset = [[NSDateComponents alloc] init];
                [offset setHour:1];
                
                // Filtramos por la personalizada
                NSPredicate *predicado = [NSPredicate predicateWithFormat:@"inicio <= %@ AND fin >= %@", [[NSCalendar currentCalendar] dateByAddingComponents:offset toDate:[NSDate date] options:0], [NSDate date]];
                
                // Establecemos el filtrado
                self.ofertas = [self.listaofertas filteredArrayUsingPredicate:predicado];
            } break;
            
        // Si son las cercanas
        case 4:
            {
                // No hay ofertas
                self.textovacio.text = @"No hay ofertas";
                
                // Mostramos todas
                self.ofertas = [self.listaofertas copy];
                
                // Ordenamos por la distancia
                self.ofertas = [self.ofertas sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                    NSNumber *first  = [(Oferta *) a kilometros];
                    NSNumber *second = [(Oferta *) b kilometros];
                    return [first compare:second];
                }];
            } break;
            
        default:
            break;
    }
    
    // Refrescamos la tabla
    [self.tabla reloadData];
    
    // Mostramos el primer elemento
    [self.tabla scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

////////////////////////////////////////////////////////
// Establece el color del texto de la barra de estado //
////////////////////////////////////////////////////////
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma Delegado de UITableView
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // Si hay datos, quitamos el texto de vacío
    self.textovacio.hidden = [self.ofertas count] != 0;
    
    return [self.ofertas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 157.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NOOfertaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Oferta"];
    
    if (!cell)
    {
        cell = [[NOOfertaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:@"Oferta"];
    }
  
    // Obtenemos la fila de datos a mostrar
    Oferta* datos = [self.ofertas objectAtIndex:indexPath.row];
    
    // Si no tenemos logo de empresa, ponemos una por defecto
    if (datos.logo == nil || [datos.logo isEqual:@""])
    {
        cell.logo.image = [UIImage imageNamed:@"logo.png"];
    }
    else
    {
        // Ahora indicamos que debemos cargar
        [cell.logo sd_setImageWithURL:[SPUtilidades urlImagenes:@"empresas" Imagen:[datos.logo stringByAppendingString:@".jpg"]]
                     placeholderImage:[UIImage imageNamed:@"loading.png"]
                              options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    }
    
    // Cargamos la imagen de la oferta
    [cell.imagen sd_setImageWithURL:[SPUtilidades urlImagenes:@"ofertas" Imagen:[datos.imagen stringByAppendingString:@".jpg"]]
                   placeholderImage:[UIImage imageNamed:@"loading.png"]
                            options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    // Nos permitirá trocear la fecha
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:datos.inicio];
    
    // Establecemos el día de la oferta
    cell.dia.text = [NSString stringWithFormat:@"%02ld", (long)[components day]];
    
    // Establecemos el nombre del mes
    cell.mes.text = [SPUtilidades nombreMes:(int) [components month] - 1];
    
    // Establecemos la hora
    cell.hora.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)[components hour], (long)[components minute]];
    
    // Nombre de la oferta
    cell.nombre.text = datos.nombre;
    
    // Si no es favorito   
    if ([datos.favorito isEqual:@"S"])
        cell.favorito.hidden = NO;
    else cell.favorito.hidden = YES;
    
    // Kilómetros a la empresa
    if ([datos.kilometros floatValue] < 1.0f) cell.kilometros.text = [[NSString stringWithFormat:@"%.02f", [datos.kilometros floatValue] * 100.0f] stringByAppendingString:@" mts."];
    else cell.kilometros.text = [[NSString stringWithFormat:@"%.02f", [datos.kilometros floatValue]] stringByAppendingString:@" kms."];
    
    // Empresa de la oferta
    cell.empresa.text = datos.empresa;
    
    // Desactivamos la selección
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
     
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Oferta* datos = [self.ofertas objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[NOOfertaViewController alloc] initWithOferta:[datos.codigo intValue] Llevas:YES] animated:YES];
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
    [self crearBoton: @"Ofertas" Posicion:CGPointMake(10, 4) Color:RGB(114, 205, 148) Imagen:@"tickets.png" Scroll:scroll Evento:nil];
    [self crearBoton: @"Noctuas" Posicion:CGPointMake(60, 4) Color:RGB(239, 176, 76) Imagen:@"miscupones.png" Scroll:scroll Evento:@selector(mostrarCupones)];
    [self crearBoton: @"Mapa" Posicion:CGPointMake(110, 4) Color:RGB(155, 157, 255) Imagen:@"mimapa.png" Scroll:scroll Evento:@selector(mostrarMapa)];
    
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

/////////////////////
// Muestra el mapa //
/////////////////////
-(void) mostrarMapa
{
    [SPUtilidades cargarRootUIViewController:[[NOMapaViewController alloc] initWithAtras:NO]];
}

/////////////////////////
// Muestra los cupones //
/////////////////////////
-(void) mostrarCupones
{
    [SPUtilidades cargarRootUIViewController:[[NOCuponesViewController alloc] initWithAtras:YES Internet:YES]];
}

#pragma Eventos
-(void) TabSeleccionada:(UISegmentedControl *)segment
{
    // Cambiamos el elemento seleccionado
    seleccionada =  (int) segment.selectedSegmentIndex + 1;
    
    // Filtramos de nuevo las ofertas
    [self filtrarOfertas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
