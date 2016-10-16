//
//  NOPruebaViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 2/11/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//
#import "NOPerfilViewController.h"

@interface NOPerfilViewController ()
@property (nonatomic, strong) M13ProgressHUD * progreso;
@end

@implementation NOPerfilViewController
@synthesize sGenero;
@synthesize token;

- (void)viewDidLoad
{
    [super viewDidLoad:@""];
    
    // Leemos el token
    token = [SPUtilidades leerDatosToken];
    
    // Inicializamos las variables
    sGenero = @"H";
    
    // Inicializamos el interfaz gráfico
    [self initUI];
    
    // Cargamos los datos
    [self cargarDatos];
    
    // Configuramos la ventana de progreso
    self.progreso                  = [[M13ProgressHUD alloc] initWithProgressView:[[M13ProgressViewRing alloc] init]];
    self.progreso.indeterminate    = YES;
    self.progreso.progressViewSize = CGSizeMake(60.0, 60.0);
    self.progreso.animationPoint   = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    UIWindow *window = ((NOAppDelegate *)[UIApplication sharedApplication].delegate).window;
    [window addSubview:self.progreso];
}

////////////////////////////////////
// Inicializa el interfaz gráfico //
////////////////////////////////////
-(void) initUI
{
    // Configuramos el tamaño del scroll
    [super initUI:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
      ContentSize:CGSizeMake(self.view.frame.size.width, 610)
         Posicion:0
       Background:@"logobackground.png"];
    
    // Creamos la foto
    self.foto = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 130) / 2, 68, 130, 130)];
    // Añadimos la foto al scroll
    [self.scroll addSubview:self.foto];
    // Establecemos el evento de pulsación de la foto
    [self.foto addTarget:self
                  action:@selector(mostrarActionSheetFoto:)
        forControlEvents:UIControlEventTouchDown];
    
    // Creamos el nombre del usuario
    self.nombreusuario = [[SPTextField alloc] initWithFrame:CGRectMake(20, 210, self.view.frame.size.width - 40, 40)
                                                  TextColor:[UIColor whiteColor]
                                           DefaultTextColor:RGB(193, 193, 193)
                                                       Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:19]
                                                      Texto:@""
                                                DefaultText:@"Nombre"
                                                      Padre:self.scroll];
    // Configuramos el color del campo de texto y los bordes
    [self.nombreusuario setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.55f]];
    [self.nombreusuario.layer setCornerRadius:3.0f];
    // Establecemos el padding
    self.nombreusuario.padding = CGRectMake(10, 5, 20, 10);
    // Añadimos el delegado al campo de texto
    self.nombreusuario.delegate = self;
    self.nombreusuario.enabled = NO;
    
    // Creamos el email del usuario
    self.email = [[SPTextField alloc] initWithFrame:CGRectMake(20, 255, self.view.frame.size.width - 40, 40)
                                          TextColor:[UIColor whiteColor]
                                   DefaultTextColor:RGB(193, 193, 193)
                                               Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:19]
                                              Texto:@""
                                        DefaultText:@"Email"
                                              Padre:self.scroll];
    // Configuramos el color del campo de texto y los bordes
    [self.email setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.55f]];
    [self.email.layer setCornerRadius:3.0f];
    // Establecemos el padding
    self.email.padding = CGRectMake(10, 5, 20, 10);
    // Añadimos el delegado al campo de texto
    self.email.delegate = self;
    self.email.enabled = NO;
    
    
    // Creamos el usuario
    self.usuario = [[SPTextField alloc] initWithFrame:CGRectMake(20, 300, self.view.frame.size.width - 40, 40)
                                            TextColor:[UIColor whiteColor]
                                     DefaultTextColor:RGB(193, 193, 193)
                                                 Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:19]
                                                Texto:@""
                                          DefaultText:@"Usuario"
                                                Padre:self.scroll];
    // Configuramos el color del campo de texto y los bordes
    [self.usuario setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.55f]];
    [self.usuario.layer setCornerRadius:3.0f];
    // Establecemos el padding
    self.usuario.padding = CGRectMake(10, 5, 20, 10);
    // Añadimos el delegado al campo de texto
    self.usuario.delegate = self;
    
    
    // Creamos el password
    self.password = [[SPTextField alloc] initWithFrame:CGRectMake(20, 345, self.view.frame.size.width - 40, 40)
                                             TextColor:[UIColor whiteColor]
                                      DefaultTextColor:RGB(193, 193, 193)
                                                  Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:19]
                                                 Texto:@""
                                           DefaultText:@"Contraseña"
                                                 Padre:self.scroll];
    // Configuramos el color del campo de texto y los bordes
    [self.password setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.55f]];
    [self.password.layer setCornerRadius:3.0f];
    // Establecemos el padding
    self.password.padding = CGRectMake(10, 5, 20, 10);
    // Añadimos el delegado al campo de texto
    self.password.delegate = self;
    // Indicamos que es de tipo contraseña
    self.password.secureTextEntry = YES;
    
    
    // Creamos la repetición del password
    self.repeatpassword = [[SPTextField alloc] initWithFrame:CGRectMake(20, 390, self.view.frame.size.width - 40, 40)
                                                   TextColor:[UIColor whiteColor]
                                            DefaultTextColor:RGB(193, 193, 193)
                                                        Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:19]
                                                       Texto:@""
                                                 DefaultText:@"Repetir contraseña"
                                                       Padre:self.scroll];
    // Configuramos el color del campo de texto y los bordes
    [self.repeatpassword setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.55f]];
    [self.repeatpassword.layer setCornerRadius:3.0f];
    // Establecemos el padding
    self.repeatpassword.padding = CGRectMake(10, 5, 20, 10);
    // Añadimos el delegado al campo de texto
    self.repeatpassword.delegate = self;
    // Indicamos que es de tipo contraseña
    self.repeatpassword.secureTextEntry = YES;
    
    
    // Creamos el botón del tipo de genero
    self.genero = [SPUtilidades buttonWithButton: CGRectMake(20, 435, self.view.frame.size.width - 40, 40)
                                          Titulo: @"Hombre"
                                            Font: [UIFont fontWithName:@"HelveticaNeue-Medium"
                                                                  size:18.0f]
                                          Imagen: @"man.png"
                                      SizeImagen: CGSizeMake(32, 32)
                                 TitleEdgeInsets: UIEdgeInsetsMake(10, 20, 10, 0)
                                 ImageEdgeInsets: UIEdgeInsetsMake(0, -(self.view.frame.size.width - 40) / 2 - 32, 0, 0)];
    // Establecemos el color del botón
    [self.genero setBackgroundColor:[RGB(38, 194, 231) colorWithAlphaComponent:0.75f]];
    [self.genero.layer setCornerRadius:3.0f];
    self.genero.layer.borderWidth = 1.0f;
    self.genero.layer.borderColor = [[UIColor whiteColor] CGColor];
    // Establecemos el evento para el botón del genero
    [self.genero addTarget:self action:@selector(generoUsuario:) forControlEvents:UIControlEventTouchUpInside];
    // Añadimos el elemento a la ventana
    [self.scroll addSubview:self.genero];
    
    
    // Creamos un botón para la fecha de nacimiento
    self.edad = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"18-25", @"26-33", @"34-40", @">40", nil]];
    self.edad.frame = CGRectMake(20, 480, self.view.frame.size.width - 40, 40);
    self.edad.backgroundTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    self.edad.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    self.edad.textShadowColor = [UIColor clearColor];
    self.edad.thumb.tintColor = RGB(97, 168, 221);
    self.edad.thumb.textShadowColor = [UIColor clearColor];
    // Añadimos el botón al scroll
    [self.scroll addSubview:self.edad];
    
    // Creamos un botón para aceptar
    SPButton* aceptar = [[SPButton alloc] initWithFrame:CGRectMake(20, 550, self.view.frame.size.width - 40, 40)];
    // Título del botón
    [aceptar setTitle:@"Guardar"
             forState:UIControlStateNormal];
    // Background del botón
    [aceptar setBackgroundColor:RGB(69, 175, 217)];
    [aceptar.layer setCornerRadius:3.0f];
    [aceptar setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
    // Fuente del botón
    aceptar.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium"
                                              size:19.0f];
    // Añadimos el evento de aceptar
    [aceptar addTarget:self action:@selector(aceptarRegistro:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:aceptar];
    
    // Creamos la barra de navegación
    [SPUtilidades crearBarraNavegacion:self Titulo:@"Perfíl" MenuIzquierdo:YES MenuDerecho:NO SelectorIzquierdo:nil];
}

////////////////////////////////////
// Cargamos los datos del usuario //
////////////////////////////////////
-(void) cargarDatos
{
    // Datos para la creación del usuario
    NSDictionary *params = @{
                             @"token" : token,
                             };
    
    // Realizamos la petición para registrar el usuario
    [SPUtilidades procesarPeticionPOST:@"datosusuario"
                            Parametros:params
                          SuccessBlock:^(id responseObject)
     {
         // Comprobamos la respuesta
         if (![responseObject objectForKey:@"Error"])
         {
             self.nombreusuario.text = [responseObject objectForKey:@"nombre"];
             self.usuario.text       = [responseObject objectForKey:@"usuario"];
             self.email.text         = [responseObject objectForKey:@"email"];
             sGenero                 = [responseObject objectForKey:@"genero"];
             [self.edad setSelectedSegmentIndex:[[responseObject objectForKey:@"edad"] intValue] animated:YES];
             
             // Si era un hombre
             if ([sGenero isEqual:@"H"])
             {
                 // Cambiamos el background
                 [self.genero setBackgroundColor:[RGB(38, 194, 231) colorWithAlphaComponent:0.75f]];
                 
                 // Cambiamos el texto
                 [self.genero setTitle:@"Hombre" forState:UIControlStateNormal];
                 
                 // Cambiamos la imagen
                 [SPUtilidades setImagenBoton:self.genero Image:@"man.png" SizeImagen:CGSizeMake(32, 32)];
             }
             // Si era una mujer
             else
             {
                 // Cambiamos el background
                 [self.genero setBackgroundColor:[RGB(245, 158, 219) colorWithAlphaComponent:0.75f]];
                 
                 // Cambiamos el texto
                 [self.genero setTitle:@"Mujer" forState:UIControlStateNormal];
                 
                 // Cambiamos la imagen
                 [SPUtilidades setImagenBoton:self.genero Image:@"woman.png" SizeImagen:CGSizeMake(32, 32)];
             }
         }
     }
                          FailureBlock:^(NSError * error)
     {
         // Mostramos el error
         [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido cargar los datos del usuario" Handler:^(SIAlertView *alertView) {}];
     }];
}


#pragma mark - Eventos
////////////////////////////////////////////////////////////////////
// Evento que muestra el ActionSheet para las acciones de la foto //
////////////////////////////////////////////////////////////////////
-(IBAction) mostrarActionSheetFoto: (UIButton *)sender
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
    
    // Creamos la alerta
    SIAlertView *alertError = [[SIAlertView alloc] initWithTitle:@"Selección de imagen" andMessage:@"Seleccione la fuente de las imágenes"];
    [alertError addButtonWithTitle:@"Avatar"
                              type:SIAlertViewButtonTypeDefault
                           handler:^(SIAlertView *alertView)
     {
         // Cargamos la ventana
         [self.navigationController pushViewController:[[NOPerfilAvatarViewController alloc] init] animated:YES];
     }];
    [alertError addButtonWithTitle:@"Tomar Foto"
                              type:SIAlertViewButtonTypeDefault
                           handler:^(SIAlertView *alertView)
     {
         [self performSelector:@selector(tomarFoto) withObject:nil afterDelay:0.3];
     }];
    [alertError addButtonWithTitle:@"Seleccionar Foto"
                              type:SIAlertViewButtonTypeDefault
                           handler:^(SIAlertView *alertView)
     {
         UIImagePickerController *picker = [[UIImagePickerController alloc] init];
         picker.delegate                 = self;
         picker.allowsEditing            = YES;
         picker.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
         
         [self presentViewController:picker animated:YES completion:NULL];
     }];
    [alertError show];
}

////////////////////////
// Vuelve hacia atrás //
////////////////////////
-(IBAction) volverAtras: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

///////////////////
// Tomar el foto //
///////////////////
-(void) tomarFoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate                 = self;
        picker.allowsEditing            = YES;
        picker.sourceType               = UIImagePickerControllerSourceTypeCamera;
        picker.modalPresentationStyle   = UIModalPresentationCurrentContext;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Leemos la imagen
        UIImage * imagen = [SPUtilidades leerImagen:@"Noctua"
                                            Archivo:@"fotoNoctua.jpg"];
        
        // Refrescamos las imágenes
        [((NOMenuIzquierdaViewController *) [SPUtilidades getResideMenu].leftMenuViewController) refrescarImagen];
        
        // Si no es nula
        if (imagen != nil)
        {
            [self.foto setBackgroundImage:[UIImage imageNamed:@"mascara.png"] forState:UIControlStateNormal];
            
            // Establecemos la imagen
            [self.foto setImage:[SPUtilidades maskImage:imagen withMask:[UIImage imageNamed:@"mascaracompleta.jpg"]] forState:UIControlStateNormal];
        }
        else
        {
            [self.foto setBackgroundImage:[UIImage imageNamed:@"mascara.png"] forState:UIControlStateNormal];
        }
    });
}

//////////////////////////////////////////////////////
// Evento que captura la foto seleccionada o tomada //
//////////////////////////////////////////////////////
- (void) imagePickerController: (UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Obtenemos la imagen capturada
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    // Cerramos la ventana de selección o toma de foto
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    // Guardamos la imagen
    [SPUtilidades guardarImagen:@"Noctua" Archivo:@"fotoNoctua.jpg" Datos:UIImageJPEGRepresentation(chosenImage, 1.0)];
    
    // Refrescamos las imágenes
    [((NOMenuIzquierdaViewController *) [SPUtilidades getResideMenu].leftMenuViewController) refrescarImagen];
    
    // Refrescamos la imagen
    [self.foto setBackgroundImage:[UIImage imageNamed:@"mascara.png"] forState:UIControlStateNormal];
    
    // Establecemos la imagen
    [self.foto setImage:[SPUtilidades maskImage:chosenImage withMask:[UIImage imageNamed:@"mascara.png"]] forState:UIControlStateNormal];
}

////////////////////////////////////////////////
// Cuando cancelamos la petición de selección //
////////////////////////////////////////////////
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

///////////////////////////////////////////////
// Evento que gestiona el genero del usuario //
///////////////////////////////////////////////
- (IBAction) generoUsuario:(id) sender
{
    // Si era un hombre
    if ([sGenero isEqual:@"H"])
    {
        // Cambiamos el background
        [self.genero setBackgroundColor:[RGB(245, 158, 219) colorWithAlphaComponent:0.75f]];
        
        // Cambiamos el texto
        [self.genero setTitle:@"Mujer" forState:UIControlStateNormal];
        
        // Cambiamos la imagen
        [SPUtilidades setImagenBoton:self.genero Image:@"woman.png" SizeImagen:CGSizeMake(32, 32)];
        
        // Cambiamos el valor del género (Mujer)
        sGenero = @"M";
    }
    // Si era una mujer
    else
    {
        // Cambiamos el background
        [self.genero setBackgroundColor:[RGB(38, 194, 231) colorWithAlphaComponent:0.75f]];
        
        // Cambiamos el texto
        [self.genero setTitle:@"Hombre" forState:UIControlStateNormal];
        
        // Cambiamos la imagen
        [SPUtilidades setImagenBoton:self.genero Image:@"man.png" SizeImagen:CGSizeMake(32, 32)];
        
        // Cambiamos el valor del género (Hombre)
        sGenero = @"H";
    }
}

///////////////////////////////////
// Evento que acepta un registro //
///////////////////////////////////
-(void) aceptarRegistro: (id)sender
{
    // Faltan parámetros por rellenar
    if ([SPUtilidades isEmpty:self.usuario.text] || [SPUtilidades isEmpty:self.email.text])
    {
        // Mostramos el mensaje de error
        [SPUtilidades mostrarError:@"Error" Mensaje:@"Faltan parámetros por rellenar" Handler:^(SIAlertView *alertView) { }];
        
        // Salimos de la función
        return;
    }
    
    // Si las contraseñas no son iguales
    if (![SPUtilidades isEmpty:self.password.text] && ![self.password.text isEqual:self.repeatpassword.text])
    {
        // Mostramos el mensaje de error
        [SPUtilidades mostrarError:@"Error" Mensaje:@"Las contraseñas no coinciden" Handler:^(SIAlertView *alertView) { }];
        
        // Salimos de la función
        return;
    }
    
    // Si no hemos establecido la imagen
    if ([self.foto.imageView.image isEqual:nil])
    {
        // Mostramos el mensaje de error
        [SPUtilidades mostrarError:@"Error" Mensaje:@"No has establecido tu foto de perfíl" Handler:^(SIAlertView *alertView) { }];
        
        // Salimos de la función
        return;
    }
    
    // Desactivamos el botón de REGISTRAR
    UIButton* botonRegistrar = (UIButton *) sender;
    [botonRegistrar setEnabled:NO];
    
    // Creamos el progreso
    self.progreso.status = @"Guardando cambios en Noctua";
    
    // Lo añadimos a la vista
    [self.progreso show:YES];
    
    // Datos para la creación del usuario
    NSDictionary *params = @{
                             @"nombre"     : self.nombreusuario.text,
                             @"usuario"    : self.usuario.text,
                             @"password"   : self.password.text,
                             @"email"      : self.email.text,
                             @"genero"     : sGenero,
                             @"edad"       : [NSNumber numberWithUnsignedInt:[self.edad selectedSegmentIndex]],
                             @"token"      : token,
                             };
    
    // Realizamos la petición para registrar el usuario
    [SPUtilidades procesarPeticionPOST:@"editarusuario"
                            Parametros:params
                          SuccessBlock:^(id responseObject)
     {
         // Comprobamos la respuesta
         if ([responseObject objectForKey:@"Mensaje"] != nil)
         {
             // Guardamos los datos del usuario en NSDefaults
             [SPUtilidades guardarDatosUsuario:self.nombreusuario.text
                                         Token:token
                                        Imagen:[SPUtilidades leerDatosImagen]];
             
             // Registramos el APN
             [SPUtilidades registrarAPN];
         }
         else
         {
             // Escondemos el progreso
             [self.progreso hide:YES];
             
             // Mostramos el error
             [SPUtilidades mostrarError:@"Error" Mensaje:[responseObject objectForKey:@"Error"] Handler:^(SIAlertView *alertView) {}];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             // Volvemos a activar el botón
             [botonRegistrar setEnabled:YES];
         });
     }
                          FailureBlock:^(NSError * error)
     {
         // Escondemos el progreso
         [self.progreso hide:YES];
         
         // Mostramos el error
         [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido guardar los datos del usuario" Handler:^(SIAlertView *alertView) {}];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             // Volvemos a activar el botón
             [botonRegistrar setEnabled:YES];
         });
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationController
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}
@end
