//
//  NODesactivacionOfertaViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 12/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NODesactivacionOfertaViewController.h"
#import "DollarP/DollarDefaultGestures.h"

@interface NODesactivacionOfertaViewController ()

@end

@implementation NODesactivacionOfertaViewController
@synthesize datosoferta;

// Constructor por defecto
-(id) initWithOferta: (int) oferta
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.oferta = oferta;
    }
    return self;
}

- (void)viewDidLoad {
    // Inicializamos la vista
    [self initUI];
    
    // Inicializamos el número de elementos seleccionados
    self.numelementos = -1;
    
    // Cargamos los datos
    [self CargarDatos];
}

-(void) initUI
{
    // Configuramos el background
    self.view.backgroundColor = [UIColor whiteColor];
    [SPUtilidades setBackground:@"logobackground.png" Posicion:0 Vista:self.view Alpha:1.0f];
    
    // Creamos la barra de navegación
    [SPUtilidades crearBarraNavegacion:self Titulo:@"Noctúa" MenuIzquierdo:NO MenuDerecho:NO SelectorIzquierdo:@selector(volverAtras:)];
    
    // Creamos el texto vacío
    self.textocargando = [[SPLabel alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20, self.view.frame.size.height - 80) Text:@"Cargando los datos de la oferta..." Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f] TextColor:RGB(97, 168, 221) Padre:self.view];
    self.textocargando.textAlignment = NSTextAlignmentCenter;
    self.textocargando.numberOfLines = 0;
}

////////////////////////////
// Inicializa el interfaz //
////////////////////////////
-(void) initInterfaz
{
    // Imagen de la oferta
    self.imagen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 140)];
    [self.view addSubview:self.imagen];
    
    // Imagen de la empresa
    self.imagen = [[UIImageView alloc] initWithFrame:CGRectMake(5, 50, 50, 50)];
    [self.imagen setContentMode:UIViewContentModeScaleToFill];
    self.imagen.layer.cornerRadius  = roundf(self.imagen.frame.size.width / 2.0f);
    self.imagen.layer.masksToBounds = YES;
    [self.view addSubview:self.imagen];
    
    // Creamos el texto de la oferta
    self.nombre = [[SPLabel alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 15)
                                            Text:@""
                                            Font:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]
                                       TextColor:RGB(97, 168, 221)
                                       Alignment:NSTextAlignmentCenter
                                         Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                           Padre:self.view];
    
    // Es multilínea
    self.nombre.numberOfLines = 0;
    self.nombre.lineBreakMode = NSLineBreakByWordWrapping;
    
    // Creamos el texto de la fecha
    self.fecha = [[SPLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)
                                           Text:@""
                                           Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]
                                      TextColor:RGB(97, 168, 221)
                                      Alignment:NSTextAlignmentLeft
                                        Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                          Padre:self.view];
    
    // Creamos el texto de la hora
    self.hora = [[SPLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)
                                          Text:@""
                                          Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]
                                     TextColor:RGB(97, 168, 221)
                                     Alignment:NSTextAlignmentLeft
                                       Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                         Padre:self.view];
    
    // Creamos el texto de la selección
    self.seleccionados1 = [[SPLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)
                                                    Text:@""
                                                    Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f]
                                               TextColor:RGB(97, 168, 221)
                                               Alignment:NSTextAlignmentCenter
                                                 Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                   Padre:self.view];
    
    // Creamos el texto de la selección
    self.seleccionadosnum = [[SPLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)
                                                      Text:@""
                                                      Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:25.0f]
                                                 TextColor:RGB(97, 168, 221)
                                                 Alignment:NSTextAlignmentCenter
                                                   Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                     Padre:self.view];
    
    // Creamos el texto de la selección
    self.seleccionados2 = [[SPLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)
                                                    Text:@""
                                                    Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f]
                                               TextColor:RGB(97, 168, 221)
                                               Alignment:NSTextAlignmentCenter
                                                 Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                   Padre:self.view];
    
    // Creamos el texto de los servicios disponibles
    self.disponibles = [[SPLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)
                                                 Text:@""
                                                 Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f]
                                            TextColor:RGB(97, 168, 221)
                                            Alignment:NSTextAlignmentCenter
                                              Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                Padre:self.view];
    
    // Creamos el texto de desactivación
    self.textodesactivacion = [[SPLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)
                                                        Text:@"Código desactivación:"
                                                        Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]
                                                   TextColor:RGB(97, 168, 221)
                                                   Alignment:NSTextAlignmentCenter
                                                     Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                       Padre:self.view];
    
    // Posición de la línea
    self.linea2 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 2)];
    self.linea2.backgroundColor = RGB(97, 168, 221);
    [self.view addSubview:self.linea2];
    
    // Creamos la colección
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset                = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.itemSize                    = CGSizeMake(50, 50);
    layout.minimumInteritemSpacing     = 3.0f;
    layout.minimumLineSpacing          = 3.0f;
    self.grideliminacion               = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 51, self.view.frame.size.width, self.view.frame.size.height - 51) collectionViewLayout:layout];
    [self.grideliminacion setDataSource:self];
    [self.grideliminacion setDelegate:self];
    [self.grideliminacion registerClass:[NODesactivacionOfertaCollectionViewCell class] forCellWithReuseIdentifier:@"NumeroEliminacion"];
    [self.grideliminacion setBackgroundColor:[UIColor clearColor]];
    self.grideliminacion.bounces = NO;
    [self.view addSubview:self.grideliminacion];
}

////////////////////////
// Vuelve hacia atrás //
////////////////////////
-(void) volverAtras: (id) sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

//////////////////////////////////
// Carga los datos de la oferta //
//////////////////////////////////
-(void) CargarDatos
{
    self.datosoferta = [CoreDataHelper cuponBD:[NSNumber numberWithInt:self.oferta] Tipo:@"N"];
    
    // Quitamos el texto de cargando
     self.textocargando.hidden = YES;
     
     // Inicializamos el interfaz
     [self initInterfaz];
    
     // Si no tenemos logo de empresa, ponemos una por defecto
     if (datosoferta.logo == nil || [datosoferta.logo isEqual:@""])
     {
         self.imagen.image = [UIImage imageNamed:@"logo.png"];
     }
     else
     {
         // Cargamos la imagen
         self.imagen.image = [SPUtilidades leerImagen:@"Noctua/cupones" Archivo:[datosoferta.logo stringByAppendingString:@".jpg"]];
     }
     
     // Establecemos el nombre de la oferta
     self.nombre.text = datosoferta.nombre;
     
     // Obtenemos el tamaño del nombre de la oferta
     [self.nombre CambiarAlto:[SPUtilidades TamanyoTexto:self.nombre.text Tamanyo:self.nombre.frame.size Fuente:self.nombre.font] + 5];
     
     // Posición inicial
     int posicion = self.nombre.frame.size.height + self.nombre.frame.origin.y;
    
     // Posicionamos la imagen
     self.imagen.frame = CGRectMake(5, posicion, 50, 50);
     
     // Nos permitirá trocear la fecha
     NSDateComponents *componentsInicio = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:datosoferta.inicio];
     NSDateComponents *componentsFin    = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:datosoferta.fin];
     
     // Establecemos la fecha
     self.fecha.text = [NSString stringWithFormat:@"%@ %ld de %@", [SPUtilidades nombreDia:(int)[componentsInicio weekday] - 1], (long)[componentsInicio day], [SPUtilidades nombreMesCompleto:(int)[componentsInicio month] - 1]];
     
     // Tamaño del texto
     int sizeText = [self.fecha.text sizeWithAttributes:@{ NSFontAttributeName: self.fecha.font }].width;
     
     // Posición de la imagen
     int posicionimagen = (self.view.frame.size.width + 10 - sizeText) / 2;
     
     // Establecemos la posición
     [self.fecha CambiarPosicion:CGPointMake(posicionimagen + 23, posicion)];
     
     // Establecemos la imagen de la fecha
     UIImageView * imagenfecha = [[UIImageView alloc] initWithFrame:CGRectMake(posicionimagen, posicion + 1, 18, 18)];
     imagenfecha.image         = [UIImage imageNamed:@"fecha.png"];
     [self.view addSubview:imagenfecha];
    
     // Actualizamos la posición actual
     posicion += self.fecha.frame.size.height;
     
     // Establecemos la hora
     self.hora.text = [NSString stringWithFormat:@"%02d:%02d - %02d:%02d", (int)[componentsInicio hour], (int)[componentsInicio minute], (int)[componentsFin hour], (int)[componentsFin minute]];
     
     // Tamaño del texto
     sizeText = [self.hora.text sizeWithAttributes:@{ NSFontAttributeName: self.hora.font }].width;
     
     // Posición de la imagen
     posicionimagen = (self.view.frame.size.width + 10 - sizeText) / 2;
     
     // Establecemos la posición
     [self.hora CambiarPosicion:CGPointMake(posicionimagen + 23, posicion + 1)];
     
     // Establecemos la imagen de la fecha
     UIImageView * imagenhora = [[UIImageView alloc] initWithFrame:CGRectMake(posicionimagen, posicion + 2, 18, 18)];
     imagenhora.image         = [UIImage imageNamed:@"hora.png"];
     [self.view addSubview:imagenhora];
     
     // Actualizamos la posición actual
     posicion += self.fecha.frame.size.height;
     
     // Creamos la línea de separación
     UIView * linea = [[UIView alloc] initWithFrame:CGRectMake(10, posicion + 8, self.view.frame.size.width - 20, 2)];
     linea.backgroundColor = RGB(97, 168, 221);
     [self.view addSubview:linea];
     
     // Aumentamos la posición
     posicion += 16;
    
     // Mostramos los datos
     [self MostrarDatos: posicion];
}

/////////////////////////////////////////
// Muestra el interfaz y lo estructura //
/////////////////////////////////////////
-(void) MostrarDatos: (int) posicion
{
    // Inicializamos el número de elementos seleccionados
    self.numelementos = -1;
    
    // Número de disponibles
    self.numerodisponibles = [self.datosoferta.disponibles intValue] - [self.datosoferta.usados intValue];
    
    // Si no quedan elementos disponibles
    if (self.datosoferta.usados == self.datosoferta.disponibles)
    {
        // Ocultamos los textos de la selección
        self.seleccionados1.hidden   = YES;
        self.seleccionadosnum.hidden = YES;
        self.seleccionados2.hidden   = YES;
        
        // Escondemos la tabla de selección
        self.grideliminacion.hidden = YES;
        
        // Escondemos la línea de separación
        self.linea2.hidden = YES;
        
        // Escondemos el texto y código de desactivación
        self.textodesactivacion.hidden  = YES;
        
        // Establecemos el texto de la cantidad disponible
        self.disponibles.text = @"Has gastado todos tus servicios";
    }
    else
    {
        // Si sólo queda un elemento
        if (self.numerodisponibles == 1)
        {
            // Ocultamos los textos de la selección
            self.seleccionados1.hidden   = YES;
            self.seleccionadosnum.hidden = YES;
            self.seleccionados2.hidden   = YES;
            
            // Escondemos la tabla de selección
            self.grideliminacion.hidden = YES;
            
            // Establecemos el texto de la cantidad disponible
            self.disponibles.text = @"1 servicio disponible";
            
            // Inicializamos el número de elementos seleccionados
            self.numelementos = 0;
        }
        else
        {
            // Posicionamos el texto de la selección
            self.seleccionados1.frame   = CGRectMake(0, posicion, self.view.frame.size.width, 22);
            self.seleccionadosnum.frame = CGRectMake(0, posicion, self.view.frame.size.width, 22);
            self.seleccionados2.frame   = CGRectMake(0, posicion, self.view.frame.size.width, 22);
            
            // Si ya hemos usado todos los servicios
            if ([self.datosoferta.usados intValue] == 0)
                // Cambiamos el texto
                self.disponibles.text = @"No has usado ningún servicio";
            else
                self.disponibles.text = [NSString stringWithFormat:@"Has usado %d servicios", [self.datosoferta.usados intValue]];
            
            // Aumentamos la posición
            posicion += 30;
        }
    }
    
    // Texto por defecto
    [self textoSeleccionado:@"No has seleccionado nada" Numero:@"" Texto2:@""];
    
    // Si hay elementos disponibles
    if (self.numerodisponibles > 0)
    {
        // Número de columnas
        int columnas = (int) floor((self.view.frame.size.width - 20.0f) / 50.0f);
        if (columnas > self.numerodisponibles) columnas = self.numerodisponibles;
    
        // Número de filas
        int filas = (self.numerodisponibles / columnas) + (self.numerodisponibles % columnas != 0);
        
        // Posicionamos las eliminaciones
        self.grideliminacion.frame = CGRectMake((self.view.frame.size.width - 20.0f - (columnas * 50.0f) - (columnas - 1) * 3.0f) / 2, posicion, 20.0f + columnas * 50.0f + (columnas - 1) * 3.0f, filas * 50.0f + (filas - 1) * 3.0f);
    }
    
    // Aumentamos la posición
    if (self.grideliminacion.hidden == NO) posicion += self.grideliminacion.frame.size.height + 5.0f;
    
    // Si no quedan elementos disponibles
    if (self.datosoferta.usados == self.datosoferta.disponibles)
    {
        // Cambiamos el tamaño del texto
        self.disponibles.font          = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0f];
        self.disponibles.frame         = CGRectMake(10, posicion, self.view.frame.size.width - 20, self.view.frame.size.height - posicion - 50);
        self.disponibles.textAlignment = NSTextAlignmentCenter;
        self.disponibles.numberOfLines = 0;
    }
    else
    {
        // Establecemos la posición
        self.disponibles.frame = CGRectMake(0, posicion, self.view.frame.size.width, 22);
    }
    
    // Aumentamos la posición
    posicion += 33;
    
    // Posicionamos la línea de separación
    self.linea2.frame = CGRectMake(10, posicion - 7, self.view.frame.size.width - 20, 2);
    
    // Aumentamos la posición
    posicion += 40;
    
    // Tamaño de la celda numérica
    int celda = 0;
    
    // Para centrar la tabla numeríca
    int posiciontabla = 0;
    
    // Obtenemos el tamaño de la celda
    celda = (self.view.frame.size.width - 24.0f) / 3;
    
    // Comprobamos el tamaño de las celdas
    if (celda > (self.view.frame.size.height - posicion - 50) / 2)
    {
        // Obtenemos el tamaño de la celda
        celda = (self.view.frame.size.height - posicion - 50) / 2;
    }
    
    // Calculamos la posición de la tabla
    posiciontabla = (self.view.frame.size.width - 24.0f - (3 * celda)) / 2;
}

////////////////////////////
// Desactivamos la oferta //
////////////////////////////
-(void) DesactivarOferta
{
    // Actualizamos la cantidad de usados
    self.datosoferta.usados = [NSNumber numberWithInt:[self.datosoferta.usados intValue] + self.numelementos + 1];
    
    // Si hemos usado todos
    if ([self.datosoferta.usados isEqual:self.datosoferta.disponibles])
    {
        // Actualizamos los datos de los usados
        [CoreDataHelper actualizarCupon:[NSNumber numberWithInt:self.oferta]
                                   Tipo:@"N"
                                 Usados:self.numelementos + 1
                              Consumido:@"S"];
        
        [self volverAtras:nil];
    }
    else
    {
        // Actualizamos los datos de los usados
        [CoreDataHelper actualizarCupon:[NSNumber numberWithInt:self.oferta]
                                   Tipo:@"N"
                                 Usados:self.numelementos + 1
                              Consumido:@""];
        
        // Refrescamos los datos de la pantalla
        [self MostrarDatos:self.fecha.frame.origin.y + self.fecha.frame.size.height + 35];
    
        // Recargamos los datos
        [self.grideliminacion reloadData];
    }
}

/////////////////////////////////////////////
// Establece el texto de los seleccionados //
/////////////////////////////////////////////
-(void) textoSeleccionado: (NSString *) texto1
                   Numero: (NSString *) numero
                   Texto2: (NSString *) texto2
{
    // Establecemos los textos
    self.seleccionados1.text   = texto1;
    self.seleccionadosnum.text = numero;
    self.seleccionados2.text   = texto2;
    
    // Si no hemos establecido los demás
    if ([numero isEqual:@""])
    {
        // Posicionamos los textos
        self.seleccionados1.frame = CGRectMake(10, self.seleccionados1.frame.origin.y, self.view.frame.size.width - 20, 22);
    }
    else
    {
        // Calculamos el tamaño del texto completo
        int anchurasel1 = [SPUtilidades AnchuraTexto:self.seleccionados1.text Tamanyo:self.seleccionados1.frame.size Fuente:self.seleccionados1.font] + 1;
        int anchuranum  = [SPUtilidades AnchuraTexto:self.seleccionadosnum.text Tamanyo:self.seleccionadosnum.frame.size Fuente:self.seleccionadosnum.font] + 1;
        int anchurasel2 = [SPUtilidades AnchuraTexto:self.seleccionados2.text Tamanyo:self.seleccionados2.frame.size Fuente:self.seleccionados2.font] + 1;
        int tamanyo = anchurasel1 + 5 + anchuranum + anchurasel2 + 5;
        
        // Posicionamos los textos
        self.seleccionados1.frame = CGRectMake((self.view.frame.size.width - tamanyo) / 2,
                                               self.seleccionados1.frame.origin.y,
                                               anchurasel1, 22);
        self.seleccionadosnum.frame = CGRectMake(self.seleccionados1.frame.origin.x + self.seleccionados1.frame.size.width + 5,
                                               self.seleccionados1.frame.origin.y,
                                               anchuranum, 22);
        self.seleccionados2.frame = CGRectMake(self.seleccionadosnum.frame.origin.x + self.seleccionadosnum.frame.size.width + 5,
                                               self.seleccionados1.frame.origin.y,
                                               anchurasel2, 22);
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numerodisponibles;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NODesactivacionOfertaCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NumeroEliminacion" forIndexPath:indexPath];
    
    // Establecemos el valor
    cell.numero.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    
    // Si está seleccionado
    if (self.numelementos != -1)
    {
        if (indexPath.row <= self.numelementos)
        {
            // No está seleccionado
            cell.numero.backgroundColor = RGB(97, 168, 221);
            cell.numero.textColor       = [UIColor whiteColor];
        }
        else
        {
            // No está seleccionado
            cell.numero.backgroundColor = [UIColor clearColor];
            cell.numero.textColor       = RGB(97, 168, 221);
        }
    }
    else
    {
        // No está seleccionado
        cell.numero.backgroundColor = [UIColor clearColor];
        cell.numero.textColor       = RGB(97, 168, 221);
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Indicamos que elemento hemos seleccionado
    self.numelementos = (int) indexPath.row;
    
    // Indicamos cuantos elementos hemos seleccionado
    [self textoSeleccionado:@"Has seleccionado" Numero:[NSString stringWithFormat:@"%d", indexPath.row + 1] Texto2:@"servicios"];

    // Recargamos los datos
    [self.grideliminacion reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
