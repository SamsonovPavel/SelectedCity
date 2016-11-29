//
//  PSGCityTableViewCell.h
//  SelectedCity
//
//  Created by Pavel Samsonov on 27.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

@protocol PSGCityCellDelegate;

@interface PSGCityTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *cellInfo;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;
@property (weak, nonatomic) id <PSGCityCellDelegate> delegate;

@end

@protocol PSGCityCellDelegate <NSObject>
@optional
// Вызывается в делегате при нажатии на кнопку "Добавить в избранное"
- (void)cellFavoritesButtonPressed:(PSGCityTableViewCell *)sender button:(UIButton *)button;
@end
