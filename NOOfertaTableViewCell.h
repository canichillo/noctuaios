//
//  NOOfertaTableViewCell.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 23/7/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import <QuartzCore/QuartzCore.h>

@interface NOOfertaTableViewCell : UITableViewCell
@property (nonatomic ,strong) UIImageView * logo;
@property (nonatomic ,strong) UIImageView * imagen;
@property (nonatomic, strong) SPLabel * dia;
@property (nonatomic, strong) SPLabel * mes;
@property (nonatomic, strong) SPLabel * hora;
@property (nonatomic, strong) SPLabel * nombre;
@property (nonatomic, strong) SPLabel * empresa;
@property (nonatomic, strong) SPLabel * kilometros;
@property (nonatomic, strong) UIImageView * favorito;
@end
