//
//  PSGFavoritesVC.h
//  SelectedCity
//
//  Created by Pavel Samsonov on 25.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

@protocol PSGFavoritesVCDelegate;

@interface PSGFavoritesVC : PSGCommonMainVC

@property (weak, nonatomic) id <PSGFavoritesVCDelegate> delegate;

@end

@protocol PSGFavoritesVCDelegate <NSObject>
@optional
// Вызывается в делегате для обновления таблицы
- (void)reloadTableViewControllerButtonPressed:(PSGFavoritesVC *)sender;
@end
