//
//  Empresa.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 1/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle/Mantle.h"

@interface Empresa : MTLModel<MTLJSONSerializing>
// Variables
@property (strong, nonatomic) NSNumber* codigo;
@property (strong, nonatomic) NSString* nombre;
@property (strong, nonatomic) NSString* logo;
@property (strong, nonatomic) NSNumber* latitud;
@property (strong, nonatomic) NSNumber* longitud;
@property (strong, nonatomic) NSString* descripcion;
@property (strong, nonatomic) NSString* direccion;
@property (strong, nonatomic) NSString* poblacion;
@property (strong, nonatomic) NSString* favorito;
@property (strong, nonatomic) NSString* twitter;
@property (strong, nonatomic) NSString* facebook;
@property (strong, nonatomic) NSString* telefonos;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* web;
@property (strong, nonatomic) NSNumber* seguidores;

// Convierte los datos recibidos por un servicio web en una lista de empresas
+(NSMutableArray *) consumirLista:(id) respuesta;
@end
