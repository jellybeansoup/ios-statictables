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

@interface JSMStaticSection (JSMStaticRow)

- (void)requestReloadForRow:(JSMStaticRow *)row;

@end

@interface JSMStaticDataSource (JSMStaticRow)

- (void)requestReloadForRow:(JSMStaticRow *)row;

@end

@implementation JSMStaticRow

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@",self.class];
    if( self.key != nil ) {
        [description appendFormat:@": #%@",self.key];
    }
    if( self.text != nil ) {
        [description appendFormat:@" text='%@';",self.text];
    }
    if( self.detailText != nil ) {
        [description appendFormat:@" detailText='%@';",self.detailText];
    }
    [description appendString:@">"];
    return description;
}

#pragma mark - Creating Sections

- (instancetype)init {
    if( ( self = [super init] ) ) {
        _style = UITableViewCellStyleValue1;
        _accessoryType = UITableViewCellAccessoryNone;
        _editingAccessoryType = UITableViewCellAccessoryNone;
        _selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return self;
}

- (instancetype)initWithKey:(NSString *)key {
    if( ( self = [self init] ) ) {
        _key = key;
    }
    return self;
}

+ (instancetype)row {
    return [[self alloc] init];
}

+ (instancetype)rowWithKey:(NSString *)key {
    return [[self alloc] initWithKey:key];
}

#pragma mark - Comparing Rows

- (BOOL)isEqual:(id)object {
    if( self == object ) {
        return YES;
    }

    if( ! [object isKindOfClass:[JSMStaticRow class]] ) {
        return NO;
    }

    return [self isEqualToRow:(JSMStaticRow *)object];
}

- (BOOL)isEqualToRow:(JSMStaticRow *)row {
    // Both keys are nil
    if( self.key == nil && row.key == nil ) {
        BOOL haveEqualText = ( ! self.text && ! row.text ) || [self.text isEqualToString:row.text];
        BOOL haveEqualDetailText = ( ! self.detailText && ! row.detailText ) || [self.detailText isEqualToString:row.detailText];
        BOOL haveEqualImage = ( ! self.image && ! row.image ) || [self.image isEqual:row.image];
        return haveEqualText && haveEqualDetailText && haveEqualImage;
    }

    // Otherwise compare the keys
    return [self.key isEqual:row.key];
}

- (NSUInteger)hash {
    return self.text.hash ^ self.detailText.hash ^ self.image.hash;
}

#pragma mark - Data Structure

- (UITableView *)tableView {
    return self.section.tableView;
}

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
    if( [_text isEqualToString:text] ) {
        return;
    }
    _text = text;
    [self setNeedsReload];
}

- (void)setDetailText:(NSString *)detailText {
    if( [_detailText isEqualToString:detailText] ) {
        return;
    }
    _detailText = detailText;
    [self setNeedsReload];
}

- (void)setImage:(UIImage *)image {
    if( [_image isEqual:image] ) {
        return;
    }
    _image = image;
    [self setNeedsReload];
}

- (void)setStyle:(UITableViewCellStyle)style {
    if( _style == style ) {
        return;
    }
    _style = style;
    [self setNeedsReload];
}

#pragma mark - Configuring the cell

- (void)prepareCell:(UITableViewCell *)cell {
    self.dirty = NO;
    [self configureCell:cell];
    if( self.configurationBlock != nil ) {
        self.configurationBlock( self, cell );
    }
}

- (void)configureCell:(UITableViewCell *)cell {
}

- (void)configurationForCell:(JSMStaticTableViewCellConfiguration)configurationBlock {
    self.configurationBlock = configurationBlock;
}

#pragma mark - Refreshing the Row

- (BOOL)needsReload {
    return self.isDirty;
}

- (void)setNeedsReload {
    self.dirty = YES;
    if( self.section != nil ) {
        [self.section requestReloadForRow:self];
    }
    if( self.section.dataSource != nil ) {
        [self.section.dataSource requestReloadForRow:self];
    }
}

@end
