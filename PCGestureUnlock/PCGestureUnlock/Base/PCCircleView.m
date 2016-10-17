//
//  PCCircleView.m
//
//  modified by alpha yu on 16/4/21.
//

#import "PCCircleView.h"
#import "PCCircle.h"
#import "PCCircleViewConst.h"
#import "QiyeDBHelper.h"
#import "QiyeSingleData.h"

@interface PCCircleView()

// 选中的圆的集合
@property (nonatomic, strong) NSMutableArray *circleSet;

// 当前点
@property (nonatomic, assign) CGPoint currentPoint;

// 数组清空标志
@property (nonatomic, assign) BOOL hasClean;

@end

@implementation PCCircleView

- (NSMutableArray *)circleSet {
    if (!_circleSet) {
        _circleSet = [NSMutableArray array];
    }
    return _circleSet;
}

#pragma mark - 初始化方法
- (instancetype)initWithType:(CircleViewType)type arrow:(BOOL)arrow {
    return [self initWithType:type clip:arrow arrow:arrow];
}

- (instancetype)initWithType:(CircleViewType)type clip:(BOOL)clip arrow:(BOOL)arrow {
    if (self = [super init]) {
        // 解锁视图准备
        [self lockViewPrepare];
        
        _type = type;
        _clip = clip;
        _arrow = arrow;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        // 解锁视图准备
        [self lockViewPrepare];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 解锁视图准备
        [self lockViewPrepare];
    }
    return self;
}

/*
 *  解锁视图准备
 */
- (void)lockViewPrepare {
    
    [self setFrame:CGRectMake(0, 0,
                              [UIScreen mainScreen].bounds.size.width - CircleViewEdgeMargin * 2,
                              [UIScreen mainScreen].bounds.size.width - CircleViewEdgeMargin * 2)];
    [self setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0, CircleViewCenterY)];
    
    // 默认剪裁子控件
    self.clip = YES;
    
    // 默认有箭头
    self.arrow = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
    for (NSUInteger i = 0; i < 9; i++) {
        
        PCCircle *circle = [[PCCircle alloc] init];
        circle.type = CircleTypeGesture;
        circle.arrow = NO;
        [self addSubview:circle];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat itemViewWH = CircleRadius * 2.0;
    CGFloat marginValue = (self.frame.size.width - itemViewWH * 3) / 3.0f;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        
        NSUInteger row = idx % 3;
        
        NSUInteger col = idx / 3;
        
        CGFloat x = itemViewWH * row + marginValue * row + marginValue / 2.0;
        
        CGFloat y = itemViewWH * col+ marginValue * col + marginValue / 2.0;
        
        CGRect frame = CGRectMake(x, y, itemViewWH, itemViewWH);
        
        // 设置tag -> 密码记录的单元
        subview.tag = idx + 1;
        
        subview.frame = frame;
    }];
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview {
    newSuperview.backgroundColor = CircleViewBackgroundColor;
}

#pragma mark - touch began - moved - end
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self gestureEndResetMembers];
    
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.subviews enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(circle.frame, point)) {
            circle.state = CircleStateSelected;
            [self.circleSet addObject:circle];
            *stop = YES;
        }
    }];
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.subviews enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(circle.frame, point)) {
            if (![self.circleSet containsObject:circle]) {
                [self.circleSet addObject:circle];
                
                // move过程中的连线（包含跳跃连线的处理）
                [self calAngleAndconnectTheJumpedCircle];
                
                *stop = YES;
            }
        } else {
            self.currentPoint = point;
        }
    }];
    
    [self.circleSet enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
        circle.state = CircleStateSelected;
    }];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _hasClean = NO;
    
    NSString *gesture = [self getGestureResultFromCircleSet:self.circleSet];
    
    if (gesture.length == 0) {
        return;
    }

    // 手势绘制结果处理
    if (_type == CircleViewTypeSetting) {
        [self gestureEndByTypeSettingWithGesture:gesture length:gesture.length];
    } else {
        [self gestureEndByTypeVerifyWithGesture:gesture length:gesture.length];
    }
    
    // 手势结束后是否错误回显重绘，取决于是否延时清空数组和状态复原
    [self errorToDisplay];
}

/**
 *  是否错误回显重绘
 */
- (void)errorToDisplay {
    if ([self getCircleState] == CircleStateError) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kdisplayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gestureEndResetMembers];
        });
    } else {
        [self gestureEndResetMembers];
    }
}

/**
 *  手势结束时的清空操作
 */
- (void)gestureEndResetMembers {
    @synchronized(self) {   // 保证线程安全
        if (!_hasClean) {
            
            // 手势完毕，选中的圆回归普通状态
            [self changeCircleInCircleSetWithState:CircleStateNormal];
            
            // 清空数组
            [self.circleSet removeAllObjects];
            
            // 清空方向
            [self resetAllCirclesDirect];
            
            // 完成之后改变clean的状态
            _hasClean = YES;
        }
    }
}

/**
 *  获取当前选中圆的状态
 */
- (CircleState)getCircleState {
    return [(PCCircle *)[self.circleSet firstObject] state];
}

/**
 *  清空所有子控件的方向
 */
- (void)resetAllCirclesDirect {
    [self.subviews enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
        circle.angle = 0;
        circle.arrow = NO;
    }];
}

/**
 *  解锁类型：设置 手势路径的处理
 */
- (void)gestureEndByTypeSettingWithGesture:(NSString *)gesture length:(NSUInteger)length {
    if (length < CircleSetCountLeast) {     // 连接少于最少个数
        NSString *gestureOne = [PCCircleViewConst getTmpGestureWithKey:gestureOneSaveKey];
        
        if (gestureOne.length > 0) {    // 看是否存在第一个密码
            if ([self.delegate respondsToSelector:@selector(circleView:didCompleteSetSecondGesture:result:)]) {
                [self.delegate circleView:self didCompleteSetSecondGesture:gesture result:NO];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(circleView:didCompleteSetFirstGesture:result:)]) {
                [self.delegate circleView:self didCompleteSetFirstGesture:gesture result:NO];
            }
        }
        
        // 2.改变状态为error
        [self changeCircleInCircleSetWithState:CircleStateError];
        
    } else {        // 连接多于最少个数
        NSString *gestureOne = [PCCircleViewConst getTmpGestureWithKey:gestureOneSaveKey];
        if (gestureOne.length < CircleSetCountLeast) { // 接收并存储第一个密码
            // 记录第一次密码
            [PCCircleViewConst saveGesture:gesture Key:gestureOneSaveKey];
            
            // 通知代理
            if ([self.delegate respondsToSelector:@selector(circleView:didCompleteSetFirstGesture:result:)]) {
                [self.delegate circleView:self didCompleteSetFirstGesture:gesture result:YES];
            }
        } else { // 接受第二个密码并与第一个密码匹配，一致后存储起来
            BOOL equal = [gesture isEqualToString:[PCCircleViewConst getTmpGestureWithKey:gestureOneSaveKey]]; // 匹配两次手势
            if (equal){     // 一致，存储密码
                
                NSString *key = [[QiyeSingleData instance]getDataWithKey:@"gestureKeySaveKey"];
                NSAssert(key, @"没有传进来保存的key");
                QiyeDBHelper *db = [[QiyeDBHelper alloc]init];
                [db insertWithKey:key andLockCode:gesture];
                
                [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
            } else {        // 不一致，重绘回显
                [self changeCircleInCircleSetWithState:CircleStateError];
            }
            
            // 通知代理
            if ([self.delegate respondsToSelector:@selector(circleView:didCompleteSetSecondGesture:result:)]) {
                [self.delegate circleView:self didCompleteSetSecondGesture:gesture result:equal];
            }
        }
    }
}

/**
 *  解锁类型：验证 手势路径的处理
 */
- (void)gestureEndByTypeVerifyWithGesture:(NSString *)gesture length:(NSUInteger)length {
    
    NSString *key = [[QiyeSingleData instance]getDataWithKey:@"gestureKeySaveKey"];
    NSAssert(key, @"没有传进来保存的key");
    QiyeDBHelper *db = [[QiyeDBHelper alloc]init];

    NSString *password = [db selectLockCodeWithKey:key];

    BOOL equal = [gesture isEqualToString:password];
    if (!equal) {
        [self changeCircleInCircleSetWithState:CircleStateError];
    }
    
    if ([self.delegate respondsToSelector:@selector(circleView:didCompleteVerifyGesture:result:)]) {
        [self.delegate circleView:self didCompleteVerifyGesture:gesture result:equal];
    }
}

/**
 *  改变选中数组CircleSet子控件状态
 */
- (void)changeCircleInCircleSetWithState:(CircleState)state {
    [self.circleSet enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
        circle.state = state;
    }];
    
    [self setNeedsDisplay];
}

/**
 *  将circleSet数组解析遍历，拼手势密码字符串
 */
- (NSString *)getGestureResultFromCircleSet:(NSMutableArray *)circleSet {
    NSMutableString *gesture = [NSMutableString string];
    
    for (PCCircle *circle in circleSet) {
        // 遍历取tag拼字符串
        [gesture appendFormat:@"%@", @(circle.tag)];
    }
    
    return gesture;
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    // 如果没有任何选中按钮， 直接retrun
    if (self.circleSet == nil || self.circleSet.count == 0) return;
    
    UIColor *color;
    if ([self getCircleState] == CircleStateError) {
        color = CircleConnectLineErrorColor;
    } else {
        color = CircleConnectLineNormalColor;
    }
    
    // 绘制图案
    [self connectCirclesInRect:rect lineColor:color];
}

/**
 *  将选中的圆形以color颜色链接起来
 *
 *  @param rect  图形上下文
 *  @param color 连线颜色
 */
- (void)connectCirclesInRect:(CGRect)rect lineColor:(UIColor *)color {
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加路径
    CGContextAddRect(ctx, rect);
    
    //是否剪裁
    [self clipSubviewsWhenConnectInContext:ctx clip:self.clip];
    
    //剪裁上下文
    CGContextEOClip(ctx);
    
    // 遍历数组中的circle
    for (NSInteger index = 0; index < self.circleSet.count; index++) {
        
        // 取出选中按钮
        PCCircle *circle = self.circleSet[index];
        
        if (index == 0) { // 起点按钮
            CGContextMoveToPoint(ctx, circle.center.x, circle.center.y);
        } else {
            CGContextAddLineToPoint(ctx, circle.center.x, circle.center.y); // 全部是连线
        }
    }
    
    // 连接最后一个按钮到手指当前触摸得点
    if (!CGPointEqualToPoint(self.currentPoint, CGPointZero)) {
        
        [self.subviews enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
            
            if ([self getCircleState] == CircleStateError) {
                // 如果是错误的状态下不连接到当前点
                
            } else {
                
                CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
                
            }
        }];
    }
    
    //线条转角样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    // 设置绘图的属性
    CGContextSetLineWidth(ctx, CircleConnectLineWidth);
    
    // 线条颜色
    [color set];
    
    //渲染路径
    CGContextStrokePath(ctx);
}

/**
 *  是否剪裁子控件
 *
 *  @param ctx  图形上下文
 *  @param clip 是否剪裁
 */
- (void)clipSubviewsWhenConnectInContext:(CGContextRef)ctx clip:(BOOL)clip {
    if (clip) {
        
        // 遍历所有子控件
        [self.subviews enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
            
            CGContextAddEllipseInRect(ctx, circle.frame); // 确定"剪裁"的形状
        }];
    }
}

/**
 *  每添加一个圆，就计算一次方向
 */
- (void)calAngleAndconnectTheJumpedCircle {
    if (_circleSet == nil || _circleSet.count <= 1) {
        return;
    }
    
    //取出最后一个
    PCCircle *lastOne = [_circleSet lastObject];
    
    //倒数第二个
    PCCircle *lastTwo = [_circleSet objectAtIndex:(self.circleSet.count - 2)];
    
    //计算倒数第二个的位置
    CGFloat last_1_x = lastOne.center.x;
    CGFloat last_1_y = lastOne.center.y;
    CGFloat last_2_x = lastTwo.center.x;
    CGFloat last_2_y = lastTwo.center.y;
    
    // 1.计算角度（反正切函数）
    CGFloat angle = atan2(last_1_y - last_2_y, last_1_x - last_2_x) + M_PI_2;
    lastTwo.angle = angle;
    lastTwo.arrow = _arrow;
    
    // 2.处理跳跃连线
    CGPoint center = [self centerPointWithPointOne:lastOne.center pointTwo:lastTwo.center];
    PCCircle *centerCircle = [self enumCircleSetToFindWhichSubviewContainTheCenterPoint:center];
    if (centerCircle) {
        // 把跳过的圆加到数组中，它的位置是倒数第二个
        if (![_circleSet containsObject:centerCircle]) {
            centerCircle.arrow = _arrow;
            [_circleSet insertObject:centerCircle atIndex:_circleSet.count - 1];
        }
    }
}

/**
 *  提供两个点，返回一个它们的中点
 *
 *  @param pointOne
 *  @param pointTwo
 *
 *  @return 两点的中点
 */
- (CGPoint)centerPointWithPointOne:(CGPoint)pointOne pointTwo:(CGPoint)pointTwo {
    CGFloat x1 = pointOne.x > pointTwo.x ? pointOne.x : pointTwo.x;
    CGFloat x2 = pointOne.x < pointTwo.x ? pointOne.x : pointTwo.x;
    CGFloat y1 = pointOne.y > pointTwo.y ? pointOne.y : pointTwo.y;
    CGFloat y2 = pointOne.y < pointTwo.y ? pointOne.y : pointTwo.y;
    
    return CGPointMake((x1 + x2) / 2.0, (y1 + y2) / 2.0);
}

/**
 *  给一个点，判断这个点是否被圆包含，如果包含就返回当前圆，如果不包含返回的是nil
 *
 *  @param point 当前点
 *
 *  @return 点所在的圆
 */
- (PCCircle *)enumCircleSetToFindWhichSubviewContainTheCenterPoint:(CGPoint)point {
    PCCircle *centerCircle;
    for (PCCircle *circle in self.subviews) {
        if (CGRectContainsPoint(circle.frame, point)) {
            centerCircle = circle;
        }
    }
    
    if (![_circleSet containsObject:centerCircle]) {
        // 这个circle的角度和倒数第二个circle的角度一致
        centerCircle.angle = [[_circleSet objectAtIndex:_circleSet.count - 2] angle];
    }
    
    return centerCircle; // 注意：可能返回的是nil，就是当前点不在圆内
}

@end
