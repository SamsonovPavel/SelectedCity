//
//  PSGFavoritesVC.m
//  SelectedCity
//
//  Created by Pavel Samsonov on 25.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

#import "PSGFavoritesVC.h"
#import "PSGFavoritesCell.h"

NSString *const kFavoritesCellNibReuseIdn = @"PSGFavoritesCell";

#define kFavoritesCellReuseIdn @"FavoritesCell"

@interface PSGFavoritesVC () <PSGFavoritesCellDelegate>

@end

@implementation PSGFavoritesVC
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - SETUP/INIT

- (void)setupTableView
{
    self.navigationItem.title = @"Избранное";
    [self.tableView registerNib:[UINib nibWithNibName:kFavoritesCellNibReuseIdn bundle:nil]
         forCellReuseIdentifier:kFavoritesCellReuseIdn];
}

#pragma mark - PSGFavoritesCellDelegate

// Обработчик нажатия на кнопку "Удалить из избранного"
- (void)cellDeleteFromFavoritesButtonPressed:(PSGFavoritesCell *)sender button:(UIButton *)button
{
    PSGFavoritesCell *cell = (PSGFavoritesCell *)[button superTableViewCell];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (cell)
    {
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
//        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Cities class])];
//        NSError *error = nil;
//        NSArray *allObjects = [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext executeFetchRequest:request
//                                                                                                     error:&error];
//        
//        NSLog(@"%@", allObjects);
        
        [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext deleteObject:object];
        [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext save:nil];
    }
    
    UITabBarController *tabBar = (UITabBarController *)ApplicationDelegate.window.rootViewController;
    UINavigationController *nc = (UINavigationController *)[tabBar.viewControllers firstObject];
    self.delegate = [nc.viewControllers firstObject];
    
    if ([self.delegate respondsToSelector:@selector(reloadTableViewControllerButtonPressed:)])
        [self.delegate reloadTableViewControllerButtonPressed:self];
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Cities class])
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"countryID" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (PSGFavoritesCell *)[tableView dequeueReusableCellWithIdentifier:kFavoritesCellReuseIdn
                                                                                forIndexPath:indexPath];
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self configureFavoritesCell:(PSGFavoritesCell *)cell withObject:object];
    
    return cell;
}

#pragma mark UITableView cell configuration

- (void)configureFavoritesCell:(PSGFavoritesCell *)cell withObject:(NSManagedObject *)object
{
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];
    Cities *cities = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.cellInfo = cities.name;
    cell.delegate = self;
}

@end


















