//
//  NOMeLlevasViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 10/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import <MapKit/MapKit.h>
#import "LocationService.h"
#import "SPUtilidades.h"
#import "NOIndicacionTableViewCell.h"
#import <JPSThumbnail.h>
#import <JPSThumbnailAnnotation.h>

@interface NOMeLlevasViewController : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) CLLocationCoordinate2D origen;
@property (nonatomic) CLLocationCoordinate2D destino;
@property (nonatomic, strong) UIView * panelTabs;
@property (nonatomic, strong) UITableView * tabla;
@property (nonatomic, strong) SPLabel * distancia;
@property (nonatomic) NSString * nombreempresa;
@property (nonatomic) NSString * nombreoferta;
@property (nonatomic) NSString * imagenempresa;
@property (nonatomic, strong) MKMapView * mapa;
@property (nonatomic) int seleccionada;
@property (nonatomic, strong) NSArray * indicaciones;
@property (nonatomic, strong) UIButton * coche;
@property (nonatomic, strong) UIButton * andando;
@property (nonatomic, strong) MKDirectionsRequest * directionsRequest;

// Inicializador
-(id) initWithDestino: (CLLocationCoordinate2D) destino
              Empresa: (NSString *) empresa
               Oferta: (NSString *) oferta
               Imagen: (NSString *) imagen;
@end
