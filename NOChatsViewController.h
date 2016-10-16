//
//  NOChatsViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 7/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUtilidades.h"
#import "NOChatTableViewCell.h"
#import "Chat.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import "CoreDataHelper.h"
#import "MCSwipeTableViewCell.h"
#import "NOChatViewController.h"

@interface NOChatsViewController : UIViewController<MCSwipeTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * tabla;

@property (nonatomic) NSMutableArray * chats;
@property (nonatomic, strong) MCSwipeTableViewCell *cellToDelete;
@end
