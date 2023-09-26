//
//  Settings.m
//  Twinship
//
//  Created by Dipin Krishna on 24/03/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

#import "Settings.h"
#import "Menu.h"

@interface Settings ()

@end

@implementation Settings

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
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    twin_type = 0;
    twin_type = [prefs integerForKey:@"twin_type"];
    chatSoundOff = [prefs integerForKey:@"chatSoundOff"];
    callSoundOff = [prefs integerForKey:@"callSoundOff"];
    
    genders = [prefs objectForKey:@"gender"];
    
    NSLog(@"genders: %@", genders);
    
    if ([genders isEqualToString:@"F"]) {
        gender = 2;
    } else {
        gender = 1;
    }
    
    dob = [prefs objectForKey:@"dob"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *temp_date = [dateFormatter dateFromString:dob];
    [dateFormatter setDateFormat:@"MMM d, YYYY"];
    self.txtDOB.text =[dateFormatter stringFromDate:temp_date];
    
    NSLog(@"DOB: %@", dob);
    
    [self.genderBar setSelectedSegmentIndex:(gender - 1) ];
    [self.twinTypeBar setSelectedSegmentIndex:(twin_type - 1)];
    if (chatSoundOff) {
        [self.chatSound setOn:0];
    }
    if (callSoundOff) {
        [self.callSound setOn:0];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}


- (IBAction)showMenu:(id)sender {
    //[self alertStatus:@"Are you sure?" :@"Temp Logout!" :201];
    NSArray *menuItems =
    @[
      
      [MenuItem menuItem:@"Settings"
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
    [self alertStatus:@"Are you sure?" :@"Logout!" :201 :1];
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
            [QBMessages TUnregisterSubscriptionWithDelegate:self];
            [[QBChat instance] logout];
            [QBUsers logOutWithDelegate:self];
            //[QBAuth destroySessionWithDelegate:self];
            
            [self performSegueWithIdentifier:@"chat_logout" sender:self];
        }
        
        else
            
        {
            NSLog(@"cancel");
        }
    } else if(alertView.tag == 202) {
        if (buttonIndex == 0)
            
        {
            if ([self unpairConfirmed]) {
                NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
                
                [[QBChat instance] logout];
                [QBUsers logOutWithDelegate:self];
                //[QBAuth destroySessionWithDelegate:self];
                
                [self performSegueWithIdentifier:@"chat_logout" sender:self];
            }
        }
        
        else
            
        {
            NSLog(@"cancel");
        }
    }
}

- (IBAction)nextClicked:(id)sender {
    NSInteger success = 0;
    int pending_request = 0;
    @try {
        
        if (!gender) {
            [self alertStatus:@"Please select your gender." :@"Profile Update Failed!" :0 :0];
        } else if (!twin_type) {
            [self alertStatus:@"Please select the twin type." :@"Profile Update Failed!" :0 :0];
        } else if ([dob isEqualToString:@""]) {
            [self alertStatus:@"Please enter your date of birth" :@"Profile Update Failed!" :0 :0];
        } else {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *email = [prefs stringForKey:@"email"];
            NSString *key = [prefs stringForKey:@"login_key"];
            NSString *picString;
            if (profilePicData) {
                picString = [profilePicData base64EncodedStringWithOptions:0];
            }
            
            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@&sex=%ld&type=%ld&dob=%@&photo=%@",email,key,(long)gender,(long)twin_type,dob,picString];
            NSLog(@"PostData: %@",post);
            
            
            NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/update_profile.php"];
            
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
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    [prefs setInteger:1 forKey:@"profile"];
                    NSLog(@"profile SUCCESS");
                    
                    NSString *twin_email = (NSString *) jsonData[@"twin_email"];
                    if (twin_email.length > 0) {
                        pending_request = 1;
                        [prefs setInteger:1 forKey:@"pending_request"];
                        NSString *twin_name = (NSString *) jsonData[@"twin_name"];
                        [prefs setObject:twin_email forKey:@"twin_email"];
                        [prefs setObject:twin_name forKey:@"twin_name"];
                    }
                    
                    [prefs setInteger:twin_type forKey:@"twin_type"];
                    if (gender == 1) {
                        [prefs setObject:@"M" forKey:@"gender"];
                    } else {
                        [prefs setObject:@"F" forKey:@"gender"];
                    }
                    
                    [prefs setObject:dob forKey:@"dob"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"message"];
                    [self alertStatus:error_msg :@"Profile Update Failed!" :0 :0];
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Profile Update Failed!" :0 :0];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0 :0];
    }
    if (success) {
        [self alertStatus:@"Profile Updated." :@"Success!" :0 :0];
    }
}

- (IBAction)genderSelected:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    NSLog(@"selectedSegment: %ld", (long)selectedSegment);
    if (selectedSegment == 0) {
        gender = 1;
    }
    else{
        gender = 2;
    }
}

- (IBAction)typeSelected:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        twin_type = 1;
    }
    else{
        twin_type = 2;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    if(theTextField==self.txtSex){
        [self.txtType becomeFirstResponder];
    } else if(theTextField==self.txtType){
        [self.txtDOB becomeFirstResponder];
    }
    return TRUE;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    if (textField == self.txtDOB) {
        DOBPicker = [[UIDatePicker alloc] init];
        DOBPicker.datePickerMode = UIDatePickerModeDate;
        NSDate * currentDate = [NSDate date];
        DOBPicker.maximumDate = currentDate;
        NSDateComponents * comps = [[NSDateComponents alloc] init];
        [comps setYear: -100];
        NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        NSDate *minDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
        DOBPicker.minimumDate = minDate;
        [DOBPicker setBackgroundColor:[UIColor orangeColor]];
        [DOBPicker addTarget:self action:@selector(incidentDateValueChanged:) forControlEvents:UIControlEventValueChanged];
        textField.inputView = DOBPicker;
    }
    textField.inputAccessoryView = keyboardDoneButtonView;
    picker_selected = (TWTextField *) textField;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-120, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    return  TRUE;
}

- (void)doneClicked:(id)sender {
    // Write out the date...
    [picker_selected resignFirstResponder];
}

- (IBAction) incidentDateValueChanged:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, YYYY"];
    self.txtDOB.text = [dateFormatter stringFromDate:[DOBPicker date]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    dob = [dateFormatter stringFromDate:[DOBPicker date]];
    NSLog(@"DOB: %@",[dateFormatter stringFromDate:[DOBPicker date]]);
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [picker_values count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [picker_selected setText:[picker_values objectAtIndex:row]];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [picker_values objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    static NSString *cellIdentifier = @"pickerViewCell";
    UITableViewCell *cell = (UITableViewCell*)view;
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        /** customize the cell **/
    }
    
    /** set the label **/
    if (row == 0) {
        cell.textLabel.text = @"Please Select";
    } else {
        cell.textLabel.text = [picker_values objectAtIndex:row];
    }
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [self alertStatus:@"Camera not available." :@"Error!" :0  :0];
    }
    
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)browsePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)chatSoundChanged:(id)sender {
    UISwitch *soundSwitch = (UISwitch *) sender;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (soundSwitch.on) {
        [prefs setInteger:0 forKey:@"chatSoundOff"];
    } else {
        [prefs setInteger:1 forKey:@"chatSoundOff"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)callSoundChanged:(id)sender {
    UISwitch *soundSwitch = (UISwitch *) sender;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (soundSwitch.on) {
        [prefs setInteger:0 forKey:@"callSoundOff"];
    } else {
        [prefs setInteger:1 forKey:@"callSoundOff"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)unPair:(id)sender {
    [self alertStatus:@"Are you sure?" :@"UNPAIR!" :202 :1];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.profilePic setImage:image];
    profilePicData = UIImageJPEGRepresentation(image, 0.5);
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (int)unpairConfirmed {
    NSInteger success = 0;
    @try {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *email = [prefs stringForKey:@"email"];
        NSString *key = [prefs stringForKey:@"login_key"];
        
        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@",email,key];
        //NSLog(@"PostData: %@",post);
        
        
        NSURL *url=[NSURL URLWithString:@"http://twinship.net/api/unpair_twin.php"];
        
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
                NSLog(@"Unpair SUCCESS");
            } else {
                
                NSString *error_msg = (NSString *) jsonData[@"message"];
                [self alertStatus:error_msg :@"Unpair Failed!" :0 :0];
            }
            
        } else {
            //if (error) NSLog(@"Error: %@", error);
            [self alertStatus:@"Connection Failed" :@"Unpair Failed!" :0 :0];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Unpair Failed." :@"Error!" :0 :0];
    }
    return (int)success;
}


@end