//
//  PCCircleView.h
//
//  modified by alpha yu on 16/4/21.
//

#import <UIKit/UIKit.h>
#import "PCCircle.h"
#import "PCCircleViewConst.h"

/**
 *  手势密码界面用途类型
 */
typedef NS_ENUM(NSInteger, CircleViewType) {
    CircleViewTypeSetting = 1, // 设置手势密码
    CircleViewTypeVerify       // 验证手势密码
};

@class PCCircleView;

@protocol PCCircleViewDelegate <NSObject>

@optional

/**
 *  获取到第一个手势密码时通知代理
 *
 *  @param view    circleView
 *  @param gesture 第一个次保存的密码
 *  @param success 是否成功(通常失败是选中的数量不够)
 */
- (void)circleView:(PCCircleView *)view didCompleteSetFirstGesture:(NSString *)gesture result:(BOOL)success;

/**
 *  获取到第二个手势密码时通知代理
 *
 *  @param view    circleView
 *  @param gesture 第二次手势密码
 *  @param equal   第二次和第一次获得的手势密码匹配结果
 */
- (void)circleView:(PCCircleView *)view didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal;

/**
 *  验证手势密码输入完成时的代理方法
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 登陆时的手势密码
 */
- (void)circleView:(PCCircleView *)view didCompleteVerifyGesture:(NSString *)gesture result:(BOOL)equal;

@end

@interface PCCircleView : UIView

/**
 *  是否剪裁 default is YES
 */
@property (nonatomic, assign) BOOL clip;

/**
 *  是否有箭头 default is YES
 */
@property (nonatomic, assign) BOOL arrow;

/**
 *  解锁类型
 */
@property (nonatomic, assign) CircleViewType type;

// 代理
@property (nonatomic, weak) id<PCCircleViewDelegate> delegate;

/**
 *  初始化方法
 *
 *  @param type  类型
 *  @param clip  是否剪裁
 *  @param arrow 是否显示三角形箭头
 */
- (instancetype)initWithType:(CircleViewType)type clip:(BOOL)clip arrow:(BOOL)arrow;

+ (BOOL)hasGesture;
+ (void)removeGesture;

@end
