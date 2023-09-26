//
//  TwinInvite.m
//  Twinship
//
//  Created by Dipin Krishna on 01/12/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import "TwinInvite.h"

@interface TwinInvite ()

@end

@implementation TwinInvite

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)inviteClicked:(id)sender {
    NSInteger success = 0;
    @try {
        
        if([[self.txtEmail text] isEqualToString:@""] || [[self.txtName text] isEqualToString:@""] ) {
            
            [self alertStatus:@"Please enter Twin's Name and Email" :@"Invite Failed!" :0];
            
        } else if( ![self IsValidEmail:[self.txtEmail text]] ) {
            
            [self alertStatus:@"Please enter a valid Email" :@"Invite Failed!" :0];
            
        } else {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *email = [prefs stringForKey:@"email"];
            NSString *key = [prefs stringForKey:@"login_key"];
            NSString *tw_email = [self.txtEmail text];
            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@&tw_email=%@&tw_name=%@",email,key,tw_email,[self.txtName text]];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/invite_twin.php"];
            
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
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    [prefs setInteger:1 forKey:@"invite_email_send"];
                    [prefs setObject:tw_email forKey:@"twin_email"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"message"];
                    [self alertStatus:error_msg :@"Invite Failed!" :0];
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Invite Failed!" :0];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Invite Failed." :@"Error!" :0];
    }
    if (success) {
        [self performSegueWithIdentifier:@"goto_twinstatus" sender:self];
    }
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


-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    if(theTextField==self.txtName){
        [self.txtEmail becomeFirstResponder];
    }
    return TRUE;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-120, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    return  TRUE;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+120, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    return  TRUE;
    
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

-(BOOL) IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
