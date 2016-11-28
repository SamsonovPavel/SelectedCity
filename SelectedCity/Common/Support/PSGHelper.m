//
//  PSGHelper.m
//  SelectedCity
//
//  Created by Pavel Samsonov on 26.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

@implementation PSGHelper

+ (PSGHelper *)sharedInstance
{
    static PSGHelper *helperInst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helperInst = [[PSGHelper alloc] init];
    });
    return helperInst;
}

- (UIFont *)setFontSize
{
    NSInteger fontSize = (int)CGRectGetWidth([UIScreen mainScreen].bounds) / 20;
    return [UIFont systemFontOfSize:fontSize];
}

- (UIColor *)colorSelectedCell
{
    return [UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1.0];
}

@end
