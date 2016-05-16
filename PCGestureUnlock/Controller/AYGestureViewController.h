//
//  AYGestureViewController.h
//  PCGestureUnlock
//
//  Created by alpha yu on 5/13/16.
//  Copyright © 2016 coderMonkey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AYGestureType){
    AYGestureTypeSetting = 0,
    AYGestureTypeVerify,
    AYGestureTypeModify     //先验证再设置
};

@interface AYGestureViewController : UIViewController

@property (nonatomic, assign) AYGestureType type;

+ (BOOL)hasGesture;
+ (void)removeGesture;

@end
