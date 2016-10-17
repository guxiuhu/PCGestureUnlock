

//
//  QiyeSingleData.m
//  PCGestureUnlock
//
//  Created by 古秀湖 on 2016/10/16.
//  Copyright © 2016年 coderMonkey. All rights reserved.
//

#import "QiyeSingleData.h"

@implementation QiyeSingleData

static QiyeSingleData *singleData;

/**
 *  生成单例
 *
 *  @return 单例
 */
+ (instancetype)instance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleData = [[QiyeSingleData alloc] init];
        
    });
    
    return singleData;
}

/**
 *  初始化
 *
 *  @return 实例
 */
- (id)init{
    
    self = [super init];
    if(self){
        _shareDic =[[NSMutableDictionary alloc]init];
    }
    
    return self;
}

/**
 *  添加数据
 *
 *  @param key  键
 *  @param data 值
 */
-(void)addDataWithKey:(NSString*)key data:(id)data{
    [_shareDic setValue:data forKey:key];
}

/**
 *  删除数据
 *
 *  @param key 键
 */
-(void)delDataWithKey:(NSString*)key{
    [_shareDic removeObjectForKey:key];
}

/**
 *  获取数据
 *
 *  @param key 键
 *
 *  @return 值
 */
-(id)getDataWithKey:(NSString*)key{
    return [_shareDic objectForKey:key];
}

/**
 *  删除DIC所有数据
 */
-(void)removeAllData{
    [_shareDic removeAllObjects];
}

@end
