//
//  EmblemView.m
//  CollectionViewTutorial
//
//  Created by Scott Gardner on 1/1/13.
//  Copyright (c) 2013 Scott Gardner. All rights reserved.
//

// If we wanted to create a more customizable decoration view, we would need to make use of custom properties, which requires creating a subclass of UICollectionViewLayoutAttributes and then setting those up within the layout

#import "EmblemView.h"

static NSString * const kEmblemViewImageName = @"emblem";

@implementation EmblemView

- (id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        UIImage *image = [UIImage imageNamed:kEmblemViewImageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
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

// To provide to PhotoAlbumLayout vs. having to instantiate an emblem view
+ (CGSize)defaultSize
{
    return [UIImage imageNamed:kEmblemViewImageName].size;
}

@end
