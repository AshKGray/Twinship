//
//  TWTextField.m
//  Twinship
//
//  Created by Dipin Krishna on 28/11/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import "TWTextField.h"

@implementation TWTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10.0f, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

- (void) drawPlaceholderInRect:(CGRect)rect {
    if (self.placeholder)
    {
        
        // color of placeholder text
        UIColor *placeHolderTextColor = [UIColor blackColor];
        
        CGSize drawSize = [self.placeholder sizeWithAttributes:[NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName]];
        CGRect drawRect = rect;
        
        // verticially align text
        drawRect.origin.y = (rect.size.height - drawSize.height) * 0.5;
        
        // set alignment
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.textAlignment;
        
        // dictionary of attributes, font, paragraphstyle, and color
        NSDictionary *drawAttributes = @{NSFontAttributeName: self.font,
                                         NSParagraphStyleAttributeName : paragraphStyle,
                                         NSForegroundColorAttributeName : placeHolderTextColor};
        
        
        // draw
        [self.placeholder drawInRect:drawRect withAttributes:drawAttributes];
        
    }
}



@end
