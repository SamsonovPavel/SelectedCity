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

NSString *const kCountryCellNibReuseIdn = @"PSGCountryTableViewCell";
NSString *const kCityCellNibReuseIdn    = @"PSGCityTableViewCell";

#define kCountryCellReuseIdn @"CountryCell"
#define kCityCellReuseIdn    @"CityCell"

@interface PSGCountryTVC ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - SETUP/INIT

- (void)setupTableView
{
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

// Вызывается при нажатии на секцию страны
- (void)reloadSectionWithIndexPath:(NSIndexPath *)indexPath
{    
    [self.tableView beginUpdates];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section + 1];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.loadDataArray count] * 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
                        return [[[self.loadDataArray objectAtIndex:section / 2] valueForKey:@"Cities"] count];
                    else
                        return 0;
                    break;
                    
                case CityTableSectionsNumber3:
                    if (cityTableSectionsNumber3)
                        return [[[self.loadDataArray objectAtIndex:section / 2] valueForKey:@"Cities"] count];
                    else
                        return 0;
                    break;
                    
                case CityTableSectionsNumber5:
                    if (cityTableSectionsNumber5)
                        return [[[self.loadDataArray objectAtIndex:section / 2] valueForKey:@"Cities"] count];
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
    NSInteger index = indexPath.section / 2;
    NSArray *cities = [[self.loadDataArray objectAtIndex:index] valueForKey:@"Cities"];
    
    cityCell.cellInfo = [[cities objectAtIndex:indexPath.row] valueForKey:@"Name"];
}

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
    [self reloadSectionWithIndexPath:indexPath];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
