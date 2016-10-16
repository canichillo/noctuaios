//
//  NORegistrarViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 26/6/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NORegistrarViewController.h"
#import "SPUtilidades.h"
#import "NSDate+Helper.h"
#import "SPButton.h"
#import "SIAlertView.h"

@interface NORegistrarViewController ()
@property (nonatomic, strong) M13ProgressHUD * progreso;
@end

@implementation NORegistrarViewController
@synthesize sGenero;
@synthesize bTerminos;

- (void)viewDidLoad
{
    [super viewDidLoad:@""];
    
    // Inicializamos las variables
    sGenero = @"H";
    
    // Indicamos que no hemos aceptado los términos
    bTerminos = NO;
    
    // Inicializamos los datos guardados en las preferencias
    [SPUtilidades guardarDatosUsuario:@""
                                Token:@""
                               Imagen:@""];
    
    // Inicializamos el interfaz gráfico
    [self initUI];
    
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
    [super initUI:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50)
      ContentSize:CGSizeMake(self.view.frame.size.width, 675)
         Posicion:0
       Background:@""];
    
    self.view.backgroundColor = RGB(97, 168, 221);
    
    // Creamos el logo con máscara redonda
    UIImageView* back        = [[UIImageView alloc] initWithFrame:CGRectMake(10, 22, 13, 21)];
    back.image               = [UIImage imageNamed:@"back.png"];
    // Añadimos la imagen a la vista
    [self.view addSubview:back];
    // Añadimos el evento
    UIButton* atras = [[UIButton alloc] initWithFrame:CGRectMake(10, 22, 70, 23)];
    [self.view addSubview:atras];
    
    [SPUtilidades setTextoEstatico:CGRectMake(25, 22, 50, 20)
                             Texto:@"Atrás"
                            Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:19.0f]
                         TextColor:[UIColor whiteColor]
                             Padre:self.view
                         Alignment:NSTextAlignmentCenter];
    [atras addTarget:self action:@selector(volverAtras:) forControlEvents:UIControlEventTouchDown];
    
    // Creamos el texto de la ventana
    [SPUtilidades setTextoEstatico:CGRectMake(0, 19, self.view.frame.size.width, 26)
                             Texto:@"Registrar"
                            Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:22.0f]
                         TextColor:[UIColor whiteColor]
                             Padre:self.view
                         Alignment:NSTextAlignmentCenter];
    
    // Creamos la línea de separación
    UIView* linea         = [[UIView alloc] initWithFrame:CGRectMake(30, 50, self.view.frame.size.width - 60, 1)];
    linea.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:linea];
    
    // Creamos el título "Te estamos esperando"
    [SPUtilidades setTextoEstatico:CGRectMake(0, 10, self.view.frame.size.width, 40)
                             Texto:@"Te estamos esperando"
                            Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:24.0f]
                         TextColor:[UIColor whiteColor]
                             Padre:self.scroll
                         Alignment:NSTextAlignmentCenter];
    
    
    // Creamos el título "Por favor, rellena los datos y únete a nosotros"
    [SPUtilidades setTextoEstatico:CGRectMake(0, 30, self.view.frame.size.width, 40)
                             Texto:@"Por favor, rellena los datos y únete a nosotros"
                            Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:12.0f]
                         TextColor:[UIColor whiteColor]
                             Padre:self.scroll
                         Alignment:NSTextAlignmentCenter];
    
    
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
    UIButton* genero = [SPUtilidades buttonWithButton: CGRectMake(20, 435, self.view.frame.size.width - 40, 40)
                                               Titulo: @"Hombre"
                                                 Font: [UIFont fontWithName:@"HelveticaNeue-Medium"
                                                                         size:18.0f]
                                               Imagen: @"man.png"
                                           SizeImagen: CGSizeMake(32, 32)
                                      TitleEdgeInsets: UIEdgeInsetsMake(10, 20, 10, 0)
                                      ImageEdgeInsets: UIEdgeInsetsMake(0, -(self.view.frame.size.width - 40) / 2 - 32, 0, 0)];
    // Establecemos el color del botón
    [genero setBackgroundColor:[RGB(38, 194, 231) colorWithAlphaComponent:0.75f]];
    [genero.layer setCornerRadius:6.0f];
    genero.layer.borderWidth = 1.0f;
    genero.layer.borderColor = [[UIColor whiteColor] CGColor];
    // Establecemos el evento para el botón del genero
    [genero addTarget:self action:@selector(generoUsuario:) forControlEvents:UIControlEventTouchUpInside];
    // Añadimos el elemento a la ventana
    [self.scroll addSubview:genero];
    
    
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
    
    // Creamos el checkbox
    UIButton* aceptarterminos = [SPUtilidades buttonWithButton: CGRectMake(20, 520, self.view.frame.size.width - 40, 30)
                                                        Titulo: @"Acepta los términos de uso"
                                                          Font: [UIFont fontWithName:@"HelveticaNeue-Light"
                                                                                size:15.0f]
                                                        Imagen: @"unchecked.png"
                                                    SizeImagen: CGSizeMake(24, 24)
                                               TitleEdgeInsets: UIEdgeInsetsMake(10, 10, 10, 0)
                                               ImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 0)];
    // Establecemos el evento para el botón del genero
    [aceptarterminos addTarget:self action:@selector(aceptacionTerminos:) forControlEvents:UIControlEventTouchUpInside];
    [aceptarterminos setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // Añadimos el elemento a la ventana
    [self.scroll addSubview:aceptarterminos];
    
    
    // Creamos un botón para aceptar
    SPButton* aceptar = [[SPButton alloc] initWithFrame:CGRectMake(20, 570, self.view.frame.size.width - 40, 40)];
    // Título del botón
    [aceptar setTitle:@"Aceptar"
             forState:UIControlStateNormal];
    // Background del botón
    [aceptar setBackgroundColor:[UIColor whiteColor]];
    [aceptar.layer setCornerRadius:3.0f];
    [aceptar setTitleColor:RGB(69, 175, 217)
                    forState:UIControlStateNormal];
    // Fuente del botón
    aceptar.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium"
                                              size:19.0f];
    // Añadimos el evento de aceptar
    [aceptar addTarget:self action:@selector(aceptarRegistro:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:aceptar];
    
    
    // Creamos un botón para registrar
    SPButton* terminos = [[SPButton alloc] initWithFrame:CGRectMake(60, 620, self.view.frame.size.width - 120, 40)];
    // Título del botón
    [terminos setTitle:@"Términos de Uso"
              forState:UIControlStateNormal];
    // Background del botón
    [terminos.layer setCornerRadius:6.0f];
    // Ancho del borde
    [terminos.layer setBorderWidth:2.0f];
    // Color del borde
    [terminos.layer setBorderColor:[UIColor whiteColor].CGColor];
    // Fuente del botón
    terminos.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium"
                                               size:18.0f];
    // Color del texto
    [terminos setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    [self.scroll addSubview:terminos];
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
                                       [self.navigationController pushViewController:[[NOAvatarViewController alloc] init] animated:YES];
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
            [self.foto setBackgroundImage:[UIImage imageNamed:@"avatar.png"] forState:UIControlStateNormal];
            
            // Establecemos la imagen
            [self.foto setImage:[SPUtilidades maskImage:imagen withMask:[UIImage imageNamed:@"mascaracompleta.jpg"]] forState:UIControlStateNormal];
        }
        else
        {
            [self.foto setBackgroundImage:[UIImage imageNamed:@"avatar.png"] forState:UIControlStateNormal];
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
    // Accedemos al botón
    UIButton* botonGenero = (UIButton *) sender;
    
    // Si era un hombre
    if ([sGenero isEqual:@"H"])
    {
        // Cambiamos el background
        [botonGenero setBackgroundColor:[RGB(245, 158, 219) colorWithAlphaComponent:0.75f]];
        
        // Cambiamos el texto
        [botonGenero setTitle:@"Mujer" forState:UIControlStateNormal];
        
        // Cambiamos la imagen
        [SPUtilidades setImagenBoton:botonGenero Image:@"woman.png" SizeImagen:CGSizeMake(32, 32)];
        
        // Cambiamos el valor del género (Mujer)
        sGenero = @"M";
    }
    // Si era una mujer
    else
    {
        // Cambiamos el background
        [botonGenero setBackgroundColor:[RGB(38, 194, 231) colorWithAlphaComponent:0.75f]];
    
        // Cambiamos el texto
        [botonGenero setTitle:@"Hombre" forState:UIControlStateNormal];
        
        // Cambiamos la imagen
        [SPUtilidades setImagenBoton:botonGenero Image:@"man.png" SizeImagen:CGSizeMake(32, 32)];
        
        // Cambiamos el valor del género (Hombre)
        sGenero = @"H";
    }
}

///////////////////////////////////////////////////////////////////
// Evento que gestiona la aceptación o no de los términos de uso //
///////////////////////////////////////////////////////////////////
- (IBAction) aceptacionTerminos:(id) sender
{
    // Accedemos al botón
    UIButton* botonTerminos = (UIButton *) sender;

    // Si ya estaba aceptado
    if (bTerminos)
    {
        // Cambiamos la imagen
        [SPUtilidades setImagenBoton:botonTerminos Image:@"unchecked.png" SizeImagen:CGSizeMake(24, 24)];
        
        // Indicamos que no hemos aceptado
        bTerminos = NO;
    }
    // Si no estaba aceptado
    else
    {
        // Cambiamos la imagen
        [SPUtilidades setImagenBoton:botonTerminos Image:@"checked.png" SizeImagen:CGSizeMake(24, 24)];
        
        // Indicamos que hemos aceptado
        bTerminos = YES;
    }
}

///////////////////////////////////
// Evento que acepta un registro //
///////////////////////////////////
-(void) aceptarRegistro: (id)sender
{
    // Si no tenemos establecido la aceptación de los términos
    if (!bTerminos)
    {
        // Mostramos el mensaje de error
        [SPUtilidades mostrarError:@"Error" Mensaje:@"Debes aceptar los términos de uso" Handler:^(SIAlertView *alertView) { }];
        
        // Salimos de la función
        return;
    }
    
    // Faltan parámetros por rellenar
    if ([SPUtilidades isEmpty:self.usuario.text] || [SPUtilidades isEmpty:self.password.text] ||
        [SPUtilidades isEmpty:self.repeatpassword.text] || [SPUtilidades isEmpty:self.email.text])
    {
        // Mostramos el mensaje de error
        [SPUtilidades mostrarError:@"Error" Mensaje:@"Faltan parámetros por rellenar" Handler:^(SIAlertView *alertView) { }];
        
        // Salimos de la función
        return;
    }
    
    // Si las contraseñas no son iguales
    if (![self.password.text isEqual:self.repeatpassword.text])
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
    
    // Si no está registrado anteriormente (error en la imagen
    if ([[SPUtilidades leerDatosToken] isEqual:nil] || [[SPUtilidades leerDatosToken] isEqual:@""])
    {
        // Creamos el progreso
        self.progreso.status = @"Registrando en Noctua";
        
        // Lo añadimos a la vista
        [self.progreso show:YES];
        
        // Datos para la creación del usuario
        NSDictionary *params = @{
                                  @"nombre"     : self.nombreusuario.text,
                                  @"usuario"    : self.usuario.text,
                                  @"password"   : self.password.text,
                                  @"email"      : self.email.text,
                                  @"so"         : @"I",
                                  @"genero"     : sGenero,
                                  @"dispositivo": [SPUtilidades plataformaIOS],
                                  @"edad"       : [NSNumber numberWithUnsignedInteger:self.edad.selectedSegmentIndex]
                                };
        
        // Realizamos la petición para registrar el usuario
        [SPUtilidades procesarPeticionPOST:@"nuevousuario"
                                Parametros:params
                              SuccessBlock:^(id responseObject)
                                           {
                                               // Comprobamos la respuesta
                                               if ([responseObject objectForKey:@"Mensaje"] != nil)
                                               {
                                                   // Obtenemos los datos del usuario
                                                   NSDictionary * datosUsuario = [responseObject objectForKey:@"usuario"];
                                                   
                                                   // Guardamos los datos del usuario en NSDefaults
                                                   [SPUtilidades guardarDatosUsuario:[datosUsuario objectForKey:@"nombre"]
                                                                               Token:[datosUsuario objectForKey:@"token"]
                                                                              Imagen:[datosUsuario objectForKey:@"imagen"]];
                                                   
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
    else
    {      
       
    }
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
