//
//  ScrollLockView.m
//  ScrollLockView - A view that attaches itself to a UIScrollView and locks the
//                   scroll when visible.
//                   Inspired by: https://github.com/iStopped/PullToRefreshView
//
//  Created by Michael Enger on 2/12/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied warranty.
//  In no event will the authors be held liable for any damages arising from the
//  use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//   * The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software in a
//     product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//   * Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//   * This notice may not be removed or altered from any source distribution.
//

#import "ScrollLockView.h"

@interface ScrollLockView ()

+ (ScrollLockView *)viewWithFrame:(CGRect)frame inView:(UIScrollView *)view;

@end

@implementation ScrollLockView

@synthesize scrollView = _scrollView;

#pragma mark - Constructors

+ (ScrollLockView *)viewWithFrame:(CGRect)frame inView:(UIScrollView *)view {
    ScrollLockView *object = [[ScrollLockView alloc] initWithFrame:frame];

    object.scrollView = view;
    [view addSubview:object];

    return object;
}

+ (ScrollLockView *)viewWithSize:(CGSize)size aboveView:(UIScrollView *)view {
    CGRect frame = CGRectMake(0.0, -size.height, size.width, size.height);

    ScrollLockView *object = [ScrollLockView viewWithFrame:frame inView:view];
    object.scrollView.alwaysBounceVertical = YES;

    return object;
}

+ (ScrollLockView *)viewWithSize:(CGSize)size belowView:(UIScrollView *)view {
    float y = (view.contentSize.height > view.bounds.size.height ? view.contentSize.height : view.bounds.size.height);
    CGRect frame = CGRectMake(0.0, y, size.width, size.height);

    ScrollLockView *object = [ScrollLockView viewWithFrame:frame inView:view];
    object.scrollView.alwaysBounceVertical = YES;

    return object;
}

@end
