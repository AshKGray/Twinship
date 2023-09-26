//
//  Profile.h
//  Twinship
//
//  Created by Dipin Krishna on 28/11/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTextField.h"

@interface Profile : UIViewController<UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    NSArray *sexes;
    NSArray *tw_types;
    NSArray *picker_values;
    TWTextField *picker_selected;
    UIDatePicker *DOBPicker;
    int gender;
    int twin_type;
    NSString *dob;
    NSData *profilePicData;
}


@property (weak, nonatomic) IBOutlet TWTextField *txtSex;
@property (weak, nonatomic) IBOutlet TWTextField *txtType;
@property (weak, nonatomic) IBOutlet TWTextField *txtDOB;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderBar;


- (IBAction)nextClicked:(id)sender;
- (IBAction)genderSelected:(id)sender;
- (IBAction)typeSelected:(id)sender;
- (IBAction)takePicture:(id) sender;
- (IBAction)browsePicture:(id)sender;

@end
