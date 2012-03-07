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
- (void)setState:(ScrollLockViewState)state;
- (void)setType:(ScrollLockViewType)type;
- (void)wasHidden;
- (void)wasShown;

@end

@implementation ScrollLockView

@synthesize delegate = _delegate,
            lockThreshold = _lockThreshold,
            scrollView = _scrollView,
            state = _state,
            type = _type;

#pragma mark Constructors

+ (ScrollLockView *)viewWithFrame:(CGRect)frame inView:(UIScrollView *)view {
    ScrollLockView *object = [[ScrollLockView alloc] initWithFrame:frame];

    object.scrollView = view;
    object.lockThreshold = frame.origin;
    object.state = ScrollLockViewStateNormal;
    [view addSubview:object];

    return object;
}

+ (ScrollLockView *)viewWithHeight:(float)height aboveView:(UIScrollView *)view {
    CGRect frame = CGRectMake(0.0, -height, view.frame.size.width, height);

    ScrollLockView *object = [ScrollLockView viewWithFrame:frame inView:view];
    object.type = ScrollLockViewTypeAbove;
    object.lockThreshold = CGPointMake(frame.origin.x, frame.origin.y * 0.75);
    object.scrollView.alwaysBounceVertical = YES;

    return object;
}

+ (ScrollLockView *)viewWithHeight:(float)height belowView:(UIScrollView *)view {
    float y = (view.contentSize.height > view.bounds.size.height ? view.contentSize.height : view.bounds.size.height);
    CGRect frame = CGRectMake(0.0, y, view.frame.size.width, height);

    ScrollLockView *object = [ScrollLockView viewWithFrame:frame inView:view];
    object.type = ScrollLockViewTypeBelow;
    object.lockThreshold = CGPointMake(frame.origin.x, frame.origin.y + (frame.size.height * 0.75));
    object.scrollView.alwaysBounceVertical = YES;

    return object;
}

+ (ScrollLockView *)viewWithWidth:(float)width leftOfView:(UIScrollView *)view {
    CGRect frame = CGRectMake(-width, 0.0, width, view.frame.size.height);

    ScrollLockView *object = [ScrollLockView viewWithFrame:frame inView:view];
    object.type = ScrollLockViewTypeLeft;
    object.lockThreshold = CGPointMake(frame.origin.x * 0.75, frame.origin.y);
    object.scrollView.alwaysBounceHorizontal = YES;

    return object;
}

+ (ScrollLockView *)viewWithWidth:(float)width rightOfView:(UIScrollView *)view {
    CGRect frame = CGRectMake(view.bounds.size.width, 0.0, width, view.frame.size.height);

    ScrollLockView *object = [ScrollLockView viewWithFrame:frame inView:view];
    object.type = ScrollLockViewTypeRight;
    object.lockThreshold = CGPointMake(frame.origin.x + (frame.size.width * 0.75), frame.origin.y);
    object.scrollView.alwaysBounceHorizontal = YES;

    return object;
}

#pragma mark Show/hide

- (void)hide:(BOOL)animated {
    [self hide:animated duration:0.5];
}

- (void)hide:(BOOL)animated duration:(float)duration {
    if ([self.delegate respondsToSelector:@selector(scrollView:willHide:)])
        [self.delegate scrollView:self.scrollView willHide:self];

    if (animated) {
        [UIView animateWithDuration:duration delay:0 options:0 animations:^{
            self.scrollView.contentInset = UIEdgeInsetsZero;
        } completion:^(BOOL finished){
            if (finished) {
                [self wasHidden];
            }
        }];
    } else {
        self.scrollView.contentInset = UIEdgeInsetsZero;
        [self wasHidden];
    }
}

- (void)show:(BOOL)animated {
    [self show:animated duration:0.5];
}

- (void)show:(BOOL)animated duration:(float)duration {
    if ([self.delegate respondsToSelector:@selector(scrollView:willShow:)])
        [self.delegate scrollView:self.scrollView willShow:self];

    if (animated) {
        self.state = ScrollLockViewStateLocking;
        [UIView animateWithDuration:duration delay:0 options:0 animations:^{
            self.scrollView.contentInset = self.scrollEdgeInsets;
        } completion:^(BOOL finished){
            if (finished) {
                [self wasShown];
            }
        }];
    } else {
        self.scrollView.contentInset = self.scrollEdgeInsets;
        [self wasShown];
    }
}

- (void)wasHidden {
    self.state = ScrollLockViewStateNormal;
    if ([self.delegate respondsToSelector:@selector(scrollView:didHide:)])
        [self.delegate scrollView:self.scrollView didHide:self];
}

- (void)wasShown {
    self.state = ScrollLockViewStateLocked;
    if ([self.delegate respondsToSelector:@selector(scrollView:didShow:)])
        [self.delegate scrollView:self.scrollView didShow:self];
}

#pragma mark Properties

- (UIEdgeInsets) scrollEdgeInsets {
    UIEdgeInsets inset = UIEdgeInsetsZero;
    
    switch (self.type) {
        case ScrollLockViewTypeAbove:
            inset.top = self.frame.size.height;
            break;
        case ScrollLockViewTypeBelow:
            if (self.scrollView.contentSize.height > self.scrollView.bounds.size.height)
                inset.bottom = self.frame.size.height;
            else
                inset.top = -self.frame.size.height;
            break;
        case ScrollLockViewTypeLeft:
            inset.left = self.frame.size.width;
            break;
        case ScrollLockViewTypeRight:
            inset.right = self.frame.size.width;
            break;
    }
    
    return inset;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    // Update content offset observation
    if (_scrollView != nil) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    if (scrollView != nil) {
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }

    _scrollView = scrollView;
}

- (void)setState:(ScrollLockViewState)state {
    _state = state;
}

- (void)setType:(ScrollLockViewType)type {
    _type = type;
}

#pragma mark UIScrollView

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        UIScrollView *scrollView = (UIScrollView *)object;

        if (!scrollView.isDragging) {
            BOOL lockView = NO;
            CGPoint contentOffset = scrollView.contentOffset;

            switch (self.type) {
                case ScrollLockViewTypeAbove:
                    lockView = (contentOffset.y <= self.lockThreshold.y);
                    break;
                case ScrollLockViewTypeBelow:
                    contentOffset.y += (scrollView.contentSize.height > scrollView.bounds.size.height ? scrollView.contentSize.height : scrollView.bounds.size.height);
                    lockView = (contentOffset.y >= self.lockThreshold.y);
                    break;
                case ScrollLockViewTypeLeft:
                    lockView = (contentOffset.x <= self.lockThreshold.x);
                    break;
                case ScrollLockViewTypeRight:
                    contentOffset.x += scrollView.bounds.size.width;
                    lockView = (contentOffset.x >= self.lockThreshold.x);
                    break;
                default:
                    @throw [NSException exceptionWithName: @"TypeException" reason: @"Incorrect type specified for ScrollLockViewType" userInfo: nil];
            }

            if (lockView) {
                if (self.state != ScrollLockViewStateLocking) { // prevents double events
                    if ([self.delegate respondsToSelector:@selector(scrollView:willLockToView:)])
                        if(![self.delegate scrollView:self.scrollView willLockToView:self])
                            return;
                    self.state = ScrollLockViewStateLocking;
                    scrollView.contentInset = self.scrollEdgeInsets;
                    if ([self.delegate respondsToSelector:@selector(scrollView:didLockToView:)])
                        [self.delegate scrollView:self.scrollView didLockToView:self];
                    self.state = ScrollLockViewStateLocked;
                }
            } else {
                if (self.state != ScrollLockViewStateLocking) {
                    // Allow the user to scroll away from the view
                    self.state = ScrollLockViewStateNormal;
                    self.scrollView.contentInset = UIEdgeInsetsZero;
                }
            }
        }
    }
}


@end
