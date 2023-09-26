//
//  ViewController.m
//  Twinship
//
//  Created by Dipin Krishna on 24/11/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import "ViewController.h"
#import "Starter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidAppear:(BOOL)animated {
    NSInteger loggedin = 0;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    loggedin = [prefs integerForKey:@"loggedin"];
    
    NSLog(@"login: %ld", (long)loggedin);
    
    if (loggedin) {
        NSInteger profile = [prefs integerForKey:@"profile"];
        if (profile) {
            NSInteger twinid = [prefs integerForKey:@"twinid"];
            if (twinid) {
                [self performSegueWithIdentifier:@"tochat" sender:self];
            } else {
                NSInteger pending_request = [prefs integerForKey:@"pending_request"];
                if (pending_request) {
                    if ([self checkTwinStatus]) {
                        [self performSegueWithIdentifier:@"tochat" sender:self];
                    } else {
                        [self performSegueWithIdentifier:@"starter_to_twin_request" sender:self];
                    }
                } else {
                    NSInteger invite_email_send = [prefs integerForKey:@"invite_email_send"];
                    if (invite_email_send) {
                        if ([self checkTwinStatus]) {
                            [self performSegueWithIdentifier:@"tochat" sender:self];
                        } else {
                            [self performSegueWithIdentifier:@"starter_to_twin_status" sender:self];
                        }
                    } else {
                        [self performSegueWithIdentifier:@"starter_to_invite" sender:self];
                    }
                }
            }
        } else {
            [self performSegueWithIdentifier:@"goto_profile" sender:self];
        }
        
    } else {
        [self performSegueWithIdentifier:@"tostarter" sender:self];
    }
}

- (int) checkTwinStatus {
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
