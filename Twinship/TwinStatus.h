//
//  TwinStatus.h
//  Twinship
//
//  Created by Dipin Krishna on 10/12/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface TwinStatus : UIViewController<MFMessageComposeViewControllerDelegate> {
    
}


- (IBAction)inviteAgain:(id)sender;
- (IBAction)sendSms:(id)sender;

@end
