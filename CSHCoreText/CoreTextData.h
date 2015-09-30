//
//  CoreTextData.h
//  CoreTextDemo
//
//  Created by chenshaohai on 15/7/16.
//  Copyright (c) 2015年 zf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
@interface CoreTextData : NSObject
@property(assign,nonatomic)CTFrameRef ctFrame;
/**
 *  根据限制的最大宽度获得的高度
 */
@property(assign,nonatomic)CGFloat height;

/**
 *  实际的宽度
 */
@property(assign,nonatomic)CGFloat adjustWidth;

/**
 *  图片解析的数据数组
 */
@property(strong,nonatomic)NSMutableArray* imageArr;

/**
 *  地址解析的数组
 */
@property(strong,nonatomic)NSMutableArray* urlArr;

@end
