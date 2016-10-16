//
//  NOSeguidoresViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 3/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOSeguidoresViewController.h"

@interface NOSeguidoresViewController ()
@property (nonatomic, strong) M13ProgressHUD * progreso;
@end

@implementation NOSeguidoresViewController
// Constructor por defecto
-(id) initWithEmpresa: (int) empresa
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.empresa = empresa;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Inicializa el interfaz gráfico
    [self initUI];
    
    // Configuramos la ventana de progreso
    self.progreso                  = [[M13ProgressHUD alloc] initWithProgressView:[[M13ProgressViewRing alloc] init]];
    self.progreso.indeterminate    = YES;
    self.progreso.progressViewSize = CGSizeMake(60.0, 60.0);
    self.progreso.animationPoint   = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    UIWindow *window = ((NOAppDelegate *)[UIApplication sharedApplication].delegate).window;
    [window addSubview:self.progreso];
    
    // Cargamos los datos
    [self cargarDatos];
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
    [SPUtilidades crearBarraNavegacion:self Titulo:@"Seguidores" MenuIzquierdo:NO MenuDerecho:NO SelectorIzquierdo:@selector(volverAtras:)];
}

////////////////////////
// Vuelve hacia atrás //
////////////////////////
-(void) volverAtras: (id) sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

/////////////////////
// Carga los datos //
/////////////////////
-(void) cargarDatos
{
    // Parámetros JSON para la petición
    NSDictionary *params = @{
                             @"empresa"  : [NSNumber numberWithDouble: self.empresa],
                             @"ciudad"   : @2,
                             @"token"    : [SPUtilidades leerDatosToken]
                             };
    
    // Realizamos la petición POST
    [SPUtilidades procesarPeticionPOST: @"seguidoresempresa"
                            Parametros: params
                          SuccessBlock: ^(id responseObject)
     {
         // Comprobamos si se ha producido un error
         if ([responseObject isKindOfClass:[NSArray class]])
         {
             // Creamos el array de datos
             self.seguidores = [Seguidor consumirLista:responseObject];
             
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
         [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener los datos de los seguidores" Handler:^(SIAlertView *alertView) { }];
     }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Delegado de UITableView
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.seguidores count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NOSeguidorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Seguidor"];
    
    if (!cell)
    {
        cell = [[NOSeguidorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"Seguidor"];
    }
    
    // Obtenemos la fila de datos a mostrar
    Seguidor * datos = [self.seguidores objectAtIndex:indexPath.row];
    
    // Ahora indicamos que debemos cargar
    [cell.imagen sd_setImageWithURL:[SPUtilidades urlImagenes:@"usuarios" Imagen:[datos.imagen stringByAppendingString:@".jpg"]]
                   placeholderImage:[UIImage imageNamed:@"loading.png"]
                            options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    // Nombre del usuario
    cell.nombre.text = datos.nombre;
    
    // Dispositivo del usuario
    cell.dispositivo.text = datos.dispositivo;
    
    // Establecemos el estado
    if ([datos.amigo isEqual:@"A"])
        cell.amigo.text = @"Amigo";
    if ([datos.amigo isEqual:@"E"])
        cell.amigo.text = @"Pendiente de aceptación amistad";
    if ([datos.amigo isEqual:@"T"])
        cell.amigo.text = @"Debes aceptar amistad";
    if ([datos.amigo isEqual:@""])
        cell.amigo.text = @"No es amigo";
    
    // Según sea el sistema operativo
    if ([datos.so isEqual:@"A"])
        cell.so.image = [UIImage imageNamed:@"android.png"];
    else cell.so.image = [UIImage imageNamed:@"macos.png"];
    
    // Desactivamos la selección
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Seguidor * seguidor = ((Seguidor *) [self.seguidores objectAtIndex:indexPath.row]);
    
    // Obtenemos el código del seguidor
    self.codigoseguidor = seguidor.codigo;
    
    // Array de botones
    NSArray * botones = nil;
    
    // Si no es amigo
    if ([seguidor.amigo isEqual:@""])
        botones = @[@"Solicitar Amistad"];
    else
    {
        if ([seguidor.amigo isEqual:@"A"]) botones = @[@"Chatear", @"Ver sus ofertas"];
        if ([seguidor.amigo isEqual:@"E"]) botones = @[@"Chatear", @"Eliminar solicitud"];
        if ([seguidor.amigo isEqual:@"T"]) botones = @[@"Chatear"];
    }
    
    // Mostramos las opciones
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:@"Opciones" message:nil buttonTitles:botones buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancelar"] buttonStyle:JGActionSheetButtonStyleCancel];
    
    NSArray *sections = @[section1, cancelSection];
    [cancelSection setButtonStyle:JGActionSheetButtonStyleRed forButtonAtIndex:0];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
    
    [sheet setOutsidePressBlock:^(JGActionSheet *sheet){ [sheet dismissAnimated:YES]; }];
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indice) {
        // Si estamos en la primera sección
        if (indice.section == 0)
        {
            // Obtenemos el nombre del botón seleccionado
            NSString * boton = [botones objectAtIndex:indice.row];
            
            // Si es Chatear
            if ([boton isEqual:@"Chatear"])
                [self ChatSeguidor:self.codigoseguidor];
            
            // Si es "Aceptar Amistad"
            if ([boton isEqual:@"Solicitar Amistad"])
                [self SolicitudAmistad:indice.row Codigo:self.codigoseguidor];
            
            // Si es "Eliminar Amistad"
            if ([boton isEqual:@"Eliminar solicitud"])
                [self EliminarSolicitud:indice.row Codigo:seguidor.idamigo];
            
            // Si es "Ver sus ofertas"
            if ([boton isEqual:@"Ver sus ofertas"])
                [self VerOfertas:self.codigoseguidor];
        }
        
        [sheet dismissAnimated:YES];
    }];
    
    if (![seguidor.amigo isEqual:@"T"]) [sheet showInView:self.view animated:YES];
}

////////////////////////
// Crea un nuevo chat //
////////////////////////
-(void) ChatSeguidor: (id) sender
{
    // Indice
    int indice = (int) ((UIButton *) sender).tag;
    Seguidor * seguidor = (Seguidor *) [self.seguidores objectAtIndex:indice];
    
    [self.navigationController pushViewController:[[NOChatViewController alloc] initWithCodigo:seguidor.codigo Entrada:NO] animated:YES];
}


/////////////////////////////////////
// Realiza la solicitud de amistad //
/////////////////////////////////////
-(void) SolicitudAmistad: (int) indice
                  Codigo: (NSNumber *) codigo
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
    [[SIAlertView appearance] setDestructiveButtonColor:[UIColor whiteColor]];
    
    // Establecemos el color del botón por defecto
    [[SIAlertView appearance] setDefaultButtonImage:[SPUtilidades imageWithColor:RGB(63, 157, 217)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDestructiveButtonImage:[SPUtilidades imageWithColor:RGB(255, 90, 90)] forState:UIControlStateNormal];
    
    // Creamos la alerta
    SIAlertView *alertError = [[SIAlertView alloc] initWithTitle:@"Confirmación" andMessage:@"¿Desea agregar a este seguidor como su amigo?"];
    [alertError addButtonWithTitle:@"Si"
                              type:SIAlertViewButtonTypeDefault
                           handler:^(SIAlertView *alertView)
                                    {
                                        // Parámetros JSON para la petición
                                        NSDictionary *params = @{
                                                                 @"solicitado" : codigo,
                                                                 @"token"      : [SPUtilidades leerDatosToken]
                                                                 };
        
                                        // Realizamos la petición POST
                                        [SPUtilidades procesarPeticionPOST: @"solicitudamistad"
                                                                Parametros: params
                                                              SuccessBlock: ^(id responseObject)
                                                                            {
                                                                                // Comprobamos si se ha producido un error
                                                                                if ([responseObject objectForKey:@"Mensaje"])
                                                                                {
                                                                                    // Obtenemos los datos del seguidor
                                                                                    Seguidor * seguidor = (Seguidor *) [self.seguidores objectAtIndex:indice];
                                                                                    seguidor.amigo      = @"T";
                 
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
                                                                                [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido realizar la solicitud de amistad" Handler:^(SIAlertView *alertView) { }];
                                                                            }
                                         ];
                                    }];
    
    [alertError addButtonWithTitle:@"No"
                              type:SIAlertViewButtonTypeDestructive
                           handler:^(SIAlertView *alertView)
     {
     }];
    
    [alertError show];
}

//////////////////////////////////////
// Eliminar la solicitud de amistad //
///////////////////////////////////////
-(void) EliminarSolicitud: (int) indice
                   Codigo: (NSNumber *) codigo
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
    [[SIAlertView appearance] setDestructiveButtonColor:[UIColor whiteColor]];
    
    // Establecemos el color del botón por defecto
    [[SIAlertView appearance] setDefaultButtonImage:[SPUtilidades imageWithColor:RGB(63, 157, 217)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDestructiveButtonImage:[SPUtilidades imageWithColor:RGB(255, 90, 90)] forState:UIControlStateNormal];
    
    // Creamos la alerta
    SIAlertView *alertError = [[SIAlertView alloc] initWithTitle:@"Confirmación" andMessage:@"¿Desea eliminar esta solicitud de amistad?"];
    [alertError addButtonWithTitle:@"Si"
                              type:SIAlertViewButtonTypeDefault
                           handler:^(SIAlertView *alertView)
     {
         // Parámetros JSON para la petición
         NSDictionary *params = @{
                                  @"amistad" : codigo,
                                  @"token"   : [SPUtilidades leerDatosToken]
                                  };
         
         // Realizamos la petición POST
         [SPUtilidades procesarPeticionPOST: @"eliminarsolicitudamistad"
                                 Parametros: params
                               SuccessBlock: ^(id responseObject)
          {
              // Comprobamos si se ha producido un error
              if ([responseObject objectForKey:@"Mensaje"])
              {
                  // Obtenemos los datos del seguidor
                  Seguidor * seguidor = (Seguidor *) [self.seguidores objectAtIndex:indice];
                  seguidor.amigo      = @"";
                  
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
              [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido realizar la solicitud de amistad" Handler:^(SIAlertView *alertView) { }];
          }
          ];
     }];
    
    [alertError addButtonWithTitle:@"No"
                              type:SIAlertViewButtonTypeDestructive
                           handler:^(SIAlertView *alertView)
     {
     }];
    
    [alertError show];
}


/////////////////////////////////////
// Muestra las ofertas de un amigo //
/////////////////////////////////////
-(void) VerOfertas: (NSNumber *) amigo
{
    // Mostramos las ofertas del amigo
    [self.navigationController pushViewController:[[NOOfertasAmigoViewController alloc] initWithAmigo:[amigo intValue]] animated:YES];
}
@end
