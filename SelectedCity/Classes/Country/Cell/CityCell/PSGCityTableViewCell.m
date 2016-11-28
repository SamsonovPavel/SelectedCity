//
//  PSGCityTableViewCell.m
//  SelectedCity
//
//  Created by Pavel Samsonov on 27.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

#import "PSGCityTableViewCell.h"

@interface PSGCityTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;

- (IBAction)tapOnFavorites:(UIButton *)sender;

@end

@implementation PSGCityTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellInfo:(NSString *)cellInfo
{
    _cellInfo = cellInfo;
    
    self.cityLabel.text = cellInfo;
    self.cityLabel.font = [PSGHelper sharedInstance].setFontSize;
}

#pragma mark - IBAction

- (IBAction)tapOnFavorites:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(cellFavoritesButtonPressed:button:)])
        [self.delegate cellFavoritesButtonPressed:self button:sender];
}
@end