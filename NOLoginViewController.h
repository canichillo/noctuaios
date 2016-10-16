//
//  NOLoginViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 07/06/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPScrollViewController.h"
#import "SPTextField.h"
#import "RESideMenu.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import <M13ProgressHUD.h>
#import <M13ProgressViewRing.h>
#import <FacebookSDK/FacebookSDK.h>
#import "NOAppDelegate.h"
#import "NSDate+Helper.h"
#import "NOOfertasViewController.h"
#import "NOMenuIzquierdaViewController.h"

@interface NOLoginViewController : SPScrollViewController
@property (retain, nonatomic) SPTextField* usuario;
@property (retain, nonatomic) SPTextField* password;
@property (retain, nonatomic) UIButton * botonFacebook;
@property (retain, nonatomic) UIButton * botonTwitter;
@property (retain, nonatomic) UIButton * botonGoogle;
@end
