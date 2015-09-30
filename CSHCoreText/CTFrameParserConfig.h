//
//  CTFrameParserConfig.h
//  CoreTextDemo
//
//  Created by chenshaohai on 15/7/16.
//  Copyright (c) 2015年 zf. All rights reserved.
//配置类，用于实现排版的可配置项

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>
//#import <UIKit/UIKit.h>111
@interface CTFrameParserConfig : NSObject
@property(assign,nonatomic)CGFloat width;
@property(assign,nonatomic)CGFloat fontSize;
@property(assign,nonatomic)CGFloat lineSpace;
@property(strong,nonatomic)UIColor *textColor;
-(instancetype)initWithWidth:(CGFloat)wd andFontSize:(CGFloat)fszie andTextColor:(UIColor*)txClr;
+(instancetype)ctframeParserConfigWithWidth:(CGFloat)wd andFontSize:(CGFloat)fszie andTextColor:(UIColor*)txClr;
@end
