//
//  CoreDataHelper.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 7/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

////////////////////////
// Accede al contexto //
////////////////////////
+(NSManagedObjectContext *) managedObjectContext
{
    NOAppDelegate * delegate = (NOAppDelegate *) [[UIApplication sharedApplication] delegate];
    return delegate.managedObjectContext;
}

///////////////////////////////
// Crea los datos de un chat //
///////////////////////////////
+(void) crearChat: (Chat *) chat
{
    // Creamos un objeto de CHAT nuevo
    NSManagedObject * nuevo = [NSEntityDescription insertNewObjectForEntityForName:@"CHATS"
                                                            inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    
    // Guardamos los valores
    [nuevo setValue:chat.ID forKey:@"id"];
    [nuevo setValue:chat.NOMBRE forKey:@"nombre"];
    [nuevo setValue:chat.IMAGEN forKey:@"imagen"];
    [nuevo setValue:chat.SO forKey:@"so"];
    [nuevo setValue:chat.DISPOSITIVO forKey:@"dispositivo"];
    [nuevo setValue:chat.FECHA forKey:@"fecha"];
    
    // Realizamos la petición de guardado
    NSError *error = nil;
    if (![[CoreDataHelper managedObjectContext] save:&error])
        NSLog(@"No puedo guardar el chat %@", error);
}

////////////////////////////////////
// Obtiene el máximo de una tabla //
////////////////////////////////////
+(NSNumber *) maximoTabla: (NSString *) tabla
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:tabla
                                   inManagedObjectContext:[CoreDataHelper managedObjectContext]]];
    [request setResultType:NSDictionaryResultType];
    
    NSExpression *keyPathExpression  = [NSExpression expressionForKeyPath:@"id"];
    NSExpression *maxExpression      = [NSExpression expressionForFunction:@"max:"
                                                                 arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *maximoDescription = [[NSExpressionDescription alloc] init];
    [maximoDescription setName:@"maximo"];
    [maximoDescription setExpression:maxExpression];
    [maximoDescription setExpressionResultType:NSInteger32AttributeType];
    [request setPropertiesToFetch:[NSArray arrayWithObject: maximoDescription]];
    
    NSError *error = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:request error:&error];
    
    if (error != nil) return @1;
    else
    {
        // Sumamos 1 al máximo
        int maximo = [[[fetchResults lastObject] valueForKey:@"maximo"] integerValue] + 1;
        
        return [NSNumber numberWithInt:maximo];
    }
}

///////////////////////////////////
// Actualiza la fecha de un chat //
///////////////////////////////////
+(void) actualizarChat: (NSNumber *) ID
                 Fecha: (NSDate *) fecha
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"CHATS" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", ID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error        = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Si encontramos el CHAT
    if ([fetchResults firstObject])
    {
        // Editamos los datos del chat
        NSManagedObject * editar = [fetchResults firstObject];
        [editar setValue:fecha forKey:@"fecha"];
        
        // Realizamos la petición de guardado
        NSError *error = nil;
        if (![[CoreDataHelper managedObjectContext] save:&error])
            NSLog(@"No puedo editar el chat %@", error);
    }
}

////////////////////////////////////////
// Elimina todos los datos de un chat //
////////////////////////////////////////
+(void) eliminarChat: (NSNumber *) ID
{
    // Eliminamos los datos del CHAT
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"CHATS" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", ID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error        = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Para cada uno de los elementos
    for (NSManagedObject *managedObject in fetchResults) {
        [[CoreDataHelper managedObjectContext] deleteObject:managedObject];
    }
    
    // Eliminamos los datos de LINEASCHAT
    fetchRequest = [[NSFetchRequest alloc] init];
    entity       = [NSEntityDescription entityForName:@"LINEASCHAT" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    predicate = [NSPredicate predicateWithFormat:@"(chat = %@)", ID];
    [fetchRequest setPredicate:predicate];
    
    fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Para cada uno de los elementos
    for (NSManagedObject *managedObject in fetchResults) {
        [[CoreDataHelper managedObjectContext] deleteObject:managedObject];
    }
    
    // Guardamos los cambios realizados en la base de datos
    [[CoreDataHelper managedObjectContext] save:&error];
}

//////////////////////////////////////
// Creamos un nuevo mensaje de chat //
//////////////////////////////////////
+(void) crearMensajeChat: (NSNumber *) chat
                   Texto: (NSString *) texto
                  Propio: (NSString *) propio
                    Tipo: (NSString *) tipo
{
    // Creamos un objeto de CHAT nuevo
    NSManagedObject * nuevo = [NSEntityDescription insertNewObjectForEntityForName:@"LINEASCHAT"
                                                            inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    
    // Guardamos los valores
    [nuevo setValue:[CoreDataHelper maximoTabla:@"LINEASCHAT"] forKey:@"id"];
    [nuevo setValue:chat forKey:@"chat"];
    [nuevo setValue:texto forKey:@"mensaje"];
    [nuevo setValue:propio forKey:@"propio"];
    [nuevo setValue:tipo forKey:@"tipo"];
    
    // Realizamos la petición de guardado
    NSError *error = nil;
    if (![[CoreDataHelper managedObjectContext] save:&error])
        NSLog(@"No puedo guardar el chat %@", error);
}

///////////////////////////////////
// Obtiene las líneas de un chat //
///////////////////////////////////
+(NSMutableArray *) lineasChatBD: (NSNumber *) ID
{
    // Lineas de salida
    NSMutableArray * lineas = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"LINEASCHAT" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(chat = %@)", ID];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *srt = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:srt]];
    
    NSError *error        = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    lineas = [[NSMutableArray alloc] initWithCapacity:[fetchResults count]];
    
    // Para cada uno de los elementos
    for (NSManagedObject *managedObject in fetchResults)
    {
        // Insertamos la línea
        [lineas addObject:[[LineaChat alloc] initWithID:[managedObject valueForKey:@"id"]
                                                  Texto:[managedObject valueForKey:@"mensaje"]
                                                 Origen:[managedObject valueForKey:@"propio"]
                                                   Tipo:[managedObject valueForKey:@"tipo"]]];
    }

    // Devolvemos las líneas del chat
    return lineas;
}

//////////////////////////////////
// Obtiene los datos de un chat //
//////////////////////////////////
+(Chat *) chatBD: (NSNumber *) ID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"CHATS" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", ID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error        = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchResults firstObject])
    {
        NSManagedObject *managedObject = [fetchResults firstObject];
        
        return [[Chat alloc] initWithID:[managedObject valueForKey:@"id"]
                                 Nombre:[managedObject valueForKey:@"nombre"]
                                 Imagen:[managedObject valueForKey:@"imagen"]
                                     SO:[managedObject valueForKey:@"so"]
                            Dispositivo:[managedObject valueForKey:@"dispositivo"]
                                  Fecha:[managedObject valueForKey:@"fecha"]];
    }
    return nil;
}

/////////////////////////////////
// Comprueba si existe un chat //
/////////////////////////////////
+(BOOL) existeChatBD: (NSNumber *) Remitente
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"CHATS" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %@)", Remitente];
    [fetchRequest setPredicate:predicate];
    
    NSError *error        = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchResults firstObject])
    {
        return true;
    }
    
    return false;
}

///////////////////////
// Obtiene los chats //
///////////////////////
+(NSMutableArray *) chatsBD
{
    // Lineas de salida
    NSMutableArray * chats = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"CHATS" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error        = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    chats = [[NSMutableArray alloc] initWithCapacity:[fetchResults count]];
    
    // Para cada uno de los elementos
    for (NSManagedObject *managedObject in fetchResults)
    {
        // Insertamos el chat
        [chats addObject:[[Chat alloc] initWithID:[managedObject valueForKey:@"id"]
                                           Nombre:[managedObject valueForKey:@"nombre"]
                                           Imagen:[managedObject valueForKey:@"imagen"]
                                               SO:[managedObject valueForKey:@"so"]
                                      Dispositivo:[managedObject valueForKey:@"dispositivo"]
                                            Fecha:[managedObject valueForKey:@"fecha"]]];
    }
    
    // Devolvemos las líneas del chat
    return chats;
}

////////////////////////////////
// Crea los datos de un cupón //
////////////////////////////////
+(void) crearCupon: (Cupon *) cupon
{
    // Creamos un objeto de CHAT nuevo
    NSManagedObject * nuevo = [NSEntityDescription insertNewObjectForEntityForName:@"CUPONES"
                                                            inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    
    // Guardamos los valores
    [nuevo setValue:[CoreDataHelper maximoTabla:@"CUPONES"] forKey:@"id"];
    [nuevo setValue:cupon.codigo forKey:@"codigo"];
    [nuevo setValue:cupon.nombre forKey:@"nombre"];
    [nuevo setValue:cupon.empresa forKey:@"empresa"];
    [nuevo setValue:cupon.logo forKey:@"logo"];
    [nuevo setValue:cupon.inicio forKey:@"inicio"];
    [nuevo setValue:cupon.fin forKey:@"fin"];
    [nuevo setValue:cupon.usados forKey:@"usados"];
    [nuevo setValue:cupon.disponibles forKey:@"disponibles"];
    [nuevo setValue:@"N" forKey:@"consumido"];
    [nuevo setValue:@"N" forKey:@"borrado"];
    [nuevo setValue:cupon.tipo forKey:@"tipo"];
    
    // Realizamos la petición de guardado
    NSError *error = nil;
    if (![[CoreDataHelper managedObjectContext] save:&error])
        NSLog(@"No puedo guardar el cupón %@", error);
}

////////////////////////
// Actualiza un cupón //
////////////////////////
+(void) actualizarCupon: (NSNumber *) ID
                   Tipo: (NSString *) tipo
                 Usados: (int) usados
              Consumido: (NSString *) consumido
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"CUPONES" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(codigo = %@) AND (tipo = %@)", ID, tipo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error        = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Si encontramos el CUPÓN
    if ([fetchResults firstObject])
    {
        // Registro a editar
        NSManagedObject * editar = [fetchResults firstObject];
        
        // Valor a actualizar
        int numusados = [[editar valueForKey:@"usados"] integerValue];
        
        // Editamos los datos del chat
        [editar setValue:[NSNumber numberWithInt:(numusados + usados)] forKey:@"usados"];
        [editar setValue:consumido forKey:@"consumido"];
        
        // Realizamos la petición de guardado
        NSError *error = nil;
        if (![[CoreDataHelper managedObjectContext] save:&error])
            NSLog(@"No puedo editar el cupón %@", error);
    }
}

//////////////////////
// Elimina un cupón //
//////////////////////
+(void) eliminarCupon: (NSNumber *) ID
                 Tipo: (NSString *) tipo
{
    // Eliminamos los datos del CUPONES
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"CUPONES" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(codigo = %@) AND (tipo = %@)", ID, tipo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error        = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchResults firstObject])
    {
        // Registro a editar
        NSManagedObject * editar = [fetchResults firstObject];
        [editar setValue:@"S" forKey:@"borrado"];
        
        // Realizamos la petición de guardado
        NSError *error = nil;
        if (![[CoreDataHelper managedObjectContext] save:&error])
            NSLog(@"No puedo editar el cupón %@", error);
    }
}

//////////////////////
// Elimina un cupón //
//////////////////////
+(void) eliminarCupones
{
    // Fecha para borrar
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-30];
    
    // Eliminamos los datos del CUPONES
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"CUPONES" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fin <= %@) AND (borrado = 'S')", [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error        = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Para cada uno de los elementos
    for (NSManagedObject *managedObject in fetchResults) {
        [[CoreDataHelper managedObjectContext] deleteObject:managedObject];
    }
    
    // Guardamos los cambios realizados en la base de datos
    [[CoreDataHelper managedObjectContext] save:&error];
}

//////////////////////////////////
// Comprueba si existe un cupón //
//////////////////////////////////
+(BOOL) existeCuponBD: (NSNumber *) codigo
                 Tipo: (NSString *) tipo
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"CUPONES" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(codigo = %@) AND (tipo = %@)", codigo, tipo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error        = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchResults firstObject])
    {
        return true;
    }
    return false;
}

///////////////////////////////////
// Obtiene los datos de un cupón //
///////////////////////////////////
+(Cupon *) cuponBD: (NSNumber *) ID
              Tipo: (NSString *) tipo
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"CUPONES" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(codigo = %@) AND (tipo = %@)", ID, tipo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error        = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchResults firstObject])
    {
        NSManagedObject *managedObject = [fetchResults firstObject];
        
        return [[Cupon alloc] initWithCodigo:[managedObject valueForKey:@"id"]
                                      Nombre:[managedObject valueForKey:@"nombre"]
                                     Empresa:[managedObject valueForKey:@"empresa"]
                                   IDEmpresa:[managedObject valueForKey:@"idempresa"]
                                        Logo:[managedObject valueForKey:@"logo"]
                                      Inicio:[managedObject valueForKey:@"inicio"]
                                         Fin:[managedObject valueForKey:@"fin"]
                                      Usados:[managedObject valueForKey:@"usados"]
                                 Disponibles:[managedObject valueForKey:@"disponibles"]
                                   Consumido:@""
                                        Tipo: tipo];
    }
    return nil;
}

/////////////////////////
// Obtiene los cupones //
/////////////////////////
+(NSMutableArray *) cuponesBD: (NSString *) tipo
{
    // Lineas de salida
    NSMutableArray * cupones = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"CUPONES" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *srt = [NSSortDescriptor sortDescriptorWithKey:@"inicio" ascending:YES];
    NSSortDescriptor *srt2 = [NSSortDescriptor sortDescriptorWithKey:@"consumido" ascending:YES];
    [fetchRequest setSortDescriptors:@[srt, srt2]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tipo = %@) AND (borrado = 'N')", tipo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error        = nil;
    NSArray *fetchResults = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    cupones = [[NSMutableArray alloc] initWithCapacity:[fetchResults count]];
    
    // Para cada uno de los elementos
    for (NSManagedObject *managedObject in fetchResults)
    {
        // Insertamos el chat
        [cupones addObject:[[Cupon alloc] initWithCodigo:[managedObject valueForKey:@"id"]
                                                  Nombre:[managedObject valueForKey:@"nombre"]
                                                 Empresa:[managedObject valueForKey:@"empresa"]
                                               IDEmpresa:[managedObject valueForKey:@"idempresa"]
                                                    Logo:[managedObject valueForKey:@"logo"]
                                                  Inicio:[managedObject valueForKey:@"inicio"]
                                                     Fin:[managedObject valueForKey:@"fin"]
                                                  Usados:[managedObject valueForKey:@"usados"]
                                             Disponibles:[managedObject valueForKey:@"disponibles"]
                                               Consumido:@""
                                                    Tipo:tipo]];
    }
    
    // Devolvemos los cupones
    return cupones;
}
@end
