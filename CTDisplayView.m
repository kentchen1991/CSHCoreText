//
//  CTDisplayView.m
//  CoreTextDemo
//
//  Created by chenshaohai on 15/7/16.
//  Copyright (c) 2015年 zf. All rights reserved.
//

#import "CTDisplayView.h"
#import <CoreText/CoreText.h>
#import "CoreTextImageData.h"
#import "CoreTextUrlData.h"
//
#import "CTFrameParser.h"
@implementation CTDisplayView
-(instancetype)init{
    if (self=[super init]) {
        self.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTapGestureDetected:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置坐标翻转  对于底层是左下角0 0
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);   //-1  倒转y轴
    if (self.data) {
        
        CTFrameDraw(self.data.ctFrame, context);
        if (self.data.imageArr.count>0) {
//            UIGraphicsBeginImageContext(<#CGSize size#>)
            for (CoreTextImageData*data in self.data.imageArr) {
//                UIImage*img=[UIImage imageNamed:data.name];
                [self drawRunWithRect:data.imagePosition andImageName:data.name];
            }
        }
       
    }
    
    
    
//    //1
//    CGContextRef context=UIGraphicsGetCurrentContext();
//    //2
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置坐标翻转  对于底层是左下角0 0
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);   //-1  倒转y轴
//    //3
//    CGMutablePathRef path=CGPathCreateMutable();
//    CGPathAddRect(path, NULL, self.bounds);
//    //4
//    NSAttributedString*attString=[[NSAttributedString alloc]initWithString:@"HELLOORLD""swadahjskawdawdnaw""你好这是一个消息消息洗洗休息""sss""阿姨"];
//    CTFramesetterRef framesetter=CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
//    CTFrameRef frame=CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
//    //5
//    CTFrameDraw(frame, context);
//    
//    
//    CFRelease(frame);
//    CFRelease(path);
//    CFRelease(framesetter);
}
- (BOOL)drawRunWithRect:(CGRect)rect andImageName:(NSString*)imageN
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //改  陈少海
    //
    NSString *emojiString = [NSString stringWithFormat:@"%@.png",imageN];
    //    NSString *emojiString = [NSString stringWithFormat:@"%@.gif",self.originalText];
    UIImage *image = [UIImage imageNamed:emojiString];
    if (image)
    {
        CGContextDrawImage(context, rect, image.CGImage);
    }
    return YES;
}

#pragma mark － 点击
-(void)userTapGestureDetected:(UIGestureRecognizer*)recognizer{
    CGPoint point=[recognizer locationInView:self];
    //可以加入图片点击
    CoreTextUrlData* linkData=[CoreTextUrlData touchInView:self atPoint:point data:self.data];
    
    if (linkData&&[linkData isKindOfClass:[CoreTextUrlData class]]) {
        NSLog(@"%@",linkData.url);
        if ([_ctdDelegate respondsToSelector:@selector(ctdisplayClickUrl:)]) {
            [_ctdDelegate ctdisplayClickUrl:linkData.url];
        }
        return;
    }
}



#pragma mark 聊天气泡
-(void)ctdUseingChatBubbleWith:(NSString*)content andTextClr:(UIColor*)clr andFontSize:(CGFloat)fontS andMaximumWidth:(CGFloat)maxWd{
    CTFrameParserConfig* config=[CTFrameParserConfig ctframeParserConfigWithWidth:300 andFontSize:fontS andTextColor:clr];
    config.lineSpace=5.0f;
    CoreTextData *data=[CTFrameParser parseAttributedWithImageContent:content config:config];
    self.data=data;
    self.height=data.height;
    self.width=data.adjustWidth;
    
}

@end
