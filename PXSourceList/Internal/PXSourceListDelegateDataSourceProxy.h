//
//  PXSourceListDelegateDataSourceProxy.h
//  PXSourceList
//
//  Created by Alex Rozanski on 25/12/2013.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

@import Foundation;
#import "PXSourceList.h"

@interface PXSourceListDelegateDataSourceProxy : NSProxy <NSOutlineViewDelegate, NSOutlineViewDataSource, PXSourceListDelegate, PXSourceListDataSource>

@property (nonatomic, weak) PXSourceList* sourceList;
@property (nonatomic, unsafe_unretained) id<PXSourceListDelegate> delegate;
@property (nonatomic, unsafe_unretained) id<PXSourceListDataSource> dataSource;

- (instancetype) initWithSourceList:(PXSourceList*) sourceList;

@end
