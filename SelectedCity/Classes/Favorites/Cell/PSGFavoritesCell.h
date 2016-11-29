//
//  PSGFavoritesCell.h
//  SelectedCity
//
//  Created by Pavel Samsonov on 29.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

@protocol PSGFavoritesCellDelegate;

@interface PSGFavoritesCell : UITableViewCell

@property (strong, nonatomic) NSString *cellInfo;
@property (weak, nonatomic) id <PSGFavoritesCellDelegate> delegate;

@end

@protocol PSGFavoritesCellDelegate <NSObject>
@optional
// Вызывается в делегате при нажатии на кнопку "Удалить из избранного"
- (void)cellDeleteFromFavoritesButtonPressed:(PSGFavoritesCell *)sender button:(UIButton *)button;
@end
