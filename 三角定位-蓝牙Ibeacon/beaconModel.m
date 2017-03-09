//
//  beaconModel.m
//  三角定位-蓝牙Ibeacon
//
//  Created by vina on 16/3/31.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
//

#import "beaconModel.h"

@implementation beaconModel
-(instancetype)initWithDic:(NSDictionary *)dic{

    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"KVC属性为寻找到");
}

+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}
@end
