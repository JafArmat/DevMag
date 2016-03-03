//
//  FavouritsViewController.h
//  DevMag
//
//  Created by Alexandru Antonica on 12/22/15.
//  Copyright © 2015 Alexandru Antonica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Produs.h"
static NSMutableArray *favIDs;
static NSMutableArray *favouritesItems;
static NSArray *filtered;

@interface FavouritsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

+(void)addProduct:(Produs*)produs;
+(void)deleteProduct:(Produs*)produs;
+(BOOL)checkFav:(NSNumber*)uniqueID;
@end
