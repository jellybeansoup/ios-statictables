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

#import "JSMStaticRow.h"
#import "JSMStaticDataSource.h"

@interface JSMStaticRow ()

@property (nonatomic, copy) JSMStaticTableViewCellConfiguration configurationBlock;

@property (nonatomic, getter=isDirty) BOOL dirty;

@end

@interface JSMStaticDataSource (JSMStaticRow)

- (void)requestReloadForRow:(JSMStaticRow *)row;

@end

@implementation JSMStaticRow

- (id)init {
    if( ( self = [super init] ) ) {
        self.style = UITableViewCellStyleValue1;
    }
    return self;
}

#pragma mark - Data Structure

/**
 * Provide the section for contained rows.
 *
 * @param section The section that contains the observer.
 * @return void
 */

- (void)setSection:(JSMStaticSection *)section {
    if( [_section isEqual:section] ) {
        return;
    }
    if( _section != nil && section != nil) {
        [_section removeRow:self];
    }
    _section = section;
}

#pragma mark - Predefined content

- (void)setText:(NSString *)text {
    _text = text;
    [self setNeedsReload];
}

- (void)setDetailText:(NSString *)detailText {
    _detailText = detailText;
    [self setNeedsReload];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsReload];
}

- (void)setStyle:(UITableViewCellStyle)style {
    _style = style;
    [self setNeedsReload];
}

#pragma mark - Configuring the cell

- (void)prepareCell:(UITableViewCell *)cell {
    self.dirty = NO;
    if( self.configurationBlock != nil ) {
        self.configurationBlock( self, cell );
    }
}

- (void)configurationForCell:(JSMStaticTableViewCellConfiguration)configurationBlock {
    self.configurationBlock = configurationBlock;
}

#pragma mark - Refreshing the Row

- (BOOL)needsReload {
    return self.isDirty;
}

- (void)setNeedsReload {
    // No section or data source
    if( self.section.dataSource == nil ) {
        return;
    }
    // Request a reload
    [self.section.dataSource requestReloadForRow:self];
}

@end
