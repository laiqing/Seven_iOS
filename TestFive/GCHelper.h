//
//  GCHelper.h
//  TestFive
//
//  Created by qing on 15/6/23.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>
#import "cocos2d.h"

#define EASY_MODE @"com.tidemobiles.numberseven.easymode"
#define HARD_MODE @"com.tidemobiles.numberseven.hardmode"
#define WIN_COUNT @"com.tidemobiles.numberseven.wincount"
#define LOST_COUNT @"com.tidemobiles.numberseven.lostcount"
#define DRAW_COUNT @"com.tidemobiles.numberseven.drawcount"


@interface GCHelper : NSObject  {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    int useIOS7;
    
    long long rank;
    
}


+ (GCHelper *) sharedInstance;
- (void)authenticationChanged;
- (void)authenticateLocalUser;
-(BOOL) gcAvailable;

-(void) reportEasyScore:(int)score;
-(void) reportHardScore:(int)score;
-(void) reportWin:(int)score;
-(void) reportLost:(int)score;
-(void) reportDraw:(int)score;
-(void) resendData;


@end
