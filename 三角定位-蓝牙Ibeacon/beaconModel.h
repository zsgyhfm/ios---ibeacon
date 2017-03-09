//
//  beaconModel.h
//  三角定位-蓝牙Ibeacon
//
//  Created by vina on 16/3/31.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
/*模型里面的数据 要用NSNumber类型 因为数组和字典里面只能存元素*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface beaconModel : NSObject
///设备名称
//@property(nonatomic,copy)NSString *name;
///坐标点x
@property(nonatomic,assign)NSNumber *pointX;
///坐标点y
@property(nonatomic,assign)NSNumber *pointY;
///用户距离设备的距离
@property(nonatomic,assign)NSNumber *distance;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;
@end
