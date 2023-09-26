//
//  Profile.m
//  Twinship
//
//  Created by Dipin Krishna on 28/11/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import "Profile.h"

@interface Profile ()

@end

@implementation Profile

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
    
    sexes = [[NSArray alloc] initWithObjects:@"",@"Male", @"Female", nil];
    tw_types = [[NSArray alloc] initWithObjects:@"",@"Identical", @"Fraternal", nil];
    gender = 0;
    twin_type = 0;
    dob = @"";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextClicked:(id)sender {
    NSInteger success = 0;
    int pending_request = 0;
    @try {
        
        NSLog(@"gender: %d",gender);
        if (!gender) {
            [self alertStatus:@"Please select your gender." :@"Profile Update Failed!" :0];
        } else if (!twin_type) {
            [self alertStatus:@"Please select the twin type." :@"Profile Update Failed!" :0];
        } else if ([dob isEqualToString:@""]) {
            [self alertStatus:@"Please enter your date of birth" :@"Profile Update Failed!" :0];
        } else {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *email = [prefs stringForKey:@"email"];
            NSString *key = [prefs stringForKey:@"login_key"];
            NSString *picString;
            if (profilePicData) {
                picString = [profilePicData base64EncodedStringWithOptions:0];
            }
            
            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&key=%@&sex=%d&type=%d&dob=%@&photo=%@",email,key,gender,twin_type,dob,picString];
            //NSLog(@"PostData: %@",post);
            
            
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
                    [self alertStatus:error_msg :@"Profile Update Failed!" :0];
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Profile Update Failed!" :0];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
    if (success) {
        if (pending_request) {
            [self performSegueWithIdentifier:@"goto_twin_request" sender:self];
        } else {
            [self performSegueWithIdentifier:@"profile_to_invite" sender:self];
        }
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
    if (textField == self.txtSex || textField == self.txtType) {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        [picker setBackgroundColor:[UIColor orangeColor]];
        [picker setDataSource: (id)self];
        [picker setDelegate: self];
        picker.showsSelectionIndicator = YES;
        
        if (textField == self.txtSex) {
            picker_values = [sexes mutableCopy];
        } else {
            [picker setBackgroundColor:[UIColor redColor]];
            picker_values = [tw_types mutableCopy];
        }
        textField.inputView = picker;
    } else if (textField == self.txtDOB) {
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
        [self alertStatus:@"Camera not available." :@"Error!" :0 ];
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

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.profilePic setImage:image];
    profilePicData = UIImageJPEGRepresentation(image, 0.5);
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
