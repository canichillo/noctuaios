#import "MTLModel.h"
#import "Mantle/Mantle.h"
#import "Amigo.h"

@interface Amigo () <MTLJSONSerializing>

@property (copy, nonatomic) NSDictionary *amigoData;

@end

@implementation Amigo
#pragma mark - Mantle related methods
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"usuario"     : @"usuario",
             @"nombre"      : @"nombre",
             @"imagen"      : @"imagen",
             @"so"          : @"so",
             @"dispositivo" : @"dispositivo",
             @"estado"      : @"estado",
             @"amistad"     : @"amistad",
             };
}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (Amigo *) amigo
{
    NSError *error;
    Amigo * amigo = [MTLJSONAdapter modelOfClass:[Amigo class] fromJSONDictionary:_amigoData error:&error];
    if (error) NSAssert(NO, @"Error creando amigo modelo");
    
    return amigo;
}

/////////////////////////////
// Constructor por defecto //
/////////////////////////////
-(id) initWithUsuario:(NSNumber *) usuario
               Nombre:(NSString *) nombre
               Imagen:(NSString *) imagen
                   SO:(NSString *) so
          Dispositivo:(NSString *) dispositivo
               Estado:(NSString *) estado
              Amistad:(NSNumber *) amistad
{
    // Inicializamos el objeto
    if (self = [super init])
    {
        // Asignamos los parámetros a las variables de instancia
        // En los constructores debemos acceder directamente a las variables de instancia
        // creadas por Objective-C
        _usuario     = usuario;
        _nombre      = nombre;
        _imagen      = imagen;
        _so          = so;
        _dispositivo = dispositivo;
        _estado      = estado;
        _amistad     = amistad;
    }
    
    // Devolvemos el objeto creado
    return self;
}

///////////////////////////////////////////////////////
// Convierte una respuesta JSON en un array de amigo //
///////////////////////////////////////////////////////
+(NSArray *) consumirLista:(id) respuesta
{
    // Creamos el array de datos
    NSMutableArray *datos = [[NSMutableArray alloc] initWithCapacity:[respuesta count]];
    
    // Para cada uno de los elementos
    for (NSDictionary *JSONData in respuesta)
    {
        // Convertimos el dato JSON a la clase Oferta
        Amigo * amigo = (Amigo *) [MTLJSONAdapter modelOfClass:[Amigo class] fromJSONDictionary:JSONData error:nil];
        if (amigo) [datos addObject:amigo];
    }
    
    // Devolvemos los datos
    return datos;
}
@end

