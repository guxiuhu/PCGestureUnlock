
#import "PCCircleViewConst.h"
#import "QiyeSingleData.h"
#import "QiyeDBHelper.h"

@implementation PCCircleViewConst

+ (void)saveGesture:(NSString *)gesture Key:(NSString *)key {
    
    [[QiyeSingleData instance]addDataWithKey:key data:gesture];
}

+ (NSString *)getTmpGestureWithKey:(NSString *)key {
    
    NSString *value = [[QiyeSingleData instance]getDataWithKey:key];
    
    return value;
}

+ (NSString *)getGestureWithKey:(NSString *)key {
    
    QiyeDBHelper *db = [[QiyeDBHelper alloc]init];
    
    NSString *value = [db selectLockCodeWithKey:key];
    
    return value;
}

/**
 保存密码的key
 
 @param key key
 
 @return 保存结果
 */
+ (void)saveLockCodeKey:(NSString*)key{
    
    [[QiyeSingleData instance]addDataWithKey:@"gestureKeySaveKey" data:key];
}

@end
