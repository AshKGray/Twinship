//
//  SignUp.h
//  Twinship
//
//  Created by Dipin Krishna on 25/11/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUp : UIViewController {
    
}

// Properties
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtCPassword;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;

// Actions
- (IBAction)signupClicked:(id)sender;


-(BOOL) IsValidEmail:(NSString *)checkString;
@end
