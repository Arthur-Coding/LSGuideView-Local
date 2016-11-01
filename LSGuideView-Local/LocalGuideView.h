//
//  LocalGuideView.h
//
//  Created by ArthurShuai on 16/4/14.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//
//  系统名称：加载本地图片引导页
//  功能描述：1.支持加载本地图片实现引导页
//          2.reloadData 刷新数据的方法,可以刷新引导页中数据

#import <UIKit/UIKit.h>

@interface LocalGuideView : UIScrollView

/**
 传递当前显示的图片的索引
 */
@property (nonatomic,copy)void(^pageIndexBlk)(NSInteger pageIndex);

/**
 初始化方法
 
 @param frame     frame
 @param imgArr    图片链接地址数组
 
 @return 实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame and:(NSArray *)imgArr;

/**
 开启自动轮播
 
 @param timeInterval 切换时间
 */
- (void)openCarouselWithTimeInterval:(NSInteger)timeInterval;

/**
 刷新数据方法
 */
- (void)reloadData;

@end
