//
//  UIView+frameAdjust.m
//  CoreTextDemo
//
//  Created by chenshaohai on 15/7/16.
//  Copyright (c) 2015年 zf. All rights reserved.
//

#import "UIView+frameAdjust.h"

@implementation UIView (frameAdjust)
-(float)x{
    return self.frame.origin.x;
}
-(void)setX:(float)x{
    self.frame=CGRectMake(x, self.y, self.width, self.height);
}
-(float)y{
    return self.frame.origin.y;
}
-(void)setY:(float)y{
    self.frame=CGRectMake(self.x, y, self.width, self.height);
}
-(float)height{
    return self.frame.size.height;
}
-(void)setHeight:(float)height{
    self.frame=CGRectMake(self.x, self.y, self.width, height);
    
}
-(float)width{
    return self.frame.size.width;
    
}
-(void)setWidth:(float)width{
     self.frame=CGRectMake(self.x, self.y,width,self.height);
    
}


@end
