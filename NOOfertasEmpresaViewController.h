//
//  NOOfertasEmpresaViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 31/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SPUtilidades.h"
#import "NOOfertaTableViewCell.h"
#import "NOOfertaViewController.h"
#import "Oferta.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>

@interface NOOfertasEmpresaViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * tabla;
@property (nonatomic) int empresa;
@property (nonatomic) CLLocationCoordinate2D ubicacion;
@property (nonatomic) NSMutableArray * listaofertas;

-(id) initWithEmpresa: (int) empresa
            Ubicacion: (CLLocationCoordinate2D) ubicacion;
@end
