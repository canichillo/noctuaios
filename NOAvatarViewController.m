//
//  NOAvatarViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 18/7/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOAvatarViewController.h"

@interface NOAvatarViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray * data;
@property (nonatomic, strong) M13ProgressHUD * progreso;
@end

@implementation NOAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Establecemos el título
    [self setTitle:@"Avatares"];
    
    // Inicializamos el interfaz
    [self initUI];
    
    // Obtenemos las imágenes a cargar
    [self leerAvatares];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////
// Inicializa el interfaz gráfico //
////////////////////////////////////
-(void) initUI
{
    // Establecemos el background
    [SPUtilidades setBackground:@"logobackground.png" Posicion:0 Vista:self.view Alpha:1.0f];
    
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
                            Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:18.0f]
                         TextColor:[UIColor whiteColor]
                             Padre:self.view
                         Alignment:NSTextAlignmentCenter];
    [atras addTarget:self action:@selector(volverAtras:) forControlEvents:UIControlEventTouchDown];
    
    // Creamos el texto de la ventana
    [SPUtilidades setTextoEstatico:CGRectMake(0, 22, self.view.frame.size.width, 20)
                             Texto:@"Avatares"
                            Fuente:[UIFont fontWithName: @"HelveticaNeue-Light" size:22.0f]
                         TextColor:[UIColor whiteColor]
                             Padre:self.view
                         Alignment:NSTextAlignmentCenter];
    
    // Creamos la línea de separación
    UIView* linea         = [[UIView alloc] initWithFrame:CGRectMake(30, 50, self.view.frame.size.width - 60, 1)];
    linea.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:linea];
    
    // Creamos la colección
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset                = UIEdgeInsetsMake(5, 10, 10, 10);
    layout.itemSize                    = CGSizeMake((self.view.frame.size.width - 30.0f) / 3.0f, (self.view.frame.size.width - 30.0f) / 3.0f);
    layout.minimumInteritemSpacing     = 5.0f;
    layout.minimumLineSpacing          = 5.0f;
    self.avatares                      = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 51, self.view.frame.size.width, self.view.frame.size.height - 51) collectionViewLayout:layout];
    [self.avatares setDataSource:self];
    [self.avatares setDelegate:self];
    [self.avatares registerClass:[NOAvatarCollectionViewCell class] forCellWithReuseIdentifier:@"Avatar"];
    [self.avatares setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.avatares];
    
    // Nuestros datos
    self.data = [[NSMutableArray alloc] init];
    
    // Configuramos la ventana de progreso
    self.progreso                  = [[M13ProgressHUD alloc] initWithProgressView:[[M13ProgressViewRing alloc] init]];
    self.progreso.progressViewSize = CGSizeMake(60.0, 60.0);
    self.progreso.indeterminate    = YES;
    self.progreso.primaryColor     = [UIColor whiteColor];
    self.progreso.animationPoint   = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    UIWindow *window = ((NOAppDelegate *)[UIApplication sharedApplication].delegate).window;
    [window addSubview:self.progreso];
}

////////////////////////
// Vuelve hacia atrás //
////////////////////////
-(IBAction) volverAtras: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/////////////////////////////////
// Leemos la lista de avatares //
/////////////////////////////////
-(void) leerAvatares
{
    // Realizamos la petición GET
    [SPUtilidades procesarPeticionGET: @"imagenesavatar"
                         SuccessBlock: ^(id respuesta)
                                       {
                                           NSLog(@"%@", respuesta);
                                           // Procesamos cada uno de los datos
                                           for (NSDictionary *JSONData in respuesta)
                                               [self.data addObject:[SPUtilidades urlImagenes:@"avatares" Imagen:[[JSONData objectForKey:@"id"] stringByAppendingString:@".png"]]];
                                           
                                           // Refrescamos los datos
                                           [self.avatares reloadData];
                                       }
                         FailureBlock: ^(NSError *error)
                                       {
                                           [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener las imágenes de los avatares" Handler:^(SIAlertView *alertView) { }];
                                       }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NOAvatarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Avatar" forIndexPath:indexPath];
    
    // Ahora indicamos que debemos cargar
    [cell.imageView sd_setImageWithURL:[self.data objectAtIndex:indexPath.row]
                      placeholderImage:[UIImage imageNamed:@"loading.png"]
                               options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Mostramos el mensaje de confirmación
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
    SIAlertView *alertError = [[SIAlertView alloc] initWithTitle:@"Confirmación" andMessage:@"¿Desea usar este avatar como su imagen de perfíl?"];
    [alertError addButtonWithTitle:@"Si"
                              type:SIAlertViewButtonTypeDefault
                           handler:^(SIAlertView *alertView)
     {
         // Creamos el progreso
         self.progreso.status = @"Descargando avatar";
         
         // Lo añadimos a la vista
         [self.progreso show:YES];
         
         // Realizamos la petición de guardado de la imagen
         [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[self.data objectAtIndex:indexPath.row]
                                                             options:0
                                                            progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                                                      {
                                                                      }
                                                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                                                                      {
                                                                          // Eliminamos el progreso
                                                                          [self.progreso hide:YES];
                                                                          
                                                                          // Si está finalizado
                                                                          if (image && finished)
                                                                          {
                                                                              // Guardamos la imagen
                                                                              [SPUtilidades guardarImagen:@"Noctua" Archivo:@"fotoNoctua.jpg" Datos:data];
                                                                              
                                                                              // Salimos de la ventana
                                                                              [self.navigationController popViewControllerAnimated:YES];
                                                                          }
                                                                      }
         ];
     }];
    
    [alertError addButtonWithTitle:@"No"
                              type:SIAlertViewButtonTypeDestructive
                           handler:^(SIAlertView *alertView) { }];
    [alertError show];
}
@end
