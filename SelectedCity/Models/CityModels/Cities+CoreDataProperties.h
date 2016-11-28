//
//  Cities+CoreDataProperties.h
//  SelectedCity
//
//  Created by Pavel Samsonov on 28.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Cities.h"

NS_ASSUME_NONNULL_BEGIN

@interface Cities (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDecimalNumber *countryID;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
