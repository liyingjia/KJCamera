//
//  Utility.m
//  Join
//
//  Created by 黄克瑾 on 16/11/28.
//  Copyright © 2016年 huangkejin. All rights reserved.
//

#import "Utility.h"
#import "MBProgressHUD.h"
#import "DLHDActivityIndicator.h"

@implementation Utility

+ (BOOL)isValidTelephoneNum:(NSString *)strPhoneNum {
    NSString *phoneNumRegex1 = @"^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *phoneNum1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNumRegex1];
    
    return [phoneNum1 evaluateWithObject:strPhoneNum];
}

#pragma mark -提示语
+ (void)showTextDialog:(UIView *)view {
    //初始化进度框，置于当前的View当中
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    //    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = @"请稍等";
    
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(3);
    } completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
    }];
}

+ (void)showProgressDialog:(UIView *)view {
    [DLHDActivityIndicator hideActivityIndicatorInView:view];
    DLHDActivityIndicator *indicator = [[DLHDActivityIndicator alloc] init];
    indicator.window = view;
    [indicator showWithLabelText:@"正在加载"];
}

+ (void)showProgressDialog:(UIView *)view text:(NSString *)text {
    
    [DLHDActivityIndicator hideActivityIndicatorInView:view];
    DLHDActivityIndicator *indicator = [[DLHDActivityIndicator alloc] init];
    indicator.window = view;
    [indicator showWithLabelText:text];
}

+ (void)showProgressDialogText:(NSString *)text {
    DLHDActivityIndicator *indicator = [DLHDActivityIndicator shared];
    [indicator showWithLabelText:text];
}

+ (void)hideProgressDialog:(UIView *)view {
    [DLHDActivityIndicator hideActivityIndicatorInView:view];
    
}

+ (void)hideProgressDialog {
    
    [DLHDActivityIndicator hideActivityIndicator];
}

+ (void)showCustomDialog:(UIView *)view title:(NSString *)text {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.labelText = text;
    HUD.labelFont = [UIFont systemFontOfSize:14.0];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"save_complete"]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

+ (void)showAllTextDialog:(UIView *)view  Text:(NSString *)text{
    if (!view) {
        return;
    }
    if ([view isKindOfClass:[UITableView class]]) {
        view = view.superview;
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.margin = 12.f;
    HUD.detailsLabelText = text;
    HUD.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    //    HUD.yOffset = 150.0f;
    //    HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}


//计算一个时间与当前时间的时间差 返回秒
+ (NSDateComponents *)difftimeDate:(NSDate *)date withUnit:(NSCalendarUnit)unit {
    if (!date) {
        date = [NSDate date];
    }
    // 获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
//    NSCalendarUnit unit = unit;//NSCalendarUnitYear | NSCalendarUnitMonth
    //| NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
    
    /**
     *年差额 = dateCom.year
     *月差额 = dateCom.month
     *日差额 = dateCom.day
     *小时差额 = dateCom.hour
     *分钟差额 = dateCom.minute
     *秒差额 = dateCom.second
     */
    return dateCom;
}

+ (NSDateComponents *)date:(NSDate *)currenDate subtractDate:(NSDate *)date withUnit:(NSCalendarUnit)unit {
    // 获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
//    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:currenDate toDate:date options:0];
    
    /**
     *年差额 = dateCom.year
     *月差额 = dateCom.month
     *日差额 = dateCom.day
     *小时差额 = dateCom.hour
     *分钟差额 = dateCom.minute
     *秒差额 = dateCom.second
     */
    return dateCom;
}

//获取当前控制器
+ (UIViewController *)getCurrentViewController {

    UIViewController *resultVC;
    resultVC = [Utility _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [Utility _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [Utility _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [Utility _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

//字典转json字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
    }
    
    return dic;
}

@end
