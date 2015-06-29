//
//  MenuLayer.m
//  TestFive
//
//  Created by qing on 15/6/21.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "MenuLayer.h"
#import "HelloWorldLayer.h"
#import "HardWorldLayer.h"
#import "AppDelegate.h"
#import "GameMatchLayer.h"
#import "AutoMatchFindLayer.h"

@implementation MenuLayer

+(void) initSound
{
    int soundstate = 0;
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised)
    {
        [NSThread sleepForTimeInterval:0.1];
    }
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine == nil ||
        audioManager.soundEngine.functioning == NO) {
        CCLOG(@"CocosDenshion failed to init, no audio will play.");
        soundstate = -1;
    } else {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        soundstate = 1;
        CCLOG(@"CocosDenshion is Ready");
    }
}

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    MenuLayer *layer = [[[MenuLayer alloc] init] autorelease];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

-(id)init
{
    if ((self=[super init])) {
        
        NSUserDefaults* userdata = [NSUserDefaults standardUserDefaults];
        sound = (int)[userdata integerForKey:@"com.tidemobiles.numberseven.sound"];
        music = (int)[userdata integerForKey:@"com.tidemobiles.numberseven.music"];
        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"loop.aifc"];
        if ((music==0)||(music==2)) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"loop.aifc" loop:YES];
        }
        

        [[SimpleAudioEngine sharedEngine] preloadEffect:@"equal5.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"low5.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"more5.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"touch.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"lost.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"losthp.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"alarm.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"camera.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"win.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"attack.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"kill.caf"];
        
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        CCSprite* bg = [CCSprite spriteWithFile:@"seven_bg.png"];
        bg.position = ccp(wsize.width*0.5, wsize.height*0.5);
        [self addChild:bg z:0];
        
        //menu button
        CCSprite* es = [CCSprite spriteWithFile:@"easybtn.png"];
        CCSprite* es1 = [CCSprite spriteWithFile:@"easybtn.png"];
        //es1.scale = 0.9;
        CCMenuItemSprite* easy = [CCMenuItemSprite itemWithNormalSprite:es selectedSprite:es1 target:self selector:@selector(gotoEasyScene)];
        
        CCSprite* hs = [CCSprite spriteWithFile:@"hardbtn.png"];
        CCSprite* hs1 = [CCSprite spriteWithFile:@"hardbtn.png"];
        //hs1.scale = 0.9;
        CCMenuItemSprite* hard = [CCMenuItemSprite itemWithNormalSprite:hs selectedSprite:hs1 target:self selector:@selector(gotoHardScene)];
        
        CCSprite* ma = [CCSprite spriteWithFile:@"matchbtn.png"];
        CCSprite* ma1 = [CCSprite spriteWithFile:@"matchbtn.png"];
        //hs1.scale = 0.9;
        CCMenuItemSprite* mat = [CCMenuItemSprite itemWithNormalSprite:ma selectedSprite:ma1 target:self selector:@selector(gotoMatchScene)];
        
        
        CCMenu* menu = [CCMenu menuWithItems:easy,hard,mat, nil];
        [menu alignItemsVerticallyWithPadding:10];
        menu.position = ccp(wsize.width*0.5, wsize.height*0.18);
        [self addChild:menu z:2];
        
        
        //rate button
        SingleTouchSprite* ratebtn = [SingleTouchSprite spriteWithFile:@"rate.png"];
        ratebtn.position = ccp(wsize.width - 20 , 20);
        [self addChild:ratebtn z:2];
        [ratebtn initTheCallbackFunc0:@selector(rateus) withCaller:self];
        
        //game center button
        SingleTouchSprite* gcbtn = [SingleTouchSprite spriteWithFile:@"gc.png"];
        gcbtn.position = ccp(20, 20);
        [self addChild:gcbtn z:2];
        [gcbtn initTheCallbackFunc0:@selector(showGameCenter) withCaller:self];
        
    }
    return self;
    
}

-(void) gotoEasyScene
{
    if ((sound==0)||(sound==2)) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
    }
    
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

-(void) gotoHardScene
{
    if ((sound==0)||(sound==2))
        [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
    [[CCDirector sharedDirector] replaceScene:[HardWorldLayer scene]];
}

-(void) gotoMatchScene
{
    if ([[GCHelper sharedInstance] gcAvailable]==NO) {
        UIAlertView *alertView = [[[UIAlertView alloc]
                                   initWithTitle:@"Game Center unavailible"
                                   message:@"Something is wrong in game center, you can wait some seconds, or try another game mode."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    
    if ((sound==0)||(sound==2))
        [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
    [[CCDirector sharedDirector] replaceScene:[AutoMatchFindLayer scene]];
}

-(void)rateus
{
    if ((sound==0)||(sound==2))
        [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
    NSString* staticurl = @"itms-apps://itunes.apple.com/app/id1010994739";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:staticurl]];
}



-(void) showMatchGame
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc =
    [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    
    [[CCDirector sharedDirector] presentViewController:mmvc animated:YES completion:nil];
}


- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [[ShareMatchManager shareMatchManager] removeMatch];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    CCLOG(@"error in match %@",error);
}


// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    if ((sound==0)||(sound==2))
        [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
    
    CCScene *sc = [GameMatchLayer node];
    GameMatchLayer* gmlayer = (GameMatchLayer*)[sc getChildByTag:1];
    match.delegate = gmlayer;
    [[ShareMatchManager shareMatchManager] setMatch:match];
    //[[ShareMatchManager shareMatchManager] setMatchDelegate:gmlayer];
    
    [[CCDirector sharedDirector] replaceScene:sc];
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
}





-(void) showChallenge
{
    CCLOG(@"chanllenge");
    GKLeaderboard *query = [[GKLeaderboard alloc] init];
    query.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
    query.range = NSMakeRange(1,100);
    
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    long besteasy = [userData integerForKey:EASY_MODE];
    GKScore* sc = [[[GKScore alloc] initWithLeaderboardIdentifier:EASY_MODE] autorelease];
    sc.value = besteasy;
    
    [query loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"value < %qi",sc];
        NSArray *lesserScores = [scores filteredArrayUsingPredicate:filter];
        [sc challengeComposeControllerWithMessage:@"Can you beat my score ?" players:lesserScores completionHandler:nil];
        //[sc issueChallengeToPlayers:lesserScores message:@"Can you beat my score in 'Seven!' ?"];
        //[[CCDirector sharedDirector] presentChallengeWithPreselectedScores: lesserScores];
    }];
}

-(void)showGameCenter
{
    if ([[GCHelper sharedInstance] gcAvailable]) {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
            gameCenterController.leaderboardIdentifier = EASY_MODE;
            [[CCDirector sharedDirector] presentViewController: gameCenterController animated: YES completion:nil];
        
        }
    }
    
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
}


@end
