//
//  LoginViewController.h
//  DevMag
//
//  Created by Alexandru Antonica on 12/18/15.
//  Copyright © 2015 Alexandru Antonica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
- (IBAction)didPressLogIn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *pasTF;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
