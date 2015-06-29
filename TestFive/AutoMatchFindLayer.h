//
//  AutoMatchFindLayer.h
//  TestFive
//
//  Created by qing on 15/6/26.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#import <GameKit/GameKit.h>
#import "GCHelper.h"
#import "ShareMatchManager.h"


@interface AutoMatchFindLayer : CCLayer {
    int sound;
}

+(CCScene *) scene;

@end
