//
//  Utility.h
//  Join
//
//  Created by 黄克瑾 on 16/11/28.
//  Copyright © 2016年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Utility : NSObject

//判断是否是手机号
+ (BOOL)isValidTelephoneNum:(NSString *)strPhoneNum;

//HUD
+ (void)showTextDialog:(UIView *)view;
+ (void)showProgressDialog:(UIView *)view;
+ (void)showProgressDialog:(UIView *)view text:(NSString *)text;
+ (void)showProgressDialogText:(NSString *)text;
+ (void)hideProgressDialog:(UIView *)view;
+ (void)hideProgressDialog;
+ (void)showCustomDialog:(UIView *)view title:(NSString *)text;
+ (void)showAllTextDialog:(UIView *)view  Text:(NSString *)text;


//计算一个时间与当前时间的时间差
+ (NSDateComponents *)difftimeDate:(NSDate *)date withUnit:(NSCalendarUnit)unit;
//两个时间差
+ (NSDateComponents *)date:(NSDate *)currenDate subtractDate:(NSDate *)date withUnit:(NSCalendarUnit)unit;

//获取当前控制器
+ (UIViewController *)getCurrentViewController;

//字典转json字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

//json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;



@end
