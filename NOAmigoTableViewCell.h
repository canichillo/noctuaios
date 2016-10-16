//
//  NOAmigoTableViewCell.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 5/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"

@interface NOAmigoTableViewCell : UITableViewCell
@property (nonatomic ,strong) UIImageView * imagen;
@property (nonatomic, strong) SPLabel * nombre;
@property (nonatomic, strong) SPLabel * dispositivo;
@property (nonatomic, strong) SPLabel * amigo;
@property (nonatomic, strong) UIImageView * so;
@end
