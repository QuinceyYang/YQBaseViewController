//
//  YQBaseViewController.m
//  QuinceyYang
//
//  Created by 杨清 on 2017/4/11.
//  Copyright © 2017年 QuinceyYang. All rights reserved.
//

#import "YQBaseViewController.h"


@interface YQBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation YQBaseViewController

#if 1
/// 改变状态栏的颜色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    NSLog(@"状态栏改成 UIStatusBarStyleLightContent");
    return UIStatusBarStyleLightContent;
}
#endif

#pragma mark - Lifecycle
- (void)loadView
{
    [super loadView];
    
    // 背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    //解决ScrollView自动下移20像素
    self.automaticallyAdjustsScrollViewInsets = NO;
    //支持右滑返回上一级
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //ios 6和7导航栏适配
    if([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    // self
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //支持右滑返回上一级的代理
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (self.navigationController.navigationBarHidden == YES) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognize
{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark 设置导航条Title Label
- (void)setTitleStr:(NSString *)titleStr font:(UIFont *)font color:(UIColor *)color
{
    _titleStr = titleStr;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-100, 30);
    titleLab.text = titleStr;
    titleLab.font = font;
    titleLab.textColor = color;
    
    self.navigationItem.titleView = titleLab;
}

#pragma mark 设置导航条Title颜色
- (void)setTitleColor:(UIColor *)titleColor font:(UIFont *)font
{
    if (!titleColor)
    {
        return;
    }
    
    _titleColor = titleColor;
    
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0f)
    {
#ifdef __IPHONE_8_0
#else
        textAttrs[UITextAttributeTextColor] = titleColor;
        textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
        textAttrs[UITextAttributeFont] = font;
#endif
    }
    else
    {
        textAttrs[NSForegroundColorAttributeName] = titleColor;
        textAttrs[NSFontAttributeName] = font;
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeZero;
        textAttrs[NSShadowAttributeName] = shadow;
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
}



#pragma mark - setter
#pragma mark 设置导航条Title Button
- (void)setTitleImage:(NSString *)titleImage{
    _titleImage = titleImage;
    
    UIButton *titleBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 41.0f, 21.0f)];
    // 高亮的时候不要自动调整图标
    titleBut.adjustsImageWhenHighlighted = NO;
    titleBut.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleBut.imageView.contentMode = UIViewContentModeCenter;
    [titleBut setImage:[UIImage imageNamed:titleImage] forState:UIControlStateNormal];
    
    self.navigationItem.titleView = titleBut;
}


#pragma mark 设置导航条背景颜色
- (void)setNavBgColor:(UIColor *)navBgColor{
    if (!navBgColor) { return; }
    
    _navBgColor = navBgColor;
    // 设置导航栏背景
    UIImage *navImage = [self imageFromColor:navBgColor rectSize:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ? 44.0f : 64.0f)];
    [self.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
}

#pragma mark 设置导航条Shadow颜色
- (void)setNavShadowColor:(UIColor *)navShadowColor{
    if (!navShadowColor) { return; }
    _navShadowColor = navShadowColor;
    // 设置导航栏背景
    UIImage *navImage = [self imageFromColor:navShadowColor rectSize:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ? 44.0f : 0.50f)];
    self.navigationController.navigationBar.shadowImage = navImage;
}

#pragma mark 设置左边按钮
- (void)setNavLeftImage:(NSString *)navLeftImage{
    _navLeftImage = navLeftImage;
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 44, 44);
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(-8, 0, 44, 44);
    button.imageEdgeInsets = UIEdgeInsetsMake(-2, -6, 0, 0);
    //button.backgroundColor = [UIColor redColor];
    [button setImage:[UIImage imageNamed:navLeftImage] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapNavLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 1;
    
    [view addSubview:button];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

#pragma mark 设置右边按钮
- (void)setNavRightImage:(NSString *)navRightImage{
    _navRightImage = navRightImage;
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 40, 40);
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.imageEdgeInsets = UIEdgeInsetsMake(5, -5, 0, 0);
    //button.backgroundColor = [UIColor redColor];
    [button setImage:[UIImage imageNamed:navRightImage] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapNavRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 2;
    
    [view addSubview:button];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

#pragma mark 设置多个导航左按钮
- (void)setNavLeftImageArray:(NSArray *)navLeftImageArray{
    _navLeftImageArray = navLeftImageArray;
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i < navLeftImageArray.count; i++) {
        NSString *imageName = navLeftImageArray[i];
        NSInteger itemTag = MoreNavLeftTag + i;
        UIBarButtonItem *item = [self moreItemWithIcon:imageName highIcon:nil target:self action:@selector(tapMoreNavLeftBtn:) tag:itemTag];
        item.tag = itemTag;
        [itemArray addObject:item];
    }
    
    self.navigationItem.leftBarButtonItems = itemArray;
}

#pragma mark 设置多个导航右按钮
- (void)setNavRightImageArray:(NSArray *)navRightImageArray{
    _navRightImageArray = navRightImageArray;
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:1];
    
    //NSEnumerationReverse 倒序遍历
    [navRightImageArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *imageName = navRightImageArray[idx];
        NSInteger itemTag = MoreNavRightTag + navRightImageArray.count - (navRightImageArray.count - idx);
        UIBarButtonItem *item = [self moreItemWithIcon:imageName highIcon:nil target:self action:@selector(tapMoreNavRightBtn:) tag:itemTag];
        item.tag = itemTag;
        [itemArray addObject:item];
    }];
    
    self.navigationItem.rightBarButtonItems = itemArray;
}

#pragma mark - [ 设置导航按钮点击事件 ]
#pragma mark 点击左按钮
- (void)tapNavLeftBtn:(UIButton *)sender
{
    if ((self.navLeftImage && self.navLeftImage.length > 0) ||
        (self.navLeftImageArray && self.navLeftImageArray.count > 0))
    {
        if (self == self.navigationController.viewControllers[0]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark 点击右按钮
- (void)tapNavRightBtn:(UIButton *)sender
{

}

#pragma mark 点击左边其它按钮
- (void)tapMoreNavLeftBtn:(UIButton *)sender
{

}

#pragma mark 点击右边其它按钮
- (void)tapMoreNavRightBtn:(UIButton *)sender
{

}

#pragma mark 触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark 内存管理
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - [ 公共的一些方法 ]
#pragma mark 通过颜色来生成一个纯色图片
- (UIImage *)imageFromColor:(UIColor *)color rectSize:(CGRect)Rect
{
    UIGraphicsBeginImageContext(Rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, Rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


#pragma mark 创建多个自定义UIBarButtonItem
- (UIBarButtonItem *)moreItemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    if (highIcon && highIcon.length > 0) {
        [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    }
    button.tag = tag;
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    UIView *view = [[UIView alloc] init];
    view.frame = button.bounds;
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:button];
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}



@end



