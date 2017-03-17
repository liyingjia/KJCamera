//
//  ViewController.m
//  KJCamera
//
//  Created by Kegem Huang on 2017/3/17.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "ViewController.h"
#import "HVideoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCameraAction:(UIButton *)sender {
    //额 。。由于是demo,所以用的xib，大家根据需求自己更改，该demo只是提供一个思路，使用时不要直接拖入项目
    HVideoViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
    ctrl.HSeconds = 30;//设置可录制最长时间
    ctrl.takeBlock = ^(id item) {
        if ([item isKindOfClass:[NSURL class]]) {
            NSURL *videoURL = item;
            //视频url
            
        } else {
            //图片
            
        }
    };
    [self presentViewController:ctrl animated:YES completion:nil];
}

@end
