
#import "PCCircleViewConst.h"

@implementation PCCircleViewConst

+ (void)saveGesture:(NSString *)gesture Key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:gesture forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getGestureWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - other
+ (BOOL)hasGesture {
    NSString *gesture = [PCCircleViewConst getGestureWithKey:gestureFinalSaveKey];
    return gesture.length > 0 ? YES : NO;
}


@end
