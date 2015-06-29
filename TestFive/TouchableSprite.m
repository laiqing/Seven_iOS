//
//  TouchableSprite.m
//  TestFive
//
//  Created by qing on 15/6/20.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "TouchableSprite.h"


@implementation TouchableSprite

-(id)init
{
    if ((self = [super init])) {

    }
    return self;
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ callbackFunc1:(SEL)cbfunc1_ withCaller:(id)caller_ withImage0:(NSString *)st0 withImage1:(NSString *)st1
{
    caller = caller_;
    state = 0; // sound on
    callbackFunc0 = cbfunc0_;
    callbackFunc1 = cbfunc1_;
    state0Image = [st0 retain];
    state1Image = [st1 retain];
}

-(void) dealloc
{
    [state0Image release];
    [state1Image release];
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
    
    if (state == 0) {
        //call func1 to set music off
        state = 1;
        if ([caller respondsToSelector:callbackFunc1]) {
            [caller performSelector:callbackFunc1];
        }
        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:state1Image];
        [self setTexture: tex];
        
        //[self setDisplayFrame:[CCSpriteFrame frameWithTextureFilename:state1Image rect:self.boundingBox ]];
    }
    else {
        state = 0;
        if ([caller respondsToSelector:callbackFunc0]) {
            [caller performSelector:callbackFunc0];
        }
        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:state0Image];
        [self setTexture: tex];
        //[self setDisplayFrame:[CCSpriteFrame frameWithTextureFilename:state0Image rect:self.boundingBox ]];
    }

    
}


-(void) changeState:(int)st
{
    state = st;
    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:state1Image];
    [self setTexture: tex];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
}


@end
