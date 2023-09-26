//
//  Twinspirational.h
//  Twinship
//
//  Created by Dipin Krishna on 24/03/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IMAGE_WIDTH 100
#define IMAGE_HEIGHT 100
#define START_POSITION_X 5
#define START_POSITION_Y 10
#define MARGING 5
#define IMAGES_IN_ROW 3

@interface Twinspirational : UIViewController<QBActionStatusDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate> {
    NSArray *files;
    
    int currentImageX;
    int currentImageY;
    int picturesInRowCounter;
    
    NSMutableArray* imageViews;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)refreshGallery:(id)sender;

- (IBAction)showMenu:(id)sender;
@end
