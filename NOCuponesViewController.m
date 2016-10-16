//
//  NOCuponesViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 6/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOCuponesViewController.h"

@interface NOCuponesViewController ()

@end

@implementation NOCuponesViewController
@synthesize atras;
@synthesize internet;

// Constructor
-(id) initWithAtras: (BOOL) back
           Internet:(BOOL) inter
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        atras = back;
        internet = inter;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Inicializamos la vista
    [self initUI];
    
    // Cargamos los datos
    [self CargarDatos];
}

////////////////////////////////////
// Inicializa el interfaz gráfico //
////////////////////////////////////
-(void) initUI
{
    // Establecemos el background
    [SPUtilidades setBackground:@"logobackground.png"
                       Posicion:45
                          Vista:self.view
                          Alpha:1.0f];
    
    // Establecemos el background de la vista
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Creamos la tabla donde aparecerán las ofertas
    self.tabla                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStylePlain];
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
    self.tabla.contentInset = UIEdgeInsetsMake(0, 0, 63, 0);
    // Añadimos la tabla a la vista
    [self.view addSubview:self.tabla];
    
    // Si no tenemos internet
    if (!internet)
    {
        [SPUtilidades crearBarraNavegacion:self Titulo:@"Mis Noctuas" MenuIzquierdo:NO MenuDerecho:NO SelectorIzquierdo:nil];
    }
    else
    {
        // Configuramos la barra de navegación según la opción seleccionada
        if (atras)
            // Creamos la barra de navegación
            [SPUtilidades crearBarraNavegacion:self Titulo:@"Mis Noctuas" MenuIzquierdo:NO MenuDerecho:NO SelectorIzquierdo:@selector(volverAtras:)];
        else [SPUtilidades crearBarraNavegacion:self Titulo:@"Mis Noctuas" MenuIzquierdo:YES MenuDerecho:NO SelectorIzquierdo:nil];
    }
    
    // Si hay internet
    if (internet)
        // Crea el panel de opciones
        [self opcionesNoctua];
    
    // Eliminamos los cupones antiguos
    [CoreDataHelper eliminarCupones];
}

////////////////////////
// Vuelve hacia atrás //
////////////////////////
-(void) volverAtras: (id) sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
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
    [self crearBoton: @"Noctuas" Posicion:CGPointMake(60, 4) Color:RGB(239, 176, 76) Imagen:@"miscupones.png" Scroll:scroll Evento:nil];
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
// Muestra las ofertas //
/////////////////////////
-(void) mostrarOfertas
{
    [SPUtilidades cargarRootUIViewController: [[NOOfertasViewController alloc] init]];
}

////////////////////////
// Cargamos los datos //
////////////////////////
-(void) CargarDatos
{
    // Si estamos conectados a internet
    if ([SPUtilidades conectadoInternet])
    {
        // Parámetros JSON para la petición
        NSDictionary *params = @{
                                 @"token" : [SPUtilidades leerDatosToken],
                                };
    
        // Realizamos la petición POST
        [SPUtilidades procesarPeticionPOST: @"cupones"
                                Parametros: params
                              SuccessBlock: ^(id responseObject)
         {
             // Comprobamos si se ha producido un error
             if ([responseObject isKindOfClass:[NSArray class]])
             {
                 // Para cada una de los cupones solicitados
                 for (NSDictionary *JSONData in responseObject)
                 {
                     // Comprobamos si existe el cupón en la base de datos
                     if (![CoreDataHelper existeCuponBD:[JSONData objectForKey:@"id"] Tipo:@"N"])
                     {
                         // Si el logo está vacío
                         if ([JSONData objectForKey:@"logo"] == [NSNull null])
                         {
                             // Creamos el cupón
                             [CoreDataHelper crearCupon:[[Cupon alloc] initWithCodigo:[JSONData objectForKey:@"id"]
                                                                               Nombre:[JSONData objectForKey:@"nombre"]
                                                                              Empresa:[JSONData objectForKey:@"empresa"]
                                                                            IDEmpresa:[JSONData objectForKey:@"idempresa"]
                                                                                 Logo:@""
                                                                               Inicio:[NSDate dateFromString:[JSONData objectForKey:@"inicio"] withFormat:@"yyyy-MM-dd'T'HH:mm:ss"]
                                                                                  Fin:[NSDate dateFromString:[JSONData objectForKey:@"fin"] withFormat:@"yyyy-MM-dd'T'HH:mm:ss"]
                                                                               Usados:[NSNumber numberWithInt:0]
                                                                          Disponibles:[JSONData objectForKey:@"disponibles"]
                                                                            Consumido:@""
                                                                                 Tipo:@"N"]];
                         }
                         else
                         {
                             [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[SPUtilidades urlImagenes:@"empresas" Imagen:[[JSONData objectForKey:@"logo"] stringByAppendingString:@".jpg"]]
                                                                                 options:0
                                                                                progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                                                                          {
                                                                                          }
                                                                               completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                                                                                          {
                                                                                              if (image && finished)
                                                                                              {
                                                                                                  // Guardamos la imagen
                                                                                                  [SPUtilidades guardarImagen:@"Noctua/cupones" Archivo:[[JSONData objectForKey:@"logo"] stringByAppendingString:@".jpg"] Datos:data];
                                                                                                  
                                                                                                  // Creamos el cupón
                                                                                              [CoreDataHelper crearCupon:[[Cupon alloc] initWithCodigo:[JSONData objectForKey:@"id"]
                                                                                                                                                Nombre:[JSONData objectForKey:@"nombre"]
                                                                                                                                               Empresa:[JSONData objectForKey:@"empresa"]
                                                                                                                                             IDEmpresa:[JSONData objectForKey:@"idempresa"]
                                                                                                                                                  Logo:[JSONData objectForKey:@"logo"]
                                                                                                                                                Inicio:[NSDate dateFromString:[JSONData objectForKey:@"inicio"] withFormat:@"yyyy-MM-dd'T'HH:mm:ss"]
                                                                                                                                                   Fin:[NSDate dateFromString:[JSONData objectForKey:@"fin"] withFormat:@"yyyy-MM-dd'T'HH:mm:ss"]
                                                                                                                                                Usados:[NSNumber numberWithInt:0]
                                                                                                                                           Disponibles:[JSONData objectForKey:@"disponibles"]
                                                                                                                                             Consumido:@"" Tipo:@"N"
                                                                                                                                              ]];
                                                                                                  
                                                                                                  // Obtenemos la lista de cupones de la base de datos
                                                                                                  self.listacupones = [CoreDataHelper cuponesBD:@"N"];
                                                                                                  
                                                                                                  // Recargamos los datos
                                                                                                  [self.tabla reloadData];
                                                                                              }
                                                                                          }];
                         }
                     }
                 }
                 
                 // Obtenemos la lista de cupones de la base de datos
                 self.listacupones = [CoreDataHelper cuponesBD:@"N"];
                 
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
             [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener los datos de tus cupones" Handler:^(SIAlertView *alertView) { }];
         }
         ];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    // Obtenemos la lista de cupones de la base de datos
    self.listacupones = [CoreDataHelper cuponesBD:@"N"];
    
    // Recargamos los datos
    [self.tabla reloadData];
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
    return [self.listacupones count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NOCuponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cupon"];
    
    if (!cell)
    {
        cell = [[NOCuponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@"Cupon"];
    }
    
    // Obtenemos la fila de datos a mostrar
    Cupon * datos = [self.listacupones objectAtIndex:indexPath.row];
    
    // Si no tenemos logo de empresa, ponemos una por defecto
    if (datos.logo == nil || [datos.logo isEqual:@""])
    {
        cell.logo.image = [UIImage imageNamed:@"logo.png"];
    }
    else
    {
        // Ahora indicamos que debemos cargar
        cell.logo.image = [SPUtilidades leerImagen:@"Noctua/cupones" Archivo:[datos.logo stringByAppendingString:@".jpg"]];
    }
    
    // Nos permitirá trocear la fecha
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:datos.inicio];
    
    // Establecemos el día de la oferta
    cell.dia.text = [NSString stringWithFormat:@"%02d", (int) [components day]];
    
    // Establecemos el nombre del mes
    cell.mes.text = [SPUtilidades nombreMes:(int) [components month] - 1];
    
    // Establecemos la hora
    cell.hora.text = [NSString stringWithFormat:@"%02d:%02d", (int) [components hour], (int) [components minute]];
    
    // Nombre de la oferta
    cell.nombre.text = datos.nombre;
    
    // Empresa de la oferta
    cell.empresa.text = datos.empresa;
    
    // Ajustamos el tamaño del texto
    int alto = [SPUtilidades TamanyoTexto:cell.nombre.text Tamanyo:cell.nombre.frame.size Fuente:cell.nombre.font] + 5;
    [cell.nombre CambiarAlto: alto < 50 ? alto : alto - 18];
    
    // Establecemos la posición de la empresa
    [cell.empresa CambiarPosicionY:cell.nombre.frame.size.height - 3];
    
    // Comprobamos si ha sido consumido por completo
    cell.gastada.hidden = ![datos.disponibles isEqual:datos.usados];
    
    UIView *crossView = [self viewWithImageName:@"eliminar.png"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    // Establecemos los eventos del "Swipe"
    [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        _cellToDelete = cell;
        
        // Mostramos la confirmación
        [self mostrarConfirmacionEliminacion];
    }];
    
    // Desactivamos la selección
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cupon * datos = [self.listacupones objectAtIndex:indexPath.row];
    
    // Sólo podemos acceder si queda algún cupón disponible
    if (![datos.disponibles isEqual:datos.usados])
        [self.navigationController pushViewController:[[NODesactivacionOfertaViewController alloc] initWithOferta:[datos.codigo intValue]] animated:YES];
}

////////////////////////////////
// Mostramos una confirmación //
////////////////////////////////
-(void) mostrarConfirmacionEliminacion
{
    // Indice del registro a borrar
    int indice = (int) [self.tabla indexPathForCell:_cellToDelete].row;
    
    // Datos del cupón seleccionado
    Cupon * datoscupon = (Cupon *) [self.listacupones objectAtIndex:indice];
    
    // Mensaje a mostrar
    NSString * mensaje = @"¿Desea eliminar este noctúa?";
    
    // Si no está consumido
    if (![datoscupon.disponibles isEqual:datoscupon.usados])
        mensaje = @"No has gastado tu noctúa. ¿Deseas eliminar el noctúa?";
    
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
         // Eliminamos el registro
         [self.listacupones removeObjectAtIndex:indice];
         
         // Eliminamos ese chat de la tabla
         [self.tabla deleteRowsAtIndexPaths:@[[self.tabla indexPathForCell:_cellToDelete]] withRowAnimation:UITableViewRowAnimationFade];
         
         // Eliminamos el registro de la base de datos local
         [CoreDataHelper eliminarCupon:datoscupon.codigo Tipo:@"N"];
         
         // No hay ningún elemento seleccionado
         _cellToDelete = nil;
     }];
    
    [alertError addButtonWithTitle:@"No"
                              type:SIAlertViewButtonTypeDestructive
                           handler:^(SIAlertView *alertView)
     {
         [_cellToDelete swipeToOriginWithCompletion:^{
         }];
         _cellToDelete = nil;
     }];
    
    [alertError show];
}

- (UIView *)viewWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[SPUtilidades imageWithImage:image scaledToSize:CGSizeMake(40, 40)]];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

#pragma mark - MCSwipeTableViewCellDelegate
// When the user starts swiping the cell this method is called
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell {
}

// When the user ends swiping the cell this method is called
- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell {
}

// When the user is dragging, this method is called and return the dragged percentage from the border
- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipeWithPercentage:(CGFloat)percentage {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
