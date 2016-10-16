//
//  NOChatViewController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 7/9/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessages.h>
#import <JSQMessagesViewController/JSQMessagesBubbleImageFactory.h>
#import "SPUtilidades.h"
#import "CoreDataHelper.h"
#import "Chat.h"
#import <SDWebImageManager.h>    

@interface NOChatViewController : JSQMessagesViewController
@property (nonatomic) NSNumber * codigo;
@property (nonatomic) Chat * chat;
@property (nonatomic) NSMutableArray * mensajes;
@property (nonatomic) NSMutableArray * posiciones;
@property (nonatomic) NSMutableArray * fechas;
@property (nonatomic, strong) UILabel * titulo;
@property (nonatomic, strong) NSTimer * temporizador;

@property (strong, nonatomic) UIImageView *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView *incomingBubbleImageView;

@property (nonatomic) BOOL entrada;

-(id) initWithCodigo: (NSNumber *) codigo Entrada: (BOOL) entrada;
@end
