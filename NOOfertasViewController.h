//
//  NOOfertasViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 22/7/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import "SPScrollViewController.h"
#import "Oferta.h"
#import "NOOfertaTableViewCell.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import <SVPullToRefresh.h>
#import "LocationService.h"
#import "NOMapaViewController.h"
#import "NOCuponesViewController.h"

@interface NOOfertasViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * tabla;
@property (nonatomic, strong) SPLabel * textovacio;
@property (nonatomic, strong) UIView * panelTipos;

// Nuestro listado de ofertas
@property (nonatomic) NSMutableArray * listaofertas;
@property (nonatomic) NSArray * ofertas;
@property (nonatomic, assign) int seleccionada;
@property (nonatomic) CLLocation * ubicacion;
@property (nonatomic) int posicionScroll;
@end
