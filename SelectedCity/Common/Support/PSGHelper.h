//
//  PSGHelper.h
//  SelectedCity
//
//  Created by Pavel Samsonov on 26.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

typedef enum {
    TableCountrySections,
    TableCitySections,
} CountryTableSections;

typedef enum {
    CityTableSectionsNumber1 = 1,
    CityTableSectionsNumber3 = 3,
    CityTableSectionsNumber5 = 5
} CityTableSections;

static BOOL cityTableSectionsNumber1,
            cityTableSectionsNumber3,
            cityTableSectionsNumber5;

@interface PSGHelper : NSObject

+ (PSGHelper *)sharedInstance;

- (UIFont *)setFontSize;

@end
