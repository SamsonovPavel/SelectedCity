//
//  PSGSettingsVC.m
//  SelectedCity
//
//  Created by Pavel Samsonov on 25.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

#import "PSGSettingsVC.h"

@interface PSGSettingsVC ()

@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;

@end

@implementation PSGSettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Настройки";
    
    NSInteger fontSize = (int)CGRectGetWidth([UIScreen mainScreen].bounds) / 18;
    self.settingsLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
