//
//  HardWorldLayer.h
//  TestFive
//
//  Created by qing on 15/6/22.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import <Social/Social.h>
#import "SimpleAudioEngine.h"
#import "NumberSprite.h"
#import "MyAdBanner.h"

#import "GCHelper.h"

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "TouchableSprite.h"
#import "SingleTouchSprite.h"

@interface HardWorldLayer : CCLayerColor {
    int scheduleState;
    int optOpened;
    int canPlayed;
    
    CCArray* row1;
    CCArray* row2;
    CCArray* row3;
    CCArray* row4;
    CCArray* row5;
    CCArray* row6;
    
    //float lowpos[6];
    //float highpos[6];
    //float lowy;
    //float highy;
    
    NumberSprite* firstsp;
    NumberSprite* secondsp;
    NumberSprite* thirdsp;
    
    //CCSprite* mushroom;
    
    int direction;
    
    //CCProgressTimer* hpbar;
    //CCProgressTimer* accumulatePT;
    
    int timeLeft;
    int playerHP;
    int playerMaxHP;
    int score;
    int step;
    int life;
    int getSeven;
    
    int firstIn;
    int secondIn;
    int thirdIn;
    
    CCLabelTTF* scorelab;
    CCLabelTTF* movelab;
    CCLabelTTF* timelab;
    
    MyAdBanner* adbanner;
    UIImage* capture;
    
    int music;
    int sound;
    int showtip;
}

+(CCScene *) scene;

//+(void) initSound;

-(void) setSoundOn;
-(void) setSoundOff;

-(void) setMusicOn;
-(void) setmusicOff;

@end
