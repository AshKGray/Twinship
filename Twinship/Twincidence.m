//
//  Twincidence.m
//  Twinship
//
//  Created by Dipin Krishna on 24/03/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

#import "Twincidence.h"
#import "Menu.h"

@interface Twincidence ()

@end

@implementation Twincidence

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBarController.moreNavigationController setNavigationBarHidden:YES animated:NO];
    [self.tabBarController.tabBar setHidden:YES];
    // Do any additional setup after loading the view.
}


- (IBAction)showMenu:(id)sender {
    //[self alertStatus:@"Are you sure?" :@"Temp Logout!" :201];
    NSArray *menuItems =
    @[
      
      [MenuItem menuItem:@"Twincidence"
                   image:nil
                  target:nil
                  action:NULL],
      
      [MenuItem menuItem:@"Chat"
                   image:[UIImage imageNamed:@"reload"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Twinstinct"
                   image:[UIImage imageNamed:@"img_t"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Twinspirational Moments"
                   image:[UIImage imageNamed:@"img_m"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Twinterests"
                   image:[UIImage imageNamed:@"img_in"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Plans and Events"
                   image:[UIImage imageNamed:@"img_pe"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Settings"
                   image:[UIImage imageNamed:@"img_s"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      ];
    
    MenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [Menu showMenuInView:self.view
                fromRect:((UIButton*)sender).frame
               menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", ((MenuItem*)sender).title);
    NSString *title = ((MenuItem*)sender).title;
    if ([title isEqualToString: @"Twinstinct"]) {
        self.tabBarController.selectedIndex = 1;
    } else if ([title isEqualToString: @"Twinspirational Moments"]) {
        self.tabBarController.selectedIndex = 2;
    } else if ([title isEqualToString: @"Twincidence"]) {
        self.tabBarController.selectedIndex = 3;
    } else if ([title isEqualToString: @"Twinterests"]) {
        self.tabBarController.selectedIndex = 4;
    } else if ([title isEqualToString: @"Plans and Events"]) {
        self.tabBarController.selectedIndex = 5;
    } else if ([title isEqualToString: @"Settings"]) {
        self.tabBarController.selectedIndex = 6;
    } else if ([title isEqualToString: @"Chat"]) {
        self.tabBarController.selectedIndex = 0;
    }
}


- (IBAction)logOut:(id)sender {
    [self alertStatus:@"Are you sure?" :@"Logout!" :201];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
    alertView.tag = tag;
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 201)     // check alert by tag
    {
        
        if (buttonIndex == 0)
            
        {
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            [self performSegueWithIdentifier:@"chat_logout" sender:self];
        }
        
        else
            
        {
            NSLog(@"cancel");
        }
    } else {
    }
}

@end