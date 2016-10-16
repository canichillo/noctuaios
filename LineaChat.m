//
//  LineaChat.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 8/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "LineaChat.h"

@implementation LineaChat
// Constructor por defecto
-(id) initWithID: (NSNumber *) ID
           Texto: (NSString *) texto
          Origen: (NSString *) origen
            Tipo: (NSString *) tipo
{
    self = [super init];
    if (self)
    {
        self.ID     = ID;
        self.TEXTO  = texto;
        self.ORIGEN = origen;
        self.TIPO   = tipo;        
    }
    return self;
}
@end
