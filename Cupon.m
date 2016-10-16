//
//  Cupon.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 13/10/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "Cupon.h"

@implementation Cupon
/////////////////////////////
// Constructor por defecto //
/////////////////////////////
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
                 Tipo: (NSString *) tipo
{
    self = [super init];
    if (self)
    {
        self.codigo      = codigo;
        self.nombre      = nombre;
        self.empresa     = empresa;
        self.idempresa   = idempresa;
        self.logo        = logo;
        self.inicio      = inicio;
        self.fin         = fin;
        self.usados      = usados;
        self.disponibles = disponibles;
        self.consumido   = consumido;
        self.tipo        = tipo;
    }
    return self;
}
@end
