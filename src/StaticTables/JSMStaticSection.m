//
// Copyright © 2019 Daniel Farrelly
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

@interface JSMStaticSection ()

@property (nonatomic, strong) NSMutableArray *mutableRows;

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

- (instancetype)initWithKey:(id)key {
    if( ( self = [super init] ) ) {
        _key = key;
        _dirty = NO;
        _mutableRows = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init {
    return [self initWithKey:nil];
}

+ (instancetype)section {
    return [[self alloc] initWithKey:nil];
}

+ (instancetype)sectionWithKey:(id)key {
    return [[self alloc] initWithKey:key];
}

#pragma mark - Comparing Sections

- (BOOL)isEqual:(id)object {
    if( self == object ) {
        return YES;
    }

    if( ! [object isKindOfClass:[JSMStaticSection class]] ) {
        return NO;
    }

    return [self isEqualToSection:(JSMStaticSection *)object];
}

- (BOOL)isEqualToSection:(JSMStaticSection *)section {
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

#pragma mark - Accessing rows

- (NSArray *)rows {
	return self.mutableRows.copy;
}

- (NSUInteger)numberOfRows {
	return self.mutableRows.count;
}

- (JSMStaticRow *)rowWithKey:(id)key {
	return [[self.mutableRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"key = %@",key]] firstObject];
}

- (JSMStaticRow *)rowAtIndex:(NSUInteger)index {
	if( index == NSNotFound || index >= self.mutableRows.count ) {
		return nil;
	}

	return (JSMStaticRow *)self.mutableRows[index];
}

- (NSUInteger)indexForRow:(JSMStaticRow *)row {
	return [self.mutableRows indexOfObject:row];
}

- (BOOL)containsRow:(JSMStaticRow *)row {
	return [self.mutableRows containsObject:row];
}

#pragma mark - Mutating rows

- (void)setRows:(NSArray *)rows {
	if( self.mutableRows.count > 0 ) {
		[self.mutableRows makeObjectsPerformSelector:@selector(setSection:) withObject:nil];
		[self.mutableRows removeAllObjects];
	}
	
	for( JSMStaticRow *row in rows ) {
		if( row.section != nil ) {
			[row.section removeRow:row];
		}

		row.section = self;
		
		[self.mutableRows addObject:row];
	}

	[self rowsDidChange];
}

- (JSMStaticRow *)createRow {
    JSMStaticRow *row = [JSMStaticRow row];
	[self insertRow:row atIndex:self.mutableRows.count];
    return row;
}

- (JSMStaticRow *)createRowAtIndex:(NSUInteger)index {
	NSAssert(index != NSNotFound, @"You cannot create a row at NSNotFound.");
	
    JSMStaticRow *row = [JSMStaticRow row];
    [self insertRow:row atIndex:index];
    return row;
}

- (void)addRow:(JSMStaticRow *)row {
	[self insertRow:row atIndex:self.mutableRows.count];
}

- (void)insertRow:(JSMStaticRow *)row atIndex:(NSUInteger)index {
	NSAssert(index != NSNotFound, @"You cannot insert a row at NSNotFound.");

	// Remove from the existing section
	if( row.section == self ) {
		NSUInteger oldIndex = [self.mutableRows indexOfObject:row];
		
		if( index == oldIndex || index == oldIndex + 1 ) {
			return;
		}
		else if( index > oldIndex ) {
			index -= 1; // Adjust to account for the row's removal.
		}

		[self.mutableRows removeObjectAtIndex:oldIndex];
	}
	else if( row.section != nil ) {
		[row.section removeRow:row];
	}

	// Add to the receiver
	row.section = self;
	if( index >= self.mutableRows.count ) {
        [self.mutableRows addObject:row];
    }
    else {
        [self.mutableRows insertObject:row atIndex:index];
    }
	
	[self rowsDidChange];
}

- (void)removeRowAtIndex:(NSUInteger)index {
	NSAssert(index != NSNotFound, @"You cannot remove a row at NSNotFound.");
	
	JSMStaticRow *row = [self.mutableRows objectAtIndex:index];
	
	if( row == nil ) {
		return;
	}
	
	[self removeRow:row atIndex:index];
}

- (void)removeRow:(JSMStaticRow *)row {
	NSUInteger index = [self.mutableRows indexOfObject:row];
	
	if( index == NSNotFound ) {
		return;
	}
	
	[self removeRow:row atIndex:index];
}

- (void)removeRow:(JSMStaticRow *)row atIndex:(NSUInteger)index {
	NSAssert(index != NSNotFound, @"You cannot remove a row at NSNotFound.");
	
	row.section = nil;
	[self.mutableRows removeObjectAtIndex:index];
	
	[self rowsDidChange];
}

- (void)removeAllRows {
    if( self.mutableRows.count == 0 ) {
        return;
    }

	[self.mutableRows makeObjectsPerformSelector:@selector(setSection:) withObject:nil];
    [self.mutableRows removeAllObjects];

	[self rowsDidChange];
}

- (void)rowsDidChange {
	if( self.delegate != nil && [self.delegate respondsToSelector:@selector(section:rowsDidChange:)] ) {
		self.mutableRows = [[self.delegate section:self rowsDidChange:self.mutableRows.copy] mutableCopy];
	}
}

#pragma mark - Refreshing the Row

- (BOOL)needsReload {
    return self.isDirty;
}

- (void)setNeedsReload {
	self.dirty = YES;
    // No section or data source
    if( self.dataSource == nil ) {
        return;
    }
    // Request a reload
    [self.dataSource requestReloadForSection:self];
}

@end
