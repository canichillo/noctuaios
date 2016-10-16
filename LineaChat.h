//
//  LineaChat.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 8/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineaChat : NSObject
@property (nonatomic, strong) NSNumber * ID;
@property (nonatomic, strong) NSString * TEXTO;
@property (nonatomic, strong) NSString * ORIGEN;
@property (nonatomic, strong) NSString * TIPO;

// Constructor por defecto
-(id) initWithID: (NSNumber *) ID
           Texto: (NSString *) texto
          Origen: (NSString *) origen
            Tipo: (NSString *) tipo;
@end
