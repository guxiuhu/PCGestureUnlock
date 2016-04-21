
#import <UIKit/UIKit.h>

@interface PCCircleInfoView : UIView

/**
 *  根据选中的手势选中相应的circle
 */
- (void)selectedCirclesWithGesture:(NSString *)gesture;

/**
 *  还原视图
 */
- (void)reset;

@end
