//
//  TwinInvite.h
//  Twinship
//
//  Created by Dipin Krishna on 01/12/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTextField.h"

@interface TwinInvite : UIViewController {
    
}

@property (weak, nonatomic) IBOutlet TWTextField *txtName;
@property (weak, nonatomic) IBOutlet TWTextField *txtEmail;

- (IBAction)inviteClicked:(id)sender;


@end
