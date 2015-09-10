//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by chenshaohai on 15/7/16.
//  Copyright (c) 2015年 zf. All rights reserved.
//用于生成最后绘制界面所需要的ctfreameref 

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"
#import "CoreTextImageData.h"
#import "CoreTextUrlData.h"
@interface CTFrameParser : NSObject

+(CoreTextData*)parseAttributedContent:(NSAttributedString*)content config:(CTFrameParserConfig*)config;

+(CoreTextData*)parseContent:(NSString*)content config:(CTFrameParserConfig*)config;
/**
 *  解析有图片和url的方法
 *
 *  @param content 内容
 *  @param config  nsattributestring 的属性
 *
 *  @return 返回CoreTextData
 */
+(CoreTextData*)parseAttributedWithImageContent:(NSString*)content config:(CTFrameParserConfig*)config;
@end
