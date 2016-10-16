//
//  NODesactivacionOfertaTableViewCell.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 13/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NODesactivacionOfertaCollectionViewCell.h"

@implementation NODesactivacionOfertaCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        // Creamos el estado
        self.numero = [[SPLabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)
                                                Text:@""
                                                Font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]
                                           TextColor:RGB(97, 168, 221)
                                           Alignment:NSTextAlignmentCenter
                                             Padding:UIEdgeInsetsMake(0, 0, 0, 0)
                                               Padre:self];
        self.numero.layer.borderWidth   = 2.0f;
        self.numero.layer.borderColor   = [RGB(97, 168, 221) CGColor];
        self.numero.layer.cornerRadius  = 6.0f;
        self.numero.layer.masksToBounds = YES;
        self.numero.backgroundColor     = [UIColor whiteColor];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}
@end
