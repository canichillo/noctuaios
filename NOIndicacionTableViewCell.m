//
//  NOIndicacionTableViewCell.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 22/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOIndicacionTableViewCell.h"

@implementation NOIndicacionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        // Creamos el texto de la descripción de la indicación
        self.descripcion = [[SPLabel alloc] initWithFrame:CGRectMake(5, 0, screenWidth - 10, 30)
                                                     Text:@""
                                                     Font:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]
                                                TextColor:RGB(97, 168, 221)
                                                Alignment:NSTextAlignmentLeft
                                                  Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                    Padre:self];
        self.descripcion.numberOfLines = 0;
        
        // Creamos el texto de la distancia
        self.distancia = [[SPLabel alloc] initWithFrame:CGRectMake(5, 30, screenWidth - 10, 20)
                                                   Text:@""
                                                   Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]
                                              TextColor:RGB(97, 168, 221)
                                              Alignment:NSTextAlignmentLeft
                                                Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                                  Padre:self];
        self.distancia.numberOfLines = 0;
        
        // Banda separadora
        UIView * separacion        = [[UIView alloc] initWithFrame:CGRectMake(0, 49, screenWidth, 1)];
        separacion.backgroundColor = RGB(230, 230, 230);
        [self addSubview:separacion];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
