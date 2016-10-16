//
//  NOInvitacionesViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 6/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOInvitacionesViewController.h"

@interface NOInvitacionesViewController ()

@end

@implementation NOInvitacionesViewController
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
    
    // Creamos la barra de navegación
    [SPUtilidades crearBarraNavegacion:self Titulo:@"Mis Invitaciones" MenuIzquierdo:YES MenuDerecho:NO];
    
    // Incluimos un evento que controla cuando se ha cambiado la localización
    [[LocationService sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    [[LocationService sharedInstance] startUpdatingLocation];
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
                             @"ciudad"   : @2,
                             };
    
    // Realizamos la petición POST
    [SPUtilidades procesarPeticionPOST: @"invitaciones"
                            Parametros: params
                          SuccessBlock: ^(id responseObject)
     {
         // Comprobamos si se ha producido un error
         if ([responseObject isKindOfClass:[NSArray class]])
         {
             // Creamos el array de datos
             //self.listaofertas = [Cupon consumirLista:responseObject];
             
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
         [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener los datos de tus invitaciones" Handler:^(SIAlertView *alertView) { }];
     }
     ];
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
    return [self.listaofertas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 157.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NOCuponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Invitacion"];
    
    if (!cell)
    {
        cell = [[NOCuponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@"Invitacion"];
    }
    
    // Obtenemos la fila de datos a mostrar
    Cupon * datos = [self.listaofertas objectAtIndex:indexPath.row];
    
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
    
    // Desactivamos la selección
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Oferta* datos = [self.listaofertas objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[NOOfertaViewController alloc] initWithOferta:[datos.codigo intValue] Llevas:YES] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
