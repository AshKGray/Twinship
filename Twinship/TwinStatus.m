//
//  TwinStatus.m
//  Twinship
//
//  Created by Dipin Krishna on 10/12/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import "TwinStatus.h"

@interface TwinStatus ()

@end

@implementation TwinStatus

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    if ([self twinStatus]) {
        [self performSegueWithIdentifier:@"to_chat" sender:self];
    }
}

- (int) twinStatus {
    NSInteger success = 0;
    @try {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *email = [prefs stringForKey:@"email"];
        NSString *key = [prefs stringForKey:@"login_key"];
        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@",email,key];
        NSLog(@"PostData: %@",post);
        
        NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/check_invite_status.php"];
        
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
                NSString *twin_email = (NSString *) jsonData[@"twin_email"];
                NSString *twin_name = (NSString *) jsonData[@"twin_name"];
                NSInteger twinid = [jsonData[@"twinid"] integerValue];
                NSInteger opponentid = [jsonData[@"opponentid"] integerValue];
                NSString *twin_gender = (NSString *) jsonData[@"twin_gender"];
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                if (twin_gender) {
                    [prefs setObject:twin_gender forKey:@"twin_gender"];
                }
                if (twinid) {
                    [prefs setInteger:twinid forKey:@"twinid"];
                }
                if (opponentid) {
                    [prefs setInteger:opponentid forKey:@"opponentID"];
                }
                if (twin_email.length > 0) {
                    [prefs setInteger:1 forKey:@"invite_email_send"];
                    [prefs setObject:twin_email forKey:@"twin_email"];
                    [prefs setObject:twin_name forKey:@"twin_name"];
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                //[self alertStatus:@"Invitation has been accepted." :@"Invite Twin" :0];
            }
            
        } else {
            //if (error) NSLog(@"Error: %@", error);
            [self alertStatus:@"Connection Failed" :@"Status check Failed!" :0];
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Status check Failed." :@"Error!" :0];
    }
    return (int)success;
}

- (IBAction)inviteAgain:(id)sender {
    NSInteger success = 0;
    @try {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *email = [prefs stringForKey:@"email"];
        NSString *key = [prefs stringForKey:@"login_key"];
        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@",email,key];
        NSLog(@"PostData: %@",post);
        
        NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/invite_twin_again.php"];
        
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
                NSLog(@"Invite Send SUCCESS");
                [self alertStatus:@"Invitation has been send." :@"Invite Twin" :0];
            } else {
                
                NSString *error_msg = (NSString *) jsonData[@"message"];
                [self alertStatus:error_msg :@"Invite Failed!" :0];
            }
            
        } else {
            //if (error) NSLog(@"Error: %@", error);
            [self alertStatus:@"Connection Failed" :@"Invite Failed!" :0];
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Invite Failed." :@"Error!" :0];
    }
}

- (IBAction)sendSms:(id)sender {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *tw_email = [prefs stringForKey:@"twin_email"];
        controller.body = [NSString stringWithFormat:@"I want to connect with you on Twinship. Please download it from http://twinship.net and signup using %@", tw_email];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
            [self alertStatus:@"Unknown Error." :@"Error!" :0];
			break;
		case MessageComposeResultSent:
            [self alertStatus:@"SMS has been send." :@"Invite Twin" :0];
			break;
		default:
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:nil];
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
