//
//  PSGCountryTableViewCell.m
//  SelectedCity
//
//  Created by Pavel Samsonov on 26.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

#import "PSGCountryTableViewCell.h"

@interface PSGCountryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@end

@implementation PSGCountryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellInfo:(NSString *)cellInfo
{
    _cellInfo = cellInfo;
    
    if ([cellInfo isEqualToString:@"Russia"])
        self.countryLabel.text = @"Россия";
    
    else if ([cellInfo isEqualToString:@"Germany"])
            self.countryLabel.text = @"Германия";
    
    else if ([cellInfo isEqualToString:@"USA"])
            self.countryLabel.text = @"США";
    
    self.countryLabel.font = [PSGHelper sharedInstance].setFontSize;
}

@end