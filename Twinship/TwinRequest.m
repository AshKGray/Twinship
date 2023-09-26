//
//  TwinRequest.m
//  Twinship
//
//  Created by Dipin Krishna on 11/12/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import "TwinRequest.h"

@interface TwinRequest ()

@end

@implementation TwinRequest

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
	// Do any additional setup after loading the view.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    twin_email = [prefs objectForKey:@"twin_email"];
    twin_name = [prefs objectForKey:@"twin_name"];
    [self.twinName setText:twin_name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)acceptClicked:(id)sender {
    NSInteger success = 0;
    @try {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *email = [prefs stringForKey:@"email"];
        NSString *key = [prefs stringForKey:@"login_key"];
        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@&tw_email=%@&tw_name=%@",email,key,twin_email,twin_name];
        NSLog(@"PostData: %@",post);
        
        NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/accpet_invitation.php"];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %ld", (long)[response statusCode]);
        if ([response statusCode] >= 200 && [response statusCode] < 300)
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            
            NSError *error = nil;
            NSDictionary *jsonData = [NSJSONSerialization
                                      JSONObjectWithData:urlData
                                      options:NSJSONReadingMutableContainers
                                      error:&error];
            
            NSLog(@"%@",jsonData);
            success = [jsonData[@"success"] integerValue];
            NSLog(@"%ld",(long)success);
            
            if(success == 1)
            {
                NSInteger twinid = [jsonData[@"success"] integerValue];
                NSLog(@"Pairing SUCCESS");
                if (twinid) {
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    [prefs setInteger:twinid forKey:@"twinid"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            } else {
                
                NSString *error_msg = (NSString *) jsonData[@"message"];
                [self alertStatus:error_msg :@"Pairing Failed!" :0];
            }
            
        } else {
            //if (error) NSLog(@"Error: %@", error);
            [self alertStatus:@"Connection Failed" :@"Invite Failed!" :0];
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Unknown Error." :@"Pairing Failed!" :0];
    }
    if (success) {
        NSLog(@"Got to chat");
        [self performSegueWithIdentifier:@"accept_request" sender:self];
    }
}

- (IBAction)declineClicked:(id)sender {
}


- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    
    [alertView show];
}

@end
