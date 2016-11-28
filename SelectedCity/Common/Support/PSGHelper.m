//
//  PSGHelper.m
//  SelectedCity
//
//  Created by Pavel Samsonov on 26.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

@implementation PSGHelper

+ (PSGHelper *)sharedInstance
{
    static PSGHelper *helperInst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helperInst = [[PSGHelper alloc] init];
    });
    return helperInst;
}

- (UIFont *)setFontSize
{
    NSInteger fontSize = (int)CGRectGetWidth([UIScreen mainScreen].bounds) / 20;
    return [UIFont systemFontOfSize:fontSize];
}

- (UIColor *)colorSelectedCell
{
    return [UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1.0];
}

#pragma mark - Methods for working with CoreData

- (void)allObjects
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Cities class])];
    NSError *error = nil;
    NSArray *allObjects = [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext executeFetchRequest:request
                                                                                                 error:&error];
    if ([allObjects count] > 0)
    {
        for (Cities *cities in allObjects)
            NSLog(@"%@ - %@", cities.countryID, cities.name);
    }
    else if (error != nil)
        NSLog(@"Error print - %@", [error localizedDescription]);
    else
        NSLog(@"CoreData is Empty!");
}

- (void)deleteAllObjects
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([ParentClass class])];
    NSError *error = nil;
    NSArray *allObjects = [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext executeFetchRequest:request
                                                                                                 error:&error];
    if ([allObjects count] > 0)
    {
        for (id object in allObjects)
        {
            [[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext deleteObject:object];
        }
    }
    else if (error != nil)
        NSLog(@"Delete error - %@", [error localizedDescription]);
    
    if ([[PSGCoreDataAPI sharedCoreDataAPI].managedObjectContext save:nil])
        NSLog(@"CoreData is deleted!");
    
}

@end
