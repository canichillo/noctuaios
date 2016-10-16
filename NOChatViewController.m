//
//  NOChatViewController.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 7/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOChatViewController.h"

@interface NOChatViewController ()

@end

@implementation NOChatViewController
-(id) initWithCodigo: (NSNumber *) codigo Entrada:(BOOL)entrada
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.codigo = codigo;
        self.entrada = entrada;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Inicializamos las líneas
    self.mensajes   = [[NSMutableArray alloc] init];
    self.posiciones = [[NSMutableArray alloc] init];
    self.fechas     = [[NSMutableArray alloc] init];
    
    // Inicializamos la vista
    [self initUI];
    
    // Leemos los datos del chat
    [self datosChat];
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
    
    // Creamos la barra de navegación
    if (self.entrada) self.titulo = [SPUtilidades crearBarraNavegacion:self Titulo:@"Chat" MenuIzquierdo:YES MenuDerecho:NO SelectorIzquierdo:nil];
    else self.titulo = [SPUtilidades crearBarraNavegacion:self Titulo:@"Chat" MenuIzquierdo:NO MenuDerecho:NO SelectorIzquierdo:@selector(volverAtras:)];
    
    // Quitamos el icono de la cámara
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    // Siempre mostramos el último mensaje
    self.automaticallyScrollsToMostRecentMessage = YES;
    
    // Ajustamos el margen superior
    self.collectionView.contentInset = UIEdgeInsetsMake(25, 0, 45, 0);
}

///////////////////////////////
// Leemos los datos del chat //
///////////////////////////////
-(void) datosChat
{
    // Comprobamos si ya existe el chat en la base de datos
    self.chat = [CoreDataHelper chatBD:self.codigo];
    
    // Si no existe el chat
    if (self.chat == nil)
    {
        // Parámetros JSON para la petición
        NSDictionary *params = @{
                                 @"remitente"  : self.codigo,
                                 @"token"      : [SPUtilidades leerDatosToken],
                                 };
        
        // Realizamos la petición POST
        [SPUtilidades procesarPeticionPOST: @"datosremitentechat"
                                Parametros: params
                              SuccessBlock: ^(id responseObject)
                                            {
                                                // Obtenemos los datos del chat
                                                self.chat = [[Chat alloc] initWithID:self.codigo
                                                                              Nombre:[responseObject objectForKey:@"nombre"]
                                                                               Imagen:[responseObject objectForKey:@"imagen"]
                                                                                   SO:[responseObject objectForKey:@"so"]
                                                                          Dispositivo:[responseObject objectForKey:@"dispositivo"]
                                                                                Fecha:[NSDate dateFromString:@"2014-01-01" withFormat:@"yyyy-MM-dd"]];
                                                
                                                // Los guardamos en la base de datos
                                                [CoreDataHelper crearChat:self.chat];
                                                
                                                // Establecemos el título
                                                self.titulo.text = self.chat.NOMBRE;
                                                
                                                // Cambiamos la fuente
                                                self.titulo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
                                                
                                                // Ajustamos la posición del texto
                                                self.titulo.frame = CGRectMake(75, 6, self.view.frame.size.width - 110, 50);
                                                
                                                // Cargamos los datos
                                                [self cargarDatos];
                                                
                                                // Leemos las líneas del chat
                                                [self leerLineasChat];
                                                
                                                // Comprobamos si está almacenada anteriormente
                                                if ([SPUtilidades existeImagen:@"Noctua/temp" Archivo:self.chat.IMAGEN])
                                                {
                                                    // Cargamos la imagen
                                                    UIImageView * foto = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 32, 19, 28, 28)];
                                                    foto.image         = [SPUtilidades leerImagen:@"Noctua/temp" Archivo:self.chat.IMAGEN];
                                                    foto.layer.cornerRadius = 14.0f;
                                                    foto.layer.masksToBounds = YES;
                                                    foto.layer.borderWidth = 1.0f;
                                                    foto.layer.borderColor = [[UIColor whiteColor] CGColor];
                                                    [self.view addSubview:foto];
                                                }
                                                else
                                                {
                                                    // Realizamos la petición de guardado de la imagen
                                                    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[SPUtilidades urlImagenes:@"usuarios" Imagen:[self.chat.IMAGEN stringByAppendingString:@".jpg"]]
                                                                                                        options:0
                                                                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                                     {
                                                     }
                                                                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                                                     {
                                                         // Si está finalizado
                                                         if (image && finished)
                                                         {
                                                             // Guardamos la imagen
                                                             [SPUtilidades guardarImagen:@"Noctua/temp" Archivo:self.chat.IMAGEN Datos:data];
                                                             
                                                             // Cargamos la imagen
                                                             UIImageView * foto = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 32, 19, 28, 28)];
                                                             foto.image         = [SPUtilidades leerImagen:@"Noctua/temp" Archivo:self.chat.IMAGEN];
                                                             foto.layer.cornerRadius = 14.0f;
                                                             foto.layer.masksToBounds = YES;
                                                             foto.layer.borderWidth = 1.0f;
                                                             foto.layer.borderColor = [[UIColor whiteColor] CGColor];
                                                             [self.view addSubview:foto];
                                                         }
                                                     }
                                                     ];
                                                }
                                            }
                              FailureBlock: ^(NSError *error)
                                            {
                                                // Se ha producido un error
                                                [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido obtener los datos del chat" Handler:^(SIAlertView *alertView) { }];
                                            }
         ];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Establecemos el título
            self.titulo.text = self.chat.NOMBRE;
        
            // Cambiamos la fuente
            self.titulo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            
            // Ajustamos la posición del texto
            self.titulo.frame = CGRectMake(75, 6, self.view.frame.size.width - 110, 50);
        });
        
        // Cargamos los datos
        [self cargarDatos];
        
        // Comprobamos si está almacenada anteriormente
        if ([SPUtilidades existeImagen:@"Noctua/temp" Archivo:self.chat.IMAGEN])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Cargamos la imagen
                UIImageView * foto = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 32, 19, 28, 28)];
                foto.image         = [SPUtilidades leerImagen:@"Noctua/temp" Archivo:self.chat.IMAGEN];
                foto.layer.cornerRadius = 14.0f;
                foto.layer.masksToBounds = YES;
                foto.layer.borderWidth = 1.0f;
                foto.layer.borderColor = [[UIColor whiteColor] CGColor];
                [self.view addSubview:foto];
            });
        }
        else
        {
            // Realizamos la petición de guardado de la imagen
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[SPUtilidades urlImagenes:@"usuarios" Imagen:[self.chat.IMAGEN stringByAppendingString:@".jpg"]]
                                                                options:0
                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                                                        {
                                                                        }
                                                              completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                                                                        {
                                                                            // Si está finalizado
                                                                            if (image && finished)
                                                                            {
                                                                                // Guardamos la imagen
                                                                                [SPUtilidades guardarImagen:@"Noctua/temp" Archivo:self.chat.IMAGEN Datos:data];
                                                                                
                                                                                // Cargamos la imagen
                                                                                UIImageView * foto = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 32, 19, 28, 28)];
                                                                                foto.image         = [SPUtilidades leerImagen:@"Noctua/temp" Archivo:self.chat.IMAGEN];
                                                                                foto.layer.cornerRadius = 14.0f;
                                                                                foto.layer.masksToBounds = YES;
                                                                                foto.layer.borderWidth = 1.0f;
                                                                                foto.layer.borderColor = [[UIColor whiteColor] CGColor];
                                                                                [self.view addSubview:foto];
                                                                            }
                                                                        }
             ];
        }
    }
}

//////////////////////////////////////////////////////
// Cargamos las líneas del chat de la base de datos //
//////////////////////////////////////////////////////
-(void) cargarDatos
{
    // Leemos las líneas del chat de la base de datos
    NSArray * lineas = [CoreDataHelper lineasChatBD:self.chat.ID];
   
    // Si hay líneas
    if (lineas != nil && [lineas count] != 0)
    {
        // Para cada una de las líneas de la base de datos
        for (LineaChat * linea in lineas)
        {
            // Si es de tipo fecha
            if ([linea.TIPO isEqual:@"F"])
            {
                // Añadimos la posición de la fecha
                [self.posiciones addObject:[NSNumber numberWithInt:(int) [self.mensajes count]]];
                
                // Añadimos la fecha
                [self.fechas addObject:[NSDate dateFromString:linea.TEXTO withFormat:@"yyyy-MM-dd HH:mm:ss"]];
            }
            else [self.mensajes addObject:[[JSQMessage alloc] initWithSenderId:[linea.ORIGEN isEqual:@"S"] ? self.senderId : @""
                                                             senderDisplayName:self.senderDisplayName
                                                                          date:[NSDate date]
                                                                          text:linea.TEXTO]];
        }
        
        // Creamos el mensaje de la fecha
        [CoreDataHelper crearMensajeChat:self.codigo
                                   Texto:[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]
                                  Propio:@""
                                    Tipo:@"F"];
        
        // Añadimos la posición de la fecha
        [self.posiciones addObject:[NSNumber numberWithInt:(int) [self.mensajes count]]];
        
        // Añadimos la fecha
        [self.fechas addObject:[NSDate date]];
        
        // Recargamos la tabla
        [self.collectionView reloadData];
    }
    
    // Leemos las líneas
    [self leerLineasChat];
    
    // Creamos un temporizador
    self.temporizador = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(leerLineasChat) userInfo:nil repeats:YES];
}

//////////////////////////////////////
// Cargamos las líneas del servidor //
//////////////////////////////////////
-(void) leerLineasChat
{
    // Parámetros JSON para la petición
    NSDictionary *params = @{
                             @"remitente"   : self.codigo,
                             @"token"       : [SPUtilidades leerDatosToken],
                             @"fecha"       : [NSDate stringFromDate:self.chat.FECHA withFormat:@"yyyy-MM-dd HH:mm:ss"],
                             };
    
    // Realizamos la petición POST
    [SPUtilidades procesarPeticionPOST: @"mensajeschat"
                            Parametros: params
                          SuccessBlock: ^(id responseObject)
                                        {
                                            // Si hay datos
                                            if ([responseObject count] != 0)
                                            {
                                                // Para cada uno de los mensajes leidos
                                                for (NSDictionary * JSONData in responseObject)
                                                {
                                                    // Creamos el mensaje obtenido
                                                    [CoreDataHelper crearMensajeChat:self.codigo
                                                                               Texto:[JSONData objectForKey:@"texto"]
                                                                              Propio:@"N"
                                                                                Tipo:@"T"];
                                                    
                                                    [self.mensajes addObject:[[JSQMessage alloc] initWithSenderId:self.senderId
                                                                                                senderDisplayName:self.senderDisplayName
                                                                                                             date:[NSDate date]
                                                                                                             text:[JSONData objectForKey:@"texto"]]];
                                                }
                                                
                                                // Recargamos la tabla
                                                [self.collectionView reloadData];
                                                
                                                // Actualizamos la fecha
                                                [CoreDataHelper actualizarChat:self.chat.ID Fecha:[NSDate date]];
                                                self.chat.FECHA = [NSDate date];
                                                
                                                // Parámetros JSON para la petición
                                                NSDictionary *params = @{
                                                                         @"token" : [SPUtilidades leerDatosToken],
                                                                         @"fecha" : [NSDate stringFromDate:self.chat.FECHA withFormat:@"yyyy-MM-dd HH:mm:ss"],
                                                                         };
                                                
                                                // Realizamos la petición POST
                                                [SPUtilidades procesarPeticionPOST: @"eliminarmensajeschat"
                                                                        Parametros: params
                                                                      SuccessBlock: ^(id responseObject)
                                                                                    {
                                                                                    }
                                                                      FailureBlock:^(NSError * error)
                                                                                    {
                                                                                    }];
                                            }
                                        }
                          FailureBlock:^(NSError *error)
                                        {
                                        }];
}

////////////////////////
// Vuelve hacia atrás //
////////////////////////
-(void) volverAtras: (id) sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JSQMessages CollectionView DataSource
-(id<JSQMessageData>) collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.mensajes objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.mensajes objectAtIndex:indexPath.item];
    
    // Establecemos las imágenes de las burbujas
    JSQMessagesBubbleImageFactory * factoria = [[JSQMessagesBubbleImageFactory alloc] init];
       
    if ([message.senderId isEqualToString:self.senderId]) {
        return [factoria outgoingMessagesBubbleImageWithColor:RGB(205, 205, 205)];
    }
    
    return [factoria incomingMessagesBubbleImageWithColor:RGB(52, 138, 208)] ;
}

-(UIImageView *) collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.mensajes objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return [[UIImageView alloc] initWithImage:self.outgoingBubbleImageView.image
                                 highlightedImage:self.outgoingBubbleImageView.highlightedImage];
    }
    
    return [[UIImageView alloc] initWithImage:self.incomingBubbleImageView.image
                             highlightedImage:self.incomingBubbleImageView.highlightedImage];
}

-(UIImageView *) collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.mensajes count];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    long indice =  [self.posiciones indexOfObject:[NSNumber numberWithInt:indexPath.item]];

    if (indice != NSNotFound)
    {
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:[self.fechas objectAtIndex:indice]];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(UICollectionViewCell *) collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *msg = [self.mensajes objectAtIndex:indexPath.item];
    
    if ([msg.senderId isEqualToString:self.senderId]) {
        cell.textView.textColor = [UIColor whiteColor];
    }
    else {
        cell.textView.textColor = [UIColor blackColor];
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    return cell;
}

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    long indice = (long) [self.posiciones indexOfObject:[NSNumber numberWithInt:indexPath.item]];
    
    if (indice != NSNotFound) return kJSQMessagesCollectionViewCellLabelHeightDefault;
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                    sender:(NSString *)sender
                      date:(NSDate *)date
{
    // Si no hemos puesto un mensaje de error
    if (text == nil || [text isEqual:@""]) return;
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId senderDisplayName:self.senderDisplayName date:date text:text];
    [self.mensajes addObject:message];
    
    [self finishSendingMessage];
    
    // Añadimos el mensaje a la base de datos
    [CoreDataHelper crearMensajeChat:self.codigo
                               Texto:text
                              Propio:@"S"
                                Tipo:@"T"];
    
    // Creamos un nuevo de chat en el servidor
    NSDictionary *params = @{
                             @"chat"  : self.codigo,
                             @"token" : [SPUtilidades leerDatosToken],
                             @"texto" : text,
                             @"tipo"  : @"T",
                             };
    
    // Realizamos la petición POST
    [SPUtilidades procesarPeticionPOST: @"nuevomensajechat"
                            Parametros: params
                          SuccessBlock: ^(id responseObject)
                                        {
                                            if ([responseObject objectForKey:@"Error"])
                                            {
                                                // Se ha producido un error
                                                [SPUtilidades mostrarError:@"Error" Mensaje:[responseObject objectForKey:@"Error"] Handler:^(SIAlertView *alertView) { }];
                                            }
                                        }
                          FailureBlock:^(NSError *error)
                                        {
                                            // Se ha producido un error
                                            [SPUtilidades mostrarError:@"Error" Mensaje:@"No se ha podido enviar el mensaje" Handler:^(SIAlertView *alertView) { }];
                                        }];
    
    // Si solo hay un mensaje
    if ([self.mensajes count] == 1)
        [self.collectionView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated
{
    if(self.temporizador)
    {
        [self.temporizador invalidate];
        self.temporizador = nil;
    }
}

@end
