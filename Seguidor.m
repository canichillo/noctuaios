//
//  Seguidor.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 3/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "Seguidor.h"

@interface Seguidor () <MTLJSONSerializing>

@property (copy, nonatomic) NSDictionary *seguidorData;

@end

@implementation Seguidor
///////////////////////
// MÉTODOS DE MANTLE //
///////////////////////
#pragma mark - Mantle related methods
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"codigo"      : @"id",
             @"nombre"      : @"nombre",
             @"imagen"      : @"imagen",
             @"so"          : @"so",
             @"dispositivo" : @"dispositivo",
             @"amigo"       : @"amigo",
             @"idamigo"     : @"idamigo",
             };
}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (Seguidor *) seguidor
{
    NSError *error;
    Seguidor * seguidor = [MTLJSONAdapter modelOfClass:[Seguidor class] fromJSONDictionary:_seguidorData error:&error];
    if (error) NSAssert(NO, @"Error creando seguidor modelo");
    
    return seguidor;
}

/////////////////////////////
// Constructor por defecto //
/////////////////////////////
-(id) initWithCodigo:(NSNumber *) codigo
              Nombre:(NSString *) nombre
              Imagen:(NSString *) imagen
                  SO:(NSString *) so
         Dispositivo:(NSString *) dispositivo
               Amigo:(NSString *) amigo
             IDAmigo:(NSNumber *) idamigo
{
    // Inicializamos el objeto
    if (self = [super init])
    {
        // Asignamos los parámetros a las variables de instancia
        // En los constructores debemos acceder directamente a las variables de instancia
        // creadas por Objective-C
        _codigo      = codigo;
        _nombre      = nombre;
        _imagen      = imagen;
        _so          = so;
        _dispositivo = dispositivo;
        _amigo       = amigo;
        _idamigo     = idamigo;
    }
    
    // Devolvemos el objeto creado
    return self;
}

//////////////////////////////////////////////////////////
// Convierte una respuesta JSON en un array de seguidor //
//////////////////////////////////////////////////////////
+(NSArray *) consumirLista:(id) respuesta
{
    // Creamos el array de datos
    NSMutableArray *datos = [[NSMutableArray alloc] initWithCapacity:[respuesta count]];
    
    // Para cada uno de los elementos
    for (NSDictionary *JSONData in respuesta)
    {
        // Convertimos el dato JSON a la clase Oferta
        Seguidor * seguidor = (Seguidor *) [MTLJSONAdapter modelOfClass:[Seguidor class] fromJSONDictionary:JSONData error:nil];
        if (seguidor) [datos addObject:seguidor];
    }
    
    // Devolvemos los datos
    return datos;
}
@end
