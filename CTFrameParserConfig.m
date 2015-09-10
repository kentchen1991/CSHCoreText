//
//  CTFrameParserConfig.m
//  CoreTextDemo
//
//  Created by chenshaohai on 15/7/16.
//  Copyright (c) 2015年 zf. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig
- (instancetype)init
{
    self = [super init];
    if (self) {
        _width=200.0f;
        _fontSize=16.0f;
        _lineSpace=8.0f;
//        _textColor=kcolour(108, 108, 108);
        _textColor=[UIColor colorWithRed:108/255.0f green:108/255.0f blue:108/255.0f alpha:1];
        
    }
    return self;
}

-(instancetype)initWithWidth:(CGFloat)wd andFontSize:(CGFloat)fszie andTextColor:(UIColor*)txClr{
    self = [super init];
    if (self) {
        _width=wd;
        _fontSize=fszie;
//        _lineSpace=8.0f;
        _textColor=txClr;
    }
    return self;
}
+(instancetype)ctframeParserConfigWithWidth:(CGFloat)wd andFontSize:(CGFloat)fszie andTextColor:(UIColor*)txClr{
    return [[self alloc]initWithWidth:wd andFontSize:fszie andTextColor:txClr];
}
@end
