//
//  NOPointAnnotation.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 30/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface NOPointAnnotation : MKPointAnnotation
@property (nonatomic) int idEmpresa;
@property (nonatomic, strong) NSString * tipo;
@end
