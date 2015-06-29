//
//  ShareMatchManager.m
//  TestFive
//
//  Created by qing on 15/6/25.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import "ShareMatchManager.h"
#import "GameMatchLayer.h"


@implementation ShareMatchManager

static ShareMatchManager* _instance = nil;

+(id)shareMatchManager {
    @synchronized([ShareMatchManager class]) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

+(id)alloc {
    @synchronized([ShareMatchManager class]) {
        NSAssert(_instance==nil, @"ShareNetworkManager singleton already exists...");
        _instance = [super alloc];
        return _instance;
    }
    return nil;
}

-(id)init {
    if ((self = [super init])) {
        _match = nil;
    }
    return self;
}

-(void)dealloc
{
    if (_match) {
        [_match release];
    }
    _mtlayer = nil;
    [super dealloc];
}

-(GKMatch*)match
{
    return _match;
}


-(void) setMatch:(GKMatch *)mt
{
    if (_match) {
        [_match disconnect];
        [_match release];
        _match = nil;
    }
    _match = [mt retain];
    //match = mt;
}

-(void) setMatchDelegate:(id<GKMatchDelegate>)dele
{
    _match.delegate = dele;
}


-(void) removeMatch
{
    if (_match) {
        [_match disconnect];
        [_match release];
        _match = nil;
    }
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromRemotePlayer:(GKPlayer *)player
{
    NSLog(@"receive match data....");
    GameMsg gm;
    memset(&gm, 0, sizeof(GameMsg));
    
    if (match != _match) {
        return;
    }
    else {
        [data getBytes:&gm length:sizeof(GameMsg)];
        NSLog(@"receive data is .... %d,%d",gm.msgID,gm.value);
        if (gm.msgID<=2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //CCLayer<MatchMainLayer>* mt = (CCLayer<MatchMainLayer>*)[[[CCDirector sharedDirector] runningScene] getChildByTag:1];
                //CCLOG(@"matchlayer is %@",mt);
                [_mtlayer remotePlayerHurtSelf:gm.msgID leftHP:gm.value];
            });
            
        }
        else if (gm.msgID==3) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //CCLayer<MatchMainLayer>* mt = (CCLayer<MatchMainLayer>*)[[[CCDirector sharedDirector] runningScene] getChildByTag:1];
                [_mtlayer remotePlayerAttack:gm.value];
            });
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //CCLayer<MatchMainLayer>* mt = (CCLayer<MatchMainLayer>*)[[[CCDirector sharedDirector] runningScene] getChildByTag:1];
                [_mtlayer remoteChangeHP:gm.value];
            });
            
        }
    }
}

-(void) match:(GKMatch *)match didFailWithError:(NSError *)error
{
    NSLog(@"match get error : %@",error.localizedDescription);
}


-(void) match:(GKMatch *)match player:(GKPlayer *)player didChangeConnectionState:(GKPlayerConnectionState)state
{
    switch (state) {
        case GKPlayerStateConnected:
            NSLog(@"match connected...");
            
            [self gotonext];
            break;
            
        case GKPlayerStateDisconnected:
            NSLog(@"match disconnected....");
            [self removeMatch];
            if (_mtlayer)
                [_mtlayer showGameOver:4];
                
            [self removeMatchLayer];
            break;
        default:
            break;
    }
}

- (BOOL)match:(GKMatch *)match shouldReinviteDisconnectedPlayer:(GKPlayer *)player
{
    CCLOG(@"should reinvite player ? ....");
    return YES;
}


-(void) gotonext
{
    //if ((sound==0)||(sound==2))
    [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
    
    CCScene *sc = [GameMatchLayer node];
    _mtlayer = (CCLayer<MatchMainLayer>*)sc;
    [[CCDirector sharedDirector] replaceScene:sc];
}

-(void) removeMatchLayer
{
    _mtlayer = nil;
}

/*
-(void) sendInitMsg
{
    gameMsg gm;
    memset(&gm, 0, sizeof(gameMsg));
    
    gm.messageID = 1 ; //init message
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userData stringForKey:user_name_key_in_default];
    int prewin = [userData integerForKey:user_win_count];
    int prelost = [userData integerForKey:user_lost_count];
    int predrop = [userData integerForKey:user_drop_count];
    gm.winCount = prewin;
    gm.lostCount = prelost;
    gm.dropCount = predrop;
    const char* un = [userName UTF8String];
    memccpy(gm.playerName, un, strlen(un), strlen(un));
    
    int netmode = [[ShareGameObjectManager shareGameObjectManager] getNetworkConnection];
    NSData* transdata = nil;
    transdata = [NSData dataWithBytes:&gm length:sizeof(gameMsg)];
    
    // write from nsdata to struct :  [data getBytes:&transdata length:sizeof(gameMsg)];
    NSError* err;
    if ((netmode==1)&&(match)) {
        [match sendDataToAllPlayers:transdata withDataMode:GKMatchSendDataReliable error:&err];
    }
    else if ((netmode==2)&&(session)) {
        [session sendData:transdata toPeers:peers withMode:MCSessionSendDataReliable error:&err];
    }
    
}

*/


@end
