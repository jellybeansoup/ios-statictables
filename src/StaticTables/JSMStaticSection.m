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

@end

@interface JSMStaticDataSource (JSMStaticSection)

- (void)requestReloadForSection:(JSMStaticSection *)section;

@end

@interface JSMStaticRow (JSMStaticSection)

- (void)setSection:(JSMStaticSection *)section;

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
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(rows)) options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
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
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(rows))];
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

    [self rowsDidChange];
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
    [self insertRow:row atIndex:self.mutableRows.count];
}

- (void)insertRow:(JSMStaticRow *)row atIndex:(NSUInteger)index {
    // No row, no service
    if( row == nil ) {
        return;
    }

    // Keep the index inside the bounds
    index = MIN( self.mutableRows.count, MAX( 0, index ) );

    // Row isn't moving anywhere
    if( [self isEqualToSection:row.section] && [self indexForRow:row] == index ) {
        return;
    }

    // Remove the row from it's current section
    if( row.section != nil ) {
        [row.section removeRow:row];
    }

    [self willChangeValueForKey:@"rows"];

    // Insert the row
    row.section = self;
    [self.mutableRows insertObject:row atIndex:index];

    [self rowsDidChange];
    [self didChangeValueForKey:@"rows"];
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

    // Remove the row
    row.section = nil;
    [self.mutableRows removeObject:row];

    [self rowsDidChange];
    [self didChangeValueForKey:@"rows"];
}

- (void)removeAllRows {
    // No rows to remove
    if( self.mutableRows.count == 0 ) {
        return;
    }

    // Assign an empty array
    self.rows = [NSArray array];
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

- (void)willPerformChanges {

}

- (void)didChangeRow:(__kindof JSMStaticRow *)row atIndex:(NSUInteger)index newIndex:(NSUInteger)newIndex {

}

- (void)didPerformChanges {

}

- (void)rowsDidChange {
    NSArray *filteredRows = self.mutableRows.copy;
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(section:rowsDidChange:)] ) {
        filteredRows = [self.delegate section:self rowsDidChange:filteredRows];
    }
    if( ! [self.mutableRows isEqualToArray:filteredRows] ) {
        _mutableRows = filteredRows.mutableCopy;
    }
}

- (void)userDidDeleteRow:(__kindof JSMStaticRow *)row fromIndexPath:(NSIndexPath *)indexPath {
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(section:didDeleteRow:fromIndexPath:)] ) {
        [self.delegate section:self didDeleteRow:row fromIndexPath:indexPath];
    }
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if( [object isEqual:self] && [keyPath isEqualToString:NSStringFromSelector(@selector(rows))] ) {

        // Get the old and new values
        NSArray *old = [change objectForKey:@"old"] ?: @[];
        NSArray *new = [change objectForKey:@"new"] ?: @[];
        if( [old isEqualToArray:new] ) {
            return;
        }

        if( self.delegate != nil && [self.delegate respondsToSelector:@selector(sectionWillPerformChanges:)] ) {
            [self.delegate sectionWillPerformChanges:self];
        }
        [self willPerformChanges];

        [old jsm_compareToArray:new usingBlock:^(JSMStaticRow *row, NSUInteger fromIndex, NSUInteger toIndex) {
            if( self.delegate != nil && [self.delegate respondsToSelector:@selector(section:didChangeRow:atIndex:newIndex:)] ) {
                [self.delegate section:self didChangeRow:row atIndex:fromIndex newIndex:toIndex];
            }
            [self didChangeRow:row atIndex:fromIndex newIndex:toIndex];
        }];

        if( self.delegate != nil && [self.delegate respondsToSelector:@selector(sectionDidPerformChanges:)] ) {
            [self.delegate sectionDidPerformChanges:self];
        }
        [self didPerformChanges];

    }
}

@end
