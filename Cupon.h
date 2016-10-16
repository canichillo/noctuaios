//
//  Cupon.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 13/10/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cupon : NSObject
@property (strong, nonatomic) NSNumber* codigo;
@property (strong, nonatomic) NSString* nombre;
@property (strong, nonatomic) NSString* empresa;
@property (strong, nonatomic) NSNumber* idempresa;
@property (strong, nonatomic) NSString* logo;
@property (strong, nonatomic) NSDate* inicio;
@property (strong, nonatomic) NSDate* fin;
@property (strong, nonatomic) NSNumber* usados;
@property (strong, nonatomic) NSNumber* disponibles;
@property (strong, nonatomic) NSString* consumido;
@property (strong, nonatomic) NSString* tipo;

- (id) initWithCodigo: (NSNumber *) codigo
               Nombre: (NSString *) nombre
              Empresa: (NSString *) empresa
            IDEmpresa: (NSNumber *) idempresa
                 Logo: (NSString *) logo
               Inicio: (NSDate *) inicio
                  Fin: (NSDate *) fin
               Usados: (NSNumber *) usados
          Disponibles: (NSNumber *) disponibles
            Consumido: (NSString *) consumido
                 Tipo: (NSString *) tipo;
@end
