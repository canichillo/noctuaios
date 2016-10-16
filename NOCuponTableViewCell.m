//
//  NOCuponTableViewCell.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 14/10/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOCuponTableViewCell.h"

@implementation NOCuponTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        // Contenedor de datos
        UIView * contenedordatos        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 52)];
        contenedordatos.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95f];
        [self addSubview:contenedordatos];
        
        // Vista donde estarán los datos de la fecha y hora
        UIView * contenedorfecha          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 52)];
        contenedorfecha.backgroundColor   = [RGB(114, 121, 129) colorWithAlphaComponent:0.95f];
        contenedorfecha.layer.borderWidth = 1.0f;
        contenedorfecha.layer.borderColor = [RGB(151, 155, 161) CGColor];
        [self addSubview:contenedorfecha];
        
        // Creamos el texto del nombre del día
        self.dia = [[SPLabel alloc] initWithFrame:CGRectMake(3, 1, 50, 20)
                                             Text:@""
                                             Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:22.0f]
                                        TextColor:[UIColor whiteColor]
                                        Alignment:NSTextAlignmentLeft
                                          Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                            Padre:contenedorfecha];
        
        // Creamos el texto del nombre del mes
        self.mes = [[SPLabel alloc] initWithFrame:CGRectMake(3, 19, 50, 20)
                                             Text:@""
                                             Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]
                                        TextColor:[UIColor whiteColor]
                                        Alignment:NSTextAlignmentLeft
                                          Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                            Padre:contenedorfecha];
        
        // Creamos el texto de la hora
        self.hora = [[SPLabel alloc] initWithFrame:CGRectMake(3, 34, 50, 20)
                                              Text:@""
                                              Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]
                                         TextColor:[UIColor whiteColor]
                                         Alignment:NSTextAlignmentLeft
                                           Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                             Padre:contenedorfecha];
        
        // Creamos el texto de la oferta
        self.nombre = [[SPLabel alloc] initWithFrame:CGRectMake(45, 0, screenWidth - 85, 35)
                                                Text:@""
                                                Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]
                                           TextColor:RGB(97, 168, 221)
                                           Alignment:NSTextAlignmentLeft
                                             Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                               Padre:contenedordatos];
        self.nombre.lineBreakMode = NSLineBreakByCharWrapping;
        self.nombre.numberOfLines = 0;
        
        // Creamos el texto de la empresa
        self.empresa = [[SPLabel alloc] initWithFrame:CGRectMake(45, 30, screenWidth - 85, 15)
                                                 Text:@""
                                                 Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]
                                            TextColor:RGB(93, 99, 107)
                                            Alignment:NSTextAlignmentLeft
                                              Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                Padre:contenedordatos];
        
        // Inicializamos la imagen de la empresa
        self.logo = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 38, 1, 49, 49)];
        [self.logo setContentMode:UIViewContentModeScaleToFill];
        self.logo.layer.cornerRadius  = roundf(self.logo.frame.size.width / 2.0f);
        self.logo.layer.masksToBounds = YES;
        self.logo.alpha = 0.8F;
        // Añadimos el elemento a la vista
        [self addSubview:self.logo];
        
        // Vista de gastada
        self.gastada = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 52)];
        self.gastada.backgroundColor = [RGB(97, 168, 221) colorWithAlphaComponent:0.4f];
        [self addSubview:self.gastada];
        
        SPLabel * consumido = [[SPLabel alloc] initWithFrame:CGRectMake(-2, 23, 90, 20)
                                                        Text:@"Consumido"
                                                        Font:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]
                                                   TextColor:[UIColor whiteColor]
                                                   Alignment:NSTextAlignmentCenter
                                                     Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                       Padre:self.gastada];
        consumido.layer.borderWidth = 2.0f;
        consumido.layer.borderColor = [[UIColor whiteColor] CGColor];
        consumido.backgroundColor   = [[UIColor redColor] colorWithAlphaComponent:0.7f];
        
        
        // Banda separadora
        UIView * separacion        = [[UIView alloc] initWithFrame:CGRectMake(0, 51, screenWidth, 1)];
        separacion.backgroundColor = RGB(230, 230, 230);
        [contenedordatos addSubview:separacion];
        
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
