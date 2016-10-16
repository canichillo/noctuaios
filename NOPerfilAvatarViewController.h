//
//  NOAvatarViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 18/7/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import "NOAvatarCollectionViewCell.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import <M13ProgressHUD.h>
#import <M13ProgressViewRing.h>
#import "NOAppDelegate.h"

@interface NOPerfilAvatarViewController : UIViewController
@property (strong, nonatomic) UICollectionView * avatares;
@end
