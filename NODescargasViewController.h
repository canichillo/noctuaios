//
//  NODescargasViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 2/11/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import "Seguidor.h"
#import "NOSeguidorTableViewCell.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import <M13ProgressHUD.h>
#import <M13ProgressViewRing.h>
#import "JGActionSheet.h"

@interface NODescargasViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * tabla;
@property (nonatomic) int oferta;
@property (nonatomic) NSMutableArray * seguidores;
@property (nonatomic, strong) NSNumber * codigoseguidor;

-(id) initWithOferta: (int) oferta;
@end
