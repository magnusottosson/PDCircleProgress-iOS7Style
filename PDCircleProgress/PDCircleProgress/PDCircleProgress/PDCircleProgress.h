//
//  PDCircleProgress.h
//  PDCircleProgress
//
//  Created by ChenGe on 14-4-1.
//  Copyright (c) 2014年 Panda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PDCircleProgressStyleiOS7,
    PDCircleProgressStyleWeChat,
    PDCircleProgressStyleJD,
} PDCircleProgressStyle;

typedef enum : NSUInteger {
    PDCircleProgressStateTryToConnect,
    PDCircleProgressStateDownloading,
    PDCircleProgressStateFinished,
} PDCircleProgressState;

@interface PDCircleProgress : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, setter = setProgressStyle:) PDCircleProgressStyle progressStyle;
@property (nonatomic, assign) PDCircleProgressState progressState;

- (id)init __attribute__((deprecated("Use - initWithFrame: instead")));


@end
