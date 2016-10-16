//
//  NOCuponesViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 6/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import "LocationService.h"
#import "Cupon.h"
#import "NOCuponTableViewCell.h"
#import "NOMapaViewController.h"
#import "NOOfertasViewController.h"
#import "NODesactivacionOfertaViewController.h"
#import <SDWebImageManager.h>
#import "MCSwipeTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface NOCuponesViewController : UIViewController <MCSwipeTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) BOOL atras;
@property (nonatomic) BOOL internet;
@property (nonatomic, strong) UITableView * tabla;
@property (nonatomic, strong) UIView * panelTipos;
@property (nonatomic, strong) MCSwipeTableViewCell *cellToDelete;

// Nuestro listado de cupones
@property (nonatomic) NSMutableArray * listacupones;

-(id) initWithAtras: (BOOL) back
           Internet: (BOOL) inter;
@end
