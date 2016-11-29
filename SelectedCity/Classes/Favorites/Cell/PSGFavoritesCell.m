//
//  PSGFavoritesCell.m
//  SelectedCity
//
//  Created by Pavel Samsonov on 29.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

#import "PSGFavoritesCell.h"
#import "PSGCountryTVC.h"

@interface PSGFavoritesCell ()

@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;
- (IBAction)tapOnDeleteButton:(UIButton *)sender;

@end

@implementation PSGFavoritesCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITabBarController *tabBar = (UITabBarController *)ApplicationDelegate.window.rootViewController;
    UINavigationController *nc = (UINavigationController *)[tabBar.viewControllers firstObject];
    self.delegate = [nc.viewControllers firstObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellInfo:(NSString *)cellInfo
{
    _cellInfo = cellInfo;
    
    self.favoritesLabel.text = cellInfo;
    self.favoritesLabel.font = [PSGHelper sharedInstance].setFontSize;
}

- (IBAction)tapOnDeleteButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(cellDeleteFromFavoritesButtonPressed:button:)])
        [self.delegate cellDeleteFromFavoritesButtonPressed:self button:sender];
}

@end
