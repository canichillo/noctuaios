//
//  Empresa.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 1/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "Empresa.h"

@interface Empresa () <MTLJSONSerializing>

@property (copy, nonatomic) NSDictionary *empresaData;

@end

@implementation Empresa
///////////////////////
// MÉTODOS DE MANTLE //
///////////////////////
#pragma mark - Mantle related methods
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"codigo"      : @"id",
             @"nombre"      : @"nombre",
             @"latitud"     : @"latitud",
             @"longitud"    : @"longitud",
             @"logo"        : @"logo",
             @"favorito"    : @"favorito",
             @"descripcion" : @"descripcion",
             @"poblacion"   : @"poblacion",
             @"twitter"     : @"twitter",
             @"facebook"    : @"facebook",
             @"telefonos"   : @"telefonos",
             @"email"       : @"email",
             @"web"         : @"web",
             @"seguidores"  : @"seguidores",
             };
}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (Empresa *) empresa
{
    NSError *error;
    Empresa * empresa = [MTLJSONAdapter modelOfClass:[Empresa class] fromJSONDictionary:_empresaData error:&error];
    if (error) NSAssert(NO, @"Error creando empresa modelo");
    
    return empresa;
}

/////////////////////////////
// Constructor por defecto //
/////////////////////////////
-(id) initWithCodigo:(NSNumber *) codigo
              Nombre:(NSString *) nombre
                Logo:(NSString *) logo
             Latitud:(NSNumber *) latitud
            Longitud:(NSNumber *) longitud
         Descripcion:(NSString *) descripcion
           Poblacion:(NSString *) poblacion
            Favorito:(NSString *) favorito
             Twitter:(NSString *) twitter
            Facebook:(NSString *) facebook
           Telefonos:(NSString *) telefonos
               Email:(NSString *) email
                 Web:(NSString *) web
          Seguidores:(NSNumber *) seguidores
{
    // Inicializamos el objeto
    if (self = [super init])
    {
        // Asignamos los parámetros a las variables de instancia
        // En los constructores debemos acceder directamente a las variables de instancia
        // creadas por Objective-C
        _codigo      = codigo;
        _nombre      = nombre;
        _logo        = logo;
        _latitud     = latitud;
        _longitud    = longitud;
        _favorito    = favorito;
        _descripcion = descripcion;
        _poblacion   = poblacion;
        _twitter     = twitter;
        _facebook    = facebook;
        _telefonos   = telefonos;
        _web         = web;
        _email       = email;
        _seguidores  = seguidores;
    }
    
    // Devolvemos el objeto creado
    return self;
}

/////////////////////////////////////////////////////////
// Convierte una respuesta JSON en un array de empresa //
/////////////////////////////////////////////////////////
+(NSArray *) consumirLista:(id) respuesta
{
    // Creamos el array de datos
    NSMutableArray *datos = [[NSMutableArray alloc] initWithCapacity:[respuesta count]];
    
    // Para cada uno de los elementos
    for (NSDictionary *JSONData in respuesta)
    {
        // Convertimos el dato JSON a la clase Oferta
        Empresa * empresa = (Empresa *) [MTLJSONAdapter modelOfClass:[Empresa class] fromJSONDictionary:JSONData error:nil];
        if (empresa) [datos addObject:empresa];
    }
    
    // Devolvemos los datos
    return datos;
}
@end
