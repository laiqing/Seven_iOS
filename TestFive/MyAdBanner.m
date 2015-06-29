//
//  MyAdBanner.m
//  TestFive
//
//  Created by qing on 15/6/20.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import "MyAdBanner.h"

@implementation MyAdBanner

-(id)init
{
    if ((self=[super init])) {
        [self createAdBannerView];
    }
    return self;
}

-(void)createAdBannerView
{
    _adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    [_adBannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    _adBannerView.delegate = self;
    [[[CCDirector sharedDirector] view] addSubview:_adBannerView];
}

-(void) dealloc
{
    if (_adBannerView) {
        [_adBannerView removeFromSuperview];
        [_adBannerView release];
    }
    [super dealloc];
}

/*!
 * @method bannerViewWillLoadAd:
 *
 * @discussion
 * Called when a banner has confirmation that an ad will be presented, but
 * before the resources necessary for presentation have loaded.
 */
- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
    
}

/*!
 * @method bannerViewDidLoadAd:
 *
 * @discussion
 * Called each time a banner loads a new ad. Once a banner has loaded an ad, it
 * will display it until another ad is available.
 *
 * It's generally recommended to show the banner view when this method is called,
 * and hide it again when bannerView:didFailToReceiveAdWithError: is called.
 */
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
}

/*!
 * @method bannerView:didFailToReceiveAdWithError:
 *
 * @discussion
 * Called when an error has occurred while attempting to get ad content. If the
 * banner is being displayed when an error occurs, it should be hidden
 * to prevent display of a banner view with no ad content.
 *
 * @see ADError for a list of possible error codes.
 */
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
}

/*!
 * @method bannerViewActionShouldBegin:willLeaveApplication:
 *
 * Called when the user taps on the banner and some action is to be taken.
 * Actions either display full screen content modally, or take the user to a
 * different application.
 *
 * The delegate may return NO to block the action from taking place, but this
 * should be avoided if possible because most ads pay significantly more when
 * the action takes place and, over the longer term, repeatedly blocking actions
 * will decrease the ad inventory available to the application.
 *
 * Applications should reduce their own activity while the advertisement's action
 * executes.
 */
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

/*!
 * @method bannerViewActionDidFinish:
 *
 * Called when a modal action has completed and control is returned to the
 * application. Games, media playback, and other activities that were paused in
 * bannerViewActionShouldBegin:willLeaveApplication: should resume at this point.
 */
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
}

@end
