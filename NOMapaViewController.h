//
//  NOMapaViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 26/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CCHMapClusterer.h>
#import <CCHMapClusterController.h>
#import <CCHMapClusterControllerDelegate.h>
#import <CCHMapClusterAnnotation.h>
#import "SPUtilidades.h"
#import "NOClusterAnnotationView.h"
#import "NOPointAnnotation.h"
#import "LocationService.h"
#import "NOOfertaViewController.h"
#import "NOOfertasEmpresaViewController.h"
#import "NOOfertasViewController.h"

@interface NOMapaViewController : UIViewController<CCHMapClusterControllerDelegate, MKMapViewDelegate>
@property (nonatomic) BOOL atras;
@property (nonatomic, strong) MKMapView * mapa;
@property (strong, nonatomic) CCHMapClusterController *mapClusterController;
@property (nonatomic) id<CCHMapClusterer> mapClusterer;
@property (nonatomic) id<CCHMapAnimator> mapAnimator;
@property (nonatomic) CLLocation * ubicacion;
@property (nonatomic) int empresa;
@property (nonatomic, strong) UIView * panelTipos;

-(id) initWithAtras: (BOOL) back;
@end
