//
//  LoginViewController.m
//  DevMag
//
//  Created by Alexandru Antonica on 12/18/15.
//  Copyright © 2015 Alexandru Antonica. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

static NSString *kUser = @"usernameDevMag";
static NSString *kIsLoggedIn = @"isLogged";

@interface LoginViewController ()

- (void) dismissKeyboard;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    //Set TextfieldDelegate
    self.usernameTF.delegate = self;
    self.pasTF.delegate = self;
    

    //check for existing username
    NSUserDefaults *usDefaults = [NSUserDefaults standardUserDefaults];
    if ( [usDefaults objectForKey:kUser] != nil) {
        self.usernameTF.text = [usDefaults objectForKey:kUser];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)didPressLogIn:(id)sender {
    
    NSString *username  = self.usernameTF.text;
    NSString *pass      = self.pasTF.text;
    
    
    //Check to see if username in database
    // Create a reference to a Firebase database URL
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://glowing-heat-3558.firebaseio.com/users/"];
    

    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDictionary *possibleUsers = snapshot.value;
        NSDictionary *valuesOfUser = [possibleUsers valueForKey:username];
        
        if (![valuesOfUser isEqual:[NSNull null]]) {
                if ([[valuesOfUser valueForKey:@"password"] isEqualToString:pass]) {
                    
                    //Save username in user default
                    NSUserDefaults *usDefaults = [NSUserDefaults standardUserDefaults];
                    
                    //user
                    [usDefaults setObject:username forKey:kUser];
                    
                    //save isLogged
                    [usDefaults setBool:YES forKey:kIsLoggedIn];
                    
                    
                    //Change view
                    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                    [appDelegate.window setRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlreadyLogged"]];
                    
                }else{
                    NSLog(@"Nu e buna parola");
                }
            
        }else{
            NSLog(@"Nu exista username");
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
}

- (void)labelTap{
    
    [self.usernameTF resignFirstResponder];
    [self.pasTF resignFirstResponder];
    
}

//- (IBAction)didPressSignUp:(id)sender {
//    
////    UIAlertController *alert;
////    UIAlertAction     *action;
////    
////    alert = [UIAlertController alertControllerWithTitle:@"WARNING!"
////                                                message:@"The SignUp page is still under developing."
////                                         preferredStyle:UIAlertControllerStyleAlert];
////    
////    action = [UIAlertAction actionWithTitle:@"OK"
////                                      style:UIAlertActionStyleDefault
////                                    handler:^(UIAlertAction * action)
////              {
////                  [alert dismissViewControllerAnimated:YES completion:nil];
////                  
////              }];
////    
////    [alert addAction:action];
////    [self presentViewController:alert animated:YES completion:nil];
//    
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if(textField.tag == 0)
        [textField resignFirstResponder];
    else
        [self didPressLogIn:self];
    
    return YES;
}
@end





























