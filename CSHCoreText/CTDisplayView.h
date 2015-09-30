//
//  CTDisplayView.h
//  CoreTextDemo
//
//  Created by chenshaohai on 15/7/16.
//  Copyright (c) 2015年 zf. All rights reserved.
//

/**
  "其实流程是这样的： 1、生成要绘制的NSAttributedString对象。 2、生成一个CTFramesetterRef对象，然后创建一个CGPath对象，这个Path对象用于表示可绘制区域坐标值、长宽。 3、使用上面生成的setter和path生成一个CTFrameRef对象，这个对象包含了这两个对象的信息（字体信息、坐标信息），它就可以使用CTFrameDraw方法绘制了
 */
//展示的view
#import <UIKit/UIKit.h>
#import "CoreTextData.h"


@protocol CTDisplayDelegate <NSObject>
@optional
/**
 *  点击代理事件
 *  @param url 点击中的网址
 */
-(void)ctdisplayClickUrl:(NSString*)url;
@end
@interface CTDisplayView : UIView
@property(strong,nonatomic)CoreTextData* data;
@property(assign,nonatomic)id<CTDisplayDelegate>ctdDelegate;


/**
 *  聊天气泡用的text
 *
 *  @param content 内容字符串
 *  @param clr     字体颜色
 *  @param fontS   字号
 *  @param maxWd   最大限制宽度
 */
-(void)ctdUseingChatBubbleWith:(NSString*)content andTextClr:(UIColor*)clr andFontSize:(CGFloat)fontS andMaximumWidth:(CGFloat)maxWd;
@end
