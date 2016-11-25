//
//  PSGCoreDataAPI.h
//  SelectedCity
//
//  Created by Pavel Samsonov on 26.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

@interface PSGCoreDataAPI : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (PSGCoreDataAPI *)sharedCoreDataAPI;

@end
