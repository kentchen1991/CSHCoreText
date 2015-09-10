//
//  CoreTextImageData.h
//  CoreTextDemo
//
//  Created by chenshaohai on 15/7/16.
//  Copyright (c) 2015年 zf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@interface CoreTextImageData : NSObject
@property (copy,nonatomic  ) NSString  *name;
@property (assign,nonatomic) NSInteger position;
@property(assign,nonatomic)CGRect imagePosition;

@end
