//
//  CoreTextUrlData.h
//  CoreTextDemo
//
//  Created by chenshaohai on 15/7/16.
//  Copyright (c) 2015年 zf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CoreTextData.h"
@interface CoreTextUrlData : NSObject
@property (copy,nonatomic  ) NSString * title;
@property (copy,nonatomic  ) NSString * url;
@property (assign,nonatomic) NSRange  range;
+(CoreTextUrlData*)touchInView:(UIView*)view atPoint:(CGPoint)point data:(CoreTextData*)data;

@end
