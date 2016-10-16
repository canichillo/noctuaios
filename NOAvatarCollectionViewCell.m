//
//  NOAvatarCollectionViewCell.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 19/7/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOAvatarCollectionViewCell.h"

@implementation NOAvatarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameRect.size.width, frameRect.size.height)];
        [self.imageView setContentMode:UIViewContentModeScaleToFill];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius  = 6.0f;
        
        // Añadimos el elemento a la vista
        [self addSubview:self.imageView];        
        
        // Inicializamos el background
        self.layer.borderColor     = [RGB(63, 157, 217) CGColor];
        self.layer.borderWidth     = 2.0f;
        self.layer.backgroundColor = [[RGB(217, 235, 247) colorWithAlphaComponent:0.5f] CGColor];
        self.layer.cornerRadius    = 3.0f;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

@end
