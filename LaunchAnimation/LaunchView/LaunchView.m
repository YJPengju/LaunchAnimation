//
//  LaunchView.m
//  启动动画
//
//  Created by fighting on 2018/3/15.
//  Copyright © 2018年 Mr.li. All rights reserved.
//

#import "LaunchView.h"

@interface LaunchView()

/** 背景视图*/
@property (nonatomic , strong)UIImageView * bgImageView;
/** 主窗口*/
@property (nonatomic, strong) UIWindow * window;
@end

@implementation LaunchView

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _time = 2.f;
        _window = [UIApplication sharedApplication].keyWindow;
        _bgImageView = [[UIImageView alloc] initWithFrame:_window.bounds];
        _bgImageView.image = [self launchImage];
        [self addSubview:_bgImageView];
    }
    return self;
    
}


- (void)startAnimation {
    
    [_window addSubview:self];
    
    [_window bringSubviewToFront:self];
    
    _bgImageView.alpha = 1.0;
    
    [UIView animateWithDuration:self.time animations:^{
        //放大1.5倍
        _bgImageView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.0);
        //透明度变为0
        _bgImageView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.animationFinish) {
            self.animationFinish();
        }
    }];
}

#pragma mark - private

- (UIImage *)launchImage {
    CGSize viewSize = _window.bounds.size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImageName = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    UIImage *launchImage = [UIImage imageNamed:launchImageName];
    return launchImage;
}

@end
