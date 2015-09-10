//
//  CoreTextUrlData.m
//  CoreTextDemo
//
//  Created by chenshaohai on 15/7/16.
//  Copyright (c) 2015年 zf. All rights reserved.
//

#import "CoreTextUrlData.h"

@implementation CoreTextUrlData
+(CoreTextUrlData*)touchInView:(UIView*)view atPoint:(CGPoint)point data:(CoreTextData*)data{
    CTFrameRef textFrame =data.ctFrame;
    CFArrayRef lines=CTFrameGetLines(textFrame);
    if (!lines) {
        return nil;
    }
    CFIndex count=CFArrayGetCount(lines);
    CoreTextUrlData* foundlink=nil;
    
    //获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    //翻转坐标
    CGAffineTransform transfrom=CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transfrom =CGAffineTransformScale(transfrom, 1.f, -1.f);
    
    for (int i=0; i<count; i++) {
        CGPoint linePoint =origins[i];
        CTLineRef line=CFArrayGetValueAtIndex(lines, i);
        //获得每一行的坐标
        CGRect flippedRect=[self getLineBounds:line point:linePoint];
        CGRect rect=CGRectApplyAffineTransform(flippedRect, transfrom);
        
        if (CGRectContainsPoint(rect, point)) {
            //将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint =CGPointMake(point.x-CGRectGetMinX(rect), point.y-CGRectGetMinY(rect));
            
            //获得当前点击坐标对应的字符串偏移
            CFIndex idx=CTLineGetStringIndexForPosition(line, relativePoint);
            //判断这个偏移是否在我们的链接队url列表中
            foundlink=[self urlLinkAtIndex:idx linkArray:data.urlArr];
            return foundlink;
            
        }
    }
    return nil;
}

/**
 *  每一行的坐标
 */
+(CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)Point{
    CGFloat ascent  = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width=(CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height=ascent+descent;
    return CGRectMake(Point.x, Point.y-descent, width, height);
}
/**
 *  判断这个偏移是否在我们的链接队url列表中
 */

+(CoreTextUrlData*)urlLinkAtIndex:(CFIndex)i linkArray:(NSArray*)linkArray{
    CoreTextUrlData* link=nil;
    for (CoreTextUrlData*data in linkArray) {
        if ( NSLocationInRange(i, data.range)) {
            link=data;
            break;
        }
    }
    return link;
}
@end
