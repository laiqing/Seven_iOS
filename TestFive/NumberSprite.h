//
//  NumberSprite.h
//  TestFive
//
//  Created by qing on 15/6/19.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NumberSprite : CCSprite<CCTouchOneByOneDelegate> {
    int _num;
}


@property (nonatomic,assign) int num;

@end
