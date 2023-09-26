//
//  SignIn.h
//  Twinship
//
//  Created by Dipin Krishna on 25/11/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignIn : UIViewController {
    
}


@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;


- (IBAction)signinClicked:(id)sender;


@end
