//
//  PhotoAlbumLayout.m
//  CollectionViewTutorial
//
//  Created by Scott Gardner on 12/31/12.
//  Copyright (c) 2012 Scott Gardner. All rights reserved.
//

#import "PhotoAlbumLayout.h"
#import "EmblemView.h"

static NSString * const kPhotoCellIdentifier = @"PhotoCell";

// Splitting up the definition ensures consumers use the constant, not the value
NSString * const kPhotoAlbumLayoutAlbumTitleKind = @"AlbumTitle";

static NSString * const kPhotoEmblemKind = @"Emblem";

static NSUInteger const kRotationCount = 32;
static NSUInteger const kRotationStride = 3;
static NSUInteger const kPhotoCellIdentifierBaseZIndex = 100;

@interface PhotoAlbumLayout ()
@property (nonatomic, copy) NSDictionary *layoutInfo;
@property (nonatomic, copy) NSArray *rotations;
@end

@implementation PhotoAlbumLayout

- (id)init
{
    if (self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [@{} mutableCopy];
    NSMutableDictionary *cellLayoutInfo = [@{} mutableCopy];
    NSMutableDictionary *titleLayoutInfo = [@{} mutableCopy];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    // Since we have only one emblem, we can create our attributes before we interate through all the sections and rows
    UICollectionViewLayoutAttributes *emblemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kPhotoEmblemKind withIndexPath:indexPath];
    emblemAttributes.frame = [self frameForEmblem];
    newLayoutInfo[kPhotoEmblemKind] = @{indexPath : emblemAttributes};
    
    for (int section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        // Iterate through each section's items and create its attributes based on the index path, set the frame, and then add the attributes to the sub-dictionary
        for (int item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForPhotoAtIndexPath:indexPath];
            itemAttributes.transform3D = [self transformForPhotoAtIndex:indexPath];
            itemAttributes.zIndex = kPhotoCellIdentifierBaseZIndex + itemCount - item; // Highest zIndex is on top of stack, lowest is on bottom
            cellLayoutInfo[indexPath] = itemAttributes;
            
            // Set title in supplementary view
            if (indexPath.item == 0) {
                UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kPhotoAlbumLayoutAlbumTitleKind withIndexPath:indexPath];
                titleAttributes.frame = [self frameForPhotoAlbumTitleAtIndexPath:indexPath];
                titleLayoutInfo[indexPath] = titleAttributes;
            }
        }
    }
    
    // Add the sub-dictionary to the top-level dictionary and cache the top-level dictionary
    newLayoutInfo[kPhotoCellIdentifier] = cellLayoutInfo;
    newLayoutInfo[kPhotoAlbumLayoutAlbumTitleKind] = titleLayoutInfo;
    self.layoutInfo = newLayoutInfo;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementID, NSDictionary *elementsInfo, BOOL *stop) {
        
        // Iterate through each cell in the sub-dictionary and add the cell to the return array if it intersects with the rect that was passed in
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Return the sub-dictionary based on the index path
    return self.layoutInfo[kPhotoCellIdentifier][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[kPhotoAlbumLayoutAlbumTitleKind][indexPath];
}

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
    
    // Make sure we count another row if one is only partially filled
    if ([self.collectionView numberOfSections] % self.numberOfColumns) rowCount++;
    
    CGFloat height = self.itemInsets.top + (rowCount * self.itemSize.height) + ((rowCount - 1) * self.interItemSpacingY) + (rowCount * self.titleHeight) + self.itemInsets.bottom;
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

#pragma mark - Properties

/*
 When using a custom collection view layout, we must invalidate the layout whenever changes to the layout occurs (e.g., rotation)
 TODO: Determine if there is a better way to do this
 */

- (void)setItemInsets:(UIEdgeInsets)itemInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_itemInsets, itemInsets)) return;
    _itemInsets = itemInsets;
    [self invalidateLayout];
}

- (void)setItemSize:(CGSize)itemSize
{
    if (CGSizeEqualToSize(_itemSize, itemSize)) return;
    _itemSize = itemSize;
    [self invalidateLayout];
}

- (void)setInterItemSpacingY:(CGFloat)interItemSpacingY
{
    if (_interItemSpacingY == interItemSpacingY) return;
    _interItemSpacingY = interItemSpacingY;
    [self invalidateLayout];
}

- (void)setNumberOfColumns:(NSInteger)numberOfColumns
{
    if (_numberOfColumns == numberOfColumns) return;
    _numberOfColumns = numberOfColumns;
    [self invalidateLayout];
}

- (void)setTitleHeight:(CGFloat)titleHeight
{
    if (_titleHeight == titleHeight) return;
    _titleHeight = titleHeight;
    [self invalidateLayout];
}

#pragma mark - Private

- (void)setup
{
    // Unlike cells and supplementary views, decoration views are registered with the layout rather than the collection view
    [self registerClass:[EmblemView class] forDecorationViewOfKind:kPhotoEmblemKind];
    
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    self.itemSize = CGSizeMake(125.0f, 125.0f);
    self.interItemSpacingY = 12.0f;
    self.numberOfColumns = 2;
    self.titleHeight = 26.0f;
    
    // Create rotations at load so that they are consistent during prepareLayout
    NSMutableArray *rotations = [NSMutableArray arrayWithCapacity:kRotationCount];
    
    CGFloat percentage = 0.0f;
    
    for (int i = 0; i < kRotationCount; i++) {
        // Ensure that each angle is different enough to be seen
        CGFloat newPercentage = 0.0f;
        
        // Create random percentage -1.1% to 1.1%, ensuring that each new percentage is at least 0.6% different than the previous one
        do {
            newPercentage = ((CGFloat)(arc4random() % 220) - 110) * 0.0001f;
        } while (fabsf(percentage - newPercentage) < 0.006f);
        
        percentage = newPercentage;
        CGFloat angle = 2 * M_PI * (1.0f + percentage);
        CATransform3D transform = CATransform3DMakeRotation(angle, 0.0f, 0.0f, 1.0f);
        [rotations addObject:[NSValue valueWithCATransform3D:transform]];
    }
    
    self.rotations = rotations;
}

- (CGRect)frameForPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;
    
    // Determine combined horizontal space between items
    CGFloat spacingX = self.collectionView.bounds.size.width - self.itemInsets.left - self.itemInsets.right - (self.numberOfColumns * self.itemSize.width);
    
    // If there is more than 1 column, divide the total spacing betweeen each column
    if (self.numberOfColumns > 1) spacingX = spacingX / (self.numberOfColumns -1);
    
    CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);
    
    // Determine vertical offset
    CGFloat originY = floorf(self.itemInsets.top + ((self.itemSize.height + self.titleHeight + self.interItemSpacingY) * row));
    
    // return frame based on the item's origins and size
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (CGRect)frameForPhotoAlbumTitleAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForPhotoAtIndexPath:indexPath];
    frame.origin.y += frame.size.height;
    frame.size.height = self.titleHeight;
    return frame;
}

- (CGRect)frameForEmblem
{
    CGSize size = [EmblemView defaultSize];
    
    // Centered
    CGFloat originX = floorf((self.collectionView.bounds.size.width - size.width) / 2.0f);
    
    // 30 pts above top of collection view
    CGFloat originY = -size.height - 30.0f;
    
    return CGRectMake(originX, originY, size.width, size.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[kPhotoEmblemKind][indexPath];
}

- (CATransform3D)transformForPhotoAtIndex:(NSIndexPath *)indexPath
{
    // Jump a few rotation values between sections
    NSInteger offset = (indexPath.section * kRotationStride) + indexPath.item;
    
    // Mod the offset by the RotationCount to ensure we stay within the array's bounds
    return [self.rotations[offset % kRotationCount] CATransform3DValue];
}

@end
