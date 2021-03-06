
#import <Foundation/Foundation.h>

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#pragma mark - CircleView
/**
 *  解锁背景色
 */
#define CircleViewBackgroundColor rgba(13,52,89,1)

/**
 *  整个解锁View居中时，距离屏幕左边和右边的距离
 */
#define CircleViewEdgeMargin 20.0

/**
 *  整个解锁View的Center.y值 在当前屏幕的3/5位置
 */
#define CircleViewCenterY kScreenH * 3.0 / 5.0

/**
 *  连接的圆最少的个数
 */
#define CircleSetCountLeast 4

#pragma mark - Circle
/**
 *  普通状态下单个圆背景色
 */
#define CircleNormalBackgroundColor [UIColor clearColor]

/**
 *  选中状态下单个圆背景色
 */
#define CircleSelectedBackgroundColor  [[UIColor whiteColor] colorWithAlphaComponent:0.3];

/**
 *  错误状态下单个圆背景色
 */
#define CircleErrorBackgroundColor  [[UIColor redColor] colorWithAlphaComponent:0.3];

/**
 *  单个圆的半径
 */
#define CircleRadius 35.0

/**
 *  九宫格展示infoView 单个圆的半径
 */
#define CircleInfoRadius 5

/**
 *  单个圆的圆心
 */
#define CircleCenter CGPointMake(CircleRadius, CircleRadius)

#pragma mark - 外空心圆
/**
 *  普通状态下外空心圆颜色
 */
#define CircleStateNormalOutsideColor [UIColor whiteColor]

/**
 *  选中状态下外空心圆颜色
 */
#define CircleStateSelectedOutsideColor [UIColor clearColor]

/**
 *  错误状态下外空心圆颜色
 */
#define CircleStateErrorOutsideColor [UIColor clearColor]

/**
 *  空心圆圆环宽度
 */
#define CircleEdgeWidth 1.5

#pragma mark - 内实心圆
/**
 *  普通状态下内实心圆颜色
 */
#define CircleStateNormalInsideColor [UIColor clearColor]

/**
 *  选中状态下内实心圆颜色
 */
#define CircleStateSelectedInsideColor rgba(254,215,62,1)

/**
 *  错误状态内实心圆颜色
 */
#define CircleStateErrorInsideColor rgba(254,82,92,1)

/**
 *  内部实心圆占空心圆的比例系数
 */
#define CircleRadio 0.5

#pragma mark - 三角形
/**
 *  普通状态下三角形颜色
 */
#define CircleStateNormalTrangleColor [UIColor clearColor]

/**
 *  选中状态下三角形颜色
 */
#define CircleStateSelectedTrangleColor CircleStateSelectedInsideColor

/**
 *  错误状态三角形颜色
 */
#define CircleStateErrorTrangleColor CircleStateErrorInsideColor

/**
 *  三角形边长
 */
#define kTrangleLength 10.0f

#pragma mark - 连线
/**
 *  普通时连线颜色
 */
#define CircleConnectLineNormalColor CircleStateSelectedInsideColor

/**
 *  错误时连线颜色
 */
#define CircleConnectLineErrorColor CircleStateErrorInsideColor

/**
 *  连线宽度
 */
#define CircleConnectLineWidth 3.0

#pragma mark - other
/**
 *  错误状态下回显的时间
 */
#define kdisplayTime 1.0f

/**
 *  第一个手势密码存储key
 */
#define gestureOneSaveKey @"gestureOneSaveKey"

/**
 *  最大验证出错次数
 */
#define gestureVerifyWrongMaxTimes   5

#pragma mark - 文字
/**
 *  普通状态下文字提示的颜色
 */
#define textColorNormalState [UIColor whiteColor]

/**
 *  警告状态下文字提示的颜色
 */
#define textColorWarningState rgba(254,82,92,1)

/**
 *  绘制解锁界面准备好时，提示文字
 */
#define gestureTextBeforeSet @"绘制解锁图案"

/**
 *  设置时，连线个数少，提示文字
 */
#define gestureTextConnectLess [NSString stringWithFormat:@"最少连接%d个点，请重新绘制", CircleSetCountLeast]

/**
 *  确认图案，提示再次绘制
 */
#define gestureTextDrawAgain @"再次绘制解锁图案"

/**
 *  再次绘制不一致，提示文字
 */
#define gestureTextDrawAgainError @"与上次绘制不一致，请重新绘制"

/**
 *  设置成功
 */
#define gestureTextSetSuccess @"设置成功"

/**
 *  请输入原手势密码
 */
#define gestureTextOldGesture @"请输入原手势密码"

/**
 *  密码错误
 */
#define gestureTextGestureVerifyError @"密码错误"

/**
 *  请输入手势密码
 */
#define gestureTextGestureVerify    @"请输入手势密码"

#pragma mark - PCCircleViewConst
@interface PCCircleViewConst : NSObject

/**
 *  偏好设置：存字符串（手势密码）
 *
 *  @param gesture 字符串对象
 *  @param key     存储key
 */
+ (void)saveGesture:(NSString *)gesture Key:(NSString *)key;

/**
 *  偏好设置：取字符串手势密码
 *
 *  @param key key
 *
 *  @return 字符串对象
 */
+ (NSString *)getTmpGestureWithKey:(NSString *)key;


/**
 *  偏好设置：取字符串手势密码
 *
 *  @param key key
 *
 *  @return 字符串对象
 */
+ (NSString *)getGestureWithKey:(NSString *)key;

/**
 保存密码的key

 @param key key

 @return 保存结果
 */
+ (void)saveLockCodeKey:(NSString*)key;

@end
