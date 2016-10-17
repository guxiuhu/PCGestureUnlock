
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GestureViewControllerType){
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeVerify,
    GestureViewControllerTypeModify     //先验证再设置
};

typedef NS_ENUM(NSInteger, buttonTag){
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
};

@interface GestureViewController : UIViewController

/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;

@property (nonatomic, copy) void (^getPwdBlock)(NSString *pwd,id vc);
@property (nonatomic, copy) void (^loginUseOtherAccountBlock)();


/**
 头像
 */
@property (strong, nonatomic) UIImage *userImage;


@end
