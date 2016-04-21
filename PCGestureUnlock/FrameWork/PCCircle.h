//
//  PCCircle.h
//
//  modified by alpha yu on 16/4/21.
//

#import <UIKit/UIKit.h>

/**
 *  单个圆的各种状态
 */
typedef NS_ENUM(NSInteger, CircleState) {
    CircleStateNormal = 1,
    CircleStateSelected,
    CircleStateError
};

/**
 *  单个圆的用途类型
 */
typedef NS_ENUM(NSInteger, CircleType) {
    CircleTypeInfo = 1,     //小九宫格 PCCircleInfoView 用，实心
    CircleTypeGesture
};

@interface PCCircle : UIView

/**
 *  所处的状态
 */
@property (nonatomic, assign) CircleState state;

/**
 *  类型
 */
@property (nonatomic, assign) CircleType type;

/**
 *  是否有箭头 default is YES
 */
@property (nonatomic, assign) BOOL arrow;

/** 角度 */
@property (nonatomic, assign) CGFloat angle;

@end
