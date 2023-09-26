//
//  PhotoController.m
//  SimpleSample-Content
//
//  Created by kirill on 7/17/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

-(id)initWithImage:(UIImage*)imageToDisplay{
    self = [super init];
    if (self) {
        
        // Show full screen image
        UIImageView* photoDisplayer = [[UIImageView alloc] init];
        if(IS_HEIGHT_GTE_568){
            [photoDisplayer setFrame:CGRectMake(0, 0, 320, 568)];
        }else{
            [photoDisplayer setFrame:CGRectMake(0, 0, 320, 480)];
        }
        
        photoDisplayer.opaque = NO;
        photoDisplayer.contentMode = UIViewContentModeScaleAspectFit;
        [photoDisplayer setImage:imageToDisplay];
        [self.view addSubview:photoDisplayer];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(closeView:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Close" forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.frame = CGRectMake(0.0, 10, 300.0, 40.0);
        [self.view addSubview:button];
    }
    return self;
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
