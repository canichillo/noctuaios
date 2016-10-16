//
//  NOClusterAnnotationView.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 27/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <SDWebImageManager.h>
#import "SPUtilidades.h"    

@interface NOClusterAnnotationView : MKAnnotationView
@property (nonatomic) NSUInteger count;
@property (nonatomic, getter = isUniqueLocation) BOOL uniqueLocation;
@property (nonatomic) UILabel *countLabel;
@property (nonatomic) int idEmpresa;
@property (nonatomic, strong) NSString * tipo;
@property (nonatomic, strong) NSString * logo;
@end
