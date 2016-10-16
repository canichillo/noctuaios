//
//  Chat.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 8/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "Chat.h"

@implementation Chat
/////////////////////////////
// Constructor por defecto //
/////////////////////////////
-(id) initWithID: (NSNumber *) ID
          Nombre: (NSString *) nombre
          Imagen: (NSString *) imagen
              SO: (NSString *) so
     Dispositivo: (NSString *) dispositivo
           Fecha: (NSDate *) fecha
{
    self = [super init];
    if (self)
    {
        self.ID           = ID;
        self.NOMBRE       = nombre;
        self.IMAGEN       = imagen;
        self.SO           = so;
        self.DISPOSITIVO  = dispositivo;
        self.FECHA        = fecha;
    }
    return self;
}
@end
