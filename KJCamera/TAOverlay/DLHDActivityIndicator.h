//
//  DLHDActivityIndicator.h
//  TheMovieDB
//
//  Created by Elroy on 15/8/25.
//  Copyright (c) 2015年 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark DEFINITIONS

/**
 * Font for overlay status.
 */
#define OVERLAY_LABEL_FONT              [UIFont fontWithName:@"AvenirNext-Regular" size:14]

/**
 * Text color for overlay status.
 */
#define OVERLAY_LABEL_COLOR            [UIColor blackColor]

/**
 * Label padding value for X-axis.
 */
#define LABEL_PADDING_X         12.0

/**
 * Label padding value for Y-axis.
 */
#define LABEL_PADDING_Y         66.0

/**
 * Duration of Overlay appear and disappear animations.
 */
#define ANIMATION_DURATION      0.15

/**
 * Blur tint color. Default is clear.
 */
#define OVERLAY_BLUR_TINT_COLOR        [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]

@interface DLHDActivityIndicator : UIView

+ (DLHDActivityIndicator *)shared;

#pragma mark Show/Hide Methods

/**
 *  hides currently shown overlay.
 */
+ (void) hideActivityIndicator;
+ (void) hideActivityIndicatorInView:(UIView *)view;

/** The font of the overlay */
@property (strong, nonatomic) UIFont                   *overlayFont;

/** The font color of the overlay */
@property (strong, nonatomic) UIColor                  *overlayFontColor;

/** The current application window. */
@property (strong, nonatomic) UIView *window;

- (void) showWithLabelText:(NSString *)text;

@end
