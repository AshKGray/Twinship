//
//  SignIn.m
//  Twinship
//
//  Created by Dipin Krishna on 25/11/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import "SignIn.h"

@interface SignIn ()

@end

@implementation SignIn

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
    
    // If the view is still loaded, remove it.
    if ([self isViewLoaded] && self.view.window == nil) {
        NSLog(@"UNLOADING");
        self.view = nil;
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)signinClicked:(id)sender {
    NSInteger success = 0;
    @try {
        
        if([[self.txtEmail text] isEqualToString:@""] || [[self.txtPassword text] isEqualToString:@""] ) {
            
            [self alertStatus:@"Please enter Email and Password" :@"Sign in Failed!" :0];
            
        } else if( ![self IsValidEmail:[self.txtEmail text]] ) {
            
            [self alertStatus:@"Please enter a valid Email" :@"Sign in Failed!" :0];
            
        } else {
            NSString *email = [self.txtEmail text];
            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&password=%@",email,[self.txtPassword text]];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/signin.php"];
            
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
                NSLog(@"success: %ld",(long)success);
                
                if(success == 1)
                {
                    NSLog(@"Login SUCCESS");
                    NSString *key = (NSString *) jsonData[@"key"];
                    NSString *name = (NSString *) jsonData[@"name"];
                    NSString *gender = (NSString *) jsonData[@"gender"];
                    NSString *twin_email = (NSString *) jsonData[@"twin_email"];
                    NSString *dob = (NSString *) jsonData[@"dob"];
                    NSString *twin_type = (NSString *) jsonData[@"twin_type"];
                    NSString *twin_name = (NSString *) jsonData[@"twin_name"];
                    NSInteger profile = [jsonData[@"profile"] integerValue];
                    NSInteger twinid = [jsonData[@"twinid"] integerValue];
                    NSInteger userid = [jsonData[@"userid"] integerValue];
                    NSInteger q_id = [jsonData[@"q_id"] integerValue];
                    NSInteger opponentid = [jsonData[@"opponentid"] integerValue];
                    NSString *twin_gender = (NSString *) jsonData[@"twin_gender"];
                    NSInteger pending_request = [jsonData[@"twin_request"] integerValue];
                    
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    // Save the email and login key
                    [prefs setObject:key forKey:@"login_key"];
                    [prefs setObject:email forKey:@"email"];
                    if (name) {
                        [prefs setObject:name forKey:@"name"];
                    }
                    if (gender) {
                        [prefs setObject:gender forKey:@"gender"];
                    }
                    if (twin_gender) {
                        [prefs setObject:twin_gender forKey:@"twin_gender"];
                    }
                    if (dob) {
                        [prefs setObject:dob forKey:@"dob"];
                    }
                    if ([twin_type isEqualToString:@"I"]) {
                        [prefs setInteger:1 forKey:@"twin_type"];
                    } else {
                        [prefs setInteger:2 forKey:@"twin_type"];
                    }
                    [prefs setInteger:1 forKey:@"loggedin"];
                    if (profile) {
                        [prefs setInteger:1 forKey:@"profile"];
                    }
                    if (userid) {
                        [prefs setInteger:userid forKey:@"userid"];
                    }
                    if (q_id) {
                        [prefs setInteger:q_id forKey:@"q_id"];
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
                    
                    if (pending_request) {
                        [prefs setInteger:1 forKey:@"pending_request"];
                    }
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSLog(@"loggedin SUCCESS");
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"message"];
                    [self alertStatus:error_msg :@"Sign in Failed!" :0];
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
    if (success) {
        
        /*
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSInteger profile = [prefs integerForKey:@"profile"];
        if (profile) {
            [self performSegueWithIdentifier:@"signin_success" sender:self];
        } else {
            [self performSegueWithIdentifier:@"goto_profile" sender:self];
        }*/
        
        [self performSegueWithIdentifier:@"goto_loading" sender:self];
        
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
    if(theTextField==self.txtEmail){
        [self.txtPassword becomeFirstResponder];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        [self performSegueWithIdentifier:@"signin_success" sender:self];
    }
}

@end
