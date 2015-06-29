//
//  ShareMatchManager.h
//  TestFive
//
//  Created by qing on 15/6/25.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

typedef struct _gameMsg
{
    int msgID;   // 1. hp -1
    int value;   // if msgID ==1 , this is the enemy current hp after - 1; 2. after -2 ;   3. after  + 2 , and need to play attack animation
} GameMsg;

@protocol MatchMainLayer

-(void) remotePlayerHurtSelf:(int)hurtID leftHP:(int)hpval;
-(void) remotePlayerAttack:(int)remoteHP;
-(void) remoteChangeHP:(int)hp;
-(void) showGameOver:(int)winOrLost;

@end

@interface ShareMatchManager : NSObject<GKMatchDelegate>
{
    GKMatch *_match;
    CCLayer<MatchMainLayer> *_mtlayer;
}

+(id)shareMatchManager;

-(GKMatch*)match;


-(void) setMatch:(GKMatch*)mt;

-(void) removeMatch;
-(void) removeMatchLayer;

-(void) setMatchDelegate:(id<GKMatchDelegate>)dele;

@end
