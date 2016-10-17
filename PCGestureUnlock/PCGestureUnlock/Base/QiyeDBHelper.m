//
//  QiyeDBHelper.m
//  PCGestureUnlock
//
//  Created by 古秀湖 on 2016/10/16.
//  Copyright © 2016年 coderMonkey. All rights reserved.
//

#import "QiyeDBHelper.h"
#import "FMDatabase.h"

static NSString *LOCK_TABLE_NAME  =  @"lockcode";
static NSString *LOCK_SAVE_KEY    =  @"lockkey";
static NSString *LOCK_SAVE_CODE   =  @"lockcode";

@interface QiyeDBHelper (){
    FMDatabase *db;
    NSString *database_path;
}
@end

@implementation QiyeDBHelper

-(id)init{
    
    self = [super init];
    if (self) {
        
        database_path = [[self getDocumentsPatch] stringByAppendingPathComponent:@"qiye.sqlite"];
        
        db = [FMDatabase databaseWithPath:database_path];
        
        if ([db open]) {
            
            NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY UNIQUE,'%@' TEXT)",LOCK_TABLE_NAME,LOCK_SAVE_KEY,LOCK_SAVE_CODE];
            [db executeUpdate:sqlCreateTable];
            
            [db close];
            
        }else {
            NSLog(@"数据库打开失败");
        }
    }
    
    return self;
}


/**
 插入记录，如果存在就更新

 @param key      key
 @param lockcode 锁屏码

 @return 结果
 */
-(BOOL)insertWithKey:(NSString *)key andLockCode:(NSString *)lockcode{
    
    BOOL result = false;
    if ([db open]) {
        NSString *insertSql = [NSString stringWithFormat:
                               @"REPLACE INTO '%@' ('%@','%@') VALUES ('%@','%@')",
                               LOCK_TABLE_NAME,LOCK_SAVE_KEY,LOCK_SAVE_CODE,key,lockcode];
        result = [db executeUpdate:insertSql];
        [db close];
    }
    
    return result;
}


/**
 根据key查询锁屏密码

 @param key key

 @return 密码
 */
-(NSString *)selectLockCodeWithKey:(NSString *)key{
    
    NSString *LockCode = [[NSString alloc]init];
    if ([db open]) {
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'",LOCK_TABLE_NAME,LOCK_SAVE_KEY,key];
        FMResultSet * rs = [db executeQuery:sqlQuery];
        while ([rs next]) {
            LockCode = [rs stringForColumn:LOCK_SAVE_CODE];
        }
        [db close];
    }
    
    return LockCode;
}


/**
 根据key查询是否存在密码

 @param key key

 @return 结果
 */
-(BOOL)isExistLockCodeWithKey:(NSString *)key{
    
    BOOL result = NO;
    if ([db open]) {
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'",LOCK_TABLE_NAME,LOCK_SAVE_KEY,key];
        FMResultSet * rs = [db executeQuery:sqlQuery];
        while ([rs next]) {
            
            NSString *code = [rs stringForColumn:LOCK_SAVE_CODE];
            if ([code isEqualToString:@""] || code == nil) {
                result = NO;
            }else{
                
                result = YES;
            }
        }
        [db close];
    }
    
    return result;
}

#pragma mark - private methods


/**
 获取documents目录

 @return documents目录
 */
- (NSString *)getDocumentsPatch {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = paths[0];
    return documentsPath;
}
@end
