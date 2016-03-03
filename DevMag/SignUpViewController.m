//
//  SignUpViewController.m
//  DevMag
//
//  Created by Alexandru Antonica on 2/13/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController (){
    UIDatePicker *datePicker;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *cancelButton;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set Delegates
    [self.usernameFieldText  setDelegate:self];
    [self.emailTextField     setDelegate:self];
    [self.firstNameTextField setDelegate:self];
    [self.lastNameTextField  setDelegate:self];
    [self.birthDateTexField  setDelegate:self];
    
    //Dismissing keypad
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    //Date picker options and initialization
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self
                   action:@selector(datePickerValueChanged:)
         forControlEvents:UIControlEventValueChanged];
    [self.birthDateTexField setInputView:datePicker];
    
    
    //Ne inregistram pentru aparitia/disparitia keyboardului
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAction:(id)sender {
    
    if ([self allCompleted]) {
        NSString *username  = self.usernameFieldText.text;
        NSString *firstName = self.firstNameTextField.text;
        NSString *lastName  = self.lastNameTextField.text;
        NSString *email     = self.emailTextField.text;
        NSString *birtDate  = self.birthDateTexField.text;
        NSString *password  = self.passTextField.text;
        
        
        // Check to see if username in database
        // Create a reference to a Firebase database URL
        Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://glowing-heat-3558.firebaseio.com/users/"];
        
        [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            NSDictionary *possibleUsers = snapshot.value;
            NSDictionary *valuesOfUser = [possibleUsers valueForKey:username];
            
            if (valuesOfUser != nil) {
                NSLog(@"%@",valuesOfUser);
                NSLog(@"Userul exista deja - SingUP");
                [self.userNameErrorLabel setHidden:NO];
                self.userNameErrorLabel.text = @"Username already exists!";
            }else{
                
                NSDictionary *alanisawesome = @{
                                                @"last_name" : lastName,
                                                @"date_of_birth": birtDate,
                                                @"first_name" : firstName,
                                                @"email":email,
                                                @"password" : password
                                                };
                NSMutableDictionary *user;
                if([possibleUsers isEqual:[NSNull null]])
                    user = [[NSMutableDictionary alloc] init];
                else
                    user = [[NSMutableDictionary alloc] initWithDictionary:possibleUsers];
                
                
                [user setObject:alanisawesome forKey:username];
                
                
                [myRootRef setValue:user withCompletionBlock:^(NSError *error, Firebase *ref) {
                    if (error != nil) {
                        NSLog(@"ERROR: Scrierea in baza de date nu a fost realizata");
                    }else{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
                
            }
        }];
    }
}

- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)datePickerValueChanged:(id)sender{
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSString *dateString;
    
    dateString = [NSDateFormatter localizedStringFromDate:[picker date]
                                                dateStyle:NSDateFormatterMediumStyle
                                                timeStyle:NSDateFormatterNoStyle];
    
    [_birthDateTexField setText:dateString];
    
}

- (BOOL) allCompleted{
    
    BOOL completed = YES;
    [self.userNameErrorLabel setHidden:YES];
    [self.emailErrorLabel setHidden:YES];
    [self.passErrorLabel setHidden:YES];
    
    
    
    if ([self.usernameFieldText.text isEqualToString:@""]) {
        completed = NO;
        [self.userNameErrorLabel setHidden:NO];
        self.userNameErrorLabel.text = @"Username is mandatory!";
    }
    
    if ([self.emailTextField.text isEqualToString:@""]) {
        completed = NO;
        [self.emailErrorLabel setHidden:NO];
        self.emailErrorLabel.text = @"Email is mandatory!";
    }
    
    if ([self.firstNameTextField.text isEqualToString:@""]) {
        completed = NO;
    }
    
    if ([self.lastNameTextField.text isEqualToString:@""]) {
        completed = NO;
    }
    
    if ([self.passTextField.text isEqualToString:@""]) {
        completed = NO;
        [self.passErrorLabel setHidden:NO];
        self.passErrorLabel.text = @"Password is mandatory!";
    }
    
    return completed;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.birthDateTexField) {
        //Ne inregistram pentru aparitia/disparitia keyboardului
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %f", keyboardFrame.size.height);
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-keyboardFrame.size.height-20,self.view.bounds.size.width,20)];

   // UIToolbar *toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    toolbar.barTintColor = [UIColor redColor];
    
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerActionButton:)];
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datePickerActionButton:)];
    
    
//    [toolbar setItems:[NSArray arrayWithObjects:doneButton,cancelButton, nil]];
//    [datePicker addSubview:toolbar];
//    [self.view addSubview:toolbar];
    
    self.bottomConstraintScrollView.constant = keyboardFrame.size.height+20;

}

- (void)keyboardDidHide:(id)sender{
    
    self.bottomConstraintScrollView.constant = 0;

}

- (void) datePickerActionButton:(UIBarButtonItem*)button{
    if (button == doneButton) {
        NSLog(@"Done");
    }else{
        NSLog(@"Cancel");
    }
}

@end
