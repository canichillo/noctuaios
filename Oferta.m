//
//  Oferta.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 10/7/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "Oferta.h"

@interface Oferta () <MTLJSONSerializing>

@property (copy, nonatomic) NSDictionary *ofertaData;

@end

@implementation Oferta
///////////////////////
// MÉTODOS DE MANTLE //
///////////////////////
#pragma mark - Mantle related methods
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"codigo"      : @"id",
             @"nombre"      : @"nombre",
             @"empresa"     : @"empresa",
             @"kilometros"  : @"distancia",
             @"logo"        : @"logo",
             @"imagen"      : @"imagen",             
             @"inicio"      : @"inicio",
             @"fin"         : @"fin",
             @"favorito"    : @"favorito",
             @"descripcion" : @"descripcion",
             @"adquirida"   : @"adquirida",
             @"idempresa"   : @"idempresa",
             @"tipo"        : @"tipo",
             @"disponibles" : @"disponibles",
             @"password"    : @"password",
            };
}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (Oferta *) oferta
{
    NSError *error;
    Oferta * oferta = [MTLJSONAdapter modelOfClass:[Oferta class] fromJSONDictionary:_ofertaData error:&error];
    if (error) NSAssert(NO, @"Error creando oferta modelo");
    
    return oferta;
}

/////////////////////////////
// Constructor por defecto //
/////////////////////////////
-(id) initWithCodigo:(NSNumber *) codigo
              Nombre:(NSString *) nombre
             Empresa:(NSString *) empresa
                Logo:(NSString *) logo
          Kilometros:(NSNumber *) kilometros
              Inicio:(NSDate *) inicio
                 Fin:(NSDate *) fin
            Favorito:(NSString *) favorito
         Descripcion:(NSString *) descripcion
           Adquirida:(NSString *) adquirida
                Tipo:(NSString *) tipo
           IDEmpresa:(NSNumber *) idempresa
         Disponibles:(NSNumber *) disponibles
            Password:(NSNumber *) password
{
    // Inicializamos el objeto
    if (self = [super init])
    {
        // Asignamos los parámetros a las variables de instancia
        // En los constructores debemos acceder directamente a las variables de instancia
        // creadas por Objective-C
        _codigo      = codigo;
        _nombre      = nombre;
        _empresa     = empresa;
        _logo        = logo;
        _kilometros  = kilometros;
        _inicio      = inicio;
        _fin         = fin;
        _favorito    = favorito;
        _descripcion = descripcion;
        _adquirida   = adquirida;
        _tipo        = tipo;
        _idempresa   = idempresa;
        _disponibles = disponibles;
        _password    = password;
    }
    
    // Devolvemos el objeto creado
    return self;
}

//////////////////////////////
// Mapea la fecha de inicio //
//////////////////////////////
+ (NSValueTransformer *) inicioJSONTransformer {
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

///////////////////////////
// Mapea la fecha de fin //
///////////////////////////
+ (NSValueTransformer *) finJSONTransformer {
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

// by the way, creating NSDateFormatters is expensive.  So we create a static instance...
+ (NSDateFormatter *)dateFormatter {
    
    static NSDateFormatter *kDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kDateFormatter = [[NSDateFormatter alloc] init];
        kDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        kDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";  // you configure this based on the strings that your webservice uses!!
    });
    
    return kDateFormatter;
}

/////////////////////////////////////////////////////////
// Convierte una respuesta JSON en un array de ofertas //
/////////////////////////////////////////////////////////
+(NSArray *) consumirLista:(id) respuesta
{
    // Creamos el array de datos
    NSMutableArray *datos = [[NSMutableArray alloc] initWithCapacity:[respuesta count]];
    
    // Para cada uno de los elementos
    for (NSDictionary *JSONData in respuesta)
    {
        NSError * error = nil;
        // Convertimos el dato JSON a la clase Oferta
        Oferta * oferta = (Oferta *) [MTLJSONAdapter modelOfClass:[Oferta class] fromJSONDictionary:JSONData error:&error];
       
        if (oferta) [datos addObject:oferta];
    }
    
    // Devolvemos los datos
    return datos;
}
@end
