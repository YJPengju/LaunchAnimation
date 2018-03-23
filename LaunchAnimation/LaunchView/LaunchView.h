//
//  LaunchView.h
//  启动动画
//
//  Created by fighting on 2018/3/15.
//  Copyright © 2018年 Mr.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchView : UIView

/** 动画结束block */
@property (nonatomic, copy) void (^animationFinish)(void);
/** 动画时长 (默认2S)*/
@property (nonatomic, assign) NSTimeInterval time;

/**
 开启动画
 */
- (void)startAnimation;


@end
