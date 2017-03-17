# KJCamera
自定义相机-仿微信相机

由于是临时写的一个demo，还没有仔细整理，只是提供一个思路，大家如果觉得好的话在使用时，请不要直接拖入项目，稍作修改再使用，好不好大家勿喷。

##使用方法：
```
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
```

##效果图

![效果图](https://github.com/hkjin/KJCamera/blob/master/KJCamera/datasource/KJCamera.gif?raw=true)
