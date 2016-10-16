//
//  NOChatsViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 7/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOChatsViewController.h"

@interface NOChatsViewController ()

@end

@implementation NOChatsViewController
- (void)viewDidLoad
{
    // Establecemos el título
    [super viewDidLoad];
    
    // Inicializamos algunas variables
    self.chats = nil;
    
    // Inicializamos el interfaz
    [self initUI];
    
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
    [SPUtilidades crearBarraNavegacion:self Titulo:@"Chats" MenuIzquierdo:YES MenuDerecho:NO];
}

////////////////////////////////
// Carga los datos de un chat //
////////////////////////////////
-(void) cargarChats: (NSString *) remitentes
{
    // Parámetros JSON para la petición
    NSDictionary *params = @{
                             @"token"      : [SPUtilidades leerDatosToken],
                             @"remitentes" : remitentes,
                             };
    
    // Realizamos la petición POST
    [SPUtilidades procesarPeticionPOST: @"datosremitentes"
                            Parametros: params
                          SuccessBlock: ^(id responseObject)
                                        {
                                            // Comprobamos si se ha producido un error
                                            if ([responseObject isKindOfClass:[NSArray class]])
                                            {
                                                // Para cada una de los chat
                                                for (NSDictionary *JSONData in responseObject)
                                                {
                                                    // Insertamos los datos del chat
                                                    [CoreDataHelper crearChat:[[Chat alloc] initWithID:[JSONData objectForKey:@"remitente"]
                                                                                                Nombre:[JSONData objectForKey:@"nombre"]
                                                                                                Imagen:[JSONData objectForKey:@"imagen"]
                                                                                                    SO:[JSONData objectForKey:@"so"]
                                                                                           Dispositivo:[JSONData objectForKey:@"dispositivo"]
                                                                                                 Fecha:[NSDate date]]];
                                                }
                                                
                                                // Leemos los chats de la base de datos
                                                self.chats = [CoreDataHelper chatsBD];
                                                
                                                // Refrescamos los datos
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
                                        }];

}

////////////////////////
// Cargamos los datos //
////////////////////////
-(void) cargarDatos
{
    // Nuestros remitentes a cargar
    __block NSString * remitentes = @"";
    
    // Parámetros JSON para la petición
    NSDictionary *params = @{
                             @"token" : [SPUtilidades leerDatosToken],
                             };
    
    // Realizamos la petición POST
    [SPUtilidades procesarPeticionPOST: @"listachats"
                            Parametros: params
                          SuccessBlock: ^(id responseObject)
     {
         // Comprobamos si se ha producido un error
         if ([responseObject isKindOfClass:[NSArray class]])
         {
             // Para cada una de los chat
             for (NSDictionary *JSONData in responseObject)
             {
                 // Comprobamos si existe ya un chat creado
                 if (![CoreDataHelper existeChatBD:[JSONData objectForKey:@"remitente"]])
                 {
                     remitentes = [NSString stringWithFormat:@"%@%@,", remitentes, [JSONData objectForKey:@"remitente"]];
                 }
             }
             
             // Si hemos leido datos
             if ([responseObject count] != 0 && ![remitentes isEqual:@""])
             {
                 // Guardamos la fecha de actualización
                 [SPUtilidades guardarFechaChats:[NSDate stringFromDate:[NSDate date]]];
                 
                 // Cargamos los chats
                 [self cargarChats:[remitentes substringToIndex:[remitentes length] - 1]];
             }
             
             // Leemos los chats de la base de datos
             self.chats = [CoreDataHelper chatsBD];
             
             // Refrescamos los datos
             [self.tabla reloadData];
         }
         else
         {
             // Leemos los chats de la base de datos
             self.chats = [CoreDataHelper chatsBD];
             
             // Refrescamos los datos
             [self.tabla reloadData];
             
             // Se ha obtenido algún error
             [SPUtilidades mostrarError:@"Error" Mensaje:[responseObject objectForKey:@"Error"] Handler:^(SIAlertView *alertView) { }];
         }
     }
                          FailureBlock: ^(NSError *error)
     {
         // Leemos los chats de la base de datos
         self.chats = [CoreDataHelper chatsBD];
         
         // Refrescamos los datos
         [self.tabla reloadData];
         
         // Se ha producido un error
         [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener los datos de los chats" Handler:^(SIAlertView *alertView) { }];
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
    return [self.chats count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NOChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Chat"];
    
    if (!cell)
    {
        cell = [[NOChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"Chat"];
    }
    
    // Obtenemos la fila de datos a mostrar
    Chat * datos = [self.chats objectAtIndex:indexPath.row];
    
    // Ahora indicamos que debemos cargar
    [cell.imagen sd_setImageWithURL:[SPUtilidades urlImagenes:@"usuarios" Imagen:[datos.IMAGEN stringByAppendingString:@".jpg"]]
                   placeholderImage:[UIImage imageNamed:@"loading.png"]
                            options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    // Nombre del usuario
    cell.nombre.text = datos.NOMBRE;
    
    // Dispositivo del usuario
    cell.dispositivo.text = datos.DISPOSITIVO;
    
    // Según sea el sistema operativo
    if ([datos.SO isEqual:@"A"])
        cell.so.image = [UIImage imageNamed:@"android.png"];
    else cell.so.image = [UIImage imageNamed:@"macos.png"];
    
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

////////////////////////////////
// Mostramos una confirmación //
////////////////////////////////
-(void) mostrarConfirmacionEliminacion
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
    SIAlertView *alertError = [[SIAlertView alloc] initWithTitle:@"Confirmación" andMessage:@"¿Desea eliminar este chat?"];
    [alertError addButtonWithTitle:@"Si"
                              type:SIAlertViewButtonTypeDefault
                           handler:^(SIAlertView *alertView)
     {
         // Indice del registro a borrar
         int indice = (int) [self.tabla indexPathForCell:_cellToDelete].row;
         
         // Eliminamos ese chat del servidor
         Chat * datoschat = (Chat *) [self.chats objectAtIndex:indice];
         
         // Eliminamos el registro
         [self.chats removeObjectAtIndex:indice];
         
         // Eliminamos ese chat de la tabla
         [self.tabla deleteRowsAtIndexPaths:@[[self.tabla indexPathForCell:_cellToDelete]] withRowAnimation:UITableViewRowAnimationFade];
         
         // Eliminamos el registro de la base de datos local
         [CoreDataHelper eliminarChat:datoschat.ID];
         
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Chat * datos = [self.chats objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[NOChatViewController alloc] initWithCodigo:datos.ID Entrada:NO] animated:YES];
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
@end
