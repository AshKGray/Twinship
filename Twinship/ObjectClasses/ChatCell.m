//
//  ChatCell.m
//  Twinship
//
//  Created by Dipin Krishna on 02/03/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

#import "ChatCell.h"
#define padding 20

@implementation ChatCell

static NSDateFormatter *messageDateFormatter;
static UIImage *mLeftBubble;
static UIImage *mRightBubble;
static UIImage *fLeftBubble;
static UIImage *fRightBubble;
static UIImage *defaultImage;
static UIImage *defaultVideo;


+ (void)initialize{
    [super initialize];
    // init message datetime formatter
    messageDateFormatter = [[NSDateFormatter alloc] init];
    [messageDateFormatter setDateFormat: @"yyyy-mm-dd HH:mm:ss"];
    [messageDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    // init bubbles
    mLeftBubble = [[UIImage imageNamed:@"img_blue_left"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
    fLeftBubble = [[UIImage imageNamed:@"img_pink_left"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
    mRightBubble = [[UIImage imageNamed:@"img_blue_right"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    fRightBubble = [[UIImage imageNamed:@"img_pink_right"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    defaultImage = [UIImage imageNamed:@"thumbnail-image"];
    defaultVideo = [UIImage imageNamed:@"thumbnail-video"];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        //self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundImageView = [[UIImageView alloc] init];
        [self.backgroundImageView setFrame:CGRectZero];
		[self.contentView addSubview:self.backgroundImageView];
        
        self.picView = [[UIImageView alloc] init];
        [self.picView setFrame:CGRectZero];
        self.picView.contentMode = UIViewContentModeCenter;
		[self.contentView addSubview:self.picView];
        
        self.videoView = [[UIImageView alloc] init];
        [self.videoView setFrame:CGRectZero];
		[self.contentView addSubview:self.videoView];
        
		self.messageTextView = [[UITextView alloc] init];
        [self.messageTextView setBackgroundColor:[UIColor clearColor]];
        [self.messageTextView setEditable:NO];
        [self.messageTextView setScrollEnabled:NO];
		[self.messageTextView sizeToFit];
		[self.contentView addSubview:self.messageTextView];
        
        self.dateLabel = [[UILabel alloc] init];
        [self.dateLabel setFrame:CGRectMake(10, 5, 300, 20)];
        [self.dateLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self.dateLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


+ (CGFloat)heightForCellWithMessage:(NSString *)message
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13]};
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    //NSLog(@"frame width: %f: ", screenRect.size.width);
    
    CGRect rect = [message boundingRectWithSize:CGSizeMake(260, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil];
    CGSize size = rect.size;
	size.height += 45.0;
    
    //NSLog(@"Cell Height: %f", size.height);
	return size.height;
}

- (void)configureCell
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.opponentName = [prefs objectForKey:@"twin_name"];
    self.gender = [prefs objectForKey:@"gender"];
    self.opponentGender = [prefs objectForKey:@"twin_gender"];
    
    if (self.isText) {
        //NSLog(@"is Oppoenent: %d, %@", self.isOpponent, self.chatMessage);
        
        self.messageTextView.text = self.chatMessage;
        [self.messageTextView setFrame:CGRectMake(0, 0, 260,10)];
        [self.messageTextView sizeToFit];
        //NSLog(@"Box Width: %f", self.messageTextView.frame.size.width);
        
        CGSize size = self.messageTextView.frame.size;
        
        NSString *time = [messageDateFormatter stringFromDate:self.datetime];
        
        if (self.isOpponent) {
            [self.messageTextView setFrame:CGRectMake((320 - size.width) - padding + 5, padding, size.width, size.height)];
            
            //NSLog(@"Width: %f", self.messageTextView.frame.size.width);
            
            if ([self.opponentGender isEqualToString:@"M"]) {
                self.backgroundImageView.image = mRightBubble;
            } else {
                self.backgroundImageView.image = fRightBubble;
            }
            
            [self.backgroundImageView setFrame:CGRectMake((300 - self.messageTextView.frame.size.width), padding,
                                                          self.messageTextView.frame.size.width+padding/2 + 5, self.messageTextView.frame.size.height+5)];
            
            self.dateLabel.textAlignment = NSTextAlignmentRight;
            self.dateLabel.text = [NSString stringWithFormat:@"%@ %@", self.opponentName, time];
        } else {
            size.width += 10;
            [self.messageTextView setFrame:CGRectMake(padding, padding, size.width, size.height+padding)];
            [self.messageTextView sizeToFit];
            
            
            if ([self.gender isEqualToString:@"M"]) {
                self.backgroundImageView.image = mLeftBubble;
            } else {
                self.backgroundImageView.image = fLeftBubble;
            }
            
            [self.backgroundImageView setFrame:CGRectMake(padding/2, padding,
                                                          self.messageTextView.frame.size.width+padding/2 + 5, self.messageTextView.frame.size.height+5)];
            
            self.dateLabel.textAlignment = NSTextAlignmentLeft;
            self.dateLabel.text = [NSString stringWithFormat:@"Me %@", time];
        }
    } else if (self.isImage) {
        NSLog(@"Its Image");
        /*
        if ([self.gender isEqualToString:@"M"]) {
            self.backgroundImageView.image = mLeftBubble;
        } else {
            self.backgroundImageView.image = fLeftBubble;
        }
        
        [self.backgroundImageView setFrame:CGRectMake(padding/2, padding, 240,140)];
        
        [self.picView setFrame:CGRectMake(self.backgroundImageView.frame.origin.x, self.backgroundImageView.frame.origin.y+5, self.backgroundImageView.frame.size.width, self.backgroundImageView.frame.size.height - 15)];
        
        if (self.loaded) {
            self.picView.image = self.image;
            [self.picView setContentMode:UIViewContentModeScaleAspectFit];
        } else {
            self.picView.image = defaultImage;
            [self.picView setContentMode:UIViewContentModeCenter];
            UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] init];
            [loading setFrame:self.picView.frame];
            [loading setContentMode:UIViewContentModeCenter];
            [loading setColor:[UIColor redColor]];
            [loading startAnimating];
            [self.contentView addSubview:loading];
        }
        */
        
        if (self.isOpponent) {
            
            if ([self.opponentGender isEqualToString:@"M"]) {
                self.backgroundImageView.image = mRightBubble;
            } else {
                self.backgroundImageView.image = fRightBubble;
            }
            
            [self.backgroundImageView setFrame:CGRectMake((320 - 240) - padding, padding, 240, 140)];
            
            [self.picView setFrame:CGRectMake(self.backgroundImageView.frame.origin.x, self.backgroundImageView.frame.origin.y+5, self.backgroundImageView.frame.size.width, self.backgroundImageView.frame.size.height - 15)];
            
            if (self.loaded) {
                self.picView.image = self.image;
                [self.picView setContentMode:UIViewContentModeScaleAspectFit];
                [self.picView setBackgroundColor:[UIColor clearColor]];
            } else {
                self.picView.image = defaultImage;
                [self.picView setContentMode:UIViewContentModeCenter];
                /*
                UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] init];
                [loading setFrame:self.picView.frame];
                [loading setContentMode:UIViewContentModeCenter];
                [loading setColor:[UIColor redColor]];
                [loading startAnimating];
                [self.contentView addSubview:loading];
                 */
            }
        } else {
            
            if ([self.gender isEqualToString:@"M"]) {
                self.backgroundImageView.image = mLeftBubble;
            } else {
                self.backgroundImageView.image = fLeftBubble;
            }
            
            [self.backgroundImageView setFrame:CGRectMake(padding/2, padding, 240,140)];
            
            [self.picView setFrame:CGRectMake(self.backgroundImageView.frame.origin.x, self.backgroundImageView.frame.origin.y+5, self.backgroundImageView.frame.size.width, self.backgroundImageView.frame.size.height - 15)];
            
            if (self.loaded) {
                self.picView.image = self.image;
                [self.picView setContentMode:UIViewContentModeScaleAspectFit];
                [self.picView setBackgroundColor:[UIColor clearColor]];
            } else {
                self.picView.image = defaultImage;
                [self.picView setContentMode:UIViewContentModeCenter];
                /*
                UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] init];
                [loading setFrame:self.picView.frame];
                [loading setContentMode:UIViewContentModeCenter];
                [loading setColor:[UIColor redColor]];
                [loading startAnimating];
                [self.contentView addSubview:loading];
                 */
            }
        }
        
    }
    
}

@end
