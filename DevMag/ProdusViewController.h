//
//  ProdusViewController.h
//  DevMag
//
//  Created by Alexandru Antonica on 12/20/15.
//  Copyright © 2015 Alexandru Antonica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Produs.h"
#import "KASlideShow.h"

@interface ProdusViewController : UIViewController <UIScrollViewDelegate,KASlideShowDelegate>

@property(nonatomic,strong) Produs *produs;
@property(nonatomic,strong) NSString *pageTitle;
@property(nonatomic,strong) NSString *details;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *featuresDetails;

@property (strong, nonatomic) IBOutlet KASlideShow *sliderShow;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end


//AKIAJBHDCXI4EFOH6R3A
//Secret Access Key:
//LWwujlWNA3rAUuU07KOLYK4qrb+k0WvQV9CB46uU