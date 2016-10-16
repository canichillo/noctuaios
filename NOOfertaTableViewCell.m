//
//  NOOfertaTableViewCell.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 23/7/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOOfertaTableViewCell.h"

@implementation NOOfertaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        // Inicializamos la imagen de la empresa
        self.imagen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 156)];
        self.imagen.backgroundColor = [UIColor whiteColor];
        [self.imagen setContentMode:UIViewContentModeScaleToFill];
        // Añadimos el elemento a la vista
        [self addSubview:self.imagen];
        
        // Contenedor de datos
        UIView * contenedordatos        = [[UIView alloc] initWithFrame:CGRectMake(0, 105, screenWidth, 52)];
        contenedordatos.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
        [self addSubview:contenedordatos];
        
        // Vista donde estarán los datos de la fecha y hora
        UIView * contenedorfecha          = [[UIView alloc] initWithFrame:CGRectMake(8, 8, 45, 55)];
        contenedorfecha.backgroundColor   = [RGB(114, 121, 129) colorWithAlphaComponent:0.85f];
        contenedorfecha.layer.borderWidth = 1.0f;
        contenedorfecha.layer.borderColor = [RGB(151, 155, 161) CGColor];
        [self addSubview:contenedorfecha];
        
        // Creamos el texto del nombre del día
        self.dia = [[SPLabel alloc] initWithFrame:CGRectMake(5, 2, 50, 20)
                                             Text:@""
                                             Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:25.0f]
                                        TextColor:[UIColor whiteColor]
                                        Alignment:NSTextAlignmentLeft
                                          Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                             Padre:contenedorfecha];
        
        // Creamos el texto del nombre del mes
        self.mes = [[SPLabel alloc] initWithFrame:CGRectMake(5, 20, 50, 20)
                                             Text:@""
                                             Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]
                                        TextColor:[UIColor whiteColor]
                                        Alignment:NSTextAlignmentLeft
                                          Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                            Padre:contenedorfecha];
        
        // Creamos el texto de la hora
        self.hora = [[SPLabel alloc] initWithFrame:CGRectMake(5, 37, 50, 20)
                                              Text:@""
                                              Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]
                                         TextColor:[UIColor whiteColor]
                                         Alignment:NSTextAlignmentLeft
                                           Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                             Padre:contenedorfecha];
        
        // Creamos el texto de la oferta
        self.nombre = [[SPLabel alloc] initWithFrame:CGRectMake(5, 0, screenWidth - 45, 20)
                                                Text:@""
                                                Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]
                                           TextColor:RGB(97, 168, 221)
                                           Alignment:NSTextAlignmentLeft
                                             Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                               Padre:contenedordatos];
        
        // Creamos el texto de la empresa
        self.empresa = [[SPLabel alloc] initWithFrame:CGRectMake(23, 20, screenWidth - 50, 15)
                                                 Text:@""
                                                 Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]
                                            TextColor:RGB(93, 99, 107)
                                            Alignment:NSTextAlignmentLeft
                                              Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                Padre:contenedordatos];
        
        // Establecemos la imagen de la distancia
        UIImageView * imagenubicacion = [[UIImageView alloc] initWithFrame:CGRectMake(5, 21, 16, 16)];
        imagenubicacion.image         = [UIImage imageNamed:@"ubicacion.png"];
        [contenedordatos addSubview:imagenubicacion];
        
        // Establecemos la imagen de la distancia
        UIImageView * imagencoche = [[UIImageView alloc] initWithFrame:CGRectMake(5, 33, 16, 16)];
        imagencoche.image         = [UIImage imageNamed:@"distancia.png"];
        [contenedordatos addSubview:imagencoche];
        
        // Creamos el texto de la distancia
        self.kilometros = [[SPLabel alloc] initWithFrame:CGRectMake(25, 33, 75, 20)
                                                    Text:@""
                                                    Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]
                                               TextColor:RGB(93, 99, 107)
                                               Alignment:NSTextAlignmentLeft
                                                 Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                   Padre:contenedordatos];
        
        // Si es favorito o no
        self.favorito       = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 33, 20, 32, 32)];
        self.favorito.image = [UIImage imageNamed:@"favorito.png"];
        [contenedordatos addSubview:self.favorito];
        
        // Banda separadora
        UIView * separacion        = [[UIView alloc] initWithFrame:CGRectMake(0, 51, screenWidth, 1)];
        separacion.backgroundColor = RGB(97, 168, 221);
        [contenedordatos addSubview:separacion];
        
        // Inicializamos el logo
        self.logo = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 45, 75, 42, 42)];
        [self.logo setContentMode:UIViewContentModeScaleToFill];
        self.logo.layer.cornerRadius = 21.0f;
        self.logo.layer.masksToBounds = YES;
        self.logo.layer.borderColor = [RGB(97, 168, 221) CGColor];
        self.logo.layer.borderWidth = 1.0f;
        // Añadimos el elemento a la vista
        [self addSubview:self.logo];
        
        // La celda es transparente
        self.backgroundColor = [UIColor clearColor];
        
        // Color de la selección
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
