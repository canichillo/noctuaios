//
//  CoreDataHelper.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 7/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NOAppDelegate.h"
#import "Chat.h"
#import "LineaChat.h"
#import "Cupon.h"

@interface CoreDataHelper : NSObject
// Contexto
+(NSManagedObjectContext *) managedObjectContext;

// Crea los datos de un chat
+(void) crearChat: (Chat *) chat;

// Máximo de una tabla
+(NSNumber *) maximoTabla: (NSString *) tabla;

// Actualiza los datos de un chat
+(void) actualizarChat: (NSNumber *) ID
                 Fecha: (NSDate *) fecha;

// Elimina los datos de un chat
+(void) eliminarChat: (NSNumber *) ID;

// Crea un mensaje de chat
+(void) crearMensajeChat: (NSNumber *) chat
                   Texto: (NSString *) texto
                  Propio: (NSString *) propio
                    Tipo: (NSString *) tipo;

// Obtiene las líneas de un chat
+(NSMutableArray *) lineasChatBD: (NSNumber *) ID;

// Obtiene los datos de un chat
+(Chat *) chatBD: (NSNumber *) ID;

// Comprueba si existe un chat en la base de datos
+(BOOL) existeChatBD: (NSNumber *) Remitente;

// Obtiene los chats
+(NSMutableArray *) chatsBD;

// Crea los datos de un cupón
+(void) crearCupon: (Cupon *) cupon;

// Actualiza los datos de un cupón
+(void) actualizarCupon: (NSNumber *) ID
                   Tipo: (NSString *) tipo
                 Usados: (int) usados
              Consumido: (NSString *) consumido;

// Elimina todos los cupones antiguos
+(void) eliminarCupones;

// Elimina un cupón
+(void) eliminarCupon: (NSNumber *) ID
                 Tipo: (NSString *) tipo;

// Comprueba si existe un cupón en la base de datos
+(BOOL) existeCuponBD: (NSNumber *) codigo
                 Tipo: (NSString *) tipo;

// Obtiene los datos de los cupones
+(Cupon *) cuponBD: (NSNumber *) ID
              Tipo: (NSString *) tipo;

// Obtiene los cupones
+(NSMutableArray *) cuponesBD: (NSString *) tipo;
@end
