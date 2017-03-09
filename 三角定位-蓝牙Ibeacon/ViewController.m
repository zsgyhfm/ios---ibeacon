//
//  ViewController.m
//  三角定位-蓝牙Ibeacon
//
//  Created by vina on 16/3/31.
//  Copyright © 2016年 zsgyhfm. All rights reserved.
//

#import "ViewController.h"
#import "BRTBeaconSDK.h"
#import <CoreLocation/CoreLocation.h>
#import "beaconModel.h"
#include <stdio.h>
#include <stdlib.h>
static NSString *const UUID1=@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
static NSString *const UUID2=@"FDA50693-A4E2-4FB1-AFCF-C6EB07647825";
@interface ViewController ()

///坐标模型
@property(nonatomic,strong)beaconModel *model;
///定位数据源
@property(nonatomic,strong)NSArray *modelArr;
///UUID数组
@property(nonatomic,strong)NSArray *UUIDArr;
///搜索到设备数组
@property(nonatomic,strong)NSArray *tableArr;
///筛选后设备的数组
@property(nonatomic,strong)NSMutableArray *checkArr;
///tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   CGPoint p= [self ibeaconLocation:self.modelArr];
    NSLog(@"x=%f  --y=%f",p.x,p.y);
    [self searchBeacon];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//view消失停止扫描设备
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"停止搜索");
    [BRTBeaconSDK stopRangingBrightBeacons];

}

#pragma mark -搜索附近ibeacon
#pragma mark - 扫描BrightBeacon设备，uuids为NSUUID数组
-(void)searchBeacon{


    //    NSLog(@"开始搜索设备%@",self.UUIDArr);
    //搜索设备 属于耗时操作 异步执行
    //创建线程

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        [BRTBeaconSDK startRangingBeaconsInRegions:nil onCompletion:^(NSArray *beacons, BRTBeaconRegion *region, NSError *error) {
            NSLog(@"开始搜索设备%@",self.UUIDArr);
            //根据距离排序
            self.tableArr=[beacons sortedArrayUsingComparator:^NSComparisonResult(BRTBeacon *obj1, BRTBeacon *obj2) {
                if ([obj1.distance floatValue]>[obj2.distance floatValue]) {
                    //左边小于右边
                    return NSOrderedDescending;
                }
                return NSOrderedAscending;
            }];

            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.tableView reloadData ];
            });
            
        }];
        //进程循环
        [[NSRunLoop currentRunLoop] run];
        
    });
    

    
}



/**
 *  三角定位引擎
 *
 *  @param ibeaconPoint 传入一个包含三个ibeacon的坐标的数组
 *
 *  @return 返回当前人所处的坐标点
 */
-(CGPoint)ibeaconLocation:(NSArray<beaconModel*>*)ibeaconPoint{

    //遍历数组
    beaconModel *model1=ibeaconPoint[0];
    beaconModel *model2=ibeaconPoint[1];
    beaconModel *model3=ibeaconPoint[2];

    //取得三个点的坐标
    CGFloat p1x=[model1.pointX floatValue];
    CGFloat p2x=[model2.pointX floatValue];
    CGFloat p3x=[model3.pointX floatValue];
    
    CGFloat p1y=[model1.pointY floatValue];
    CGFloat p2y=[model2.pointY floatValue];
    CGFloat p3y=[model3.pointY floatValue];

    //取得用户到三个点的距离
    CGFloat d1=[model1.distance floatValue];;
    CGFloat d2=[model2.distance floatValue];
    CGFloat d3=[model3.distance floatValue];
    //三点定位
    CGFloat x=0;
    CGFloat x1=0;
    CGFloat x2=0;
    CGFloat x3=0;
    CGFloat y=0;
    CGFloat y1=0;
    CGFloat y2=0;
    CGFloat y3=0;


//
    x1=(pow(p1x, 2)-pow(p2x, 2)+pow(p1y, 2)-pow(p2y, 2)-pow(d1, 2)+pow(d2, 2))*(p1y-p3y);
    x2=(pow(p1x, 2)-pow(p2x, 2)+pow(p1y, 2)-pow(p3y, 2)-pow(d1, 2)+pow(d3, 2))*(p1y-p2y);
    x3=((p1x-p2x)*(p1y-p3y)-(p1x-p3x)*(p1y-p3y))*2;
    x=(x1-x2)/x3;
//    x=((pow(p1x, 2)-pow(p2x, 2)+pow(p1y, 2)-pow(p2y, 2)-pow(d1, 2)+pow(d2, 2))*(p1y-p3y)-(pow(p1x, 2)-pow(p2x, 2)+pow(p1y, 2)-pow(p3y, 2)-pow(d1, 2)+pow(d3, 2))*(p1y-p2y))/2/((p1x-p2x)*(p1y-p3y)-(p1x-p3x)*(p1y-p3y));


    y1=(pow(p1x, 2)-pow(p2x, 2)+pow(p1y, 2)-pow(p2y, 2)-pow(d1, 2)+pow(d2, 2))*(p1x-p3x);
    y2=(pow(p1x, 2)-pow(p3x, 2)+pow(p1y, 2)-pow(p3y, 2)-pow(d1, 2)+pow(d3, 2))*(p1x-p2x);
    y3=((p1y-p2y)*(p1x-p3x)-(p1y-p3y)*(p1x-p2x))*2;
    y=(y1-y2)/y3;
//    y=((pow(p1x, 2)-pow(p2x, 2)+pow(p1y, 2)-pow(p2y, 2)-pow(d1, 2)+pow(d2, 2))*(p1x-p3x)-(pow(p1x, 2)-pow(p3x, 2)+pow(p1y, 2)-pow(p3y, 2)-pow(d1, 2)+pow(d3, 2))*(p1x-p2x))/2/((p1y-p2y)*(p1x-p3x)-(p1y-p3y)*(p1x-p2x));
    return CGPointMake(x, y);
//    return CGPointMake(fabs(x), fabs(y));
}
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.tableArr.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    }
    BRTBeacon *beacon=  self.tableArr[indexPath.row];
    NSLog(@"设备%@",beacon);
    cell.textLabel.text=beacon.name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"距离:%f",beacon.distance.floatValue];
    //    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",beacon.proximityUUID];
  
    return cell;
}

#pragma mark - 点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //连接设备
//    BRTBeacon *beacon=self.tableArr[indexPath.row];

    //弹窗
//    [MMProgressHUD setPresentationStyle:1];
//    [MMProgressHUD showWithTitle:@"提示" status:@"正在连接"];
//    [beacon connectToBeaconWithCompletion:^(BOOL complete, NSError *error) {
//
//        NSLog(@"%@错误%@",beacon.region,error);
//        if (complete) {
//            [MMProgressHUD dismissWithSuccess:@"连接成功"];
//        }else{
//            [MMProgressHUD dismissWithError:[NSString stringWithFormat:@"连接失败%@",error]];
//        }
//
//    }];

}


#pragma mark - BRTbeacon的代理
//beacon连接产生错误回调该方法.
-(void)beaconConnection:(BRTBeacon *)beacon withError:(NSError *)error{
    NSLog(@"代理连接失败重新扫描%@",error);
    [self searchBeacon];
}

//断开连接的回调
-(void)beaconDidDisconnect:(BRTBeacon *)beacon withError:(NSError *)error{
    NSLog(@"断开连接%@",error);
}

#pragma mark - 懒加载
-(NSArray *)UUIDArr{
    if (_UUIDArr==nil) {
        NSUUID *uid1=[[NSUUID alloc] initWithUUIDString:UUID1];
        NSUUID *uid2=[[NSUUID alloc] initWithUUIDString:UUID2];
        _UUIDArr=@[uid1,uid2];
    }
    return _UUIDArr ;
}


///测试数据
-(NSArray *)modelArr{
    if (_modelArr==nil) {
       CGFloat d= sqrt(5);
        NSNumber *num=[NSNumber numberWithDouble:d];
        NSDictionary *dic1=@{@"pointX":@1 ,@"pointY":@1,@"distance":@1};
        NSDictionary *dic2=@{@"pointX":@2 ,@"pointY":@1,@"distance":@0};
        NSDictionary *dic3=@{@"pointX":@1 ,@"pointY":@3,@"distance":num};
        beaconModel *model1=[beaconModel modelWithDic:dic1];
        beaconModel *model2=[beaconModel modelWithDic:dic2];
        beaconModel *model3=[beaconModel modelWithDic:dic3];
        _modelArr=@[model1,model2,model3];
    }
    return _modelArr ;
}
@end
