//
//  LocalGuideView.m
//
//  Created by ArthurShuai on 16/4/14.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "LocalGuideView.h"

@interface LocalGuideView ()<UIScrollViewDelegate>

@property (nonatomic,strong)NSArray *imageArr;//图片数组,里面存放的图片的路径地址字符串
@property (nonatomic,strong) UIImageView *leftImg;//左边imageView
@property (nonatomic,strong) UIImageView *middleImg;//当前 imageView, 即中间显示的 imageView
@property (nonatomic,strong) UIImageView *rightImg;//右边imageView
@property (nonatomic       ) NSInteger   currentIndex;//当前图片索引
@property (nonatomic       ) NSInteger   direction;//滑动方向标识,0为无滑动,1为左滑动,2为右滑动

@property (nonatomic)BOOL isStartTimer;//是否开启定时器
@property (nonatomic,strong) NSTimer *timer;//定时器
@property (nonatomic)NSInteger timeInterval;//定时器时间间隔

@end
@implementation LocalGuideView
- (instancetype)initWithFrame:(CGRect)frame and:(NSArray *)imgArr{
    if (self = [super initWithFrame:frame]) {
        self.imageArr = imgArr;
        self.contentSize = CGSizeMake(CGRectGetWidth(frame) * 3, CGRectGetHeight(frame));
        self.pagingEnabled = YES;
        self.bounces = NO;//关闭弹性
        //关闭水平和垂直方向的滚动指示条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        //设置初始偏移,默认显示中间的图片
        self.contentOffset = CGPointMake(CGRectGetWidth(frame), 0);
        //设置代理
        self.delegate = self;
        //加载图片占位
        [self loadImageForScrollViewWithFrame:frame];
        
        //对方向的改变添加 KVO 监听
        [self addObserver:self forKeyPath:@"direction" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
//初始加载3个 imageView 进行占位并赋初值
- (void)loadImageForScrollViewWithFrame:(CGRect)frame{
    if (self.imageArr.count == 0) return;//防止数组为空
    _leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    _middleImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame), 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    _rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)*2, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    
    _middleImg.userInteractionEnabled = YES;
    _leftImg.userInteractionEnabled = YES;
    _rightImg.userInteractionEnabled = YES;
    
    [self addSubview:_leftImg];
    [self addSubview:_middleImg];
    [self addSubview:_rightImg];
    
    if (self.imageArr.count == 1) {//防止图片数据只有一个而因索引不存在崩溃
        [_leftImg removeFromSuperview];
        [_rightImg removeFromSuperview];
        _middleImg.image = [UIImage imageNamed:self.imageArr[0]];
        _middleImg.contentMode = UIViewContentModeScaleToFill;
        _middleImg.layer.masksToBounds = YES;
        self.scrollEnabled = NO;
    }
    if (self.imageArr.count > 1) {
        _leftImg.image = [UIImage imageNamed:self.imageArr[self.imageArr.count-1]];
        _middleImg.image = [UIImage imageNamed:self.imageArr[0]];
        _rightImg.image = [UIImage imageNamed:self.imageArr[1]];
        _leftImg.contentMode = UIViewContentModeScaleToFill;
        _middleImg.contentMode = UIViewContentModeScaleToFill;
        _rightImg.contentMode = UIViewContentModeScaleToFill;
        _leftImg.layer.masksToBounds = YES;
        _middleImg.layer.masksToBounds = YES;
        _rightImg.layer.masksToBounds = YES;
    }
}
- (void)openCarouselWithTimeInterval:(NSInteger)timeInterval{
    _timeInterval = timeInterval;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(pageChangeWithTimer) userInfo:nil repeats:YES];
    _isStartTimer = YES;
}

//时刻监听方向的改变,给方向属性赋值
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    self.direction = offsetX > CGRectGetWidth(self.frame) ? 1 : offsetX < CGRectGetWidth(self.frame) ? 2 : 0;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (self.imageArr.count == 0) return;//防止数组为空
    NSInteger direction = [change[NSKeyValueChangeNewKey] integerValue];
    if (direction == 0) return;
    NSInteger rightIndex = (_currentIndex+1)% self.imageArr.count;//判断索引合法
    NSInteger leftIndex = (_currentIndex-1)<0 ? self.imageArr.count-1 : _currentIndex-1;//判断索引合法
    _leftImg.image = [UIImage imageNamed:self.imageArr[leftIndex]];
    _rightImg.image = [UIImage imageNamed:self.imageArr[rightIndex]];
    _leftImg.contentMode = UIViewContentModeScaleToFill;
    _rightImg.contentMode = UIViewContentModeScaleToFill;
    _leftImg.layer.masksToBounds = YES;
    _rightImg.layer.masksToBounds = YES;
}
#pragma mark UIScrollViewDelegate
- (void)pageChange{
    if (self.imageArr.count == 0) return;//防止数组为空
    if (self.direction == 0) return;//无滑动直接返回
    else if (self.direction == 1) _currentIndex = (_currentIndex+1)% self.imageArr.count;//改变当前索引,并判断索引合法
    else if (self.direction == 2) _currentIndex = (_currentIndex-1)<0 ? self.imageArr.count-1 : _currentIndex-1;//改变当前索引,并判断索引合法
    _middleImg.image = [UIImage imageNamed:self.imageArr[_currentIndex]];
    _middleImg.contentMode = UIViewContentModeScaleToFill;
    _middleImg.layer.masksToBounds = YES;
    self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);//再次设置偏移
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self pageChange];
    if (_pageIndexBlk) _pageIndexBlk(_currentIndex);
    if (_isStartTimer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(pageChangeWithTimer) userInfo:nil repeats:YES];
    }
}
//MSTimer control
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}
//NSTimer event
- (void)pageChangeWithTimer{
    CGFloat offsetX = self.contentOffset.x + CGRectGetWidth(self.frame);
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    [self pageChange];
    if (_pageIndexBlk) _pageIndexBlk((_currentIndex+1)% self.imageArr.count);
}
//刷新数据
- (void)reloadData{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _currentIndex = 0;
    if (_pageIndexBlk) _pageIndexBlk(_currentIndex);
    [self.timer invalidate];
    if (_isStartTimer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(pageChangeWithTimer) userInfo:nil repeats:YES];
    }
    [self loadImageForScrollViewWithFrame:self.frame];
}

//结束程序后,销毁 KVO 监听与定时器
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"direction" context:nil];
    [self.timer invalidate];
}

@end
