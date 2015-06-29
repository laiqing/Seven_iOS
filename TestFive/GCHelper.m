//
//  GCHelper.m
//  TestFive
//
//  Created by qing on 15/6/23.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "GCHelper.h"
#import "AppDelegate.h"


@implementation GCHelper

static GCHelper *sharedHelper = nil;
+ (GCHelper *) sharedInstance {
    @synchronized([GCHelper class])
    {
        if (!sharedHelper) {
            [[self alloc] init];
        }
        return sharedHelper;
    }
    return nil;
}

+(id)alloc
{
    @synchronized ([GCHelper class])
    {
        NSAssert(sharedHelper == nil, @"Attempted to allocated a \
                 second instance of the GCHelper singleton");
        sharedHelper = [super alloc];
        return sharedHelper;
    }
    return nil;
}

-(id)init
{
    if ((self=[super init])) {
        useIOS7 = 1;
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}


- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    useIOS7 = 1;
    return (gcClass);
}


- (void)authenticationChanged {
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if ([GKLocalPlayer localPlayer].isAuthenticated &&
                           !userAuthenticated) {
                           NSLog(@"Authentication changed: player authenticated.");
                           userAuthenticated = TRUE;
                           [self resendData];
                       } else if (userAuthenticated) {
                           NSLog(@"Authentication changed: player not authenticated");
                           userAuthenticated = FALSE;
                       }
                   });
}

- (void)authenticateLocalUser {
    
    if (!gameCenterAvailable) return;
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        NSLog(@"not auth....");
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        localPlayer.authenticateHandler = ^(UIViewController *viewController,NSError *error) {
            if (localPlayer.authenticated) {
                //already authenticated
                NSLog(@"local player auth.");
                userAuthenticated = YES;
            } else if(viewController) {
                AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
                [[app navController] presentViewController:viewController animated:YES completion:^(){
                    userAuthenticated = YES;
                    NSLog(@"user auth in controller view...");
                }];
                //[self presentViewController:viewController];//present the login form
            } else {
                //problem with authentication,probably bc the user doesn't use Game Center
                NSLog(@"user not use game center....");
            }
        };
    }
    else {
        NSLog(@"Already authenticated!");
    }
}

-(void) resendData
{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    long besteasy = [userData integerForKey:EASY_MODE];
    if (besteasy > 0) {
        GKScore* sc = [[[GKScore alloc] initWithLeaderboardIdentifier:EASY_MODE] autorelease];
        sc.value = besteasy;
        sc.context = 0;
        NSArray *scores = @[sc];
        [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
            if (error == NULL) {
                //success report
                NSLog(@"resend easy data success...");
            }
            else {
                //save to best local value
                NSLog(@"error report occur: %@",error);
            }
        }];
    }
    long besthard = [userData integerForKey:HARD_MODE];
    if (besthard > 0) {
        GKScore* sc = [[[GKScore alloc] initWithLeaderboardIdentifier:HARD_MODE] autorelease];
        sc.value = besthard;
        sc.context = 0;
        NSArray *scores = @[sc];
        [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
            if (error == NULL) {
                //success report
                NSLog(@"resend data hard success...");
            }
            else {
                //save to best local value
                NSLog(@"error report occur: %@",error);
            }
        }];
    }
    long win = [userData integerForKey:WIN_COUNT];
    if (win > 0) {
        GKScore* sc = [[[GKScore alloc] initWithLeaderboardIdentifier:WIN_COUNT] autorelease];
        sc.value = win;
        sc.context = 0;
        NSArray *scores = @[sc];
        [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
            if (error == NULL) {
                //success report
                NSLog(@"resend data hard success...");
            }
            else {
                //save to best local value
                NSLog(@"error report occur: %@",error);
            }
        }];
    }
    long lost = [userData integerForKey:LOST_COUNT];
    if (lost > 0) {
        GKScore* sc = [[[GKScore alloc] initWithLeaderboardIdentifier:LOST_COUNT] autorelease];
        sc.value = lost;
        sc.context = 0;
        NSArray *scores = @[sc];
        [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
            if (error == NULL) {
                //success report
                NSLog(@"resend data hard success...");
            }
            else {
                //save to best local value
                NSLog(@"error report occur: %@",error);
            }
        }];
    }
    long draw = [userData integerForKey:DRAW_COUNT];
    if (draw > 0) {
        GKScore* sc = [[[GKScore alloc] initWithLeaderboardIdentifier:DRAW_COUNT] autorelease];
        sc.value = draw;
        sc.context = 0;
        NSArray *scores = @[sc];
        [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
            if (error == NULL) {
                //success report
                NSLog(@"resend data hard success...");
            }
            else {
                //save to best local value
                NSLog(@"error report occur: %@",error);
            }
        }];
    }
    
    
}

-(void) reportEasyScore:(int)score
{
    //save to local first
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    long besteasy = [userData integerForKey:EASY_MODE];
    if (score > besteasy) {
        [userData setInteger:score forKey:EASY_MODE];
        [userData synchronize];
    }
    if ([self gcAvailable] == NO) {
        NSLog(@"game center not available.");
        return;
    }
    
    GKScore* sc = [[[GKScore alloc] initWithLeaderboardIdentifier:EASY_MODE] autorelease];
    sc.value = score;
    sc.context = 0;
    NSArray *scores = @[sc];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (error == NULL) {
            //success report
            NSLog(@"success report to gc...");
        }
        else {
            //save to best local value
            NSLog(@"error report occur: %@",error);
        }
    }];
}

-(void) reportHardScore:(int)score
{
    //save to local first
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    long besteasy = [userData integerForKey:HARD_MODE];
    if (score > besteasy) {
        [userData setInteger:score forKey:HARD_MODE];
        [userData synchronize];
    }
    if ([self gcAvailable] == NO) {
        NSLog(@"game center not available.");
        return;
    }
    
    GKScore* sc = [[[GKScore alloc] initWithLeaderboardIdentifier:HARD_MODE] autorelease];
    sc.value = score;
    sc.context = 0;
    NSArray *scores = @[sc];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (error == NULL) {
            //success report
            NSLog(@"success report to gc.");
        }
        else {
            //save to best local value
            NSLog(@"error report occur: %@",error);
        }
    }];
}

-(void) reportWin:(int)score
{
    if ([self gcAvailable] == NO) {
        NSLog(@"game center not available.");
        return;
    }
    GKScore* sc = [[[GKScore alloc] initWithLeaderboardIdentifier:WIN_COUNT] autorelease];
    sc.value = score;
    sc.context = 0;
    NSArray *scores = @[sc];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (error == NULL) {
            //success report
            NSLog(@"success report to gc.");
        }
        else {
            //save to best local value
            NSLog(@"error report occur: %@",error);
        }
    }];
    
}
-(void) reportLost:(int)score
{
    if ([self gcAvailable] == NO) {
        NSLog(@"game center not available.");
        return;
    }
    GKScore* sc = [[[GKScore alloc] initWithLeaderboardIdentifier:LOST_COUNT] autorelease];
    sc.value = score;
    sc.context = 0;
    NSArray *scores = @[sc];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (error == NULL) {
            //success report
            NSLog(@"success report to gc.");
        }
        else {
            //save to best local value
            NSLog(@"error report occur: %@",error);
        }
    }];
}
-(void) reportDraw:(int)score
{
    if ([self gcAvailable] == NO) {
        NSLog(@"game center not available.");
        return;
    }
    GKScore* sc = [[[GKScore alloc] initWithLeaderboardIdentifier:DRAW_COUNT] autorelease];
    sc.value = score;
    sc.context = 0;
    NSArray *scores = @[sc];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (error == NULL) {
            //success report
            NSLog(@"success report to gc.");
        }
        else {
            //save to best local value
            NSLog(@"error report occur: %@",error);
        }
    }];
}




-(BOOL) gcAvailable
{
    if (!gameCenterAvailable || !userAuthenticated)
    {
        return NO;
    }
    else {
        return YES;
    }
}


















@end
