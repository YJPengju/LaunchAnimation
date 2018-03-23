# LaunchAnimation

#### 前言
设置iOS启动图，目前我知道的有三种方式
1. 在Xcode工程中自带的Assets.xcassets中通过添加New iOS Launch Image来添加启动图。
2. 在LaunchScreen.storyboad中添加设置启动页面。
3. 不在Assets中添加启动图，也不启用LaunchScreen.storyboad，直接在工程中添加名称Default-568h@2x.png为图片，系统会默认设置该图片为启动图。

#### 正文
App在启动时，显示LaunchImage，当APP初始化完成之后就会立即消失并显示App的界面，但是我们不想启动页面那么快或者那么平淡的消失掉（比如我们想加一个过渡效果，或者希望某些设置、数据加载完之后再消失），其实很简单，只要我们把LaunchImage再显示出来并且置顶，很用户伪造出一种还在启动页面的效果就Ok了。

下面是我写的一个Demo演示

![启动动画.gif](https://upload-images.jianshu.io/upload_images/2464399-bc3ab17986ad6495.gif?imageMogr2/auto-orient/strip)

两个动画效果，一个是缩放，一个是渐变，根据个人喜好可做更改。

#### 代码

这里我是在Assets里面添加的启动图，通过👇这个方法可以获取到系统启动图。
```
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
```

开始动画
```
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
```
调用
⚠️注意：调用之前要调用[self.window makeKeyAndVisible]，让窗口成为主窗口，并且显示出来。否则在创建LaunchView的时候获取的_window为nil，无法展示启动动画。
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //这里一定要调用[self.window makeKeyAndVisible]，让窗口成为主窗口，并且显示出来。
    [self.window makeKeyAndVisible];
    
    LaunchView *launchView = [[LaunchView alloc] init];
    //默认动画时间为2s
    launchView.time = 2.f;
    [launchView startAnimation];
    launchView.animationFinish = ^{
        NSLog(@"动画结束了");
    };
    
    return YES;
}
```

#### 结尾
这里我封装的是View，也可以封装成ViewController，个人喜好了。
