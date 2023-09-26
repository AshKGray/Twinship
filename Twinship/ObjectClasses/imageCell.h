//
//  ImageCell.h
//  Twinship
//
//  Created by Dipin Krishna on 18/04/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ImageCell : UICollectionViewCell


@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSString *fileName;
@end
