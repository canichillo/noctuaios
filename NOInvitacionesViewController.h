//
//  NOInvitacionesViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 6/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import "LocationService.h"
#import "Oferta.h"
#import "NOOfertaTableViewCell.h"
#import "NOOfertaViewController.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>

@interface NOInvitacionesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * tabla;
@property (nonatomic) CLLocation * ubicacion;

// Nuestro listado de ofertas
@property (nonatomic) NSMutableArray * listaofertas;

@end
