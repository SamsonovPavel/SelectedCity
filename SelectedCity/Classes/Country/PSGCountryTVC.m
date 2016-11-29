//
//  PSGCountryTVC.m
//  SelectedCity
//
//  Created by Pavel Samsonov on 26.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

#import "PSGCountryTVC.h"
#import "PSGCountryTableViewCell.h"
#import "PSGCityTableViewCell.h"
#import "PSGFavoritesCell.h"

NSString *const kCountryCellNibReuseIdn = @"PSGCountryTableViewCell";
NSString *const kCityCellNibReuseIdn    = @"PSGCityTableViewCell";

#define kCountryCellReuseIdn @"CountryCell"
#define kCityCellReuseIdn    @"CityCell"

@interface PSGCountryTVC () <PSGCityCellDelegate, PSGFavoritesCellDelegate>

@property (strong, nonatomic) NSArray *loadDataArray;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *imagesArray;

@end

@implementation PSGCountryTVC

#pragma mark - LIFE CICLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self loadData];
    [self refreshTableView];
    [self countryImagesArray];
    
//    [[PSGHelper sharedInstance] allObjects];        // Вывести все объекты в лог
//    [[PSGHelper sharedInstance] deleteAllObjects];  // Удалить все объекты
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - SETUP/INIT

- (void)setupTableView
{
    self.navigationItem.title = @"Страны";
    [self.tableView registerNib:[UINib nibWithNibName:kCountryCellNibReuseIdn bundle:nil]
            forCellReuseIdentifier:kCountryCellReuseIdn];
    [self.tableView registerNib:[UINib nibWithNibName:kCityCellNibReuseIdn bundle:nil]
         forCellReuseIdentifier:kCityCellReuseIdn];
}

- (void)refreshTableView
{
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                         target:self
                                                         action:@selector(loadData)];
    self.navigationItem.rightBarButtonItem = refresh;
}

- (void)loadData
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGPoint activityIndicatorCenter = CGPointMake(CGRectGetMidX(MainScreen.bounds),
                                                  CGRectGetMidY(MainScreen.bounds) - (CGRectGetMaxY(MainScreen.bounds) / 10.0));
    self.activityIndicator.center = activityIndicatorCenter;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    __weak typeof(self) weakSelf = self;
    [[PSGApiConnection sharedApiConnection] getDataWithSuccefullHandler:^(id  _Nonnull data) {
        
        weakSelf.loadDataArray = [NSArray arrayWithArray:[data valueForKey:@"Result"]];
        cityTableSectionsNumber1 = cityTableSectionsNumber3 = cityTableSectionsNumber5 = NO;
        [weakSelf.tableView reloadData];
        [weakSelf.activityIndicator stopAnimating];
        
    } connectionError:^(NSError * _Nonnull error) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SelectedCity"
                                                                       message:[error localizedDescription]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        [weakSelf.activityIndicator stopAnimating];
        
    }];
}
// Если на сервере ссылки на изображения равны nil
- (void)countryImagesArray
{
    UIImage *russia = [UIImage imageNamed:@"flagRussia"];
    UIImage *germany = [UIImage imageNamed:@"flagGermany"];
    UIImage *unitedStates = [UIImage imageNamed:@"flagUnitedStates"];
    
    self.imagesArray = [NSArray arrayWithObjects:russia, germany, unitedStates, nil];
}

#pragma mark - PSGCityCellDelegate

// Обработчик нажатия на кнопку "Добавить в избранное"
- (void)cellFavoritesButtonPressed:(PSGCityTableViewCell *)sender button:(UIButton *)button
{
    UITableViewCell *cell = [button superTableViewCell];
    
    if (cell)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Cities class])];
        NSError *error = nil;
        NSArray *allObjects = [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext executeFetchRequest:request
                                                                                                     error:&error];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSInteger index = indexPath.section / 2;
        NSArray *array = [[self.loadDataArray objectAtIndex:index] valueForKey:@"Cities"];
        
        for (Cities *cities in allObjects)
        {
            if ([cities.countryID isEqual:[[array objectAtIndex:indexPath.row] valueForKey:@"CountryId"]] &
                [cities.name isEqualToString:[[array objectAtIndex:indexPath.row] valueForKey:@"Name"]])
            {
                [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext deleteObject:cities];
                [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext save:nil];
                
                [button setImage:[UIImage imageNamed:kFavoritesImage] forState:UIControlStateNormal];
                
                return;
            }
        }
        
        Cities *cities = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Cities class])
                                                       inManagedObjectContext:[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext];
        if (cities != nil)
        {
            cities.countryID = [[array objectAtIndex:indexPath.row] valueForKey:@"CountryId"];
            cities.name = [[array objectAtIndex:indexPath.row] valueForKey:@"Name"];
            
            NSError *error = nil;
            if (![[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext save:&error])
                NSLog(@"Error - %@", [error localizedDescription]);
            
            [button setImage:[UIImage imageNamed:kFavoritesImagePressed] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - PSGFavoritesCellDelegate

// Обработчик нажатия на кнопку "Удалить из избранного"
- (void)cellDeleteFromFavoritesButtonPressed:(PSGFavoritesCell *)sender button:(UIButton *)button
{
    UITableViewCell *cell = [button superTableViewCell];
    
    if (cell)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Cities class])];
        NSError *error = nil;
        NSArray *allObjects = [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext executeFetchRequest:request
                                                                                                     error:&error];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext deleteObject:[allObjects objectAtIndex:indexPath.row]];
        [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext save:nil];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.loadDataArray count] * 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger countRow = [[[self.loadDataArray objectAtIndex:section / 2] valueForKey:@"Cities"] count];
    
    switch (section % 2)
    {
        case TableCountrySections:
            return 1;
            break;
            
        case TableCitySections:
        {
            switch (section)
            {
                case CityTableSectionsNumber1:
                    if (cityTableSectionsNumber1)
                        return countRow;
                    else
                        return 0;
                    break;
                    
                case CityTableSectionsNumber3:
                    if (cityTableSectionsNumber3)
                        return countRow;
                    else
                        return 0;
                    break;
                    
                case CityTableSectionsNumber5:
                    if (cityTableSectionsNumber5)
                        return countRow;
                    else
                        return 0;
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section % 2)
    {
        case TableCountrySections:
            cell = (PSGCountryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCountryCellReuseIdn
                                                                              forIndexPath:indexPath];
            [self configureCountryCell:(PSGCountryTableViewCell *)cell forIndexPath:indexPath];
            break;
            
        case TableCitySections:
        {
            cell = (PSGCityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCityCellReuseIdn
                                                                           forIndexPath:indexPath];
            [self configureCityCell:(PSGCityTableViewCell *)cell forIndexPath:indexPath];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark UITableView cell configuration

- (void)configureCountryCell:(PSGCountryTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    PSGCountryTableViewCell *countryCell = (PSGCountryTableViewCell *)cell;
    countryCell.selectedBackgroundView = [[UIView alloc] init];
    countryCell.selectedBackgroundView.backgroundColor = [PSGHelper sharedInstance].colorSelectedCell;

    NSInteger index = indexPath.section / 2;
    NSString *imagePath = [[self.loadDataArray objectAtIndex:index] valueForKey:@"ImageLink"];
    NSURL *imageURL = [NSURL URLWithString:imagePath];
    [countryCell.flagImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    if ([countryCell.flagImageView.image isEqual:[UIImage imageNamed:@"placeholder"]])
        countryCell.flagImageView.image = [self.imagesArray objectAtIndex:index];
    
    countryCell.cellInfo = [[self.loadDataArray objectAtIndex:index] valueForKey:@"Name"];
}

- (void)configureCityCell:(PSGCityTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    PSGCityTableViewCell *cityCell = (PSGCityTableViewCell *)cell;
    cityCell.delegate = self;
    
    NSInteger index = indexPath.section / 2;
    NSArray *cities = [[self.loadDataArray objectAtIndex:index] valueForKey:@"Cities"];
    
    cityCell.cellInfo = [[cities objectAtIndex:indexPath.row] valueForKey:@"Name"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Cities class])];
    NSError *error = nil;
    NSArray *allObjects = [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext executeFetchRequest:request
                                                                                                 error:&error];
    if ([allObjects count] > 0)
    {
        NSArray *array = [[self.loadDataArray objectAtIndex:index] valueForKey:@"Cities"];
        
        for (Cities *cities in allObjects)
        {
            if ([cities.countryID isEqual:[[array objectAtIndex:indexPath.row] valueForKey:@"CountryId"]] &
                [cities.name isEqualToString:[[array objectAtIndex:indexPath.row] valueForKey:@"Name"]])
                [cityCell.favoritesButton setImage:[UIImage imageNamed:kFavoritesImagePressed] forState:UIControlStateNormal];
            else
                [cityCell.favoritesButton setImage:[UIImage imageNamed:kFavoritesImage] forState:UIControlStateNormal];
        }
    }
    else
        [cityCell.favoritesButton setImage:[UIImage imageNamed:kFavoritesImage] forState:UIControlStateNormal];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (!cityTableSectionsNumber1) cityTableSectionsNumber1 = YES;
        else cityTableSectionsNumber1 = NO;
    }
    else if (indexPath.section == 2)
    {
        if (!cityTableSectionsNumber3) cityTableSectionsNumber3 = YES;
        else cityTableSectionsNumber3 = NO;
    }
    else if (indexPath.section == 4)
    {
        if (!cityTableSectionsNumber5) cityTableSectionsNumber5 = YES;
        else cityTableSectionsNumber5 = NO;
    }
    [self.tableView reloadData];
}

@end
