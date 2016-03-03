//
//  FirstViewController.m
//  DevMag
//
//  Created by Alexandru Antonica on 12/17/15.
//  Copyright © 2015 Alexandru Antonica. All rights reserved.
//

#import "ProductsTableView.h"
#import "Produs.h"
#import "CustomTableViewCell.h"
#import "ProdusViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "FavouritsViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


static NSString *kStatusBarStyle            = @"kStatusBarStyle";
static NSString *kBarTintColor              = @"kBarTintColor";
static NSString *kTintColor                 = @"kTintColor";
static NSString *simpleTableIdentifier      = @"CustomCell";
static NSString *nCheckConectivity          = @"internet";
static BOOL isDataDownloaded                = NO;
static BOOL  editMode                       = NO;

@interface ProductsTableView(){
    NSMutableArray *arrayProduse;
    NSArray *searchedProducts;
    Produs *prodPassed;
    UISearchController *searchController;
    NSArray *filtered;
    NSNotificationCenter *center;
    NSString *netStatus;
}

-(void)fillTable:(id)jsonObject;
-(void)networkMethodTest;
-(void) setColors;
-(void)checkFav:(UIButton *)button;
-(void) initialiseLocalVariables;
-(void) downloadData:(NSNotification *)notification;
@end

@implementation ProductsTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialiseLocalVariables];
    [self setColors];
    
    //Registre for internet check
    [center addObserver:self selector:@selector(downloadData:) name:nCheckConectivity object:nil];
    
    
    //Preparations for using searchController and searchBar
    searchController                                    = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater               = self;
    searchController.dimsBackgroundDuringPresentation   = false;
    [searchController.searchBar sizeToFit];
    
    self.tableView.tableHeaderView  = searchController.searchBar;
    self.definesPresentationContext = true;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 109;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    //Unregistre for internet check
    [center removeObserver:self];
    isDataDownloaded = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [self setColors];
    //Registre for internet check
    [center addObserver:self selector:@selector(downloadData:) name:nCheckConectivity object:nil];
    
    if (!isDataDownloaded) {
        [self networkMethodTest];
    }

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setColors{
    NSUserDefaults *usDef = [NSUserDefaults standardUserDefaults];
    
    UIColor *tintColor       = [usDef objectForKey:kTintColor];
    UIColor *barTintColor    = [usDef objectForKey:kBarTintColor];
    NSInteger statusBarStyle = (NSInteger)[usDef objectForKey:kStatusBarStyle];
    
    if (tintColor != nil && barTintColor != nil) {
        //Setare culoare nagivation bar
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:kBarTintColor];
        UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        [self.navigationController.navigationBar  setBarTintColor:color];
        
        colorData   = [[NSUserDefaults standardUserDefaults] objectForKey:kTintColor];
        color       = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        [self.navigationController.navigationBar  setTintColor:color];
        
        //Set Title color
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : color}];
        
        
        //TODO: Nu imi salveaza starea barii
       // NSLog(@"status :%li",statusBarStyle);
        
        //Set status bar style
        if (statusBarStyle == 0)
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        else
            if(statusBarStyle == 1)
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
        
    }
    
}


-(void) initialiseLocalVariables{
    self->arrayProduse = [[NSMutableArray alloc] init];
    center = [NSNotificationCenter defaultCenter];
    netStatus = [[NSString alloc]init];
}


#pragma mark - TableView delegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [filtered  count];
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    int index    = (int)indexPath.row;
    Produs *prod = self->filtered[index];
    
    cell.cellProdus = prod;
    cell.nameLabel.text     = prod.nume;
    cell.priceLabel.text    = [[NSString alloc] initWithFormat:@"%@ $",prod.pret];
    cell.qntyLabel.text     = [prod.rating respondsToSelector:@selector(doubleValue)] ? [[NSString alloc] initWithFormat:@"%.1f",[prod.rating doubleValue]] : @"-/-";
    
    if (editMode == NO)
        cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
    else
        cell.accessoryType      = UITableViewCellAccessoryNone;
    
    cell.fav                = NO;
    [cell.favButton setHidden:YES];
    [self getImage:prod.thumbnail forCell:cell];

    return cell;
}

- (CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath{
    return 109;
    
    //TODO: Nu merge height, look it up
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editMode) {

        CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
       
        if (![FavouritsViewController checkFav:cell.cellProdus.uniqueID]) {
            cell.fav = YES;
            [cell.favButton setImage:[UIImage imageNamed:@"FavFill"] forState:UIControlStateNormal];
            
            [favouritesItems addObject:cell.cellProdus];
            
            //TODO: Adauga la favorite
        }else{
            [cell.favButton setImage:[UIImage imageNamed:@"FavEmpty"] forState:UIControlStateNormal];
            
            //TODO: Sterge de la favorite
            [FavouritsViewController deleteProduct:cell.cellProdus];
        }

        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        prodPassed = [filtered objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"detailsViewSegue" sender:self];

    }
    
}

#pragma mark - SearchBar delegate methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchControllerr{
    
    NSString *text = [[NSString alloc] initWithString:searchControllerr.searchBar.text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nume CONTAINS[cd] %@", text];
    filtered = [arrayProduse filteredArrayUsingPredicate:predicate];
    
    if ([searchController.searchBar.text isEqual:@""]) {
        filtered = arrayProduse;
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - My methods

-(void)checkFav:(UIButton *)button{
    
    [button setImage:[UIImage imageNamed:@"FavEmpty"] forState:UIControlStateNormal];
    
}

-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
    
}

-(void)getImage:(NSString*)pathToImage forCell:(CustomTableViewCell*)cell{
    
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        [cell.indicatorViewCell startAnimating];
        
        NSURL *url = [[NSURL alloc]initWithString:pathToImage];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        
       cell.logoImgView.contentMode = UIViewContentModeScaleAspectFit;
       // cell.imageView.clipsToBounds = YES;
        
        __weak CustomTableViewCell *weakCell = cell;
        [cell.logoImgView setImageWithURLRequest:urlRequest
                              placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                  
                                 // UIImage *resizedImage = [self resizeImage:image imageSize:CGSizeMake(50, 77)];
                                  
                                  [weakCell.logoImgView setImage:image];
                                  [weakCell.indicatorViewCell stopAnimating];
                                  [weakCell.indicatorViewCell setHidden:true];
                                  [weakCell setNeedsLayout];
                                  
                              } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                  
                                  [weakCell.indicatorViewCell stopAnimating];
                                  [weakCell.indicatorViewCell setHidden:true];
                                  [weakCell setNeedsLayout];
                                  
                              }];
    });
}

-(IBAction)edit:(UIBarButtonItem*)button{
    

    if([button.title isEqualToString:@"Edit"]){
        button.title= @"Done";
        editMode = YES;
        for (CustomTableViewCell* cell in [self.tableView visibleCells])
        {
            
            
            //Set action for fav button
            [cell.favButton addTarget:self action:@selector(checkFav:) forControlEvents:UIControlEventTouchUpInside];
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                
                if ([FavouritsViewController checkFav:cell.cellProdus.uniqueID]) {
                    cell.fav = YES;
                    [cell.favButton setImage:[UIImage imageNamed:@"FavFill"] forState:UIControlStateNormal];
                }else{
                    [cell.favButton setImage:[UIImage imageNamed:@"FavEmpty"] forState:UIControlStateNormal];
                }
                
            });
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.favButton setHidden:NO];
            
        }
        
        
        
    }else{
        button.title= @"Edit";
        editMode = NO;
        
        for (CustomTableViewCell* cell in [self.tableView visibleCells])
        {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.favButton setHidden:YES];
            
        }
    }
}

-(void) downloadData:(NSNotification *)notification{
    netStatus = [notification object];
    
    if ([netStatus isEqualToString:@"Not Reachable"]) {
        NSLog(@"Nu e net");
        
        ///[self testMethods];
        [self networkMethodTest];
        
    }else{
        if ([netStatus containsString:@"Reachable via"] && isDataDownloaded == NO) {
            NSLog(@"E net");
           // [self testMethods];
            [self networkMethodTest];
        }
    }
}

#pragma mark - Segue methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    ProdusViewController *produsViewController =  [segue destinationViewController];
    produsViewController.produs = prodPassed;
    
}


//-----------------------------------------------------------------

-(void) testMethods{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet Access!"
                                                                             message:@"It seems that your device is not connected to the internet!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Settings"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         NSURL*url=[NSURL URLWithString:@"prefs:root"];
                                                         if([[UIApplication sharedApplication] openURL:url]){
                                                             [[UIApplication sharedApplication] openURL:url];
                                                         }
                                                     }];
    
    
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)networkMethodTest{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    

    NSString *url = @"https://api.bestbuy.com/v1/products((search=htc)&(categoryPath.id=pcmcat209400050001))?apiKey=f8q7ay5vtnzxmgvtrb6tjqs2&pageSize=2&format=json";
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        isDataDownloaded = YES;
        [self fillTable:[responseObject objectForKey:@"products"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        isDataDownloaded = NO;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error Downloading Data!"
                                                                                 message:@"We had some dificulties fetching your data. Check to see if your  device is connected to the internet"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             NSURL*url=[NSURL URLWithString:@"prefs:root"];
                                                             if([[UIApplication sharedApplication] openURL:url]){
                                                                 [[UIApplication sharedApplication] openURL:url];
                                                             }
                                                         }];
        
        
        [alertController addAction:actionOk];
        [alertController addAction:settings];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
    
}



-(void)fillTable:(id)responseObject{
    
    NSArray *jsonDataArray = responseObject;
    for (NSDictionary  *obj in jsonDataArray) {
        
        //Cream un obiect de tip Produs
        Produs* prod = [[Produs alloc] initWithDictionary:obj];
        [self->arrayProduse addObject:prod];
        filtered = [[NSArray alloc] initWithArray:arrayProduse];
        [self.tableView reloadData];
    }
    
}

@end


