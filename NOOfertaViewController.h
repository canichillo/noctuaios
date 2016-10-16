//
//  NOOfertaViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 29/7/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPScrollViewController.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import "Oferta.h"
#import "NOMeLlevasViewController.h"
#import "NOEmpresaViewController.h"
#import "NODescargasViewController.h"
#import <MTLModel.h>

@interface NOOfertaViewController : UIViewController
@property (nonatomic) int oferta;
@property (nonatomic, strong) UIImageView * logo;
@property (nonatomic, strong) UIImageView * imagen;
@property (nonatomic, strong) SPLabel * nombreoferta;
@property (nonatomic, strong) SPLabel * nombreempresa;
@property (nonatomic, strong) SPLabel * fecha;
@property (nonatomic, strong) SPLabel * hora;
@property (nonatomic, strong) SPLabel * descripcion;
@property (nonatomic, strong) UIScrollView * scroll;
@property (nonatomic, strong) SPLabel * textocargando;
@property (nonatomic, strong) UIView * panelInferior;
@property (nonatomic, strong) UIView * adquisicion;
@property (nonatomic, strong) SPLabel * numdescargas;
@property (nonatomic, strong) UIButton * mellevas;
@property (nonatomic) Oferta * datosoferta;
@property (nonatomic) CLLocationCoordinate2D ubicacionempresa;
@property (nonatomic) BOOL llevas;

-(id) initWithOferta: (int) oferta
              Llevas: (BOOL) llevas;
@end
