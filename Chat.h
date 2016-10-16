//
//  Chat.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 8/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chat : NSObject
@property (nonatomic, strong) NSNumber * ID;
@property (nonatomic, strong) NSString * NOMBRE;
@property (nonatomic, strong) NSString * IMAGEN;
@property (nonatomic, strong) NSString * SO;
@property (nonatomic, strong) NSString * DISPOSITIVO;
@property (nonatomic, strong) NSDate * FECHA;

// Constructor por defecto
-(id) initWithID: (NSNumber *) ID
          Nombre: (NSString *) nombre
          Imagen: (NSString *) imagen
              SO: (NSString *) so
     Dispositivo: (NSString *) dispositivo
           Fecha: (NSDate *) fecha;
@end
