//
//  Photo.h
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;

+ (Photo *)photoWithImageURL:(NSURL *)imageURL;

@end
