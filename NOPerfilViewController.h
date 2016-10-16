//
//  NOPruebaViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 2/11/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "SPScrollViewController.h"
#import "SPButton.h"
#import "SVSegmentedControl.h"
#import "NOPerfilAvatarViewController.h"

@interface NOPerfilViewController : SPScrollViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (retain, nonatomic) UIButton* foto;
@property (retain, nonatomic) UIButton* genero;
@property (retain, nonatomic) SPTextField* nombreusuario;
@property (retain, nonatomic) SPTextField* usuario;
@property (retain, nonatomic) SPTextField* email;
@property (retain, nonatomic) SPTextField* password;
@property (retain, nonatomic) SPTextField* repeatpassword;
@property (retain, nonatomic) SVSegmentedControl * edad;

// Variables
@property (nonatomic, retain) NSString* sGenero;
@property (nonatomic, retain) NSString* token;
@end
