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

@import XCTest;
@import StaticTables;

@interface JSMRowTests : XCTestCase

@property (nonatomic, strong) JSMStaticRow *row;

@end

@interface JSMStaticRow (Private)

- (void)prepareCell:(UITableViewCell *)cell;

@end

@implementation JSMRowTests

- (JSMStaticRow *)row {
	if( _row == nil ) {
		_row = [JSMStaticRow row];
		_row.text = @"Text";
		_row.detailText = @"Detail Text";
		_row.image = [UIImage new];
		_row.style = UITableViewCellStyleSubtitle;
		_row.selectionStyle = UITableViewCellSelectionStyleGray;
		_row.accessoryType = UITableViewCellAccessoryDetailButton;
		_row.editingAccessoryType = UITableViewCellAccessoryDetailButton;
	}

	return _row;
}

- (void)test_row {
	JSMStaticRow *row = [JSMStaticRow row];
	XCTAssertNotNil(row, @"Row was not created.");
	XCTAssertNil(row.key, @"Row created without a key does not have a nil key.");
}

- (void)test_rowWithKey {
	JSMStaticRow *row = [JSMStaticRow rowWithKey:@"test"];
	XCTAssertNotNil(row, @"Row was not created with the key `test`.");
	XCTAssertEqualObjects(row.key, @"test", @"Row created with the key `test` does not have the correct key.");
}

- (void)test_prepareCell {
	JSMStaticRow *row = self.row;
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:row.style reuseIdentifier:nil];

	[row prepareCell:cell];

	XCTAssertEqualObjects(cell.textLabel.text, row.text, @"Configured cell does not reflect the text provided by the row.");
	XCTAssertEqualObjects(cell.detailTextLabel.text, row.detailText, @"Configured cell does not reflect the detail text provided by the row.");
	XCTAssertEqualObjects(cell.imageView.image, row.image, @"Configured cell does not reflect the image provided by the row.");
	XCTAssertEqual(cell.selectionStyle, row.selectionStyle, @"Configured cell does not reflect the selection style provided by the row.");
	XCTAssertEqual(cell.accessoryType, row.accessoryType, @"Configured cell does not reflect the accessory type provided by the row.");
	XCTAssertEqual(cell.editingAccessoryType, row.editingAccessoryType, @"Configured cell does not reflect the editing accessory type provided by the row.");

	[row configurationForCell:^(JSMStaticRow * _Nonnull r, UITableViewCell * _Nonnull c) {
		c.textLabel.text = @"Updated Text";
		c.detailTextLabel.text = nil;
		c.imageView.image = nil;
		c.selectionStyle = UITableViewCellSelectionStyleBlue;
	}];

	[row prepareCell:cell];

	XCTAssertEqualObjects(cell.textLabel.text, @"Updated Text", @"Configured cell does not reflect the text set in the configuration block.");
	XCTAssertNil(cell.detailTextLabel.text, @"Configured cell does not reflect the detail text set in the configuration block.");
	XCTAssertNil(cell.imageView.image, @"Configured cell does not reflect the image set in the configuration block.");
	XCTAssertEqual(cell.selectionStyle, UITableViewCellSelectionStyleBlue, @"Configured cell does not reflect the selection style set in the configuration block.");
}

- (void)test_needsReload {
	JSMStaticRow *row = self.row;
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:row.style reuseIdentifier:nil];

	XCTAssertTrue(row.needsReload, @"Unprepared row doesn't indicate it requires reload.");

	[row prepareCell:cell];

	XCTAssertFalse(row.needsReload, @"Prepared row hasn't cleared the `needsReload` parameter.");

	[row setNeedsReload];

	XCTAssertTrue(row.needsReload, @"Row marked for reload doesn't indicate it requires reload.");
}

- (void)test_canBeDeleted {
	JSMStaticRow *row = self.row;

	XCTAssertEqual(row.editingStyle, UITableViewCellEditingStyleNone, @"Unprepared row doesn't have editing style of \'None\'.");
	XCTAssertFalse(row.canBeDeleted, @"Unprepared row inaccurately indicates that it can be deleted.");

	row.canBeDeleted = YES;

	XCTAssertEqual(row.editingStyle, UITableViewCellEditingStyleDelete, @"Row marked as being deletable doesn't editing style of \'Delete\'.");
	XCTAssertTrue(row.canBeDeleted, @"Row marked as being deletable doesn't indicate it can be deleted.");

	row.editingStyle = UITableViewCellEditingStyleInsert;

	XCTAssertEqual(row.editingStyle, UITableViewCellEditingStyleInsert, @"Insertion row doesn't have editing style of \'Insert\'.");
	XCTAssertFalse(row.canBeDeleted, @"Insertion row inaccurately indicates that it can be deleted.");

	row.canBeDeleted = NO;

	XCTAssertEqual(row.editingStyle, UITableViewCellEditingStyleInsert, @"Insertion row should not change style when `canBeDeleted` is set to NO.");

	row.canBeDeleted = YES;

	XCTAssertEqual(row.editingStyle, UITableViewCellEditingStyleDelete, @"Row marked as being deletable doesn't editing style of \'Delete\'.");
	XCTAssertTrue(row.canBeDeleted, @"Row marked as being deletable doesn't indicate it can be deleted.");
}

@end
