//
//  ScrollLockView.h
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

#import <UIKit/UIKit.h>

typedef enum {
    ScrollLockViewTypeAbove = 0,
	ScrollLockViewTypeBelow,
	ScrollLockViewTypeLeft,
    ScrollLockViewTypeRight
} ScrollLockViewType;

typedef enum {
    ScrollLockViewStateNormal = 0,
	ScrollLockViewStateLocking,
	ScrollLockViewStateLocked
} ScrollLockViewState;

@protocol ScrollLockViewDelegate;

@interface ScrollLockView : UIView

@property (strong, nonatomic) id<ScrollLockViewDelegate> delegate;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGPoint lockThreshold;
@property (assign, nonatomic, readonly) CGPoint scrollOffset;
@property (assign, nonatomic, readonly) ScrollLockViewType type;
@property (assign, nonatomic, readonly) ScrollLockViewState state;

+ (ScrollLockView *)viewWithSize:(CGSize)size aboveView:(UIScrollView *)view;
+ (ScrollLockView *)viewWithSize:(CGSize)size belowView:(UIScrollView *)view;
+ (ScrollLockView *)viewWithSize:(CGSize)size leftOfView:(UIScrollView *)view;
+ (ScrollLockView *)viewWithSize:(CGSize)size rightOfView:(UIScrollView *)view;

- (void)hide:(BOOL)animated;
- (void)hide:(BOOL)animated duration:(float)duration;
- (void)show:(BOOL)animated;
- (void)show:(BOOL)animated duration:(float)duration;

@end

@protocol ScrollLockViewDelegate <NSObject>

@optional
- (void)scrollView:(UIScrollView *)scrollView didHide:(ScrollLockView *)view;
- (void)scrollView:(UIScrollView *)scrollView didLockToView:(ScrollLockView *)view;
- (void)scrollView:(UIScrollView *)scrollView didShow:(ScrollLockView *)view;
- (void)scrollView:(UIScrollView *)scrollView willHide:(ScrollLockView *)view;
- (void)scrollView:(UIScrollView *)scrollView willShow:(ScrollLockView *)view;

@end
