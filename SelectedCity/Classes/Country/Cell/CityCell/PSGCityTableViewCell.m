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

@end

@implementation PSGCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
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

@end
