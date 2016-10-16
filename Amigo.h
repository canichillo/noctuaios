#import "MTLModel.h"
#import "Mantle/Mantle.h"

@interface Amigo : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSNumber * usuario;
@property (nonatomic, strong) NSString * nombre;
@property (nonatomic, strong) NSString * dispositivo;
@property (nonatomic, strong) NSString * so;
@property (nonatomic, strong) NSString * imagen;
@property (nonatomic, strong) NSString * estado;
@property (nonatomic, strong) NSNumber * amistad;

+(NSMutableArray *) consumirLista:(id) respuesta;
@end
