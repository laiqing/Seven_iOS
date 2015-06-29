//
//  HardWorldLayer.m
//  TestFive
//
//  Created by qing on 15/6/22.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "HardWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "MenuLayer.h"
#import "Appirater.h"
#import "AutoMatchFindLayer.h"

@implementation HardWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    HardWorldLayer *layer = [[[HardWorldLayer alloc] initWithColor:ccc4(25, 25, 25, 255)] autorelease];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

-(void) resetGame
{
    scheduleState = 0;
    timeLeft = 60;
    playerHP = 10;
    playerMaxHP = 10;
    [row1 removeAllObjects];
    [row2 removeAllObjects];
    [row3 removeAllObjects];
    [row4 removeAllObjects];
    [row5 removeAllObjects];
    [row6 removeAllObjects];
    direction = 0;
    score = 0;
    step = 0;
    firstIn = 0;
    secondIn = 0;
    thirdIn = 0;
    //view label not change to the same value
}

-(void) onEnter
{
    [super onEnter];
    
}

-(void) onExit
{
    [super onExit];
}

-(void) captureAll
{
    [self setGameOverLayerVisible:NO];
    
    //[CCDirector sharedDirector].nextDeltaTimeZero = YES;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCRenderTexture* rtx =
    [CCRenderTexture renderTextureWithWidth:winSize.width
                                     height:winSize.height];
    
    CCNode* n;
    CCScene* running = [[CCDirector sharedDirector] runningScene];
    CCARRAY_FOREACH(running.children, n)
    {
        [rtx begin];
        [n visit];
        [rtx end];
    }
    
    [self setGameOverLayerVisible:YES];
    
    capture =  [rtx getUIImage];
    
    
    
    
}

-(id) initWithColor:(ccColor4B)color
{
    if ((self = [super initWithColor:color])) {
        
        scheduleState = 0;
        playerHP = 10;
        playerMaxHP = 10;
        row1 = [[CCArray alloc] init];
        row2 = [[CCArray alloc] init];
        row3 = [[CCArray alloc] init];
        row4 = [[CCArray alloc] init];
        row5 = [[CCArray alloc] init];
        row6 = [[CCArray alloc] init];
        direction = 0;
        score = 0;
        step = 0;
        firstIn = 0;
        secondIn = 0;
        thirdIn = 0;
        timeLeft = 60;
        life = 3;
        getSeven = 0;
        
        optOpened = 0;
        canPlayed = 1;
        
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        
        NSUserDefaults* userdata = [NSUserDefaults standardUserDefaults];
        showtip = (int)[userdata integerForKey:@"com.tidemobiles.numberseven.tip2"];
        sound = (int)[userdata integerForKey:@"com.tidemobiles.numberseven.sound"];
        music = (int)[userdata integerForKey:@"com.tidemobiles.numberseven.music"];
        
        //add bg
        CCSprite* bbg = [CCSprite spriteWithFile:@"bg2.png"];
        bbg.position = ccp(wsize.width*0.5, wsize.height*0.5-40);
        [self addChild:bbg z:1];
        
        CCLabelTTF* sc = [CCLabelTTF labelWithString:@"Score" fontName:@"Verdana" fontSize:16];
        sc.color = ccMAGENTA;
        sc.position = ccp(50 , wsize.height*0.5+bbg.boundingBox.size.height*0.5+30);
        [self addChild:sc z:1];
        
        CCLabelTTF* tc = [CCLabelTTF labelWithString:@"Time" fontName:@"Verdana" fontSize:16];
        //tc.color = ccBLACK;
        tc.position = ccp(wsize.width*0.5, sc.position.y);
        [self addChild:tc z:1];
        
        CCLabelTTF* mc = [CCLabelTTF labelWithString:@"Seven!" fontName:@"Verdana" fontSize:16];
        mc.color = ccBLUE;
        mc.position = ccp(wsize.width-50,sc.position.y );
        [self addChild:mc z:1];
        
        scorelab = [CCLabelTTF labelWithString:@"0" fontName:@"Arial Rounded MT Bold" fontSize:24];
        scorelab.color = ccMAGENTA;
        scorelab.position = ccp(sc.position.x, sc.position.y-30);
        [self addChild:scorelab z:2];
        
        movelab = [CCLabelTTF labelWithString:@"0" fontName:@"Arial Rounded MT Bold" fontSize:24];
        movelab.color = ccBLUE;
        movelab.position = ccp(mc.position.x, mc.position.y-30);
        [self addChild:movelab z:2];
        
        timelab = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",timeLeft] fontName:@"Arial Rounded MT Bold" fontSize:24];
        //timelab.color = ccBLACK;
        timelab.position = ccp(tc.position.x, tc.position.y-30);
        [self addChild:timelab z:2];
        
        
        //add tip label
        CCLabelTTF* tip1 = [CCLabelTTF labelWithString:@"Swipe 3 button to sum, how many 7 can you get?" fontName:@"Arial" fontSize:12];
        tip1.color = ccGRAY;
        //tip1.anchorPoint = ccp(0, 0.5);
        tip1.position = ccp(wsize.width*0.5, bbg.position.y - bbg.boundingBox.size.height*0.5 - 10);
        [self addChild:tip1 z:1];
        
        //CCLabelTTF* tip2 = [CCLabelTTF labelWithString:@"if sum less than 7, your life will receive 3 damage!" fontName:@"Arial" fontSize:24];
        //tip2.anchorPoint = ccp(0, 0.5);
        //tip2.position = ccp(15, bbg.position.y - bbg.boundingBox.size.height*0.5 - 20);
        //[self addChild:tip2 z:1];
        
        
        TouchableSprite* musicbtn = [TouchableSprite spriteWithFile:@"musicon.png"];
        musicbtn.position = ccp(40, bbg.position.y - bbg.boundingBox.size.height*0.5 - 40);
        [self addChild:musicbtn z:1];
        [musicbtn initTheCallbackFunc0:@selector(setMusicOn) callbackFunc1:@selector(setmusicOff) withCaller:self withImage0:@"musicon.png" withImage1:@"musicoff.png"];
        if (music==3) {
            [musicbtn changeState:1];
        }
        
        TouchableSprite* soundbtn = [TouchableSprite spriteWithFile:@"soundon.png"];
        soundbtn.position = ccp(wsize.width-40, bbg.position.y - bbg.boundingBox.size.height*0.5 - 40);
        [self addChild:soundbtn z:1];
        [soundbtn initTheCallbackFunc0:@selector(setSoundOn) callbackFunc1:@selector(setSoundOff) withCaller:self withImage0:@"soundon.png" withImage1:@"soundoff.png"];
        if (sound==3) {
            [soundbtn changeState:1];
        }
        
        
        SingleTouchSprite* optbtn = [SingleTouchSprite spriteWithFile:@"optbtn.png"];
        optbtn.position = ccp(wsize.width*0.5, musicbtn.position.y);
        [self addChild:optbtn z:1];
        [optbtn initTheCallbackFunc0:@selector(openMenu) withCaller:self];
        
        [self genSpriteMatrix];
        
        
        
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        
        //[self scheduleUpdate];
        if (showtip==0) {
            //means that never set
            CCLOG(@"never set before");
            [self showTip];
        }
        else {
            [self schedule:@selector(scheduleTimeDown) interval:1];
        }
        
        
        //add ad banner
        adbanner = [[MyAdBanner alloc] init];
        //adbanner = [[ADBannerView alloc] initWithFrame:CGRectZero];
        //adbanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        
        
    }
    return self;
}

-(void) genSpriteMatrix
{
    CGSize wsize = [[CCDirector sharedDirector] winSize];
    CGPoint start = ccp(wsize.width*0.5 - 112.5 , wsize.height*0.5 - 152.5);
    
    
    
    for (int j=0; j<6; j++) {
        for (int i=0; i<6; i++) {
            int c = arc4random()%5;
            NSString* fn = [NSString stringWithFormat:@"%d.png",c];
            NumberSprite* gesp = [NumberSprite spriteWithFile:fn];
            gesp.num = c;
            gesp.position = ccp(start.x + 45*i, start.y);
            [self addChild:gesp z:2];
            
            if (i==0) {
                [row1 addObject:gesp];
            }
            else if (i==1) {
                [row2 addObject:gesp];
            }
            else if (i==2) {
                [row3 addObject:gesp];
            }
            else if (i==3) {
                [row4 addObject:gesp];
            }
            else if (i==4) {
                [row5 addObject:gesp];
            }
            else {
                [row6 addObject:gesp];
            }
            
        }
        start = ccp(start.x, start.y+45);
    }
    
    //print the row
    
    
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [row1 removeAllObjects];
    [row1 release];
    [row2 removeAllObjects];
    [row2 release];
    [row3 removeAllObjects];
    [row3 release];
    [row4 removeAllObjects];
    [row4 release];
    [row5 removeAllObjects];
    [row5 release];
    [row6 removeAllObjects];
    [row6 release];
    if (adbanner) {
        [adbanner release];
    }
    [super dealloc];
}

-(void) cleanForNext
{
    NumberSprite* ns;
    CCARRAY_FOREACH(row1, ns)
    {
        [ns removeFromParent];
    }
    CCARRAY_FOREACH(row2, ns)
    {
        [ns removeFromParent];
    }
    CCARRAY_FOREACH(row3, ns)
    {
        [ns removeFromParent];
    }
    CCARRAY_FOREACH(row4, ns)
    {
        [ns removeFromParent];
    }
    CCARRAY_FOREACH(row5, ns)
    {
        [ns removeFromParent];
    }
    CCARRAY_FOREACH(row6, ns)
    {
        [ns removeFromParent];
    }
    [row1 removeAllObjects];
    [row2 removeAllObjects];
    [row3 removeAllObjects];
    [row4 removeAllObjects];
    [row5 removeAllObjects];
    [row6 removeAllObjects];
    
    scheduleState = 0;
    playerHP = 10;
    playerMaxHP = 10;
    direction = 0;
    score = 0;
    step = 0;
    firstIn = 0;
    secondIn = 0;
    thirdIn = 0;
    timeLeft = 60;
    life = 3;
    getSeven = 0;
    
    optOpened = 0;
    canPlayed = 1;
    //cclabel set text
    [scorelab setString:@"0"];
    [movelab setString:@"0"];
    [timelab setString:@"60"];
    
    [self genSpriteMatrix];
    
}

-(BOOL) selectNumberSpriteFromPos:(CGPoint)loc
{
    if (canPlayed==0) {
        return NO;
    }
    
    //CCLOG(@"touch on %f,%f",loc.x,loc.y);
    //if pos y in the 6
    BOOL found = NO;
    NumberSprite* ns;
    CCARRAY_FOREACH(row1, ns)
    {
        if (CGRectContainsPoint(ns.boundingBox, loc)) {
            //[[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
            firstsp = ns;
            ns.scale = 1.2;
            found = YES;
            firstIn = 1;
            break;
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row2, ns)
        {
            if (CGRectContainsPoint(ns.boundingBox, loc)) {
                //[[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
                firstsp = ns;
                ns.scale = 1.2;
                found = YES;
                firstIn = 2;
                break;
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row3, ns)
        {
            if (CGRectContainsPoint(ns.boundingBox, loc)) {
                //[[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
                firstsp = ns;
                ns.scale = 1.2;
                found = YES;
                firstIn = 3;
                break;
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row4, ns)
        {
            if (CGRectContainsPoint(ns.boundingBox, loc)) {
                //[[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
                firstsp = ns;
                ns.scale = 1.2;
                found = YES;
                firstIn = 4;
                break;
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row5, ns)
        {
            if (CGRectContainsPoint(ns.boundingBox, loc)) {
                // [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
                firstsp = ns;
                ns.scale = 1.2;
                found = YES;
                firstIn = 5;
                break;
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row6, ns)
        {
            if (CGRectContainsPoint(ns.boundingBox, loc)) {
                //[[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
                firstsp = ns;
                ns.scale = 1.2;
                found = YES;
                firstIn = 6;
                break;
            }
        }
    }
    
    return found;
    
    
    
    
}

-(void) getsecond:(CGPoint)loc
{
    BOOL found = NO;
    NumberSprite* ns;
    CCARRAY_FOREACH(row1, ns)
    {
        if (ns != firstsp) {
            if (CGRectContainsPoint(ns.boundingBox, loc)) {
                if (ns.position.x == firstsp.position.x) {
                    direction = 1;
                    secondsp = ns;
                    ns.scale = 1.2;
                    secondIn = 1;
                    found = YES;
                    //CCLOG(@"second.position: %f,%f",ns.position.x,ns.position.y);
                    break;
                }
                else if (ns.position.y == firstsp.position.y) {
                    direction = 2;
                    secondsp = ns;
                    secondIn = 1;
                    ns.scale = 1.2;
                    found = YES;
                    //CCLOG(@"second.position: %f,%f",ns.position.x,ns.position.y);
                    break;
                }
                else {
                    break;
                }
                
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row2, ns)
        {
            if (ns!=firstsp) {
                if (CGRectContainsPoint(ns.boundingBox, loc)) {
                    if (ns.position.x == firstsp.position.x) {
                        direction = 1;
                        secondsp = ns;
                        secondIn = 2;
                        ns.scale = 1.2;
                        found = YES;
                        //CCLOG(@"second.position: %f,%f",ns.position.x,ns.position.y);
                        break;
                    }
                    else if (ns.position.y == firstsp.position.y) {
                        direction = 2;
                        secondsp = ns;
                        secondIn = 2;
                        ns.scale = 1.2;
                        found = YES;
                        //CCLOG(@"second.position: %f,%f",ns.position.x,ns.position.y);
                        break;
                    }
                    else {
                        break;
                    }
                    
                }
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row3, ns)
        {
            if (ns!=firstsp) {
                if (CGRectContainsPoint(ns.boundingBox, loc)) {
                    if (ns.position.x == firstsp.position.x) {
                        direction = 1;
                        secondsp = ns;
                        secondIn = 3;
                        ns.scale = 1.2;
                        found = YES;
                        //CCLOG(@"second.position: %f,%f",ns.position.x,ns.position.y);
                        break;
                    }
                    else if (ns.position.y == firstsp.position.y) {
                        direction = 2;
                        secondsp = ns;
                        secondIn = 3;
                        ns.scale = 1.2;
                        found = YES;
                        //CCLOG(@"second.position: %f,%f",ns.position.x,ns.position.y);
                        break;
                    }
                    else {
                        break;
                    }
                    
                }
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row4, ns)
        {
            if (ns!=firstsp) {
                if (CGRectContainsPoint(ns.boundingBox, loc)) {
                    if (ns.position.x == firstsp.position.x) {
                        direction = 1;
                        secondsp = ns;
                        secondIn = 4;
                        ns.scale = 1.2;
                        found = YES;
                        //CCLOG(@"second.position: %f,%f",ns.position.x,ns.position.y);
                        break;
                    }
                    else if (ns.position.y == firstsp.position.y) {
                        direction = 2;
                        secondsp = ns;
                        secondIn = 4;
                        ns.scale = 1.2;
                        found = YES;
                        //CCLOG(@"second.position: %f,%f",ns.position.x,ns.position.y);
                        break;
                    }
                    else {
                        break;
                    }
                    
                }
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row5, ns)
        {
            if (ns!=firstsp) {
                if (CGRectContainsPoint(ns.boundingBox, loc)) {
                    if (ns.position.x == firstsp.position.x) {
                        direction = 1;
                        secondsp = ns;
                        secondIn = 5;
                        ns.scale = 1.2;
                        found = YES;
                        //CCLOG(@"second.position: %f,%f",ns.position.x,ns.position.y);
                        break;
                    }
                    else if (ns.position.y == firstsp.position.y) {
                        direction = 2;
                        secondsp = ns;
                        secondIn = 5;
                        ns.scale = 1.2;
                        found = YES;
                        //CCLOG(@"second.position: %f,%f",ns.position.x,ns.position.y);
                        break;
                    }
                    else {
                        break;
                    }
                    
                }
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row6, ns)
        {
            if (ns!=firstsp) {
                if (CGRectContainsPoint(ns.boundingBox, loc)) {
                    if (ns.position.x == firstsp.position.x) {
                        direction = 1;
                        secondsp = ns;
                        secondIn = 6;
                        ns.scale = 1.2;
                        found = YES;
                        //CCLOG(@"second.position: %f,%f",ns.position.x,ns.position.y);
                        break;
                    }
                    else if (ns.position.y == firstsp.position.y) {
                        direction = 2;
                        secondsp = ns;
                        secondIn = 6;
                        ns.scale = 1.2;
                        found = YES;
                        //CCLOG(@"second.position: %f,%f",ns.position.x,ns.position.y);
                        break;
                    }
                    else {
                        break;
                    }
                }
            }
        }
    }
    
}

-(void) getthird:(CGPoint)loc
{
    BOOL found = NO;
    NumberSprite* ns;
    CCARRAY_FOREACH(row1, ns)
    {
        if ((ns != firstsp)&&(ns!=secondsp)) {
            if (CGRectContainsPoint(ns.boundingBox, loc)) {
                if (direction==1) {
                    if ((ns.position.x == firstsp.position.x)&&(fabs(ns.position.y-secondsp.position.y)==45)) {
                        thirdsp = ns;
                        thirdIn = 1;
                        ns.scale = 1.2;
                        found = YES;
                        break;
                        
                    }
                    else {
                        break;
                    }
                }
                else if (direction==2) {
                    if ((ns.position.y == firstsp.position.y)&&(fabs(ns.position.x-secondsp.position.x)==45)) {
                        thirdsp = ns;
                        thirdIn = 1;
                        ns.scale = 1.2;
                        found = YES;
                        break;
                    }
                    else {
                        break;
                    }
                }
                else {
                    break;
                }
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row2, ns)
        {
            if ((ns != firstsp)&&(ns!=secondsp)) {
                if (CGRectContainsPoint(ns.boundingBox, loc)) {
                    if (direction==1) {
                        if ((ns.position.x == firstsp.position.x)&&(fabs(ns.position.y-secondsp.position.y)==45)) {
                            thirdsp = ns;
                            thirdIn = 2;
                            ns.scale = 1.2;
                            found = YES;
                            break;
                        }
                        else {
                            break;
                        }
                    }
                    else if (direction==2) {
                        if ((ns.position.y == firstsp.position.y)&&(fabs(ns.position.x-secondsp.position.x)==45)) {
                            thirdsp = ns;
                            thirdIn = 2;
                            ns.scale = 1.2;
                            found = YES;
                            break;
                        }
                        else {
                            break;
                        }
                    }
                    else {
                        break;
                    }
                }
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row3, ns)
        {
            if ((ns != firstsp)&&(ns!=secondsp)) {
                if (CGRectContainsPoint(ns.boundingBox, loc)) {
                    if (direction==1) {
                        if ((ns.position.x == firstsp.position.x)&&(fabs(ns.position.y-secondsp.position.y)==45)) {
                            thirdsp = ns;
                            thirdIn = 3;
                            ns.scale = 1.2;
                            found = YES;
                            break;
                        }
                        else {
                            break;
                        }
                    }
                    else if (direction==2) {
                        if ((ns.position.y == firstsp.position.y)&&(fabs(ns.position.x-secondsp.position.x)==45)) {
                            thirdsp = ns;
                            thirdIn = 3;
                            ns.scale = 1.2;
                            found = YES;
                            break;
                        }
                        else {
                            break;
                        }
                    }
                    else {
                        break;
                    }
                }
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row4, ns)
        {
            if ((ns != firstsp)&&(ns!=secondsp)) {
                if (CGRectContainsPoint(ns.boundingBox, loc)) {
                    if (direction==1) {
                        if ((ns.position.x == firstsp.position.x)&&(fabs(ns.position.y-secondsp.position.y)==45)) {
                            thirdsp = ns;
                            thirdIn = 4;
                            ns.scale = 1.2;
                            found = YES;
                            break;
                        }
                        else {
                            break;
                        }
                    }
                    else if (direction==2) {
                        if ((ns.position.y == firstsp.position.y)&&(fabs(ns.position.x-secondsp.position.x)==45)) {
                            thirdsp = ns;
                            thirdIn = 4;
                            ns.scale = 1.2;
                            found = YES;
                            break;
                        }
                        else {
                            break;
                        }
                    }
                    else {
                        break;
                    }
                }
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row5, ns)
        {
            if ((ns != firstsp)&&(ns!=secondsp)) {
                if (CGRectContainsPoint(ns.boundingBox, loc)) {
                    if (direction==1) {
                        if ((ns.position.x == firstsp.position.x)&&(fabs(ns.position.y-secondsp.position.y)==45)) {
                            thirdsp = ns;
                            thirdIn = 5;
                            ns.scale = 1.2;
                            found = YES;
                            break;
                        }
                        else {
                            break;
                        }
                    }
                    else if (direction==2) {
                        if ((ns.position.y == firstsp.position.y)&&(fabs(ns.position.x-secondsp.position.x)==45)) {
                            thirdsp = ns;
                            thirdIn = 5;
                            ns.scale = 1.2;
                            found = YES;
                            break;
                        }
                        else {
                            break;
                        }
                    }
                    else {
                        break;
                    }
                }
            }
        }
    }
    if (found==NO) {
        CCARRAY_FOREACH(row6, ns)
        {
            if ((ns != firstsp)&&(ns!=secondsp)) {
                if (CGRectContainsPoint(ns.boundingBox, loc)) {
                    if (direction==1) {
                        if ((ns.position.x == firstsp.position.x)&&(fabs(ns.position.y-secondsp.position.y)==45)) {
                            thirdsp = ns;
                            thirdIn = 6;
                            ns.scale = 1.2;
                            found = YES;
                            break;
                        }
                        else {
                            break;
                        }
                    }
                    else if (direction==2) {
                        if ((ns.position.y == firstsp.position.y)&&(fabs(ns.position.x-secondsp.position.x)==45)) {
                            thirdsp = ns;
                            thirdIn = 6;
                            ns.scale = 1.2;
                            found = YES;
                            break;
                        }
                        else {
                            break;
                        }
                    }
                    else {
                        break;
                    }
                }
            }
        }
    }
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (showtip==0) {
        return YES;
    }
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    return [self selectNumberSpriteFromPos:location];
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (showtip==0) {
        return;
    }
    //取得second，second必须和 first.x 或者 first.y 相等
    if (secondsp==nil) {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        [self getsecond:location];
    }
    else if ((secondsp!=nil)&&(thirdsp==nil)) {
        //取得third
        //判断third的x 或者y direction相等
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        [self getthird:location];
    }
    else {
        //nothing
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (showtip==0) {
        [self closeTip];
        return;
    }
    if ((firstsp)&&(secondsp)&&(thirdsp)) {
        firstsp.scale =1;
        secondsp.scale = 1;
        thirdsp.scale = 1;
        //求和
        int sum = firstsp.num + secondsp.num + thirdsp.num;
        ccColor3B ccco;
        if (sum < 7) {
            if ((sound==0)||(sound==2))
                [[SimpleAudioEngine sharedEngine] playEffect:@"low5.caf"];
            [self increaseHP:-1];
            score += 1;
            [scorelab setString:[NSString stringWithFormat:@"%d",score]];
            ccco = ccc3(255, 255, 255);
        }
        else if (sum == 7) {
            if ((sound==0)||(sound==2))
                [[SimpleAudioEngine sharedEngine] playEffect:@"equal5.caf"];
            [self increaseHP:3];
            score += 7;
            [scorelab setString:[NSString stringWithFormat:@"%d",score]];
            getSeven +=1;
            [movelab setString:[NSString stringWithFormat:@"%d",getSeven]];
            ccco = ccc3(255, 255, 0);
        }
        else {
            if ((sound==0)||(sound==2))
                [[SimpleAudioEngine sharedEngine] playEffect:@"more5.caf"];
            int dec = -2;
            [self increaseHP:dec];
            score += 1;
            //timeLeft -= 1;
            //if (score <0) {
            //    score = 0;
            //}
            [scorelab setString:[NSString stringWithFormat:@"%d",score]];
            ccco = ccMAGENTA; //ccc3(0, 0, 0);
        }
        //step += 1;
        //[movelab setString:[NSString stringWithFormat:@"%d",step]];
        
        //出现sum的值，然后放大到3，然后fadeout，然后free
        //CGSize wsize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF* valstr = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",sum] fontName:@"Arial" fontSize:50];
        valstr.color = ccco;
        valstr.position = secondsp.position;
        [self addChild:valstr z:3];
        
        CCScaleTo* st = [CCScaleTo actionWithDuration:0.5 scale:4];
        CCFadeOut* ft = [CCFadeOut actionWithDuration:0.5];
        CCSpawn* sp = [CCSpawn actions:st,ft, nil];
        CCCallBlockN* cb = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [node removeFromParentAndCleanup:YES];
        }];
        CCSequence* seq = [CCSequence actions:sp,cb, nil];
        [valstr runAction:seq];
        
        [self remove3AndAdd3];
        
        
        firstsp = nil;
        secondsp = nil;
        thirdsp = nil;
        direction = 0;
        firstIn = 0;
        secondIn = 0;
        thirdIn = 0;
        
    }
    else if ((firstsp)&&(secondsp)) {
        firstsp.scale =1;
        secondsp.scale = 1;
        firstsp = nil;
        secondsp = nil;
        thirdsp = nil;
        direction = 0;
        firstIn = 0;
        secondIn = 0;
        thirdIn = 0;
    }
    else if (firstsp){
        firstsp.scale = 1;
        firstsp = nil;
        secondsp = nil;
        thirdsp = nil;
        direction = 0;
        firstIn = 0;
        secondIn = 0;
        thirdIn = 0;
    }
    
    
}

-(void) remove3AndAdd3
{
    //如果在同一列
    if (firstIn==secondIn) {
        //get the object after firstsp, arrange it has a cceasebounceout action
        if (firstsp.position.y < thirdsp.position.y) {
            //从下向上滑动，获得所有大于thirdsp.position.y的元素，让他们向下掉，如果没有，则在位置新生成
            CCArray* currentRow;
            switch (firstIn) {
                case 1:
                    currentRow = row1;
                    break;
                case 2:
                    currentRow = row2;
                    break;
                case 3:
                    currentRow = row3;
                    break;
                case 4:
                    currentRow = row4;
                    break;
                case 5:
                    currentRow = row5;
                    break;
                case 6:
                    currentRow = row6;
                    break;
                default:
                    currentRow = row1;
                    break;
            }
            NumberSprite* ns;
            float finy = 0;
            CCARRAY_FOREACH(currentRow, ns)
            {
                if (ns.position.y >thirdsp.position.y) {
                    finy = ns.position.y - 135;
                    CCMoveBy* mb = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -135)];
                    CCEaseBounceOut* eb = [CCEaseBounceOut actionWithAction:mb];
                    [ns runAction:eb];
                    
                }
                else {
                    finy = ns.position.y-135;
                }
            }
            [currentRow removeObject:firstsp];
            [currentRow removeObject:secondsp];
            [currentRow removeObject:thirdsp];
            
            //add here
            int cusum = 0;
            CCARRAY_FOREACH(currentRow, ns)
            {
                cusum += ns.num;
            }
            
            int cleft = (abs(20 - cusum))/3;
            int c;
            int factor;
            if (cleft>6) {
                factor = 6;
            }
            else {
                factor = cleft;
            }
            
            NumberSprite* lastobj = (NumberSprite*)[currentRow lastObject];
            //add 3 new
            c = arc4random()%factor;
            NSString* fn = [NSString stringWithFormat:@"%d.png",c];
            NumberSprite* ns1 = [NumberSprite spriteWithFile:fn];
            ns1.num = c;
            ns1.position = ccp(lastobj.position.x, finy+ 180);
            [self addChild:ns1 z:2];
            [currentRow addObject:ns1];
            CCMoveBy* mb1 = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -135)];
            CCEaseBounceOut* eb1 = [CCEaseBounceOut actionWithAction:mb1];
            [ns1 runAction:eb1];
            
            c = arc4random()%factor;
            NSString* fn2 = [NSString stringWithFormat:@"%d.png",c];
            NumberSprite* ns2 = [NumberSprite spriteWithFile:fn2];
            ns2.num = c;
            ns2.position = ccp(lastobj.position.x, finy+ 225);
            [self addChild:ns2 z:2];
            [currentRow addObject:ns2];
            CCMoveBy* mb2 = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -135)];
            CCEaseBounceOut* eb2 = [CCEaseBounceOut actionWithAction:mb2];
            [ns2 runAction:eb2];
            
            c = arc4random()%factor;
            NSString* fn3 = [NSString stringWithFormat:@"%d.png",c];
            NumberSprite* ns3 = [NumberSprite spriteWithFile:fn3];
            ns3.num = c;
            ns3.position = ccp(lastobj.position.x, finy+270);
            [self addChild:ns3 z:2];
            [currentRow addObject:ns3];
            CCMoveBy* mb3 = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -135)];
            CCEaseBounceOut* eb3 = [CCEaseBounceOut actionWithAction:mb3];
            [ns3 runAction:eb3];
            
            
            
            [firstsp removeFromParentAndCleanup:YES];
            [secondsp removeFromParentAndCleanup:YES];
            [thirdsp removeFromParentAndCleanup:YES];
            
        }
        else {
            //从上向下滑动，获得所有大于firstsp.position.y的元素，让他们向下掉，如果没有，则在位置新生成
            CCArray* currentRow;
            switch (firstIn) {
                case 1:
                    currentRow = row1;
                    break;
                case 2:
                    currentRow = row2;
                    break;
                case 3:
                    currentRow = row3;
                    break;
                case 4:
                    currentRow = row4;
                    break;
                case 5:
                    currentRow = row5;
                    break;
                case 6:
                    currentRow = row6;
                    break;
                default:
                    currentRow = row1;
                    break;
            }
            NumberSprite* ns;
            float finy = 0;
            CCARRAY_FOREACH(currentRow, ns)
            {
                if (ns.position.y >firstsp.position.y) {
                    finy = ns.position.y - 135;
                    CCMoveBy* mb = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -135)];
                    CCEaseBounceOut* eb = [CCEaseBounceOut actionWithAction:mb];
                    [ns runAction:eb];
                    
                }
                else {
                    finy = ns.position.y-135;
                }
            }
            [currentRow removeObject:firstsp];
            [currentRow removeObject:secondsp];
            [currentRow removeObject:thirdsp];
            
            //add here
            int cusum = 0;
            CCARRAY_FOREACH(currentRow, ns)
            {
                cusum += ns.num;
            }
            
            int cleft = (abs(20 - cusum))/3;
            int c;
            int factor;
            if (cleft>6) {
                factor = 6;
            }
            else {
                factor = cleft;
            }
            
            NumberSprite* lastobj = (NumberSprite*)[currentRow lastObject];
            //add 3 new
            c = arc4random()%factor;
            NSString* fn = [NSString stringWithFormat:@"%d.png",c];
            NumberSprite* ns1 = [NumberSprite spriteWithFile:fn];
            ns1.num = c;
            ns1.position = ccp(lastobj.position.x, finy+ 180);
            [self addChild:ns1 z:2];
            [currentRow addObject:ns1];
            CCMoveBy* mb1 = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -135)];
            CCEaseBounceOut* eb1 = [CCEaseBounceOut actionWithAction:mb1];
            [ns1 runAction:eb1];
            
            c = arc4random()%factor;
            NSString* fn2 = [NSString stringWithFormat:@"%d.png",c];
            NumberSprite* ns2 = [NumberSprite spriteWithFile:fn2];
            ns2.num = c;
            ns2.position = ccp(lastobj.position.x, finy+ 225);
            [self addChild:ns2 z:2];
            [currentRow addObject:ns2];
            CCMoveBy* mb2 = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -135)];
            CCEaseBounceOut* eb2 = [CCEaseBounceOut actionWithAction:mb2];
            [ns2 runAction:eb2];
            
            c = arc4random()%factor;
            NSString* fn3 = [NSString stringWithFormat:@"%d.png",c];
            NumberSprite* ns3 = [NumberSprite spriteWithFile:fn3];
            ns3.num = c;
            ns3.position = ccp(lastobj.position.x, finy+270);
            [self addChild:ns3 z:2];
            [currentRow addObject:ns3];
            CCMoveBy* mb3 = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -135)];
            CCEaseBounceOut* eb3 = [CCEaseBounceOut actionWithAction:mb3];
            [ns3 runAction:eb3];
            
            [firstsp removeFromParentAndCleanup:YES];
            [secondsp removeFromParentAndCleanup:YES];
            [thirdsp removeFromParentAndCleanup:YES];
        }
        
    }
    else {
        //左右滑动，属于不同行列
        CCArray* currentRow;
        switch (firstIn) {
            case 1:
                currentRow = row1;
                break;
            case 2:
                currentRow = row2;
                break;
            case 3:
                currentRow = row3;
                break;
            case 4:
                currentRow = row4;
                break;
            case 5:
                currentRow = row5;
                break;
            case 6:
                currentRow = row6;
                break;
            default:
                currentRow = row1;
                break;
        }
        NumberSprite* ns;
        float finy = 0;
        CCARRAY_FOREACH(currentRow, ns)
        {
            if (ns.position.y >firstsp.position.y) {
                finy = ns.position.y - 45;
                CCMoveBy* mb = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -45)];
                CCEaseBounceOut* eb = [CCEaseBounceOut actionWithAction:mb];
                [ns runAction:eb];
                
            }
            else {
                finy = ns.position.y-45;
            }
        }
        [currentRow removeObject:firstsp];
        
        //add here
        int cusum = 0;
        CCARRAY_FOREACH(currentRow, ns)
        {
            cusum += ns.num;
        }
        
        int cleft = (abs(20 - cusum));
        int c;
        int factor;
        if (cleft>6) {
            factor = 6;
        }
        else {
            factor = cleft;
        }
        
        NumberSprite* lastobj = (NumberSprite*)[currentRow lastObject];
        //add 1 new
        c = arc4random()%factor;
        NSString* fn = [NSString stringWithFormat:@"%d.png",c];
        NumberSprite* ns1 = [NumberSprite spriteWithFile:fn];
        ns1.num = c;
        ns1.position = ccp(lastobj.position.x, finy+ 90);
        [self addChild:ns1 z:2];
        [currentRow addObject:ns1];
        CCMoveBy* mb1 = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -45)];
        CCEaseBounceOut* eb1 = [CCEaseBounceOut actionWithAction:mb1];
        [ns1 runAction:eb1];
        
        [firstsp removeFromParentAndCleanup:YES];
        
        
        switch (secondIn) {
            case 1:
                currentRow = row1;
                break;
            case 2:
                currentRow = row2;
                break;
            case 3:
                currentRow = row3;
                break;
            case 4:
                currentRow = row4;
                break;
            case 5:
                currentRow = row5;
                break;
            case 6:
                currentRow = row6;
                break;
            default:
                currentRow = row1;
                break;
        }
        CCARRAY_FOREACH(currentRow, ns)
        {
            if (ns.position.y >secondsp.position.y) {
                finy = ns.position.y - 45;
                CCMoveBy* mb = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -45)];
                CCEaseBounceOut* eb = [CCEaseBounceOut actionWithAction:mb];
                [ns runAction:eb];
                
            }
        }
        [currentRow removeObject:secondsp];
        
        //add here
        cusum = 0;
        CCARRAY_FOREACH(currentRow, ns)
        {
            cusum += ns.num;
        }
        
        cleft = abs(20 - cusum);
        if (cleft>5) {
            factor = 5;
        }
        else {
            factor = cleft;
        }
        
        lastobj = (NumberSprite*)[currentRow lastObject];
        //add 1 new
        c = arc4random()%factor;
        fn = [NSString stringWithFormat:@"%d.png",c];
        NumberSprite* ns2 = [NumberSprite spriteWithFile:fn];
        ns2.num = c;
        ns2.position = ccp(lastobj.position.x, finy+ 90);
        [self addChild:ns2 z:2];
        [currentRow addObject:ns2];
        CCMoveBy* mb2 = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -45)];
        CCEaseBounceOut* eb2 = [CCEaseBounceOut actionWithAction:mb2];
        [ns2 runAction:eb2];
        
        [secondsp removeFromParentAndCleanup:YES];
        
        
        
        switch (thirdIn) {
            case 1:
                currentRow = row1;
                break;
            case 2:
                currentRow = row2;
                break;
            case 3:
                currentRow = row3;
                break;
            case 4:
                currentRow = row4;
                break;
            case 5:
                currentRow = row5;
                break;
            case 6:
                currentRow = row6;
                break;
            default:
                currentRow = row1;
                break;
        }
        CCARRAY_FOREACH(currentRow, ns)
        {
            if (ns.position.y >thirdsp.position.y) {
                finy = ns.position.y - 45;
                CCMoveBy* mb = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -45)];
                CCEaseBounceOut* eb = [CCEaseBounceOut actionWithAction:mb];
                [ns runAction:eb];
                
            }
        }
        [currentRow removeObject:thirdsp];
        
        //add here
        cusum = 0;
        CCARRAY_FOREACH(currentRow, ns)
        {
            cusum += ns.num;
        }
        
        cleft = abs(20 - cusum);
        if (cleft>6) {
            factor = 6;
        }
        else {
            factor = cleft;
        }
        
        lastobj = (NumberSprite*)[currentRow lastObject];
        //add 1 new
        c = arc4random()%factor;
        fn = [NSString stringWithFormat:@"%d.png",c];
        NumberSprite* ns3 = [NumberSprite spriteWithFile:fn];
        ns3.num = c;
        ns3.position = ccp(lastobj.position.x, finy+ 90);
        [self addChild:ns3 z:2];
        [currentRow addObject:ns3];
        CCMoveBy* mb3 = [CCMoveBy actionWithDuration:0.3 position:ccp(0, -45)];
        CCEaseBounceOut* eb3 = [CCEaseBounceOut actionWithAction:mb3];
        [ns3 runAction:eb3];
        
        [thirdsp removeFromParentAndCleanup:YES];
        
    }
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    firstsp = nil;
    secondsp = nil;
    thirdsp = nil;
    direction = 0;
}



-(void) increaseHP:(int)val
{
    //show number up effect
    if (val >0) {
        
        timeLeft += val;
        [timelab setString:[NSString stringWithFormat:@"%d",timeLeft]];
    }
    else {
        timeLeft += val;
        [timelab setString:[NSString stringWithFormat:@"%d",timeLeft]];
    }
    
}

-(void) showGameOver
{
    if ((sound==0)||(sound==2))
        [[SimpleAudioEngine sharedEngine] playEffect:@"lost.caf"];
    
    //report score to game center
    if (score>0) {
        [[GCHelper sharedInstance] reportHardScore:score];
    }
    
    CGSize wsize = [[CCDirector sharedDirector] winSize];
    CCSprite* gobg = [CCSprite spriteWithFile:@"menubg.png"];
    gobg.position = ccp(wsize.width*0.5, wsize.height*0.5-40);
    gobg.tag = 600;
    [self addChild:gobg z:10];
    
    CCLabelTTF* gm = [CCLabelTTF labelWithString:@"Game Over!" fontName:@"Verdana" fontSize:32];
    gm.color = ccWHITE;
    gm.position = ccp(wsize.width*0.5, gobg.position.y + gobg.boundingBox.size.height*0.5 - 25);
    gm.tag = 601;
    [self addChild:gm z:11];
    
    CCSprite* seven = [CCSprite spriteWithFile:@"sevenlogo.png"];
    seven.position = ccp(wsize.width*0.28, gobg.position.y);
    seven.tag = 602;
    [self addChild:seven z:11];
    
    //seven logo, menu , share 3 btn , rate 1 btn
    CCSprite* restart = [CCSprite spriteWithFile:@"restartbtn.png"];
    restart.scale = 0.7;
    CCSprite* restart1 = [CCSprite spriteWithFile:@"restartbtn.png"];
    restart1.scale = 0.7;
    CCMenuItemSprite* rebtn = [CCMenuItemSprite itemWithNormalSprite:restart selectedSprite:restart1 target:self selector:@selector(restartGame2)];
    
    CCSprite* ex = [CCSprite spriteWithFile:@"exitbtn.png"];
    ex.scale = 0.7;
    CCSprite* ex1 = [CCSprite spriteWithFile:@"exitbtn.png"];
    ex1.scale = 0.7;
    CCMenuItemSprite* exbtn = [CCMenuItemSprite itemWithNormalSprite:ex selectedSprite:ex1 target:self selector:@selector(backtoMenu)];
    
    CCMenu* me = [CCMenu menuWithItems:rebtn,exbtn, nil];
    [me alignItemsVerticallyWithPadding:10];
    me.tag = 603;
    me.position = ccp(wsize.width*0.73, gobg.position.y+20);
    [self addChild:me z:11];
    
    SingleTouchSprite* twbtn = [SingleTouchSprite spriteWithFile:@"twitter.png"];
    twbtn.position = ccp(50, me.position.y - 120);
    twbtn.tag = 604;
    [self addChild:twbtn z:11];
    [twbtn initTheCallbackFunc0:@selector(tweet) withCaller:self];
    
    SingleTouchSprite* fbbtn = [SingleTouchSprite spriteWithFile:@"facebook.png"];
    fbbtn.position = ccp(twbtn.position.x + 70, twbtn.position.y);
    fbbtn.tag = 605;
    [self addChild:fbbtn z:11];
    [fbbtn initTheCallbackFunc0:@selector(facebook) withCaller:self];
    
    SingleTouchSprite* wbbtn = [SingleTouchSprite spriteWithFile:@"weibo.png"];
    wbbtn.position = ccp(fbbtn.position.x + 70, fbbtn.position.y);
    wbbtn.tag = 606;
    [self addChild:wbbtn z:11];
    [wbbtn initTheCallbackFunc0:@selector(weibo) withCaller:self];
    
    SingleTouchSprite* rtbtn = [SingleTouchSprite spriteWithFile:@"rate.png"];
    rtbtn.position = ccp(wbbtn.position.x+ 70, wbbtn.position.y);
    rtbtn.tag = 607;
    [self addChild:rtbtn z:11];
    [rtbtn initTheCallbackFunc0:@selector(rateus) withCaller:self];
    
    
    canPlayed = 0;
    
    //launch rate
    [Appirater setAppId:@"1010994739"];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
}

-(void) setGameOverLayerVisible:(BOOL)visible
{
    CCNode* it = [self getChildByTag:600];
    if (it) {
        it.visible = visible;
    }
    it = [self getChildByTag:601];
    if (it) {
        it.visible = visible;
    }
    it = [self getChildByTag:602];
    if (it) {
        it.visible = visible;
    }
    it = [self getChildByTag:603];
    if (it) {
        it.visible = visible;
    }
    it = [self getChildByTag:604];
    if (it) {
        it.visible = visible;
    }
    it = [self getChildByTag:605];
    if (it) {
        it.visible = visible;
    }
    it = [self getChildByTag:606];
    if (it) {
        it.visible = visible;
    }
    it = [self getChildByTag:607];
    if (it) {
        it.visible = visible;
    }
}

-(void)update:(ccTime)delta
{
    if (timeLeft<=0) {
        [self unscheduleUpdate];
        [self showGameOver];
    }
}



-(void) scheduleTimeDown
{
    timeLeft -= 1;
    [timelab setString:[NSString stringWithFormat:@"%d",timeLeft]];
    if (timeLeft == 3) {
        if ((sound==0)||(sound==2))
            [[SimpleAudioEngine sharedEngine] playEffect:@"alarm.caf"];
    }
    if (timeLeft <= 0) {
        //game over
        timeLeft = 0;
        [timelab setString:@"0"];
        
        //[self unscheduleUpdate];
        [self unschedule:_cmd];
        
        //show game over text and can't touch anymore
        [self showGameOver];
    }
}

-(void) setSoundOn
{
    sound = 2;
    NSUserDefaults* udata = [NSUserDefaults standardUserDefaults];
    [udata setInteger:2 forKey:@"com.tidemobiles.numberseven.sound"];
    [udata synchronize];
}
-(void) setSoundOff
{
    sound = 3;
    NSUserDefaults* udata = [NSUserDefaults standardUserDefaults];
    [udata setInteger:3 forKey:@"com.tidemobiles.numberseven.sound"];
    [udata synchronize];
}

-(void) setMusicOn
{
    music = 2;
    NSUserDefaults* udata = [NSUserDefaults standardUserDefaults];
    [udata setInteger:2 forKey:@"com.tidemobiles.numberseven.music"];
    [udata synchronize];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"loop.aifc" loop:YES];
}
-(void) setmusicOff
{
    music = 3;
    NSUserDefaults* udata = [NSUserDefaults standardUserDefaults];
    [udata setInteger:3 forKey:@"com.tidemobiles.numberseven.music"];
    [udata synchronize];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void) openMenu
{
    if (optOpened==1) {
        return;
    }
    else {
        //if game over
        CCNode* gameoverbg = [self getChildByTag:600];
        if (gameoverbg) {
            return;
        }
        
        optOpened = 1;
        //open menu
        if ((sound==0)||(sound==2)) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
        }
        //set main layer untouchable
        canPlayed = 0;
        
        [self pauseSchedulerAndActions];
        
        //bg , menu
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        CCSprite* menubg = [CCSprite spriteWithFile:@"menubg.png"];
        menubg.position = ccp(wsize.width*0.5, wsize.height*0.5-40);
        menubg.tag = 500;
        [self addChild:menubg z:10];
        
        CCSprite* seven = [CCSprite spriteWithFile:@"sevenlogo.png"];
        seven.position = ccp(wsize.width*0.28, menubg.position.y);
        seven.tag = 502;
        [self addChild:seven z:11];
        
        CCSprite* restart = [CCSprite spriteWithFile:@"restartbtn.png"];
        restart.scale = 0.7;
        CCSprite* restart1 = [CCSprite spriteWithFile:@"restartbtn.png"];
        restart1.scale = 0.7;
        CCMenuItemSprite* rebtn = [CCMenuItemSprite itemWithNormalSprite:restart selectedSprite:restart1 target:self selector:@selector(restartGame)];
        
        CCSprite* resume = [CCSprite spriteWithFile:@"resumebtn.png"];
        resume.scale = 0.7;
        CCSprite* resume1 = [CCSprite spriteWithFile:@"resumebtn.png"];
        resume1.scale = 0.7;
        CCMenuItemSprite* resbtn = [CCMenuItemSprite itemWithNormalSprite:resume selectedSprite:resume1 target:self selector:@selector(closeMenu)];
        
        CCSprite* ex = [CCSprite spriteWithFile:@"exitbtn.png"];
        ex.scale = 0.7;
        CCSprite* ex1 = [CCSprite spriteWithFile:@"exitbtn.png"];
        ex1.scale = 0.7;
        CCMenuItemSprite* exbtn = [CCMenuItemSprite itemWithNormalSprite:ex selectedSprite:ex1 target:self selector:@selector(backtoMenu)];
        
        CCMenu* me = [CCMenu menuWithItems:rebtn,resbtn,exbtn, nil];
        [me alignItemsVerticallyWithPadding:20];
        me.tag = 501;
        me.position = ccp(wsize.width*0.7, menubg.position.y);
        [self addChild:me z:11];
        
        
        
    }
}

-(void) closeMenu
{
    optOpened = 0;
    canPlayed = 1;
    if ((sound==0)||(sound==2)) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
    }
    [self resumeSchedulerAndActions];
    [self removeChildByTag:500 cleanup:YES];
    [self removeChildByTag:501 cleanup:YES];
    [self removeChildByTag:502 cleanup:YES];
}

-(void) restartGame
{
    if ((sound==0)||(sound==2)) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
    }
    [self cleanForNext];
    optOpened = 0;
    canPlayed = 1;
    [self resumeSchedulerAndActions];
    [self removeChildByTag:500 cleanup:YES];
    [self removeChildByTag:501 cleanup:YES];
    [self removeChildByTag:502 cleanup:YES];
}

-(void) restartGame2
{
    if ((sound==0)||(sound==2)) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
    }
    [self cleanForNext];
    optOpened = 0;
    canPlayed = 1;
    [self removeChildByTag:600 cleanup:YES]; //bg
    [self removeChildByTag:601 cleanup:YES]; //game over text
    [self removeChildByTag:602 cleanup:YES]; //menu
    [self removeChildByTag:603 cleanup:YES]; //7 logo
    [self removeChildByTag:604 cleanup:YES]; //twitter
    [self removeChildByTag:605 cleanup:YES]; //facebook
    [self removeChildByTag:606 cleanup:YES]; //weibo
    [self removeChildByTag:607 cleanup:YES]; //rate
    
    //[self scheduleUpdate];
    //[self schedule:@selector(scheduleTimeDown) interval:1];
    [self unscheduleAllSelectors];
    
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [[CCDirector sharedDirector] replaceScene:[AutoMatchFindLayer node]];
}

-(void) backtoMenu
{
    if ((sound==0)||(sound==2)) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
    }
    //[self cleanForNext];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [[CCDirector sharedDirector] replaceScene:[MenuLayer node]];
}

-(void)rateus
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"touch.caf"];
    NSString* staticurl = @"itms-apps://itunes.apple.com/app/id1010994739";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:staticurl]];
}

-(void) tweet
{
    if ((sound==0)||(sound==2)) [[SimpleAudioEngine sharedEngine] playEffect:@"camera.caf"];
    [self captureAll];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        NSString* tweetText = [NSString stringWithFormat:@"#Seven! I get %d Seven, total score %d.",getSeven,score];
        
        [controller setInitialText:tweetText];
        
        //Adding the URL to the facebook post value from iOS
        /*//[controller addURL:[NSURL URLWithString:@"http://facebook.com/tidestudio"]];*/
        //this url is the url of the last ninja free
        //it need to change at last
        [controller addURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id1010994739"]];
        //Adding the Image to the facebook post value from iOS
        if (capture) {
            [controller addImage:capture];
        }
        
        [[[CCDirector sharedDirector]parentViewController] presentViewController:controller animated:YES completion:Nil];
    }
    else {
        CCLOG(@"UnAvailable");
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void) facebook
{
    if ((sound==0)||(sound==2)) [[SimpleAudioEngine sharedEngine] playEffect:@"camera.caf"];
    [self captureAll];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        NSString* tweetText = [NSString stringWithFormat:@"#Seven! I get %d Seven, total score %d.",getSeven,score];
        
        [controller setInitialText:tweetText];
        
        //Adding the URL to the facebook post value from iOS
        /*//[controller addURL:[NSURL URLWithString:@"http://facebook.com/tidestudio"]];*/
        //this url is the url of the last ninja free
        //it need to change at last
        [controller addURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id1010994739"]];
        if (capture) {
            [controller addImage:capture];
        }
        
        [[[CCDirector sharedDirector]parentViewController] presentViewController:controller animated:YES completion:Nil];
    }
    else {
        CCLOG(@"UnAvailable");
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't connect to Facebook now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void) weibo
{
    if ((sound==0)||(sound==2)) [[SimpleAudioEngine sharedEngine] playEffect:@"camera.caf"];
    [self captureAll];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        NSString* tweetText = [NSString stringWithFormat:@"#Seven! 我一共算出了%d次7！我的总分是%d！",getSeven,score];
        
        [controller setInitialText:tweetText];
        
        //Adding the URL to the facebook post value from iOS
        /*//[controller addURL:[NSURL URLWithString:@"http://facebook.com/tidestudio"]];*/
        //this url is the url of the last ninja free
        //it need to change at last
        [controller addURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id1010994739"]];
        //Adding the Image to the facebook post value from iOS
        if (capture) {
            [controller addImage:capture];
        }
        
        [[[CCDirector sharedDirector]parentViewController] presentViewController:controller animated:YES completion:Nil];
    }
    else {
        CCLOG(@"UnAvailable");
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Can't connect to Sina weibo now, make sure your Internet connection is OK, and You have your Sina Weibo Application and Account correctlly setup on this device."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void) showTip
{
    canPlayed = 0;
    CGSize wsize = [[CCDirector sharedDirector] winSize];
    CCSprite* tbg = [CCSprite spriteWithFile:@"tipbg2.png"];
    tbg.position = ccp(wsize.width*0.5, wsize.height*0.5);
    tbg.tag = 900;
    [self addChild:tbg z:8];
    
    CCSprite* finger = [CCSprite spriteWithFile:@"finger.png"];
    finger.anchorPoint = ccp(0, 1);
    finger.position = ccp(tbg.position.x - 45, tbg.position.y);
    finger.tag = 901;
    [self addChild:finger z:9];
    
    CGPoint stpos = ccp(tbg.position.x - 45, tbg.position.y);
    
    CCMoveBy* fm = [CCMoveBy actionWithDuration:1 position:ccp(90, 0)];
    CCDelayTime* dt1 = [CCDelayTime actionWithDuration:0.5];
    CCCallBlockN* respos = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        node.position = stpos;
    }];
    CCSequence* csq = [CCSequence actions:fm,dt1,respos, nil];
    CCRepeatForever* crep = [CCRepeatForever actionWithAction:csq];
    [finger runAction:crep];
    
}

-(void) closeTip
{
    canPlayed = 1;
    NSUserDefaults* userdata = [NSUserDefaults standardUserDefaults];
    [userdata setInteger:1 forKey:@"com.tidemobiles.numberseven.tip2"];
    [userdata synchronize];
    showtip = 1;
    
    //close the sprite, finger
    CCSprite* sp = (CCSprite*)[self getChildByTag:900];
    if (sp) {
        [self removeChild:sp cleanup:YES];
    }
    CCSprite* sp1 = (CCSprite*)[self getChildByTag:901];
    if (sp1) {
        [sp1 stopAllActions];
        [self removeChild:sp1 cleanup:YES];
    }
    
    [self schedule:@selector(scheduleTimeDown) interval:1];
}

@end
