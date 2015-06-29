//
//  MenuLayer.h
//  TestFive
//
//  Created by qing on 15/6/21.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "SingleTouchSprite.h"
#import "ShareMatchManager.h"

@interface MenuLayer : CCLayer<GKMatchmakerViewControllerDelegate> {
 
    int sound;
    int music;
}

+(void) initSound;
+(CCScene *) scene;


@end
