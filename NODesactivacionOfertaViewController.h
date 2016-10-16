//
//  NODesactivacionOfertaViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 12/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import "Cupon.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import "NOEmpresaViewController.h"
#import "NODesactivacionOfertaCollectionViewCell.h"

@interface NODesactivacionOfertaViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) int oferta;
@property (nonatomic) int numerodisponibles;
@property (nonatomic) int numelementos;
@property (nonatomic, strong) UIImageView * imagen;
@property (nonatomic, strong) SPLabel * nombre;
@property (nonatomic, strong) SPLabel * fecha;
@property (nonatomic, strong) SPLabel * hora;
@property (nonatomic, strong) SPLabel * textocargando;
@property (nonatomic) Cupon * datosoferta;
@property (strong, nonatomic) UICollectionView * grideliminacion;
@property (nonatomic) SPLabel * seleccionados1;
@property (nonatomic) SPLabel * seleccionadosnum;
@property (nonatomic) SPLabel * seleccionados2;
@property (nonatomic) SPLabel * disponibles;
@property (nonatomic) SPLabel * textodesactivacion;
@property (nonatomic, strong) UIView * linea2;

-(id) initWithOferta: (int) oferta;
@end
