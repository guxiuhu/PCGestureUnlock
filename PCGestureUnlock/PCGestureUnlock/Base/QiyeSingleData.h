//
//  QiyeSingleData.h
//  PCGestureUnlock
//
//  Created by 古秀湖 on 2016/10/16.
//  Copyright © 2016年 coderMonkey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiyeSingleData : NSObject{
    NSMutableDictionary *_shareDic;//自定义数据
}

/**
 *  初始化
 *
 *  @return 实例
 */
+ (instancetype)instance;

/**
 *  添加数据
 *
 *  @param key  键
 *  @param data 值
 */
-(void)addDataWithKey:(NSString*)key data:(id)data;

/**
 *  删除数据
 *
 *  @param key 键
 */
-(void)delDataWithKey:(NSString*)key;

/**
 *  获取数据
 *
 *  @param key 键
 *
 *  @return 值
 */
-(id)getDataWithKey:(NSString*)key;

/**
 *  删除DIC所有数据
 */
-(void)removeAllData;

@end
