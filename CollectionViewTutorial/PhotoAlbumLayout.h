//
//  PhotoAlbumLayout.h
//  CollectionViewTutorial
//
//  Created by Scott Gardner on 12/31/12.
//  Copyright (c) 2012 Scott Gardner. All rights reserved.
//

// Made public so that it can be used for registration and in the layout dictionary
UIKIT_EXTERN NSString * const kPhotoAlbumLayoutAlbumTitleKind;

@interface PhotoAlbumLayout : UICollectionViewLayout

@property (nonatomic, assign) UIEdgeInsets itemInsets;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat interItemSpacingY;
@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) CGFloat titleHeight;

@end
