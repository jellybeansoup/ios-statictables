//
// Copyright © 2014 Daniel Farrelly
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// *	Redistributions of source code must retain the above copyright notice, this list
//		of conditions and the following disclaimer.
// *	Redistributions in binary form must reproduce the above copyright notice, this
//		list of conditions and the following disclaimer in the documentation and/or
//		other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "JSMStaticSection.h"
#import "JSMStaticDataSource.h"
#import "JSMStaticRow.h"
#import "NSArray+StaticTables.h"

@interface JSMStaticSection ()

@property (nonatomic, strong) NSMutableArray <__kindof JSMStaticRow *> *mutableRows;

@property (nonatomic, getter=isDirty) BOOL dirty;

@property (nonatomic, copy, readonly) NSArray<JSMStaticChange *> *differences;

@end

@interface JSMStaticDataSource (JSMStaticSection)

- (void)requestReloadForSection:(JSMStaticSection *)section;

- (void)jst_rowsDidChangeInSection:(JSMStaticSection *)section;

@end

@interface JSMStaticRow (JSMStaticSection)

- (void)setSection:(JSMStaticSection *)section;

@property (nonatomic, getter=isDirty) BOOL dirty;

@end

@implementation JSMStaticSection

@synthesize mutableRows = _mutableRows;

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@",self.class];
    if( self.key != nil ) {
        [description appendFormat:@": #%@",self.key];
    }
    if( self.mutableRows.count > 0 ) {
        [description appendFormat:@" (\n\t%@\n)",[[self.mutableRows valueForKeyPath:@"description"] componentsJoinedByString:@",\n\t"]];
    }
    if( self.headerText != nil ) {
        [description appendFormat:@" headerText='%@';",self.headerText];
    }
    if( self.footerText != nil ) {
        [description appendFormat:@" footerText='%@';",self.footerText];
    }
    [description appendString:@">"];
    return description;
}

#pragma mark - Creating Sections

- (instancetype)init {
    if( ( self = [super init] ) ) {
        _mutableRows = [NSMutableArray array];
        //[self addObserver:self forKeyPath:NSStringFromSelector(@selector(rows)) options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (instancetype)initWithKey:(NSString *)key {
    if( ( self = [self init] ) ) {
        _key = key;
    }
    return self;
}

- (void)dealloc {
    //[self removeObserver:self forKeyPath:NSStringFromSelector(@selector(rows))];
}

+ (instancetype)section {
    return [[self alloc] initWithKey:nil];
}

+ (instancetype)sectionWithKey:(NSString *)key {
    return [[self alloc] initWithKey:key];
}

#pragma mark - Comparing Sections

- (BOOL)isEqual:(id)object {
    if( object == nil ) return NO;

    if( self == object ) {
        return YES;
    }

    if( ! [object isKindOfClass:[JSMStaticSection class]] ) {
        return NO;
    }

    return [self isEqualToSection:(JSMStaticSection *)object];
}

- (BOOL)isEqualToSection:(JSMStaticSection *)section {
    // Nil section provided
    if( section == nil ) return NO;

    // Both keys are nil
    if( self.key == nil && section.key == nil ) {
        BOOL haveEqualHeaderText = ( ! self.headerText && ! section.headerText ) || [self.headerText isEqualToString:section.headerText];
        BOOL haveEqualFooterText = ( ! self.footerText && ! section.footerText ) || [self.footerText isEqualToString:section.footerText];
        BOOL haveEqualRows = ( ! self.mutableRows && ! section.mutableRows ) || [self.mutableRows isEqualToArray:section.mutableRows];
        return haveEqualHeaderText && haveEqualFooterText && haveEqualRows;
    }

    // Otherwise compare the keys
    return [self.key isEqual:section.key];
}

- (NSUInteger)hash {
    return self.headerText.hash ^ self.footerText.hash ^ self.mutableRows.hash;
}

#pragma mark - Predefined content

- (void)setHeaderText:(NSString *)headerText {
    if( [_headerText isEqualToString:headerText] ) {
        return;
    }
    _headerText = headerText;
    [self setNeedsReload];
}

- (void)setFooterText:(NSString *)footerText {
    if( [_footerText isEqualToString:footerText] ) {
        return;
    }
    _footerText = footerText;
    [self setNeedsReload];
}

#pragma mark - Data Structure

- (UITableView *)tableView {
    return self.dataSource.tableView;
}

- (void)setDataSource:(JSMStaticDataSource *)dataSource {
    if( [_dataSource isEqual:dataSource] ) {
        return;
    }
    if( _dataSource != nil && dataSource != nil ) {
        [_dataSource removeSection:self];
    }
    _dataSource = dataSource;
}

#pragma mark - Managing the Section's Content

- (NSArray <__kindof JSMStaticRow *> *)rows {
    return self.mutableRows.copy;
}

- (void)setRows:(NSArray <__kindof JSMStaticRow *> *)rows {
    NSMutableArray *mutableRows = rows.mutableCopy;
    NSArray *oldRows = self.rows;

    // If the rows are the same, bail out now.
    if( [_mutableRows isEqualToArray:mutableRows] ) {
        return;
    }

    // Detach the rows that are being removed.
    for( JSMStaticRow *row in _mutableRows ) {
        if( row.section != self ) continue;
        row.section = nil;
    }

    // Attach the rows that are being inserted.
    for( JSMStaticRow *row in mutableRows ) {
        if( row.section == self ) continue;
        else if( row.section != nil ) {
            [row.section removeRow:row];
        }
        row.section = self;
    }

    // Update the rows
    _mutableRows = mutableRows;

    [self filterRows];
    [self jst_rowsDidChange:oldRows];
    // We don't call KVO methods in the setter, as it appears to be done for us.
}

- (NSUInteger)numberOfRows {
    return self.mutableRows.count;
}

- (JSMStaticRow *)createRow {
    JSMStaticRow *row = [JSMStaticRow row];
    [self addRow:row];
    return row;
}

- (JSMStaticRow *)createRowAtIndex:(NSUInteger)index {
    JSMStaticRow *row = [JSMStaticRow row];
    [self insertRow:row atIndex:index];
    return row;
}

- (void)addRow:(JSMStaticRow *)row {
    if( row == nil ) return;

    // Index for appending to the array, should account for being in the datasource already
    NSUInteger index = self.mutableRows.count;
    if( row.section != nil && [self isEqual:row.section] ) {
        index = index - 1;
    }

    [self insertRow:row atIndex:index];
}

- (void)insertRow:(JSMStaticRow *)row atIndex:(NSUInteger)index {
    if( row == nil ) return;

    // Keep the index inside the bounds
    NSUInteger maxIndex = self.mutableRows.count;
    if( row.section != nil && [self isEqual:row.section] ) {
        maxIndex = maxIndex - 1;
    }
    index = MIN( maxIndex, MAX( (unsigned long)0, index ) );

    // Row isn't moving anywhere
    if( row.section != nil && [self isEqualToSection:row.section] && [self indexForRow:row] == index ) {
        return;
    }

    [self willChangeValueForKey:@"rows"];
    NSArray *oldRows = self.rows;

    // Remove the row from it's current section
    if( row.section != nil ) {
        [row.section removeRow:row];
    }

    // Insert the row
    row.section = self;
    [self.mutableRows insertObject:row atIndex:index];

    [self filterRows];
    [self didChangeValueForKey:@"rows"];
    [self jst_rowsDidChange:oldRows];
}

- (__kindof JSMStaticRow *)rowWithKey:(NSString *)key {
    return [[self.mutableRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"key = %@",key]] firstObject];
}

- (__kindof JSMStaticRow *)rowAtIndex:(NSUInteger)index {
    // We won't find anything outside the bounds
    if( index >= self.mutableRows.count ) {
        return nil;
    }
    // Fetch the object
    return (JSMStaticRow *)[self.mutableRows objectAtIndex:index];
}

- (NSUInteger)indexForRow:(JSMStaticRow *)row {
    return [self.mutableRows indexOfObject:row];
}

- (BOOL)containsRow:(JSMStaticRow *)row {
    return [self.mutableRows containsObject:row];
}

- (void)removeRowAtIndex:(NSUInteger)index {
    JSMStaticRow *row = [self rowAtIndex:index];
    [self removeRow:row];
}

- (void)removeRow:(JSMStaticRow *)row {
    if( row == nil ) {
        return;
    }

    [self willChangeValueForKey:@"rows"];
    NSArray *oldRows = self.rows;

    // Remove the row
    row.section = nil;
    [self.mutableRows removeObject:row];

    [self filterRows];
    [self didChangeValueForKey:@"rows"];
    [self jst_rowsDidChange:oldRows];
}

- (void)removeAllRows {
    // No rows to remove
    if( self.mutableRows.count == 0 ) {
        return;
    }

    // Assign an empty array
    self.rows = [NSArray array];
}

- (void)filterRows {
    NSArray *filteredRows = self.mutableRows.copy;
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(section:rowsDidChange:)] ) {
        filteredRows = [self.delegate section:self rowsDidChange:filteredRows];
    }
    if( ! [self.mutableRows isEqualToArray:filteredRows] ) {
        _mutableRows = filteredRows.mutableCopy;
    }
}

#pragma mark - Refreshing the Contents

- (void)requestReloadForRow:(JSMStaticRow *)row {
    [self jst_rowsDidChange:self.rows];
}

#pragma mark - Refreshing the Row

- (BOOL)needsReload {
    return self.isDirty;
}

- (void)setNeedsReload {
    // No section or data source
    if( self.dataSource == nil ) {
        return;
    }
    // Request a reload
    [self.dataSource requestReloadForSection:self];
}

#pragma mark - Responding to changes

- (BOOL)shouldPerformChanges {
    return YES;
    // Empty implementation, as method is designed to be overriden by subclasses.
}

- (void)didChangeRow:(__kindof JSMStaticRow *)row atIndex:(NSUInteger)index newIndex:(NSUInteger)newIndex {
    // Empty implementation, as method is designed to be overriden by subclasses.
}

- (void)didPerformChanges {
    // Empty implementation, as method is designed to be overriden by subclasses.
}

- (void)jst_rowsDidChange:(NSArray<__kindof JSMStaticRow *> *)old {
    NSArray<__kindof JSMStaticRow *> *new = self.rows.copy;

    // We're going to find all the differences
    _differences = [old jst_changesRequiredToMatchArray:new];

    // After all that, we don't have anything to change, apparently?
    if( _differences.count == 0 ) return;

    // Inform the people of the differences
    if( self.dataSource ) {
        [self.dataSource jst_rowsDidChangeInSection:self];
    }

    id<JSMStaticSectionDelegate> delegate = self.delegate;
    BOOL informDelegate = [delegate respondsToSelector:@selector(sectionShouldPerformChanges:)] ? [delegate sectionShouldPerformChanges:self] : YES;
    BOOL informSection = [self respondsToSelector:@selector(shouldPerformChanges)] ? [self shouldPerformChanges] : YES;

    if( informDelegate || informSection ) {
        [_differences enumerateObjectsUsingBlock:^(JSMStaticChange * _Nonnull change, NSUInteger idx, BOOL * _Nonnull stop) {
            if( informDelegate && [delegate respondsToSelector:@selector(section:didChangeRow:atIndex:newIndex:)] ) {
                [delegate section:self didChangeRow:change.object atIndex:change.fromIndex newIndex:change.toIndex];
            }
            if( informSection && [delegate respondsToSelector:@selector(didChangeRow:atIndex:newIndex:)] ) {
                [self didChangeRow:change.object atIndex:change.fromIndex newIndex:change.toIndex];
            }
        }];
    }

    if( delegate != nil && [delegate respondsToSelector:@selector(sectionDidPerformChanges:)] ) {
        [delegate sectionDidPerformChanges:self];
    }
    if( [self respondsToSelector:@selector(didPerformChanges)] ) {
        [self didPerformChanges];
    }
}

@end
