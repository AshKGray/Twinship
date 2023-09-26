//
//  TwinRequest.h
//  Twinship
//
//  Created by Dipin Krishna on 11/12/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwinRequest : UIViewController {
    NSString *twin_email;
    NSString *twin_name;
}

@property (weak, nonatomic) IBOutlet UILabel *twinName;

- (IBAction)acceptClicked:(id)sender;
- (IBAction)declineClicked:(id)sender;


@end
