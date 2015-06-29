//
//  AutoMatchFindLayer.m
//  TestFive
//
//  Created by qing on 15/6/26.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "AutoMatchFindLayer.h"
#import "GameMatchLayer.h"
#import "MenuLayer.h"

@implementation AutoMatchFindLayer

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    AutoMatchFindLayer *layer = [[[AutoMatchFindLayer alloc] init] autorelease];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

-(id)init
{
    if ((self = [super init])) {
        NSUserDefaults* userdata = [NSUserDefaults standardUserDefaults];
        sound = (int)[userdata integerForKey:@"com.tidemobiles.numberseven.sound"];
        //add a knight sprite, run loop idle animation
        
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        CCSprite* solider = [CCSprite spriteWithFile:@"knightidle01.png"];
        solider.position = ccp(wsize.width*0.5, wsize.height*0.65);
        [self addChild:solider z:1];
        
        CCAnimation* can = [CCAnimation animation];
        [can addSpriteFrameWithFilename:@"knightidle01.png"];
        [can addSpriteFrameWithFilename:@"knightidle02.png"];
        [can addSpriteFrameWithFilename:@"knightidle03.png"];
        can.restoreOriginalFrame = YES;
        can.delayPerUnit = 0.3;
        CCAnimate* an = [CCAnimate actionWithAnimation:can];
        CCRepeatForever* crep = [CCRepeatForever actionWithAction:an];
        [solider runAction:crep];
        
        //add a tip to show how to operation
        CCLabelTTF* tip = [CCLabelTTF labelWithString:@"try swipe 3 button to sum a 7!" fontName:@"Arial" fontSize:16];
        tip.color = ccYELLOW;
        tip.position = ccp(wsize.width*0.5, wsize.height*0.45);
        [self addChild:tip z:1];
        
        CCLabelTTF* tip2 = [CCLabelTTF labelWithString:@"Sum a 7 the solider healed and attack!" fontName:@"Arial" fontSize:16];
        tip2.color = ccYELLOW;
        tip2.position = ccp(wsize.width*0.5, wsize.height*0.4);
        [self addChild:tip2 z:1];
        
        CCLabelTTF* tip3 = [CCLabelTTF labelWithString:@"any other sum will hurt youself!" fontName:@"Arial" fontSize:16];
        tip3.color = ccYELLOW;
        tip3.position = ccp(wsize.width*0.5, wsize.height*0.35);
        [self addChild:tip3 z:1];
        
        
        //add a label to blink, change state to "finding...", "ok".
        CCLabelTTF* matching = [CCLabelTTF labelWithString:@"finding an opponent..." fontName:@"Verdana" fontSize:16];
        matching.color = ccORANGE;
        matching.position = ccp(wsize.width*0.5, wsize.height*0.25);
        [self addChild:matching z:1];
        CCBlink* blk = [CCBlink actionWithDuration:1.5 blinks:2];
        CCRepeatForever* rblk = [CCRepeatForever actionWithAction:blk];
        [matching runAction:rblk];
        
        //add a button to cancel and go back
        CCLabelTTF* ca = [CCLabelTTF labelWithString:@"Cancel" fontName:@"Marker Felt" fontSize:30];
        CCMenuItemLabel* clb = [CCMenuItemLabel itemWithLabel:ca target:self selector:@selector(cancelmatch)];
        CCMenu* menu = [CCMenu menuWithItems:clb, nil];
        menu.position = ccp(wsize.width*0.5, wsize.height*0.12);
        [self addChild:menu z:1];
        
        [self callMatchReq];
        
    }
    return self;
}

-(void) cancelmatch
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
    [[GKMatchmaker sharedMatchmaker] cancel];
    [[ShareMatchManager shareMatchManager] removeMatch];
    [[CCDirector sharedDirector] replaceScene:[MenuLayer node]];
}


-(void) callMatchReq
{
    GKMatchRequest *req = [[GKMatchRequest alloc] init];
    req.minPlayers = 2;
    req.maxPlayers = 2;
    req.defaultNumberOfPlayers = 2;
    req.playerGroup = 0;
    req.recipients = nil;
    //req.playersToInvite = nil;
    
    [[GKMatchmaker sharedMatchmaker] findMatchForRequest:req withCompletionHandler:^(GKMatch *match, NSError *error) {
        CCLOG(@"start to finding a match...");
        if (error) {
            CCLOG(@"error in find match: %@",error.localizedDescription);
            //find match error , exit to prev scene
            //[self gotoback];
            UIAlertView *alertView = [[[UIAlertView alloc]
                                       initWithTitle:@"Unable to find a match"
                                       message:@"Something is wrong, you can try to rematch, or try another game mode."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil] autorelease];
            [alertView show];
            //go back to the menu layer
            [[CCDirector sharedDirector] replaceScene:[MenuLayer node]];
        }
        else if (match != nil) {
            CCLOG(@"find a match...");
            ShareMatchManager* sm = [ShareMatchManager shareMatchManager];
            match.delegate = sm;
            [sm setMatch:match];
            /*
            //now got to the next scene
            if ((sound==0)||(sound==2))
                [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
            
            CCScene *sc = [GameMatchLayer node];
            GameMatchLayer* gmlayer = (GameMatchLayer*)[sc getChildByTag:1];
            match.delegate = gmlayer;
            [[ShareMatchManager shareMatchManager] setMatch:match];
            //[[ShareMatchManager shareMatchManager] setMatchDelegate:gmlayer];
            
            [[CCDirector sharedDirector] replaceScene:sc];
            //match.delegate = self;
             */
        }
    }];
    [req release];
    
    
}



@end
