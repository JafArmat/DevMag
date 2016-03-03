//
//  ProdusViewController.m
//  DevMag
//
//  Created by Alexandru Antonica on 12/20/15.
//  Copyright © 2015 Alexandru Antonica. All rights reserved.
//

#import "ProdusViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/UIImage+AFNetworking.h>
#import <PureLayout/PureLayout.h>
#import "MapLocationViewController.h"

static NSString *kBarTintColor      = @"kBarTintColor";
static NSString *kTintColor         = @"kTintColor";
static NSString *kStatusBarStyle    = @"kStatusBarStyle";


@interface ProdusViewController (){
    NSNumber *height;
    NSNumber *width;
    UIPageControl *pageControl;
    UIActivityIndicatorView *activityIndicator;
}


-(void) setColors;
-(void)downloadImages;
@end

@implementation ProdusViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = [self.sliderShow frame];
    self->width     = [[NSNumber alloc] initWithDouble:frame.size.width];
    self->height    = [[NSNumber alloc] initWithDouble:frame.size.height];
    
    
    //Setare Titlu
    [self setTitle:self.produs.nume];
    
    //Set Colors from memory(if saved privously)
    [self setColors];
    
    // KASlideshow
    self.sliderShow.delegate = self;
    [self.sliderShow setDelay:1];                                               // Delay between transitions
    [self.sliderShow setTransitionDuration:.5];                                 // Transition duration
    [self.sliderShow setTransitionType:KASlideShowTransitionSlide];              // Choose a transition type (fade or slide)
    [self.sliderShow setImagesContentMode:UIViewContentModeScaleAspectFit];    // Choose a content mode for images to display
    [self.sliderShow addGesture:KASlideShowGestureSwipe];                       // Gesture to go previous/next directly on the image
    [self.sliderShow addImagesFromResources:@[@"placeholder"]];
    [self performSelectorInBackground:@selector(downloadImages) withObject:nil];
    
    //Page Control
    pageControl                                 = [[UIPageControl alloc] init];
    pageControl.frame                           = CGRectMake(20, 100, 30, 10);
    pageControl.currentPage                     = 0;
    pageControl.tintColor                       = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor   = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor          = [UIColor grayColor];
    pageControl.numberOfPages                   = [self.produs.photos count];
    [self.sliderShow addSubview:pageControl];
    
    //ActivityIndicator
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator hidesWhenStopped];
    [self.sliderShow addSubview:activityIndicator];
    
    //Set Details
    self.titleLabel.text        = self.produs.nume;
    self.descriptionLabel.text  = self.produs.descriere;
    self.priceLabel.text        = [[NSString alloc]initWithFormat:@"%@ $",self.produs.pret];
    self.qtyLabel.text          = [self.produs.rating respondsToSelector:@selector(doubleValue)] ? [[NSString alloc] initWithFormat:@"%.1f",[self.produs.rating doubleValue]] : @"-/-";
    self.featuresDetails.text   = self.produs.features;

    
    //Constraints
    [pageControl autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:pageControl.superview withOffset:10.0f relation:NSLayoutRelationEqual];
    [pageControl autoAlignAxis:ALAxisVertical toSameAxisOfView:pageControl.superview];
    
    [activityIndicator autoCenterInSuperview];
    [activityIndicator startAnimating];
    
    [self.sliderShow bringSubviewToFront:activityIndicator];
    [self.sliderShow bringSubviewToFront:pageControl];
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self setColors];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - KASlideShow delegate
- (void) kaSlideShowWillShowNext:(KASlideShow *)slideShow{
    if(slideShow.currentIndex == pageControl.numberOfPages-1)
        [pageControl setCurrentPage:0];
    else
        [pageControl setCurrentPage:slideShow.currentIndex+1];
}

- (void) kaSlideShowWillShowPrevious:(KASlideShow *)slideShow{
    
    if(slideShow.currentIndex == 0)
        [pageControl setCurrentPage:pageControl.numberOfPages-1];
    else
        [pageControl setCurrentPage:slideShow.currentIndex-1];
}


#pragma mark - My methods

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
        
        //Set status bar style
        if (statusBarStyle == 0)
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        else
            if(statusBarStyle == 1)
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

//Helps at resizing the image receive as parametre
-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
    
}


-(void)downloadImages{
    
    [self.sliderShow emptyAndAddImagesFromResources:nil];
    
    for (NSString* urlPath in self.produs.photos) {
        if (urlPath != nil) {
                     NSURL *url = [NSURL URLWithString:urlPath];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
            UIImage *newImage = [Produs imageWithImage:image scaledToHeight:self.sliderShow.frame.size.height];
        
            [self.sliderShow addImage:newImage];
        }
    }
    
    [activityIndicator stopAnimating];
    [self.sliderShow setNeedsDisplay];
    
    
    
}

-(IBAction)openWebPageOfProduct:(UIButton *)sender {
    
    //Open web page with prouducta from bestbuy
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.produs.mobileURL]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.produs.mobileURL]];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"We are sorry!"
                                                                                 message:@"It seems that this product's link is broken!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        
        
        //We add buttons to the alert controller by creating UIAlertActions:
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    MapLocationViewController *mapLoc = segue.destinationViewController;
    mapLoc.prod = self.produs;

}

@end
