//
//  SignUp.m
//  Twinship
//
//  Created by Dipin Krishna on 25/11/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import "SignUp.h"

@interface SignUp ()

@end

@implementation SignUp

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

- (IBAction)signupClicked:(id)sender {
    NSInteger success = 0;
    @try {
        
        if([[self.txtName text] isEqualToString:@""] || [[self.txtEmail text] isEqualToString:@""] || [[self.txtPassword text] isEqualToString:@""] ) {
            
            [self alertStatus:@"Please enter Name, Email and Password" :@"Sign up Failed!" :0];
            
        } else if( ![self IsValidEmail:[self.txtEmail text]] ) {
            [self alertStatus:@"Please enter a valid Email" :@"Sign up Failed!" :0];
        } else if([[self.txtPassword text] isEqualToString:[self.txtCPassword text]]) {

            NSString *email = [self.txtEmail text];
            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&password=%@&c_password=%@&name=%@",email,[self.txtPassword text], [self.txtCPassword text],[self.txtName text]];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/signup.php"];
            
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
                    success = 0;
                    NSLog(@"Signup SUCCESS");
                    
                    success = [jsonData[@"login"] integerValue];
                    if (success) {
                        NSString *key = (NSString *) jsonData[@"key"];
                        
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        // Save the email and login key
                        [prefs setObject:key forKey:@"login_key"];
                        [prefs setObject:email forKey:@"email"];
                        [prefs setInteger:1 forKey:@"loggedin"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                         NSLog(@"loggedin SUCCESS");
                    } else {
                        [self alertStatus:@"Signed up Successfully." :@"Success!" :101];
                    }
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"message"];
                    [self alertStatus:error_msg :@"Sign up Failed!" :0];
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Sign up Failed!" :0];
            }
        } else {
            [self alertStatus:@"Passwords doesn't match." :@"Sign up Failed!" :0];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Signup Failed." :@"Error!" :0];
    }
    if (success) {
        [self performSegueWithIdentifier:@"signup_success" sender:self];
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
    } else if(theTextField==self.txtEmail){
        [self.txtPassword becomeFirstResponder];
    } else if(theTextField==self.txtPassword){
        [self.txtCPassword becomeFirstResponder];
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
        [self performSegueWithIdentifier:@"goto_signin" sender:self];
    }
}

@end
