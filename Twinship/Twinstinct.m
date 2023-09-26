//
//  Twinstinct.m
//  Twinship
//
//  Created by Dipin Krishna on 24/03/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

#import "Twinstinct.h"
#import "Menu.h"

@interface Twinstinct ()

@end

@implementation Twinstinct

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
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    [self.tabBarController.moreNavigationController setNavigationBarHidden:YES animated:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    gender = [prefs stringForKey:@"gender"];
    email  = [prefs stringForKey:@"email"];
    key    = [prefs stringForKey:@"login_key"];
    opponentID = [prefs integerForKey:@"opponentID"];
    // Do any additional setup after loading the view.
    self.progressView.trackTintColor = [UIColor clearColor];
    if ([gender isEqualToString:@"M"]) {
        self.progressView.progressTintColor = [UIColor cyanColor];
    } else {
        self.progressView.progressTintColor = [UIColor magentaColor];
    }
    self.progressView.thicknessRatio = 1.0f;
    self.progressView.clockwiseProgress = YES;
    
}


- (IBAction)showMenu:(id)sender {
    //[self alertStatus:@"Are you sure?" :@"Temp Logout!" :201];
    NSArray *menuItems =
    @[
      
      [MenuItem menuItem:@"Twinstinct"
                   image:nil
                  target:nil
                  action:NULL],
      
      [MenuItem menuItem:@"Chat"
                   image:[UIImage imageNamed:@"reload"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Twinspirational Moments"
                   image:[UIImage imageNamed:@"img_m"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Twincidence"
                   image:[UIImage imageNamed:@"img_i"]
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


- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag :(int) confirm
{
    
    UIAlertView *alertView;
    
    if (confirm) {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:msg
                                              delegate:self
                                     cancelButtonTitle:@"Yes"
                                     otherButtonTitles:@"No", nil];
    } else {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:msg
                                              delegate:self
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil];
    }
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


-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return TRUE;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-200, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    return  TRUE;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+200, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    return  TRUE;
    
}

#define MAXLENGTH 2

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH || returnKey;
}


-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


- (IBAction)endGame:(id)sender {
    [timer invalidate];
    timer = nil;
    NSInteger success = 0;
    
    [NSThread detachNewThreadSelector: @selector(startAnimation) toTarget:self withObject:NULL];
    
    @try {
        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@&gameid=%ld",email,key,(long)gameid];
        NSLog(@"PostData: %@",post);
        
        NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/randomNumber/timedOut.php"];
        
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
            
            [self.endGame setHidden:YES];
            [self.progressView setHidden:YES];
            [self.progressView setProgress:0.0f animated:YES];
            [self.randTxt setHidden:YES];
            [self.startBtn setHidden:NO];
            
        } else {
            //if (error) NSLog(@"Error: %@", error);
            [self alertStatus:@"Connection Failed" :@"Failed!" :0 :0];
            [self.pleasewait setHidden:YES];
            [self.startBtn setHidden:NO];
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Unknown Error." :@"Failed!" :0 :0];
    }
    
    [NSThread detachNewThreadSelector: @selector(stopAnimation) toTarget:self withObject:NULL];
    
}

- (IBAction)showNumber:(id)sender {
    [self.randTxt setHidden:NO];
    [self.endGame setHidden:NO];
    [self.mentallyFocus setHidden:YES];
    [self.shownumber setHidden:YES];
}

- (IBAction)inputBtnClicked:(id)sender {
    
    if ([self.inputTxt.text length] > 0) {
        
        [self.inputTxt resignFirstResponder];
        [self.inputBtn setEnabled:NO];
        
        [self.randTxt setHidden:YES];
        [self.twinIsThinking setHidden:YES];
        [self.progressView setProgress:0.0f animated:YES];
        [timer invalidate];
        timer = nil;
        
        NSInteger success = 0;
        NSInteger status = 0;
        
        if ([self.inputTxt.text isEqualToString:randomNumber]) {
            [self.match setHidden:NO];
            status = 1;
        } else {
            [self.nomatch setHidden:NO];
            status = 0;
        }
        
        [NSThread detachNewThreadSelector: @selector(startAnimation) toTarget:self withObject:NULL];
        
        @try {
            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@&gameid=%ld&status=%ld",email,key,(long)gameid,(long)status];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/randomNumber/matchMade.php"];
            
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
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Failed!" :0 :0];
                [self.pleasewait setHidden:YES];
                [self.startBtn setHidden:NO];
            }
            
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
            [self alertStatus:@"Unknown Error." :@"Failed!" :0 :0];
        }
        
        [NSThread detachNewThreadSelector: @selector(stopAnimation) toTarget:self withObject:NULL];
        
        [self.inputTxt setHidden:YES];
        [self.inputTxt setText:@""];
        [self.inputBtn setHidden:YES];
        [self.inputBtn setEnabled:YES];
        [self.tryAgain setHidden:NO];
    }
}

- (IBAction)revealClicked:(id)sender {
}

- (IBAction)startClicked:(id)sender {
    gameid = 0;
    existing = 0;
    
    [self.startBtn setHidden:YES];
    [self.pleasewait setHidden:NO];
    NSInteger success = 0;
    
    [NSThread detachNewThreadSelector: @selector(startAnimation) toTarget:self withObject:NULL];
    
    @try {
        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@",email,key];
        NSLog(@"PostData: %@",post);
        
        NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/randomNumber/start.php"];
        
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
            existing = 0;
            randomNumber = 0;
            gameid = 0;
            if(success == 1)
            {
                randomNumber = (NSString *) jsonData[@"value"];
                gameid   = [jsonData[@"gameid"] integerValue];
                existing = [jsonData[@"existing"] integerValue];
                
                [self.pleasewait setHidden:YES];
                [self.randTxt setHidden:NO];
                [self.progressView setHidden:NO];
                
                if (existing) {
                    [self.twinIsThinking setHidden:NO];
                    [self.randTxt setText:@"?"];
                    /*
                     countDown = 1000;
                     progress = 0.0f;
                     //[self.timerTxt setText:[NSString stringWithFormat:@"%d", countDown]];
                     timer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
                     */
                    //[self.endGame setHidden:NO];
                    [self.inputBtn setHidden:NO];
                    [self.inputTxt setHidden:NO];
                } else {
                    [self.randTxt setHidden:YES];
                    [self.randTxt setText:randomNumber];
                    /*
                     [self.wait_twin_join setHidden:NO];
                     countDown = 1800;
                     progress = 0.0f;
                     //[self.timerTxt setText:[NSString stringWithFormat:@"%d", countDown]];
                     timer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target:self selector:@selector(checkTwinStatus) userInfo:nil repeats: YES];
                     
                     //[QBMessages TSendPushWithText:@"Hey, lets test our Twinstinct. Please Join now." toUsers:[NSString stringWithFormat:@"%ld",(long)opponentID] delegate:self];
                     */
                    
                    NSString *mesage = @"Hey, lets test our Twinstinct. Please Join now.";
                    NSMutableDictionary *payload = [NSMutableDictionary dictionary];
                    NSMutableDictionary *aps = [NSMutableDictionary dictionary];
                    [aps setObject:@"default" forKey:QBMPushMessageSoundKey];
                    [aps setObject:@"GAMES" forKey:@"OBJECTKEY"];
                    [aps setObject:mesage forKey:QBMPushMessageAlertKey];
                    [payload setObject:aps forKey:QBMPushMessageApsKey];
                    
                    QBMPushMessage *message = [[QBMPushMessage alloc] initWithPayload:payload];
                    
                    // Send push to users with ids 292,300,1295
                    [QBMessages TSendPush:message toUsers:[NSString stringWithFormat:@"%ld",(long)opponentID] delegate:self];
                    [self.mentallyFocus setHidden:NO];
                    [self.shownumber setHidden:NO];
                    //[self.endGame setHidden:NO];
                    
                    //countDown = 2000;
                    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkTwinResponse) userInfo:nil repeats: YES];
                }
                //[self.timerTxt setHidden:NO];
                
            }
            
        } else {
            //if (error) NSLog(@"Error: %@", error);
            [self alertStatus:@"Connection Failed" :@"Failed!" :0 :0];
            [self.pleasewait setHidden:YES];
            [self.startBtn setHidden:NO];
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Unknown Error." :@"Failed!" :0 :0];
    }
    
    [NSThread detachNewThreadSelector: @selector(stopAnimation) toTarget:self withObject:NULL];
    
}

- (IBAction)tryAgain:(id)sender {
    [self.endGame setHidden:YES];
    [self.tryAgain setHidden:YES];
    [self.randTxt setHidden:YES];
    [self.match setHidden:YES];
    [self.nomatch setHidden:YES];
    [self.startBtn setHidden:NO];
}

-(void) checkTwinStatus
{
    //[self.timerTxt setText:[NSString stringWithFormat:@"%d", countDown]];
    [self.progressView setProgress:progress animated:YES];
    progress+=0.00056f;
    countDown -= 1;
    if (countDown < 0) {
        [timer invalidate];
        timer = nil;
        NSInteger success = 0;
        
        [NSThread detachNewThreadSelector: @selector(startAnimation) toTarget:self withObject:NULL];
        
        @try {
            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@&gameid=%ld",email,key,(long)gameid];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/randomNumber/timedOut.php"];
            
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
                
                [self.progressView setHidden:YES];
                [self.progressView setProgress:0.0f animated:YES];
                [self alertStatus:@"Twin Failed to Join" :@"Time Out!" :0 :0];
                [self.randTxt setHidden:YES];
                [self.startBtn setHidden:NO];
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Failed!" :0 :0];
                [self.pleasewait setHidden:YES];
                [self.startBtn setHidden:NO];
            }
            
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
            [self alertStatus:@"Unknown Error." :@"Failed!" :0 :0];
        }
        
        [NSThread detachNewThreadSelector: @selector(stopAnimation) toTarget:self withObject:NULL];
        
    } else if (countDown % 100 == 0) {
        if (requestInProgress == 0) {
            requestInProgress = 1;
            [NSThread detachNewThreadSelector: @selector(updateTwinStatus) toTarget:self withObject:NULL];
        }
        
    }
}

- (void) updateTwinStatus {
    NSInteger success = 0;
    
    [NSThread detachNewThreadSelector: @selector(startAnimation) toTarget:self withObject:NULL];
    
    @try {
        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@&gameid=%ld",email,key,(long)gameid];
        NSLog(@"PostData: %@",post);
        
        NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/randomNumber/isTwinIn.php"];
        
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
                [timer invalidate];
                timer = nil;
                
                [self.progressView setHidden:YES];
                [self.progressView setProgress:0.0f animated:YES];
                
                [self performSelectorOnMainThread:@selector(twinHasJoined) withObject:nil waitUntilDone:NO];
            }
            
        } else {
            //if (error) NSLog(@"Error: %@", error);
            [self alertStatus:@"Connection Failed" :@"Failed!" :0 :0];
            [self.pleasewait setHidden:YES];
            [self.startBtn setHidden:NO];
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Unknown Error." :@"Failed!" :0 :0];
    }
    
    [NSThread detachNewThreadSelector: @selector(stopAnimation) toTarget:self withObject:NULL];
    
    requestInProgress = 0;
}

-(void) twinHasJoined {
    countDown = 2000;
    progress = 0.0f;
    //[self.timerTxt setText:[NSString stringWithFormat:@"%d", countDown]];
    [self.progressView setHidden:NO];
    timer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target:self selector:@selector(checkTwinResponse) userInfo:nil repeats: YES];
}

-(void) updateCountdown
{
    //[self.timerTxt setText:[NSString stringWithFormat:@"%d", countDown]];
    [self.progressView setProgress:progress animated:YES];
    progress += 0.001f;
    countDown -= 1;
    if (countDown < 0) {
        [timer invalidate];
        timer = nil;
        if (existing) {
            [self.inputTxt setHidden:NO];
            [self.inputBtn setHidden:NO];
            [self performSelectorOnMainThread:@selector(enterResponse) withObject:nil waitUntilDone:NO];
        }
    }
}

-(void) enterResponse {
    countDown = 600;
    progress = 0.0f;
    //[self.timerTxt setText:[NSString stringWithFormat:@"%d", countDown]];
    [self.progressView setHidden:NO];
    timer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target:self selector:@selector(inputTimeout) userInfo:nil repeats: YES];
}

-(void) inputTimeout {
    //[self.timerTxt setText:[NSString stringWithFormat:@"%d", countDown]];
    [self.progressView setProgress:progress animated:YES];
    progress += 0.00167f;
    countDown -= 1;
    if (countDown < 0) {
        [timer invalidate];
        timer = nil;
        
        [self.progressView setHidden:YES];
        [self.progressView setProgress:0.0f animated:YES];
        [self alertStatus:@"You Failed to Respond in time." :@"Time Out!" :0 :0];
        [self.inputTxt setText:@""];
        [self.inputTxt setHidden:YES];
        [self.inputBtn setHidden:YES];
        [self.randTxt setText:randomNumber];
        [self.randTxt setHidden:NO];
        [self.tryAgain setHidden:NO];
    }
}

-(void) checkTwinResponse
{
    //[self.timerTxt setText:[NSString stringWithFormat:@"%d", countDown]];
    //[self.progressView setProgress:progress animated:YES];
    //progress += 0.0005f;
    if (requestInProgress == 0) {
        requestInProgress = 1;
        [NSThread detachNewThreadSelector: @selector(getStatus) toTarget:self withObject:NULL];
    }
}

-(void) getStatus {
    NSInteger success = 0;
    
    //[NSThread detachNewThreadSelector: @selector(startAnimation) toTarget:self withObject:NULL];
    
    @try {
        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@&gameid=%ld",email,key,(long)gameid];
        NSLog(@"PostData: %@",post);
        
        NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/randomNumber/status.php"];
        
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
                int status = (int) [jsonData[@"status"] integerValue];
                if (status >= 10) {
                    
                    [timer invalidate];
                    timer = nil;
                    
                    /*
                     [self.progressView setHidden:YES];
                     [self.progressView setProgress:0.0f animated:YES];
                     */
                    [self.randTxt setHidden:YES];
                    [self.mentallyFocus setHidden:YES];
                    [self.twinIsThinking setHidden:YES];
                    [self.shownumber setHidden:YES];
                    
                    if (status == 11) {
                        [self.match setHidden:NO];
                    } else if (status == 10) {
                        [self.nomatch setHidden:NO];
                    }
                    [self.tryAgain setHidden:NO];
                } else if (status == -1) {
                    
                    [timer invalidate];
                    timer = nil;
                    [self.randTxt setHidden:YES];
                    [self.mentallyFocus setHidden:YES];
                    [self.twinIsThinking setHidden:YES];
                    [self.shownumber setHidden:YES];
                    
                    [self.tryAgain setHidden:NO];
                    
                    [self alertStatus:@"Your Twin has end the game" :@"Game Ended!" :0 :0];
                }
            }
            
        } else {
            //if (error) NSLog(@"Error: %@", error);
            [self alertStatus:@"Connection Failed" :@"Failed!" :0 :0];
            [self.pleasewait setHidden:YES];
            [self.startBtn setHidden:NO];
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Unknown Error." :@"Failed!" :0 :0];
    }
    
    //[NSThread detachNewThreadSelector: @selector(stopAnimation) toTarget:self withObject:NULL];
    
    requestInProgress = 0;
}

- (void) startAnimation {
    [self.loading setHidden:NO];
    [self.loading startAnimating];
}

-(void) stopAnimation {
    [self.loading stopAnimating];
    [self.loading setHidden:YES];
}

- (void) hideAllBtns {
    
    [self.startBtn setHidden:YES];
    [self.pleasewait setHidden:YES];
    [self.match setHidden:YES];
    [self.nomatch setHidden:YES];
    [self.inputBtn setHidden:YES];
    [self.tryAgain setHidden:YES];
    [self.endGame setHidden:YES];
    [self.mentallyFocus setHidden:YES];
    [self.twinIsThinking setHidden:YES];
    [self.shownumber setHidden:YES];
    
}

@end