//
//  AlbumTitleReusableView.m
//  CollectionViewTutorial
//
//  Created by Scott Gardner on 1/1/13.
//  Copyright (c) 2013 Scott Gardner. All rights reserved.
//

#import "AlbumTitleReusableView.h"

@implementation AlbumTitleReusableView

- (id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _titleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f]; // colorWithWhite:alpha: with 1.0f values = whiteColor
        _titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        _titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        
        // Unlike cells where we add subviews to the contentView, here we add them directly to the view
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.titleLabel.text = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
