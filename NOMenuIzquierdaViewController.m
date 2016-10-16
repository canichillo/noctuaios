//
//  NOMenuIzquierdaViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 08/06/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOMenuIzquierdaViewController.h"
#import "NOPerfilViewController.h"

@interface NOMenuIzquierdaViewController ()
@end

@implementation NOMenuIzquierdaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat screenWidth  = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // Inicializamos los elementos del menú
    self.items    = @[@"Ofertas", @"Chat", @"Amigos", @"Mis Invitaciones"];
    self.imagenes = @[@"tickets.png", @"chats.png", @"amigos.png", @"misinvitaciones.png"];
    
    // Creamos el scroll
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth * 0.74f, screenHeight)];
    self.scroll.contentSize = CGSizeMake(screenWidth * 0.74f, 1000);
    self.scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scroll];
    
    // Creamos la foto del perfíl
    self.foto = [[UIImageView alloc] initWithFrame:CGRectMake(((screenWidth * 0.74f) - 100) / 2.0f, 15, 100, 100)];
    UIImage * imagen = [SPUtilidades leerImagen:@"Noctua"
                                        Archivo:@"fotoNoctua.jpg"];
    self.foto.image               = imagen;
    self.foto.layer.cornerRadius  = roundf(self.foto.frame.size.width / 2.0f);
    self.foto.layer.borderWidth   = 2.0f;
    self.foto.layer.borderColor   = [[UIColor whiteColor] CGColor];
    self.foto.layer.masksToBounds = YES;
    UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accederPerfil)];
    [self.foto setUserInteractionEnabled:YES];
    [self.foto addGestureRecognizer:newTap];
    [self.scroll addSubview:self.foto];
    
    // Nombre del usuario
    self.nombre = [[SPLabel alloc] initWithFrame:CGRectMake(10, 117, (screenWidth * 0.74f) - 20, 30)
                                            Text:[SPUtilidades leerDatosUsuario]
                                            Font:[UIFont fontWithName: @"HelveticaNeue-Light" size:18.0f]
                                       TextColor:[UIColor whiteColor]
                                       Alignment:NSTextAlignmentCenter
                                         Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                           Padre:self.scroll];
    self.nombre.numberOfLines = 0;
    self.nombre.lineBreakMode = NSLineBreakByWordWrapping;
    UITapGestureRecognizer *newTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accederPerfil)];
    [self.nombre setUserInteractionEnabled:YES];
    [self.nombre addGestureRecognizer:newTap2];
    [self.nombre CambiarAlto:[SPUtilidades TamanyoTexto:self.nombre.text Tamanyo:self.nombre.frame.size Fuente:self.nombre.font] + 5];
    
    self.tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(-5, self.nombre.frame.origin.y + self.nombre.frame.size.height + 13, 5.0f + (screenWidth * 0.74f), 42 * [self.items count])
                                                               style:UITableViewStylePlain];
        
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate         = self;
        tableView.dataSource       = self;
        tableView.opaque           = NO;
        tableView.backgroundColor  = [UIColor clearColor];
        tableView.backgroundView   = nil;
        tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        tableView.bounces          = NO;
        tableView;
    });
    [self.scroll addSubview:self.tableView];
    
    // Recalculamos el tamaño del scroll
    int sizeElementos = self.tableView.frame.origin.y + self.tableView.frame.size.height;
    self.scroll.contentSize = CGSizeMake(screenWidth * 0.74f, sizeElementos);
   
    // Si el scroll es menor a la pantalla lo centramos
    if (screenHeight > sizeElementos)
    {
        // Centramos el scroll a la mitad de la pantalla
        self.scroll.frame = CGRectMake(0, (screenHeight - sizeElementos) / 2, screenWidth * 0.74f, screenHeight);
    }
}

#pragma mark -
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Menu";
    
    NOMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[NOMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"Menu"];
    }
    
    cell.texto.text   = self.items[indexPath.row];
    cell.imagen.image = [SPUtilidades imageWithImage:[UIImage imageNamed:self.imagenes[indexPath.row]] scaledToSize:CGSizeMake(32, 32)];
    cell.selectedBackgroundView = [[UIView alloc] init];
    
    return cell;
}

/////////////////////////////////////////////////////////////////////
// Evento que se produce al seleccionar algún elemento de la lista //
/////////////////////////////////////////////////////////////////////
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Según sea el elemento seleccionado
    switch (indexPath.row)
    {
        case 0:
            [SPUtilidades cargarRootUIViewController:[[NOOfertasViewController alloc] init]];
            break;
        case 1:
            [SPUtilidades cargarRootUIViewController:[[NOChatsViewController alloc] init]];
            break;
        case 2:
            [SPUtilidades cargarRootUIViewController:[[NOAmigosViewController alloc] init]];
            break;
        case 3:
            [SPUtilidades cargarRootUIViewController:[[NOInvitacionesViewController alloc] init]];
            break;
        default:
            break;
    }
}

//////////////////////////////
// Refrescamos las imágenes //
//////////////////////////////
-(void) refrescarImagen
{
    CGFloat screenWidth  = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // Establecemos el nombre del usuario
    self.nombre.text = [SPUtilidades leerDatosUsuario];
    [self.nombre CambiarAlto:[SPUtilidades TamanyoTexto:self.nombre.text Tamanyo:self.nombre.frame.size Fuente:self.nombre.font] + 5];
    
    // Creamos la foto del perfíl
    self.foto.image = [SPUtilidades leerImagen:@"Noctua"
                                       Archivo:@"fotoNoctua.jpg"];
    
    self.tableView.frame = CGRectMake(-5, self.nombre.frame.origin.y + self.nombre.frame.size.height + 13, 5.0f + (screenWidth * 0.74f), 42 * [self.items count]);
    
    // Recalculamos el tamaño del scroll
    int sizeElementos       = self.tableView.frame.origin.y + self.tableView.frame.size.height;
    self.scroll.contentSize = CGSizeMake(screenWidth * 0.74f, sizeElementos);
    
    // Si el scroll es menor a la pantalla lo centramos
    if (screenHeight > sizeElementos)
    {
        // Centramos el scroll a la mitad de la pantalla
        self.scroll.frame = CGRectMake(0, (screenHeight - sizeElementos) / 2, screenWidth * 0.74f, screenHeight);
    }
}

//////////////////////
// Accede al perfíl //
//////////////////////
-(void) accederPerfil
{
   [SPUtilidades cargarRootUIViewController:[[NOPerfilViewController alloc] init]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 
}

@end
