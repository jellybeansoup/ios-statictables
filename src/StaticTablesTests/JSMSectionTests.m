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

@interface JSMSectionTests : XCTestCase

@property (nonatomic, strong) JSMStaticSection *section;

@end

@implementation JSMSectionTests

- (JSMStaticSection *)section {
	if( _section == nil ) {
		_section = [JSMStaticSection section];

		for( NSString *rowKey in @[ @"one", @"two", @3, @"four", @5 ] ) {
			[_section addRow:[JSMStaticRow rowWithKey:rowKey]];
		}
	}

	return _section;
}

#pragma mark - Creating Sections

- (void)test_section {
	JSMStaticSection *section = [JSMStaticSection section];

	XCTAssertNotNil(section, @"Section was not created.");
	XCTAssertNil(section.key, @"Section created without a key does not have a nil key.");
}

- (void)test_sectionWithKey {
	JSMStaticSection *section1 = [JSMStaticSection sectionWithKey:@"test"];
	XCTAssertNotNil(section1, @"Section was not created with the key `test`.");
	XCTAssertEqualObjects(section1.key, @"test", @"Section created with the key `test` does not have the correct key.");

	JSMStaticSection *section2 = [JSMStaticSection sectionWithKey:@42];
	XCTAssertNotNil(section2, @"Section was not created with the key `42`.");
	XCTAssertEqualObjects(section2.key, @42, @"Section created with the key `42` does not have the correct key.");

	XCTAssertNotEqualObjects(section1, section2, @"Sections created with different keys should not be equal.");
}

#pragma mark - Managing the Section's Content

- (void)test_addRow {
	JSMStaticRow *row = [JSMStaticRow row];
	[self.section addRow:row];

	XCTAssertEqualObjects(self.section.rows.lastObject, row, @"Added row couldn't be found at the expected index.");
	XCTAssertEqualObjects(self.section, row.section, @"Added row does not declare the correct parent section.");
}

- (void)test_insertRowAtIndex {
	JSMStaticRow *row = [JSMStaticRow row];
	[self.section insertRow:row atIndex:3];

	XCTAssertEqualObjects(self.section.rows[3], row, @"Inserted row couldn't be found at the expected index.");
	XCTAssertEqualObjects(self.section, row.section, @"Inserted row does not declare the correct parent section.");
}

- (void)test_createRow {
	JSMStaticRow *row = [self.section createRow];

	XCTAssertNotNil(row, @"Row was not created.");
	XCTAssertNil(row.key, @"Row created without a key does not have a nil key.");
	XCTAssertEqualObjects(self.section.rows.lastObject, row, @"Created row couldn't be found at the expected index.");
	XCTAssertEqualObjects(self.section, row.section, @"Created row does not declare the correct parent section.");
}

- (void)test_createRowAtIndex {
	JSMStaticRow *row = [self.section createRowAtIndex:3];

	XCTAssertNotNil(row, @"Row was not created.");
	XCTAssertNil(row.key, @"Row created without a key does not have a nil key.");
	XCTAssertEqualObjects(self.section.rows[3], row, @"Created row couldn't be found at the expected index.");
	XCTAssertEqualObjects(self.section, row.section, @"Created row does not declare the correct parent section.");
}

- (void)test_rowWithKey {
	for (NSUInteger i = 0; i < self.section.rows.count; i++) {
		NSString *key = self.section.rows[i].key;
		JSMStaticRow *row = [self.section rowWithKey:key];

		XCTAssertTrue([self.section.rows containsObject:row], @"Row does not exist within the section.");
		XCTAssertEqualObjects(self.section.rows[i], row, @"Row at index is different to the fetched row.");
	}
}

- (void)test_rowAtIndex {
	for (NSUInteger i = 0; i < self.section.rows.count; i++) {
		JSMStaticRow *row = [self.section rowAtIndex:i];

		XCTAssertEqualObjects(self.section.rows[i], row, @"Row at index returns a different row to that found in the rows array.");
	}
}

- (void)test_containsRow {
	for (NSUInteger i = 0; i < self.section.rows.count; i++) {
		JSMStaticRow *row = self.section.rows[i];

		XCTAssertTrue([self.section containsRow:row], @"Row does not exist within the section.");
	}
}

- (void)test_removeRowAtIndex {
	JSMStaticRow *row = self.section.rows[2];
	[self.section removeRowAtIndex:2];

	XCTAssertEqual(self.section.rows.count, (unsigned long)4, @"There are more than the expected number of rows.");
	XCTAssertFalse([self.section.rows containsObject:row], @"Row still exists within the section.");
	XCTAssertNotEqualObjects(self.section.rows[2], row, @"Row still exists at the original index within the section.");
	XCTAssertNil(row.section, @"Removed row still declares a parent section.");
}

- (void)test_removeRow {
	JSMStaticRow *row = self.section.rows[2];
	[self.section removeRow:row];

	XCTAssertEqual(self.section.rows.count, (unsigned long)4, @"There are more than the expected number of rows.");
	XCTAssertFalse([self.section.rows containsObject:row], @"Row still exists within the section.");
	XCTAssertNotEqualObjects(self.section.rows[2], row, @"Row still exists at the original index within the section.");
	XCTAssertNil(row.section, @"Removed row still declares a parent section.");
}

- (void)test_removeAllRows {
	[self.section removeAllRows];

	XCTAssertEqual(self.section.rows.count, (unsigned long)0, @"Rows weren't properly removed.");
}

- (void)test_needsReload {
	JSMStaticSection *section = self.section;
	[section setNeedsReload];

	XCTAssertTrue(section.needsReload, @"Row marked for reload doesn't indicate it requires reload.");
	// Sections are not "cleaned" internally; the data source cleans them when the table view reloads it's data.
}

@end
