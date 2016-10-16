//
//  NOMenuIzquierdaViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 08/06/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import "NOOfertasViewController.h"
#import "NOAmigosViewController.h"
#import "NOCuponesViewController.h"
#import "NOInvitacionesViewController.h"
#import "NOChatsViewController.h"
#import "NOMenuTableViewCell.h"

@interface NOMenuIzquierdaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView * foto;
@property (nonatomic, strong) SPLabel * nombre;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) NSArray * imagenes;
@property (nonatomic, strong) UIScrollView * scroll;
@property (strong, nonatomic) UITableView *tableView;

-(void) refrescarImagen;
@end
