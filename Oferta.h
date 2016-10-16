//
//  Oferta.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 10/7/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle/Mantle.h"

@interface Oferta : MTLModel <MTLJSONSerializing>
// Variables
@property (strong, nonatomic) NSNumber* codigo;
@property (strong, nonatomic) NSString* nombre;
@property (strong, nonatomic) NSString* empresa;
@property (strong, nonatomic) NSNumber * idempresa;
@property (strong, nonatomic) NSString * logo;
@property (strong, nonatomic) NSString * imagen;
@property (strong, nonatomic) NSNumber* kilometros;
@property (strong, nonatomic) NSDate* inicio;
@property (strong, nonatomic) NSDate* fin;
@property (strong, nonatomic) NSString* favorito;
@property (strong, nonatomic) NSString* adquirida;
@property (strong, nonatomic) NSString* descripcion;
@property (strong, nonatomic) NSString* tipo;
@property (strong, nonatomic) NSNumber *disponibles;
@property (strong, nonatomic) NSNumber *password;

// Convierte los datos recibidos por un servicio web en una lista de ofertas
+(NSMutableArray *) consumirLista:(id) respuesta;
@end
