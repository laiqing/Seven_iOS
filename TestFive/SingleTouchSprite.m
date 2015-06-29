//
//  SingleTouchSprite.m
//  TestFive
//
//  Created by qing on 15/6/22.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "SingleTouchSprite.h"


@implementation SingleTouchSprite

-(id)init
{
    if ((self = [super init])) {
        
    }
    return self;
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCaller:(id)caller_
{
    caller = caller_;
    callbackFunc0 = cbfunc0_;
}

-(void) dealloc
{
    [super dealloc];
}

-(void)onEnter {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

-(void)onExit {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    return CGRectContainsPoint(self.boundingBox, location);
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if ( ![self containsTouchLocation:touch] )
    {
        return NO;
    }
    else {
        return YES;
    }
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if ([caller respondsToSelector:callbackFunc0]) {
        [caller performSelector:callbackFunc0];
    }
    
    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

@end
