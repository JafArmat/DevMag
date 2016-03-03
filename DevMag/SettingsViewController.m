//
//  SecondViewController.m
//  DevMag
//
//  Created by Alexandru Antonica on 12/17/15.
//  Copyright © 2015 Alexandru Antonica. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
@import UIKit;

static NSString *kIsLoggedIn = @"isLogged";
static NSString *kBarTintColor = @"kBarTintColor";
static NSString *kTintColor = @"kTintColor";
static NSString *kStatusBarStyle = @"kStatusBarStyle";


@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //If SignOut is selected
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        //Logged din user defaults
        NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
        [userDefs setBool:NO forKey:kIsLoggedIn];
        
        //Return to log in view
        AppDelegate *delegateApp = [[UIApplication sharedApplication] delegate];
        [delegateApp.window setRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginPage"]];
        
    }
}

- (IBAction)changeTheme:(UISegmentedControl *)sender {
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    if (selectedSegment == 1) { // If Dark
        [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
        [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
        //Save colors
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor redColor]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:kTintColor];
        
        colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor blackColor]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:kBarTintColor];
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kStatusBarStyle];
        
    }
    else{   //If Light
        [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
        [self.tabBarController.tabBar setBarTintColor:[UIColor whiteColor]];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
        //Save colors
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:kTintColor];
        
        colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor whiteColor]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:kBarTintColor];
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kStatusBarStyle];
    }
    
    
    
    
}

@end
