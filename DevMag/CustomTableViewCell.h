//
//  CustomTableViewCell.h
//  DevMag
//
//  Created by Alexandru Antonica on 12/19/15.
//  Copyright © 2015 Alexandru Antonica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Produs.h"
@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *qntyLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorViewCell;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) Produs *cellProdus;
@property (nonatomic) BOOL fav;
@end
