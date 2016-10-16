//
//  NOCuponTableViewCell.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 14/10/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import "MCSwipeTableViewCell.h"

@interface NOCuponTableViewCell : MCSwipeTableViewCell
@property (nonatomic ,strong) UIImageView * logo;
@property (nonatomic, strong) SPLabel * dia;
@property (nonatomic, strong) SPLabel * mes;
@property (nonatomic, strong) SPLabel * hora;
@property (nonatomic, strong) SPLabel * nombre;
@property (nonatomic, strong) SPLabel * empresa;
@property (nonatomic, strong) UIView * gastada;
@end
