//
//  NOSeguidorTableViewCell.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 4/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOSeguidorTableViewCell.h"

@implementation NOSeguidorTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        // Inicializamos la imagen del seguidor
        self.imagen = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 48, 48)];
        [self.imagen setContentMode:UIViewContentModeScaleToFill];
        self.imagen.layer.cornerRadius  = roundf(self.imagen.frame.size.height) / 2;
        self.imagen.layer.masksToBounds = YES;
        // Añadimos el elemento a la vista
        [self addSubview:self.imagen];
        
        // Inicializamos la imagen del tipo de so
        self.so = [[UIImageView alloc] initWithFrame:CGRectMake(57, 20, 14, 14)];
        [self.so setContentMode:UIViewContentModeScaleToFill];
        // Añadimos el elemento a la vista
        [self addSubview:self.so];
        
        // Creamos el nombre
        self.nombre = [[SPLabel alloc] initWithFrame:CGRectMake(57, 2, screenWidth - 87, 20)
                                                Text:@""
                                                Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]
                                           TextColor:RGB(97, 168, 221)
                                           Alignment:NSTextAlignmentLeft
                                             Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                               Padre:self];
        
        // Creamos el dispositivo
        self.dispositivo = [[SPLabel alloc] initWithFrame:CGRectMake(74, 17, screenWidth - 100, 20)
                                                     Text:@""
                                                     Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]
                                                TextColor:[UIColor blackColor]
                                                Alignment:NSTextAlignmentLeft
                                                  Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                    Padre:self];
        
        // Creamos el estado
        self.amigo = [[SPLabel alloc] initWithFrame:CGRectMake(57, 32, screenWidth - 87, 20)
                                               Text:@""
                                               Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]
                                          TextColor:[UIColor blackColor]
                                          Alignment:NSTextAlignmentLeft
                                            Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                              Padre:self];
        
        // Banda separadora
        UIView * separacion        = [[UIView alloc] initWithFrame:CGRectMake(0, 53, screenWidth, 1)];
        separacion.backgroundColor = [RGB(97, 168, 221) colorWithAlphaComponent:0.4f];
        [self addSubview:separacion];
        
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
