//
//  TouchableSprite.h
//  TestFive
//
//  Created by qing on 15/6/20.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TouchableSprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc0;
    SEL callbackFunc1;

    int state;
    NSString* state0Image;  //normal image
    NSString* state1Image;
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ callbackFunc1:(SEL)cbfunc1_ withCaller:(id)caller_  withImage0:(NSString*)st0 withImage1:(NSString*)st1;

-(void) changeState:(int)st;

@end
