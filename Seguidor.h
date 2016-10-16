//
//  Seguidor.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 3/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle/Mantle.h"

@interface Seguidor : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSNumber * codigo;
@property (nonatomic, strong) NSString * nombre;
@property (nonatomic, strong) NSString * dispositivo;
@property (nonatomic, strong) NSString * so;
@property (nonatomic, strong) NSString * imagen;
@property (nonatomic, strong) NSString * amigo;
@property (nonatomic, strong) NSNumber * idamigo;

// Convierte los datos recibidos por un servicio web en una lista de ofertas
+(NSMutableArray *) consumirLista:(id) respuesta;
@end
