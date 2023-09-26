//
//  Twinspirational.m
//  Twinship
//
//  Created by Dipin Krishna on 24/03/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

#import "Twinspirational.h"
#import "Menu.h"
#import "PhotoViewController.h"
#import "ImageCell.h"

@interface Twinspirational ()

@end

@implementation Twinspirational

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentImageX = START_POSITION_X;
        currentImageY = START_POSITION_Y;
        picturesInRowCounter = 0;
        imageViews = [[NSMutableArray alloc] init];
        
        files = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBarController.moreNavigationController setNavigationBarHidden:YES animated:NO];
    [self.tabBarController.tabBar setHidden:YES];
    // Do any additional setup after loading the view.
    
    /*
    PagedRequest *pagedRequest = [[PagedRequest alloc] init];
    [pagedRequest setPerPage:5];
    
    [QBContent blobsWithPagedRequest:pagedRequest delegate:self];
     
     */
    
    files = [self listFiles];
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"ImageCell"];
    /*
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //[flowLayout setItemSize:CGSizeMake(50, 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
     */
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    files = [self listFiles];
    [self.collectionView reloadData];
    
    /*
    if (![[DataManager instance] images]) {
        
        NSLog(@"Download user's files");
        // Download user's files
        [self downloadFile];
        
        [self.activityIndicator startAnimating];
        
        return;
    }*/
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {NSLog(@"numberOfSectionsInCollectionView : %d", [files count] );
    return [files count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = (ImageCell *) [cv dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell =[[ImageCell alloc] init];
    }
    NSLog(@"indexPath: %d", indexPath.item );
    
    //cell.backgroundColor = [UIColor whiteColor];
    
    NSString *filename = [files objectAtIndex:indexPath.item];
    UIImage *image = [self loadImage:filename];
    
    UIImageView *twImageView = (UIImageView *)[cell viewWithTag:100];
    
    if (!twImageView) {
        twImageView = [[UIImageView alloc] init];
        twImageView.frame = cell.bounds;
        [cell addSubview:twImageView];
        twImageView.tag = 100;
    }

    [twImageView setImage:image];
    
    [twImageView setBackgroundColor:[UIColor whiteColor]];
    
    cell.fileName = filename;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = (ImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    UIImageView *twImageView = (UIImageView *)[cell viewWithTag:100];
    PhotoViewController* photoController = [[PhotoViewController alloc] initWithImage:twImageView.image];
    [self presentViewController:photoController animated:YES completion:nil];
}

/*
#pragma mark -
#pragma mark QBActionStatusDelegate

-(void)downloadFile{
    int fileID = [(QBCBlob *)[[[DataManager instance] fileList] lastObject] ID];
    if(fileID > 0){
        NSLog(@"Download file from QuickBlox server");
        // Download file from QuickBlox server
        [QBContent TDownloadFileWithBlobID:fileID delegate:self];
    }
    
    NSLog(@"nd of files");
    // end of files
    if ([[DataManager instance] fileList].count == 0) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
    }
}

// Show image on your gallery
-(void)showImage:(UIImageView*) image{
    image.frame = CGRectMake(currentImageX, currentImageY, IMAGE_WIDTH, IMAGE_HEIGHT);
    image.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullScreenPicture:)];
    [image addGestureRecognizer:tapRecognizer];
    
    [self.galleryView addSubview:image];
    currentImageX += IMAGE_WIDTH;
    currentImageX += MARGING; // distance between two images
    picturesInRowCounter++;
    
    if (picturesInRowCounter == IMAGES_IN_ROW) {
        currentImageX = START_POSITION_X;
        currentImageY += IMAGE_HEIGHT;
        currentImageY += MARGING;
        picturesInRowCounter = 0;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)showFullScreenPicture:(id)sender{
    UITapGestureRecognizer* tapRecognizer = (UITapGestureRecognizer*)sender;
    UIImageView* selectedImageView = (UIImageView*)[tapRecognizer view];
    PhotoViewController* photoController = [[PhotoViewController alloc] initWithImage:selectedImageView.image];
    [self presentViewController:photoController animated:YES completion:nil];
}

// Show Picker for select picture from iPhone gallery to add to your gallery
-(void)selectPicture{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:self.imagePicker animated:NO completion:nil];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result *)result{
    
    // Download file result
    if ([result isKindOfClass:QBCFileDownloadTaskResult.class]) {
        
        // Success result
        if (result.success) {
            
            QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
            if ([res file]) {
                
                // Add image to gallery
                [[DataManager instance] savePicture:[UIImage imageWithData:[res file]]];
                UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[res file]]];
                [self showImage:imageView];
                //
                [[[DataManager instance] fileList] removeLastObject];
                
                // Download next file
                [self downloadFile];
            }
        }else{
            [[[DataManager instance] fileList] removeLastObject];
            
            // download next file
            [self downloadFile];
        }
    } else if ([result isKindOfClass:[QBCBlobPagedResult class]]){
        
        // Success result
        if(result.success){
            QBCBlobPagedResult *res = (QBCBlobPagedResult *)result;
            
            // Save user's filelist
            [DataManager instance].fileList = [res.blobs mutableCopy];
            
            // hid splash screen
            [self performSelector:@selector(downloadFile) withObject:self afterDelay:1];
            [self.activityIndicator startAnimating];
        }
    }
}
*/

- (IBAction)refreshGallery:(id)sender {
    files = [self listFiles];
    [self.collectionView reloadData];
}

- (IBAction)showMenu:(id)sender {
    //[self alertStatus:@"Are you sure?" :@"Temp Logout!" :201];
    NSArray *menuItems =
    @[
      
      [MenuItem menuItem:@"Twinspirational Moments"
                   image:nil
                  target:nil
                  action:NULL],
      
      [MenuItem menuItem:@"Chat"
                   image:[UIImage imageNamed:@"reload"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Twinstinct"
                   image:[UIImage imageNamed:@"img_t"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Twincidence"
                   image:[UIImage imageNamed:@"img_i"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Twinterests"
                   image:[UIImage imageNamed:@"img_in"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Plans and Events"
                   image:[UIImage imageNamed:@"img_pe"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Settings"
                   image:[UIImage imageNamed:@"img_s"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      ];
    
    MenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [Menu showMenuInView:self.view
                fromRect:((UIButton*)sender).frame
               menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", ((MenuItem*)sender).title);
    NSString *title = ((MenuItem*)sender).title;
    if ([title isEqualToString: @"Twinstinct"]) {
        self.tabBarController.selectedIndex = 1;
    } else if ([title isEqualToString: @"Twinspirational Moments"]) {
        self.tabBarController.selectedIndex = 2;
    } else if ([title isEqualToString: @"Twincidence"]) {
        self.tabBarController.selectedIndex = 3;
    } else if ([title isEqualToString: @"Twinterests"]) {
        self.tabBarController.selectedIndex = 4;
    } else if ([title isEqualToString: @"Plans and Events"]) {
        self.tabBarController.selectedIndex = 5;
    } else if ([title isEqualToString: @"Settings"]) {
        self.tabBarController.selectedIndex = 6;
    } else if ([title isEqualToString: @"Chat"]) {
        self.tabBarController.selectedIndex = 0;
    }
}


- (IBAction)logOut:(id)sender {
    [self alertStatus:@"Are you sure?" :@"Logout!" :201];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
    alertView.tag = tag;
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 201)     // check alert by tag
    {
        
        if (buttonIndex == 0)
            
        {
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            [self performSegueWithIdentifier:@"chat_logout" sender:self];
        }
        
        else
            
        {
            NSLog(@"cancel");
        }
    } else {
    }
}


//removing an image

- (void)removeImage:(NSString*)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [fileManager removeItemAtPath: fullPath error:NULL];
    
    NSLog(@"image removed");
    
}

//loading an image

- (UIImage*)loadImage:(NSString*)imageName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    NSLog(@"Load Image: %@", fullPath);
    
    NSData *img_data = [NSData dataWithContentsOfFile:fullPath];
    //NSLog(@"%@",img_data );
    
    return [[UIImage alloc] initWithData:img_data];
    
}

- (NSArray *)listFiles
{
    // LIST ALL FILES
    NSLog(@"LISTING ALL FILES FOUND");

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    int count;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}

@end