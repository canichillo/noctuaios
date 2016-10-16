//
//  NOEmpresaViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 31/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhotoBrowser.h"
#import "Empresa.h"
#import "NOSeguidoresViewController.h"
#import "NOCuponesViewController.h"
#import "NOSeguidoresViewController.h"
#import "SPUtilidades.h"
@class AFImagePager;

@interface NOEmpresaViewController : UIViewController<MKMapViewDelegate, MWPhotoBrowserDelegate>
@property (nonatomic) int empresa;
@property (nonatomic) AFImagePager * pagerimagenes;
@property (nonatomic, strong) UIImageView * imagen;
@property (nonatomic, strong) SPLabel * nombre;
@property (nonatomic) Empresa * datosempresa;
@property (nonatomic, strong) UIScrollView * scroll;
@property (nonatomic, strong) SPLabel * descripcion;
@property (nonatomic, strong) MKMapView * mapa;
@property (nonatomic) BOOL mellevas;
@property (nonatomic) NSMutableArray * imagenes;
@property (nonatomic) NSMutableArray * photos;
@property (nonatomic, strong) UIView * panelInferior;
@property (nonatomic, strong) SPLabel * textocargando;
@property (nonatomic, strong) UIView * seguimiento;
@property (nonatomic, strong) SPLabel * numseguidores;

-(id) initWithEmpresa: (int) empresa
               Llevas: (BOOL) llevas;
@end
