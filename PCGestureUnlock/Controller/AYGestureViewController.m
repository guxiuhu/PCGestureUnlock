//
//  AYGestureViewController.m
//  PCGestureUnlock
//
//  Created by alpha yu on 5/13/16.
//  Copyright © 2016 coderMonkey. All rights reserved.
//

#import "AYGestureViewController.h"
#import "PCCircleView.h"
#import "PCLockLabel.h"
#import "PCCircleViewConst.h"
#import "PCCircleInfoView.h"

@implementation AYGestureViewController {
    PCLockLabel *_msgLabel;
    NSInteger _verifyWrongTimes;
    
    PCCircleInfoView *_infoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    _verifyWrongTimes = 0;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgImageView];
    bgImageView.image = [UIImage imageNamed:@"bg_login"];
    
    PCCircleView *lockView = [[PCCircleView alloc] initWithType:(_type == AYGestureTypeSetting ? CircleViewTypeSetting : CircleViewTypeVerify) arrow:NO];
    lockView.delegate = (id<PCCircleViewDelegate>)self;
    [self.view addSubview:lockView];
    
    _msgLabel = [[PCLockLabel alloc] init];
    _msgLabel.frame = CGRectMake(0, CGRectGetMinY(lockView.frame) - 30, kScreenW, 14);
    _msgLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_msgLabel];
    
    if (_type == AYGestureTypeVerify) {
        [_msgLabel showNormalMsg:gestureTextGestureVerify];
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"忘记手势密码?"
                                                                                  attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                                                                                               NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                               NSFontAttributeName :[UIFont systemFontOfSize:12]
                                                                                               }];
        UIButton *forgetGestureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        forgetGestureBtn.frame = CGRectMake((kScreenW - 100) / 2.0, kScreenH - 60, 100, 30);
        [forgetGestureBtn setAttributedTitle:title forState:UIControlStateNormal];
        [forgetGestureBtn addTarget:self action:@selector(forgetGestureBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:forgetGestureBtn];
    } else {
        if (_type == AYGestureTypeSetting) {
            [[self class] removeGesture];
            [_msgLabel showNormalMsg:gestureTextBeforeSet];
            
            [self addInfoView];
            
        } else if (_type == AYGestureTypeModify) {
            [_msgLabel showNormalMsg:gestureTextGestureVerify];
        }
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        closeBtn.frame = CGRectMake(kScreenW - 60, kScreenH - 60, 50, 30);
        [closeBtn addTarget:self action:@selector(closeBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
    }
}

- (void)addInfoView {
    _infoView = [[PCCircleInfoView alloc] init];
    _infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    _infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(_msgLabel.frame) - CGRectGetHeight(_infoView.frame)/2 - 10);
    [self.view addSubview:_infoView];
}

#pragma mark - PCCircleViewDelegate
- (void)circleView:(PCCircleView *)view didCompleteSetFirstGesture:(NSString *)gesture result:(BOOL)success {
    if (success) {
        [_msgLabel showNormalMsg:gestureTextDrawAgain];
        
        //infoView展示对应选中的圆
        [_infoView selectedCirclesWithGesture:gesture];
    } else {
        [_msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal {
    if (equal) {
        [_msgLabel showNormalMsg:gestureTextSetSuccess];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:NULL];
        });
    } else {
        [_msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    }
}

- (void)circleView:(PCCircleView *)view didCompleteVerifyGesture:(NSString *)gesture result:(BOOL)equal {
    if (!equal) {
        [_msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        _verifyWrongTimes++;
        if (_verifyWrongTimes >= gestureVerifyWrongMaxTimes) {
            //TODO:手势密码录入错误5次，锁定该账号?
        }
        return;
    }
    
    if (_type == AYGestureTypeVerify) {
        if (equal) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    } else if (_type == AYGestureTypeModify) {
        if (equal) {
            [_msgLabel showNormalMsg:gestureTextBeforeSet];
            view.type = CircleViewTypeSetting;
            [self addInfoView];
        }
    }
}

#pragma mark -
+ (BOOL)hasGesture {
    NSString *gesture = [PCCircleViewConst getGestureWithKey:gestureFinalSaveKey];
    return gesture.length > 0 ? YES : NO;
}

+ (void)removeGesture {
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
    [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
}

#pragma mark - button action
- (void)forgetGestureBtnDidClick:(UIButton *)sender {
    //TODO:点击忘记密码后，自动退出账号/清除手势?
//    [[self class] removeGesture];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccess object:nil];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)closeBtnDidClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
