//
//  NORegistrarViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 26/6/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPScrollViewController.h"
#import "SPTextField.h"
#import "SPButton.h"
#import "NOAvatarViewController.h"
#import "NOOfertasViewController.h"
#import "SVSegmentedControl.h"
#import "NOMenuIzquierdaViewController.h"

@interface NORegistrarViewController : SPScrollViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (retain, nonatomic) UIButton* foto;
@property (retain, nonatomic) SPTextField* nombreusuario;
@property (retain, nonatomic) SPTextField* usuario;
@property (retain, nonatomic) SPTextField* email;
@property (retain, nonatomic) SPTextField* password;
@property (retain, nonatomic) SPTextField* repeatpassword;
@property (retain, nonatomic) SVSegmentedControl * edad;

// Variables
@property (nonatomic, assign) NSString* sGenero;
@property (nonatomic, assign) BOOL bTerminos;
@end
