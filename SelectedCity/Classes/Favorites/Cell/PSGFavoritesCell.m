//
//  PSGFavoritesCell.m
//  SelectedCity
//
//  Created by Pavel Samsonov on 29.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

#import "PSGFavoritesCell.h"

@interface PSGFavoritesCell ()

@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;

@end

@implementation PSGFavoritesCell

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
    
    self.favoritesLabel.text = cellInfo;
    self.favoritesLabel.font = [PSGHelper sharedInstance].setFontSize;
}

@end
