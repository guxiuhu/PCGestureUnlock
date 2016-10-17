//
//  QiyeDBHelper.h
//  PCGestureUnlock
//
//  Created by 古秀湖 on 2016/10/16.
//  Copyright © 2016年 coderMonkey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiyeDBHelper : NSObject

/**
 插入记录，如果存在就更新
 
 @param key      key
 @param lockcode 锁屏码
 
 @return 结果
 */
-(BOOL)insertWithKey:(NSString *)key andLockCode:(NSString *)lockcode;

/**
 根据key查询锁屏密码
 
 @param key key
 
 @return 密码
 */
-(NSString *)selectLockCodeWithKey:(NSString *)key;

/**
 根据key查询是否存在密码
 
 @param key key
 
 @return 结果
 */
-(BOOL)isExistLockCodeWithKey:(NSString *)key;

@end
