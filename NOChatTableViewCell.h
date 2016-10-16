//
//  NOChatTableViewCell.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 8/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import "MCSwipeTableViewCell.h"

@interface NOChatTableViewCell : MCSwipeTableViewCell
@property (nonatomic ,strong) UIImageView * imagen;
@property (nonatomic, strong) SPLabel * nombre;
@property (nonatomic, strong) SPLabel * dispositivo;
@property (nonatomic, strong) UIImageView * so;
@end
