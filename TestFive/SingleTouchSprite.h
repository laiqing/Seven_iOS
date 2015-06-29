//
//  SingleTouchSprite.h
//  TestFive
//
//  Created by qing on 15/6/22.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SingleTouchSprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc0;
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCaller:(id)caller_;

@end
