//
//  FMDBManager.h
//  HybridApp
//
//  Created by iOSgo on 2017/10/11.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

/*
 使用例子:
 //创建数据库
 BinFMDB *Mdb=[BinFMDB tool];
 self.myFmdb=[Mdb getDBWithDBName:@"Bin.sqlite"];
 //创建表
 [Mdb DataBase:self.myFmdb createTable:@"User3" keyTypes:@{@"user_id":@"integer",@"name":@"text"}];
 //表赋值
 
 //    [Mdb DataBase:self.myFmdb insertKeyValues:@{@"user_id":@"1",@"name":@"rain"} intoTable:@"User3"];
 
 
 //更新
 [Mdb DataBase:self.myFmdb updateTable:@"User3" setKeyValues:@{@"user_id":@"1",@"name":@"rain"} whereCondition:@{@"user_id":@"2",@"name":@"rain1111"}];
 
 //删除
 //    [Mdb clearDatabase:self.myFmdb from:@"User3"];
 
 
 //查询所有
 NSArray *arr=[NSArray array];
 arr=[Mdb DataBase:self.myFmdb selectKeyTypes:@{@"user_id":@"text",@"name":@"text"} fromTable:@"User3"];
 NSLog(@"chakan= %@",arr);
 
 
 NSArray *arr1=[NSArray array];
 arr1=[Mdb DataBase:self.myFmdb selectKeyTypes:@{@"user_id":@"integer",@"name":@"text"} fromTable:@"User3" whereCondition:@{@"name":@"rain"}];
 NSLog(@"chakan= %@",arr1);
 */
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface FMDBManager : NSObject

/**
 
 *  数据库工具单例
 
 *
 
 *  @return 数据库工具对象
 
 */

+(FMDBManager *)shareInstance;



/**
 
 *  创建数据库
 
 *
 
 *  @param dbName 数据库名称(带后缀.sqlite)
 
 */

-(FMDatabase *)getDBWithDBName:(NSString *)dbName;



/**
 
 *  给指定数据库建表
 
 *
 
 *  @param db        指定数据库对象
 
 *  @param tableName 表的名称
 
 *  @param keyTypes   所含字段以及对应字段类型 字典
 
 */

-(void)DataBase:(FMDatabase *)db createTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes;



/**
 
 *  给指定数据库的表添加值
 
 *
 
 *  @param db        数据库名称
 
 *  @param keyValues 字段及对应的值
 
 *  @param tableName 表名
 
 */

-(void)DataBase:(FMDatabase *)db insertKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName;



/**
 
 *  给指定数据库的表更新值
 
 *
 
 *  @param db        数据库名称
 
 *  @param keyValues 要更新字段及对应的值
 
 *  @param tableName 表名
 
 */

-(void)DataBase:(FMDatabase *)db updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValues;



/**
 
 *  条件更新
 
 *
 
 *  @param db        数据库名称
 
 *  @param tableName 表名称
 
 *  @param keyValues 要更新的字段及对应值
 
 *  @param condition 条件
 
 */

-(void)DataBase:(FMDatabase *)db updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValues whereCondition:(NSDictionary *)condition;



/**
 
 *  查询数据库表中的所有值 限制数据条数10
 
 *
 
 *  @param db        数据库名称
 
 *  @param keyTypes 查询字段以及对应字段类型 字典
 
 *  @param tableName 表名称
 
 *  @return 查询得到数据
 
 */

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName;



/**
 
 *  条件查询数据库中的数据 限制数据条数10
 
 *
 
 *  @param db        数据库名称
 
 *  @param keyTypes 查询字段以及对应字段类型 字典
 
 *  @param tableName 表名称
 
 *  @param condition 条件
 
 *
 
 *  @return 查询得到数据 限制数据条数10
 
 */

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereCondition:(NSDictionary *)condition;

/**
 
 *  模糊查询 某字段以指定字符串开头的数据 限制数据条数10
 
 *
 
 *  @param db        数据库名称
 
 *  @param keyTypes 查询字段以及对应字段类型 字典
 
 *  @param tableName 表名称
 
 *  @param key       条件字段
 
 *  @param str       开头字符串
 
 *
 
 *  @return 查询所得数据 限制数据条数10
 
 */

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key beginWithStr:(NSString *)str;



/**
 
 *  模糊查询 某字段包含指定字符串的数据 限制数据条数10
 
 *
 
 *  @param db        数据库名称
 
 *  @param keyTypes 查询字段以及对应字段类型 字典
 
 *  @param tableName 表名称
 
 *  @param key       条件字段
 
 *  @param str       所包含的字符串
 
 *
 
 *  @return 查询所得数据
 
 */

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key containStr:(NSString *)str;



/**
 
 *  模糊查询 某字段以指定字符串结尾的数据 限制数据条数10
 
 *
 
 *  @param db        数据库名称
 
 
 *  @param keyTypes 查询字段以及对应字段类型 字典
 
 *  @param tableName 表名称
 
 *  @param key       条件字段
 
 *  @param str       结尾字符串
 
 *
 
 *  @return 查询所得数据
 
 */

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key endWithStr:(NSString *)str;



/**
 
 *  清理指定数据库中的数据  （只删除数据不删除数据库）
 
 *
 
 *  @param db 指定数据库
 
 */

-(void)clearDatabase:(FMDatabase *)db from:(NSString *)tableName;



@end
