
//
//  DLHDActivityIndicator.m
//  TheMovieDB
//
//  Created by Elroy on 15/8/25.
//  Copyright (c) 2015年 iKode Ltd. All rights reserved.
//

#import "DLHDActivityIndicator.h"

@interface DLHDActivityIndicator ()

@property (strong, nonatomic) UIView *background;
/** The status label of the overlay */
@property (strong, nonatomic) UILabel *label;

/** The overlay view. */
@property (strong, nonatomic) UIToolbar *overlay;
/** The current label text. */
@property (strong, nonatomic) NSString *labelText;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@end

static NSMutableArray *indicatorArray;
static DLHDActivityIndicator *acIndicator = nil;

@implementation DLHDActivityIndicator

+ (DLHDActivityIndicator *)shared {
    if (acIndicator == nil) {
        acIndicator = [[DLHDActivityIndicator alloc] init];
    }
    return acIndicator;
}

#pragma mark Show/Hide Methods
+ (void) hideActivityIndicator
{
    [[self shared] overlayHide];
}

+ (void) hideActivityIndicatorInView:(UIView *)view{
    if ([view isKindOfClass:[UITableView class]]) {
        //        view = view.superview;
        for (UIView* next = view; next; next = next.superview) {
            UIResponder* nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                UIViewController *ctrl = (UIViewController*)nextResponder;
                view = ctrl.navigationController.view;
                break;
            }
        }
    }
    if (view) {//存在
        for (int i = 0; i < indicatorArray.count; i++) {
            DLHDActivityIndicator *indicator = indicatorArray[i];
            if ([indicator.window isEqual:view]) {
                [indicator overlayHide];
            }
        }
    } else {
        DLHDActivityIndicator *indicator = indicatorArray.lastObject;
        [indicator overlayHide];
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _background            = nil;
        _overlay               = nil;
        self.alpha = 0;
        indicatorArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate respondsToSelector:@selector(window)])
    {
        _window = [delegate performSelector:@selector(window)];
    }
    else
    {
        _window = [[UIApplication sharedApplication] keyWindow];
    }
//    _indicator = [[KMActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _indicator.color = [UIColor grayColor];
    return self;
}

- (void) showWithLabelText:(NSString *)text
{
    self.labelText = text;
    [self setProperties];
    [self overlayCreate];
    if (text == nil) {
        [_label removeFromSuperview];
        _label = nil;
    }
    else {
        _label.text = text;
    }
    _overlay.translucent = YES;
    _overlay.barTintColor = nil;
    _overlay.backgroundColor = OVERLAY_BLUR_TINT_COLOR;
    [self overlayShow];
}

- (void)overlayCreate
{
    if (_overlay == nil)
    {
        _overlay = [[UIToolbar alloc] initWithFrame:CGRectZero];
        _overlay.translucent = YES;
        _overlay.backgroundColor = [UIColor clearColor];
        _overlay.layer.masksToBounds = YES;
    }
    if (_overlay.superview == nil) {
        if (_background == nil) {
            CGRect backGroundRect = [_window convertRect:_window.bounds toView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];
            if (backGroundRect.size.height >= [UIScreen mainScreen].bounds.size.height) {
                backGroundRect.size.height -= 64;
                backGroundRect.origin.y = 64;
            }
            _background = [[UIView alloc] initWithFrame:backGroundRect];
    
            _background.backgroundColor = [UIColor clearColor];
            _background.alpha = 0.0;
            if ([_window isKindOfClass:[UITableView class]]) {
                for (UIView* next = _window; next; next = next.superview) {
                    UIResponder* nextResponder = [next nextResponder];
                    if ([nextResponder isKindOfClass:[UIViewController class]]) {
                        UIViewController *ctrl = (UIViewController*)nextResponder;
                        _window = ctrl.navigationController.view;
                        break;
                    }
                }
            }
            [_window addSubview:_background];
            [_background addSubview:_overlay];
        } else {
            [_window addSubview:_overlay];
        }
        //添加
        [_overlay addSubview:_indicator];
    }
    if (_label == nil)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.font = _overlayFont;
        _label.textColor = _overlayFontColor;
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _label.numberOfLines = 0;
    }
    if (_label.superview == nil) [_overlay addSubview:_label];
    
    CGRect labelRect = CGRectZero;
    CGFloat overlayWidth, overlayHeight;
    _overlay.layer.cornerRadius = 10;
    overlayWidth  = 100;
    overlayHeight = 100;
    if (_labelText != nil)
    {
        NSDictionary *attributes = @{NSFontAttributeName:_label.font};
        NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
        labelRect = [_labelText boundingRectWithSize:CGSizeMake(200, 300) options:options attributes:attributes context:NULL];
        
        overlayHeight = labelRect.size.height + _indicator.frame.size.height + 18+10;
        overlayWidth = ((labelRect.size.width + 2.0*LABEL_PADDING_X) < 100) ? 100 : labelRect.size.width + 2.0*LABEL_PADDING_X;
        labelRect.origin.x = overlayWidth/2.0 - labelRect.size.width/2.0;
        labelRect.origin.y = _indicator.frame.size.height + 15;
    }
    CGRect indicator_rect = _indicator.frame;
    indicator_rect.origin.x = (overlayWidth-_indicator.frame.size.width)/2;
    indicator_rect.origin.y = 10;
    _indicator.frame = indicator_rect;
    _overlay.bounds = CGRectMake(0, 0, overlayWidth, overlayHeight);
    
    //更改background frame
    CGFloat background_y = 0 - _background.frame.origin.y;
//    _background.frame = CGRectMake(0, background_y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    PLog(@"_background.center = %@",NSStringFromCGPoint(_background.center));
    _overlay.center = CGPointMake(_background.center.x, _window.center.y+background_y);
    _label.frame = labelRect;
}

- (void) setProperties {
    
    if (_overlayFont == nil)
    {
        _overlayFont = OVERLAY_LABEL_FONT;
    }
    if (_overlayFontColor == nil)
    {
        _overlayFontColor = OVERLAY_LABEL_COLOR;
    }
}

- (void)overlayShow
{
    if (self.alpha == 0)
    {
        self.alpha = 1;
        
        _overlay.alpha = 0;
        NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;
        [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:options animations:^{
            _overlay.alpha = 1;
            _background.alpha = 1;
        } completion:^(BOOL completion){
            [_indicator startAnimating];
        }];
        [indicatorArray addObject:self];
    }
}

- (void)overlayHide
{
    if (self.alpha == 1)
    {
        NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
        [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:options animations:^{
            _overlay.alpha = 0;
            _background.alpha = 0;
        }
                         completion:^(BOOL finished) {
                             [self overlayDestroy];
                             self.alpha = 0;;
                         }];
    }
}

- (void)overlayDestroy
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_label removeFromSuperview];		_label = nil;
    [_indicator removeFromSuperview];	_indicator = nil;
    [_overlay removeFromSuperview];		_overlay = nil;
    [_background removeFromSuperview];	_background = nil;
    acIndicator = nil;
}
@end
