//
//  PSGCommonMainVC.h
//  SelectedCity
//
//  Created by Pavel Samsonov on 26.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

@interface PSGCommonMainVC : UITableViewController
<
NSFetchedResultsControllerDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
