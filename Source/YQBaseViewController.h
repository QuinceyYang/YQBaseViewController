//
//  YQBaseViewController.h
//  QuinceyYang
//
//  Created by 杨清 on 2017/4/11.
//  Copyright © 2017年 QuinceyYang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MoreNavLeftTag 10000
#define MoreNavRightTag 20000

@interface YQBaseViewController : UIViewController

@property (nonatomic, strong)NSString *navLeftImage;        ///<导航左按钮图片名
@property (nonatomic, strong)NSString *navRightImage;       ///<导航右按钮图片名
@property (nonatomic, strong)NSArray  *navLeftImageArray;   ///<导航左侧多按钮图片
@property (nonatomic, strong)NSArray  *navRightImageArray;  ///<导航右侧多按钮图片
@property (nonatomic, strong)NSString *titleStr;            ///<导航titleView;
@property (nonatomic, strong)NSString *titleImage;          ///<导航titleView;
@property (nonatomic, strong)UIColor  *titleColor;          ///<导航title颜色
@property (nonatomic, strong)UIColor  *navBgColor;          ///<导航栏颜色
@property (nonatomic, strong)UIColor  *navShadowColor;      ///<导航下面线的颜色

/**
 * 设置导航条Title颜色
 */
- (void)setTitleColor:(UIColor *)titleColor font:(UIFont *)font;


/**
 * 导航左侧按钮点击方法
 */
- (void)tapNavLeftBtn:(UIButton *)sender;

/**
 * 导航右侧按钮点击方法
 */
- (void)tapNavRightBtn:(UIButton *)sender;

/**
 * 导航多个左侧按钮点击方法（tag值越小，越靠前, tag值从10000开始）
 */
- (void)tapMoreNavLeftBtn:(UIButton *)sender;

/**
 * 导航多个右侧按钮点击方法(tag值越小，越靠前, tag值从20000开始)
 */
- (void)tapMoreNavRightBtn:(UIButton *)sender;

@end


