//
//  Settings.h
//  Twinship
//
//  Created by Dipin Krishna on 24/03/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTextField.h"

@interface Settings : UIViewController <QBChatDelegate,QBActionStatusDelegate, UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSArray *sexes;
    NSArray *tw_types;
    NSArray *picker_values;
    TWTextField *picker_selected;
    UIDatePicker *DOBPicker;
    NSInteger gender;
    NSInteger twin_type;
    NSString *dob;
    NSString *genders;
    NSData *profilePicData;
    NSInteger chatSoundOff;
    NSInteger callSoundOff;
}

- (IBAction)showMenu:(id)sender;

@property (weak, nonatomic) IBOutlet TWTextField *txtSex;
@property (weak, nonatomic) IBOutlet TWTextField *txtType;
@property (weak, nonatomic) IBOutlet TWTextField *txtDOB;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *twinTypeBar;
@property (weak, nonatomic) IBOutlet UISwitch *chatSound;
@property (weak, nonatomic) IBOutlet UISwitch *callSound;


- (IBAction)nextClicked:(id)sender;
- (IBAction)genderSelected:(id)sender;
- (IBAction)typeSelected:(id)sender;
- (IBAction)takePicture:(id) sender;
- (IBAction)browsePicture:(id)sender;
- (IBAction)chatSoundChanged:(id)sender;
- (IBAction)callSoundChanged:(id)sender;
- (IBAction)unPair:(id)sender;

@end
