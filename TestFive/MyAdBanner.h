//
//  MyAdBanner.h
//  TestFive
//
//  Created by qing on 15/6/20.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import "cocos2d.h"

@interface MyAdBanner : NSObject<ADBannerViewDelegate>
{
    ADBannerView *_adBannerView;
    BOOL _adBannerViewIsVisible;
    UIView *_contentView;
}

@property (nonatomic, assign) ADBannerView *adBannerView;
@property (nonatomic) BOOL adBannerViewIsVisible;

- (void)createAdBannerView ;

@end
