//
//  NOMenuTableViewCell.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 1/11/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOMenuTableViewCell.h"

@implementation NOMenuTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        self.backgroundColor = [UIColor clearColor];
        
        // Inicializamos la imagen del seguidor
        self.imagen = [[UIImageView alloc] initWithFrame:CGRectMake(18, 0, 32, 32)];
        [self.imagen setContentMode:UIViewContentModeScaleAspectFit];
        // Añadimos el elemento a la vista
        [self addSubview:self.imagen];
        
        // Establecemos el texto
        self.texto                      = [[UILabel alloc] initWithFrame: CGRectMake(60, 5, screenWidth - 55, 22)];
        self.texto.font                 = [UIFont fontWithName:@"HelveticaNeue" size:19];
        self.texto.textColor            = [UIColor whiteColor];
        self.texto.highlightedTextColor = [UIColor whiteColor];
        [self addSubview:self.texto];
        
        // Color de la selección
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
