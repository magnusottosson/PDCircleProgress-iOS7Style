//
//  PDCircleProgress.m
//  PDCircleProgress
//
//  Created by ChenGe on 14-4-1.
//  Copyright (c) 2014年 Panda. All rights reserved.
//

#import "PDCircleProgress.h"

@interface PDCircleProgress ()
{
    CADisplayLink * _link;
    CGFloat _tempProgress;
    CGFloat _tempAlpha;
}
@end

@implementation PDCircleProgress

- (id)init { return [self initWithFrame:CGRectZero]; }

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width);
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup
{
    self.progress = 0.f;
    _tempProgress = 0.f;
    _tempAlpha = 0.f;
    self.progressStyle = PDCircleProgressStyleiOS7;
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)didMoveToSuperview
{
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    _link.frameInterval = 0.5;
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)drawRect:(CGRect)rect
{

    switch (self.progressStyle) {
        case PDCircleProgressStyleiOS7:
            [self iOS7Style];
            break;
        case PDCircleProgressStyleJD:
            
            break;
        case PDCircleProgressStyleWeChat:
            
            break;
        default:
            break;
    }
    
}

- (void)stateRefresh
{
    if ( self.progress <= 0.f)
    {
        [self setProgressState:PDCircleProgressStateTryToConnect];
    }
    else if ( self.progress >= 1.f)
    {
        [self setProgressState:PDCircleProgressStateFinished];
    }
    else
    {
        [self setProgressState:PDCircleProgressStateDownloading];
    }
}

- (void)setNeedsDisplay
{
    [self stateRefresh];
    [super setNeedsDisplay];
}

#pragma mark - ios7 style ：三个状态

const int lineWidth = 2;
#define BLUE_COLOR [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]
#define BLUE_COLOR_ALPHA(__x__) [UIColor colorWithRed:0 green:0.48 blue:1 alpha:__x__]

- (void)iOS7Style
{
    switch (self.progressState) {
        case PDCircleProgressStateTryToConnect:
            [self iOS7TryToConnect];
            break;
        case PDCircleProgressStateFinished:
            [self iOS7FinishedLoad];
            break;
        case PDCircleProgressStateDownloading:
            [self iOS7Loading];
            break;
    }
}

- (void)iOS7TryToConnect
{
    
    CGFloat phase = [self phase] * 2 * M_PI;
    UIBezierPath * circle = [UIBezierPath bezierPathWithArcCenter:RectGetCenter(self.bounds)
                                                           radius:self.bounds.size.width / 2 - lineWidth
                                                       startAngle:phase
                                                         endAngle:0.3 + phase clockwise:NO];
    
    [circle setLineWidth:lineWidth];
    [BLUE_COLOR setStroke];
    [circle stroke];
}

- (void)iOS7Loading
{
    CGFloat phase = [self phase] > 0 ? [self phase] : - [self phase];
    
    //loading background
    UIBezierPath * loadingPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, lineWidth, lineWidth)];
    [loadingPath setLineWidth:lineWidth];
    [BLUE_COLOR setStroke];
    [loadingPath stroke];
    
    CGFloat dx = self.bounds.size.width / 2 * 0.8;
    loadingPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, dx, dx)];
    [BLUE_COLOR setFill];
    [loadingPath fill];

    //loading Progress
    NSLog(@"%f",phase);
    _tempProgress = _tempProgress > self.progress ? 1 : _tempProgress + phase;
    loadingPath = [UIBezierPath bezierPathWithArcCenter:RectGetCenter(self.bounds) radius:self.bounds.size.width / 2 - lineWidth * 2.5 startAngle:ProgressToAngle(0) endAngle:ProgressToAngle(_tempProgress) clockwise:YES];
    [loadingPath setLineWidth:lineWidth * 2];
    [BLUE_COLOR setStroke];
    [loadingPath stroke];
    
}

- (void)iOS7FinishedLoad
{
    //底图
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectInset(self.bounds, lineWidth, lineWidth)];
    
    //对勾
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(21.5, 51.67)];
    [bezierPath addLineToPoint: CGPointMake(41.69, 71.5)];
    [bezierPath addLineToPoint: CGPointMake(78.5, 35.33)];
    [bezierPath addLineToPoint: CGPointMake(72.56, 29.5)];
    [bezierPath addLineToPoint: CGPointMake(41.69, 59.83)];
    [bezierPath addLineToPoint: CGPointMake(27.44, 45.83)];
    [bezierPath addLineToPoint: CGPointMake(21.5, 51.67)];
    [bezierPath closePath];
    
    //对勾大小修正
    CGFloat scale = self.bounds.size.width / 100;
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    [bezierPath applyTransform:transform];
    
    //合并曲线 打开奇偶填充规则
    [bezierPath appendPath:ovalPath];
    [bezierPath setUsesEvenOddFillRule:YES];
    
    //设置简单动画
    CGFloat step = 0.1;
    CGFloat secondsPerFrame = 0.1;
    NSTimeInterval ti = [NSDate timeIntervalSinceReferenceDate] / secondsPerFrame;
    CGFloat phase = step * (ti - floor(ti));
    if (_tempAlpha < 1) {
        _tempAlpha += phase;
    } else {
        [_link invalidate];
    }
    
    [BLUE_COLOR_ALPHA(_tempAlpha) setFill];
    [bezierPath fill];
    [BLUE_COLOR_ALPHA(_tempAlpha) setStroke];
    bezierPath.lineWidth = lineWidth;
    [bezierPath stroke];
}

#pragma mark - common phase
- (CGFloat)phase
{
    CGFloat distance = 1;
    CGFloat secondsPerFrame = 1;
    
    NSTimeInterval ti = [NSDate timeIntervalSinceReferenceDate] / secondsPerFrame;
    BOOL goesCW = YES;
    CGFloat phase = distance * (ti - floor(ti)) * (goesCW ? - 1 : 1);
    return phase;
}

#pragma mark - public math method

CGFloat ProgressToAngle(CGFloat progress)
{
    return  progress * M_PI * 2 - M_PI_2;
}

CGPoint RectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

@end
