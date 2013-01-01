//
//  Album.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "Album.h"
#import "Photo.h"

@implementation Album

- (id)init
{
    if ([super init]) {
        _photos = [@[] mutableCopy];
    }
    
    return self;
}

- (void)addPhoto:(Photo *)photo
{
    [self.photos addObject:photo];
}

- (BOOL)removePhoto:(Photo *)photo
{
    if ([self.photos indexOfObject:photo] == NSNotFound) {
        return NO;
    }
    
    [self.photos removeObject:photo];
    
    return YES;
}

@end
