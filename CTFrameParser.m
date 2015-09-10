//
//  CTFrameParser.m
//  CoreTextDemo
//
//  Created by chenshaohai on 15/7/16.
//  Copyright (c) 2015年 zf. All rights reserved.
//

#import "CTFrameParser.h"
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
@interface CTFrameParser(){
    float imgWidth;
    float imgHeight;
}
@end;

@implementation CTFrameParser{
   
}
#pragma mark  地址的正则
+(void)parseZhengZeURL:(NSString*)content withConfig:(CTFrameParserConfig*)config andUrlArr:(NSMutableArray**)urlArr{
//    NSMutableAttributedString*arrStr=[[NSMutableAttributedString alloc]init];
    NSString *pattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                options:0
                                                                                  error:NULL];
    NSArray *arrayOfAllMatches = [expression matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    for (int i=0; i<arrayOfAllMatches.count; i++) {
        NSTextCheckingResult *match=arrayOfAllMatches[i];
        NSString* substringForMatch=[content substringWithRange:match.range];
        debugLog(@"substringForMatch==%@ ,%lu",substringForMatch,(unsigned long)match.range.location);
//        NSAttributedString*rep=[self parseImageDataWithString:substringForMatch config:config];
        CoreTextUrlData*urlData=[[CoreTextUrlData alloc]init];
        urlData.url=substringForMatch;
        urlData.range=match.range;
        [*urlArr addObject:urlData];
    }
}

//-- 替换基础文本
+(NSMutableAttributedString*)replaceTextWithAttributedString:(NSMutableAttributedString*) attributedString withurlArr:(NSMutableArray*)urlArr
{
    for (CoreTextUrlData* urlData in urlArr) {
        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:urlData.range];
         [attributedString addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:urlData.range];
    }
    return attributedString;

  
}


#pragma mark  表情的正则
+(NSAttributedString*)parseZhengZe:(NSString*)content withConfig:(CTFrameParserConfig*)config withImageArr:(NSMutableArray**)imgArr{
//    int i=0;
//    NSMutableAttributedString*arrStr=[[NSMutableAttributedString alloc]init];
    NSString *pattern = @"(\\[.{2}\\])";//   (\\[\\w{2}\\])
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                options:0
                                                                            error:NULL];
    NSArray *arrayOfAllMatches = [expression matchesInString:content options:0 range:NSMakeRange(0, [content length])];

    NSDictionary*dict=[self attributesWithConfig:config];
    NSMutableAttributedString* mess=[[NSMutableAttributedString alloc]
                                     initWithString:content attributes:dict];
    for (int i=0; i<arrayOfAllMatches.count; i++) {
        NSTextCheckingResult *match=arrayOfAllMatches[i];
        NSString* substringForMatch=[content substringWithRange:match.range];
        debugLog(@"substringForMatch==%@ ,%lu",substringForMatch,(unsigned long)match.range.location);
        NSAttributedString*rep=[self parseImageDataWithString:substringForMatch config:config];
        CoreTextImageData*imageData=[[CoreTextImageData alloc]init];
        imageData.name=substringForMatch;
        if (i==0) {
            imageData.position=match.range.location;
            [mess replaceCharactersInRange:match.range withAttributedString:rep];
          }else if(i>0){
            imageData.position=match.range.location-(i)*3;
            [mess replaceCharactersInRange:NSMakeRange(match.range.location-(i)*3, 4) withAttributedString:rep];
//              [mess appendAttributedString:rep];
              
        }
        [*imgArr addObject:imageData];
    }
    
    debugLog(@"%@",mess);
    debugLog(@"length==%ld",mess.length);
    return mess;
}

+(NSMutableAttributedString*)parseImageDataWithString:(NSString*)imgStr config:(CTFrameParserConfig*)congfig{
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    callBacks.version= kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallBack;
    callBacks.getDescent=descentCallBack;
    callBacks.getWidth=widthCallBack;
//传图片名字的写法
    CTRunDelegateRef delegate =CTRunDelegateCreate(&callBacks, (__bridge void *)(imgStr));
    //使用0xfffc作为空白占位符
    unichar objectReplacementChar =0xFFFC;//2 ^16
    NSString *content=[NSString stringWithCharacters:&objectReplacementChar length:1];
//    NSString* content=@" ";
    NSDictionary* attributes=[self attributesWithConfig:congfig];
    NSMutableAttributedString* space=[[NSMutableAttributedString alloc]initWithString:content attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

+(CoreTextData*)parseAttributedWithImageContent:(NSString*)content config:(CTFrameParserConfig*)config{
    //设置表情图片大小 也可以不设置
    //解析表情
    NSMutableArray* imgArr=[NSMutableArray array];
    NSAttributedString* contentString=[self parseZhengZe:content withConfig:config withImageArr:&imgArr];
    //解析地址
    NSMutableArray* urlArr=[NSMutableArray array];
    [self parseZhengZeURL:contentString.string withConfig:config andUrlArr:&urlArr];
    NSMutableAttributedString* mcontentString=[[NSMutableAttributedString alloc]initWithAttributedString:contentString];
    mcontentString=[self replaceTextWithAttributedString:mcontentString withurlArr:urlArr];
    //创建CTFramesetterRef实例
    CTFramesetterRef framesetter =CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mcontentString);//
    //获得要绘制的区域高度
    CGSize restrictSize= CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize= CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);//
    
    
    
    CGFloat textHegiht = coreTextSize.height;
    //生成CTFreameRef实例
    CTFrameRef frameref=[self createFrameWithFramesetter:framesetter config:config height:textHegiht];
    //将生成好的CTFreameRef实例和计算好的高度保存到coretextdata中，返回实例
   CoreTextData*data=[[CoreTextData alloc]init];
    data.ctFrame=frameref;
    data.height=textHegiht;
    data.imageArr=imgArr;
    data.urlArr=urlArr;
    
    
    //获得实际的宽度 测试
    data.adjustWidth=coreTextSize.width;
    
    CFRelease(frameref);
    CFRelease(framesetter);
    return data;
    
}

#pragma mark - /////////////////////////////////////////////////////////////////////////////////

#pragma mark 解析 NSAttributedString
+(CoreTextData*)parseAttributedContent:(NSAttributedString*)content config:(CTFrameParserConfig*)config{
    //创建CTFramesetterRef实例
    CTFramesetterRef framesetter =CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    //获得要绘制的区域高度
    CGSize restrictSize= CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize= CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);//
    CGFloat textHegiht = coreTextSize.height;
    
    //生成CTFreameRef实例
    CTFrameRef frameref=[self createFrameWithFramesetter:framesetter config:config height:textHegiht];
    
    //将生成好的CTFreameRef实例和计算好的高度保存到coretextdata中，返回实例
    CoreTextData*data=[[CoreTextData alloc]init];
    data.ctFrame=frameref;
    data.height=textHegiht;
    CFRelease(frameref);
    CFRelease(framesetter);
    return data;
    
}

#pragma mark 解析 NSString
+(CoreTextData*)parseContent:(NSString*)content config:(CTFrameParserConfig*)config{
    NSDictionary* attributes=[self attributesWithConfig:config];
    NSAttributedString* contentString=[[NSAttributedString alloc]initWithString:content attributes:attributes];
    //创建CTFramesetterRef实例
    CTFramesetterRef framesetter =CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    //获得要绘制的区域高度
    CGSize restrictSize= CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize= CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);//
    CGFloat textHegiht = coreTextSize.height;
    //生成CTFreameRef实例
    CTFrameRef frameref=[self createFrameWithFramesetter:framesetter config:config height:textHegiht];
    //将生成好的CTFreameRef实例和计算好的高度保存到coretextdata中，返回实例
    CoreTextData*data=[[CoreTextData alloc]init];
    data.ctFrame=frameref;
    data.height=textHegiht;
    CFRelease(frameref);
    CFRelease(framesetter);
    return data;
}

#pragma mark 配合解析 NSString
+(NSDictionary*)attributesWithConfig:(CTFrameParserConfig*)config{
    CGFloat fontSize= config.fontSize;
    CTFontRef fontref= CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpace= config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[3]={
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpace },
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpace}
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    UIColor *textColor =config.textColor;
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName]=(id)textColor.CGColor;
    dict[(id)kCTFontAttributeName]=(__bridge id)fontref;
    dict[(id)kCTParagraphStyleAttributeName]=(__bridge id)theParagraphRef;
    CFRelease(theParagraphRef);
    CFRelease(fontref);
    return dict;
    
}

#pragma mark 生成CTFreameRef实例
+(CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)frameSetter config:(CTFrameParserConfig*)config height:(CGFloat)height{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    CTFrameRef frame= CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    
    return frame;
}



static CGFloat ascentCallBack(void* ref){
//注释的是按照图片的大小显示内容
//    NSString *imageName = (__bridge NSString *)ref;
//    return [UIImage imageNamed:imageName].size.height;  可以用
    return 16;
}
static CGFloat descentCallBack(void* ref){
    return 0;
}
static CGFloat widthCallBack(void* ref){

//    NSString *imageName = (__bridge NSString *)ref;
//    return [UIImage imageNamed:imageName].size.width;
    return 16;
}



@end
