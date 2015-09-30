//
//  CoreTextData.m
//  CoreTextDemo
//
//  Created by chenshaohai on 15/7/16.
//  Copyright (c) 2015年 zf. All rights reserved.
//用于保存CTFrameParser生成的 ctfremaref实例 ，和ctfremaref实际绘制需要的高度

#import "CoreTextData.h"
#import "CoreTextImageData.h"
@implementation CoreTextData
-(void)setCtFrame:(CTFrameRef)ctFrame{
    if (_ctFrame!=ctFrame) {
        if (_ctFrame!=nil) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame=ctFrame;
    }
    //123
}

-(void)dealloc{
    if (_ctFrame!=nil) {
        CFRelease(_ctFrame);
        _ctFrame=nil;
        
    }
}

-(void)setImageArr:(NSMutableArray *)imageArr{
    _imageArr=imageArr;
    [self fillImagePosition];
    
}
-(void)fillImagePosition{
    if (self.imageArr.count==0) {
        return;
    }
    NSArray* lines=(NSArray*)CTFrameGetLines(self.ctFrame);//从一行中得到CTline数组
    NSUInteger lineCount=[lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);

    int imgIndex = 0 ;
    CoreTextImageData* imgData=self.imageArr[0];
    for (int i=0 ; i<lineCount; ++i) {
        if (imgData==nil) {
            break;
        }
        CTLineRef line=(__bridge CTLineRef)lines[i];
        NSArray* runObjArr=(NSArray*)CTLineGetGlyphRuns(line);//从一行中得到CTRun数组
        for (id runObj in runObjArr) {
            CTRunRef run=(__bridge CTRunRef)runObj;
            NSDictionary* runAttributes=(NSDictionary*)CTRunGetAttributes(run);
            CTRunDelegateRef delegate =(__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];//(id)kCTRunDelegateAttributeName
            
           
            if (delegate==nil) {
                continue;
            }
            //类型要对应  看c里面的读取是需要什么 做相对应的判断
            NSString* metadic = CTRunDelegateGetRefCon(delegate);
            if (![metadic isKindOfClass:[NSString class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width  = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent+descent;

            CGFloat xoffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x+xoffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            CGPathRef pathRef=CTFrameGetPath(self.ctFrame);
            CGRect colRect=CGPathGetBoundingBox(pathRef);
            CGRect delegateBounds=CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            imgData.imagePosition=delegateBounds;
            imgIndex++;
//            NSLog(@"imgIndex==%d",imgIndex);
        
            if (imgIndex==self.imageArr.count) {
                imgData=nil;
                break;
            }else{
                imgData=self.imageArr[imgIndex];
            }
        }

    }
    
    
    
}

@end
