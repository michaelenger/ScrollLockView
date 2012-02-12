# ScrollLockView

A view that attaches itself to a UIScrollView and locks the scroll when visible.
Inspired by: https://github.com/iStopped/PullToRefreshView

## Getting Started

Here is a small example of attaching the view above a text view.

    // A full-sized text view
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.text = @"Why, hello there!";
    
    // The lock view will be full width and 100px high
    CGSize lockViewSize = CGSizeMake(self.view.bounds.size.width, 100.0);
    ScrollLockView *lockView = [ScrollLockView viewWithSize:lockViewSize aboveView:textView];
    
    // Make it red so we can see it
    lockView.backgroundColor = [UIColor redColor];
    
    // Add some buttons and junk here...
    //[lockView addSubview:[UIButton ...]];
    //[lockView addSubview:[UILabel ...]];
    
    // Add the scroll view to the main view
    [self.view addSubview:textView];

## ScrollLockView Class Reference

### Properties

#### delegate

The delegate of the object.

```@property (strong, nonatomic) id<ScrollLockViewDelegate> delegate```

#### lockThreshold

Threshold for locking the scroll-view. This is automatically generated when creating the object using one of the constructor methods, but can be overridden.

```@property (assign, nonatomic) CGPoint lockThreshold```

#### scrollOffset

The offset which the scroll-view will lock to. This is generated programatically every time the property is referenced, so
be vary of using it often. (read-only)

```@property (assign, nonatomic, readonly) CGPoint scrollOffset```

#### scrollView

The UIScrollView which the object should lock.

```@property (strong, nonatomic) UIScrollView *scrollView```

#### state

The state of the object, as defined by the "State" constants (see below). (read-only)

```@property (assign, nonatomic, readonly) ScrollLockViewState state```

#### type

The type of the object, which defines which side (above, below, left or right) the object is in relation to the scroll-view. This is defined in the "Type" constants table (see below). (read-only)

```@property (assign, nonatomic, readonly) ScrollLockViewType type```

### Class Methods

#### viewWithSize:aboveView:

Creates and initializes a view to be above a specified scroll-view.

```+ (ScrollLockView *)viewWithSize:(CGSize)size aboveView:(UIScrollView *)view```

 * **size** Size of the view to create
 * **view** Scroll-view to attach to

#### viewWithSize:belowView:

Creates and initializes a view to be below a specified scroll-view.

```+ (ScrollLockView *)viewWithSize:(CGSize)size belowView:(UIScrollView *)view```

 * **size** Size of the view to create
 * **view** Scroll-view to attach to

#### viewWithSize:leftOfView:

Creates and initializes a view to be to the left of a specified scroll-view.

```+ (ScrollLockView *)viewWithSize:(CGSize)size leftOfView:(UIScrollView *)view```

 * **size** Size of the view to create
 * **view** Scroll-view to attach to

#### viewWithSize:rightOfView:

Creates and initializes a view to be to the right of a specified scroll-view.

```+ (ScrollLockView *)viewWithSize:(CGSize)size rightOfView:(UIScrollView *)view```

 * **size** Size of the view to create
 * **view** Scroll-view to attach to

### Instance Methods

#### hide:

Hides the object, returning the scroll-view to it's 0x0 origin.

```- (void)hide:(BOOL)animated```

 * **animated** Whether the movement should be animated

#### hide:duration:

Also hides the object, but does so based on a certain duration. If the ```animation``` parameter is set to ```NO``` then the duration value will be ignored.

```- (void)hide:(BOOL)animated duration:(float)duration```

 * **animated** Whether the movement should be animated
 * **duration** The amount of seconds to spend animating

#### show:

Shows the object, moving the scroll-view to the position specified by the ```scrollOffset``` property.

```- (void)show:(BOOL)animated```

 * **animated** Whether the movement should be animated

#### show:duration:

Also shows the object, but does so based on a certain duration. If the ```animation``` parameter is set to ```NO``` then the duration value will be ignored.

```- (void)show:(BOOL)animated duration:(float)duration```

 * **animated** Whether the movement should be animated
 * **duration** The amount of seconds to spend animating

### Delegate Methods

#### scrollView:didHide:

The view was hidden.

```- (void)scrollView:(UIScrollView *)scrollView didHide:(ScrollLockView *)view```

 * **scrollView** The scroll-view attached to the hidden view
 * **view** The view which was hidden

#### scrollView:didLockToView:

The scroll-view was locked to a specific view

```- (void)scrollView:(UIScrollView *)scrollView didLockToView:(ScrollLockView *)view```

 * **scrollView** The scroll-view which was locked
 * **view** The view it was locked to

#### scrollView:didShow:

The view was shown.

```- (void)scrollView:(UIScrollView *)scrollView didShow:(ScrollLockView *)view```

 * **scrollView** The scroll-view attached to the shown view
 * **view** The view which was shown

#### scrollView:willHide:

A scroll-view is about to hide a view

```- (void)scrollView:(UIScrollView *)scrollView willHide:(ScrollLockView *)view```

 * **scrollView** The scroll-view attached to the view to be hidden
 * **view** The view to hide

#### scrollView:willShow:

A scroll-view is about to show a view

```- (void)scrollView:(UIScrollView *)scrollView willShow:(ScrollLockView *)view```

 * **scrollView** The scroll-view attached to the view to be shown
 * **view** The view to show

### Constants

#### State

The state the object is in, which determines whether or not it can be shown/hidden.

    typedef enum {
        ScrollLockViewStateNormal,
        ScrollLockViewStateLocking,
        ScrollLockViewStateLocked
    } ScrollLockViewState

 * **ScrollLockViewStateNormal** Normal (hidden) state
 * **ScrollLockViewStateLocking** In the process of locking the scroll-view
 * **ScrollLockViewStateLocked** Has locked the scroll-view

#### Type

The type of object determines which side it is on relative to the scroll-view. This will affect the ```scrollOffset``` and ```lockThreshold``` properties and is defined if one of the constructors are used.

    typedef enum {
        ScrollLockViewTypeAbove,
        ScrollLockViewTypeBelow,
        ScrollLockViewTypeLeft,
        ScrollLockViewTypeRight
    } ScrollLockViewType

 * **ScrollLockViewTypeAbove** View is above the scroll-view
 * **ScrollLockViewTypeBelow** View is below the scroll-view
 * **ScrollLockViewTypeLeft** View is to the left of the scroll-view
 * **ScrollLockViewTypeRight** View is to the right of the scroll-view

## License

Copyright (c) 2012 The Lonely Coder

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

 * The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 * Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 * This notice may not be removed or altered from any source distribution.

