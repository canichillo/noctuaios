//
//  NOAmigosViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 5/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import "Amigo.h"
#import "NOAmigoTableViewCell.h"
#import "NOOfertasAmigoViewController.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import "JGActionSheet.h"

@interface NOAmigosViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) UITableView * tabla;
@property (nonatomic) NSMutableArray * amigos;
@property (nonatomic, strong) NSNumber * codigoamigo;
@end
