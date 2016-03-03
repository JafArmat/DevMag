//
//  FavouritsViewController.m
//  DevMag
//
//  Created by Alexandru Antonica on 12/22/15.
//  Copyright © 2015 Alexandru Antonica. All rights reserved.
//

#import "FavouritsViewController.h"
#import "CustomTableViewCell.h"
#import "Produs.h"

static NSString *simpleTableIdentifier      = @"CustomCell";



@interface FavouritsViewController ()

@end

@implementation FavouritsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //TODO: Umple din memorie favouritesItems cu produse deja retinute
    
    //TODO: Copiaza in filtred tot
    
    //TODO: Umple favIDs cu idurile produselor
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(BOOL)checkFav:(NSNumber *)uniqueID{
    
    for (NSNumber *idToCheck in favIDs) {
        if (idToCheck.intValue == uniqueID.intValue) {
            return YES;
        }
    }
    return NO;
}

+(void)addProduct:(Produs*)produs{
    if(favouritesItems == nil){
        favouritesItems = [[NSMutableArray alloc] init];
    }
    [favouritesItems addObject:produs];
};

+(void)deleteProduct:(Produs *)produs{
    
    for (Produs *prod in favouritesItems) {
        if (prod.uniqueID == produs.uniqueID) {
            [favouritesItems delete:produs];
            break;
        }
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    int index    = (int)indexPath.row;
    NSLog(@"%lu",(unsigned long)[favouritesItems count]);
    Produs *prod = favouritesItems[index];
    
    cell.nameLabel.text     = prod.nume;
    cell.priceLabel.text    = [[NSString alloc] initWithFormat:@"%@ $",prod.pret];
    cell.qntyLabel.text     = [[NSString alloc] initWithFormat:@"%f",[prod.rating doubleValue]];
    cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
    cell.fav                = NO;
    //[self getImage:prod.pathToPicture forCell:cell];
    
    
    //Set action for fav button
    [cell.favButton addTarget:self action:@selector(checkFav:) forControlEvents:UIControlEventTouchUpInside];
    

    
    return cell;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [favouritesItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 109;
}
@end
