//
//  Photo.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "Photo.h"

@implementation Photo

+ (Photo *)photoWithImageURL:(NSURL *)imageURL
{
    return [[self alloc] initWithImageURL:imageURL];
}

#pragma mark - Private

- (id)initWithImageURL:(NSURL *)imageURL
{
    if ([super init]) {
        _imageURL = imageURL;
    }
    
    return self;
}

#pragma mark - Properties

- (UIImage *)image
{
    if (!_image && self.imageURL) {
        NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
        UIImage *image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
        _image = image;
    }
    
    return _image;
}

@end
