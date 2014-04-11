//
//  PDViewController.m
//  PDCircleProgress
//
//  Created by ChenGe on 14-3-30.
//  Copyright (c) 2014年 Panda. All rights reserved.
//

#import "PDViewController.h"
#import "PDCircleProgress.h"

@interface PDViewController ()
{
    PDCircleProgress * progress;
    CGFloat tempProgress;
}

@end

@implementation PDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    progress = [[PDCircleProgress alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [progress setCenter:CGPointMake(160, 200)];
    [self.view addSubview:progress];
    tempProgress = 0;
    [self performSelector:@selector(go) withObject:nil afterDelay:3];
}

- (void)go
{
    if (tempProgress < 1) {
        tempProgress += 0.4;
        progress.progress = tempProgress;
    }
    [self performSelector:@selector(go) withObject:nil afterDelay:0.01];
}


@end
