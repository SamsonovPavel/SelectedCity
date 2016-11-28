//
//  UIView+UITableViewCell.m
//  SelectedCity
//
//  Created by Pavel Samsonov on 28.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

@implementation UIView (UITableViewCell)

- (UITableViewCell *)superTableViewCell
{
    if (!self.superview)
        return nil;
    if ([self.superview isKindOfClass:[UITableViewCell class]])
        return (UITableViewCell *)self.superview;
    
    return [self.superview superTableViewCell];
}

@end
