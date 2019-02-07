//
// Copyright © 2017 Daniel Farrelly
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

@interface JSMDataSourceTests : XCTestCase

@end

@implementation JSMDataSourceTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (JSMStaticDataSource *)simpleDataSource {
    JSMStaticDataSource *dataSource = [JSMStaticDataSource new];
    for( NSString *sectionKey in @[ @"a", @"b", @"c", @"d" ] ) {
        JSMStaticSection *section = [JSMStaticSection sectionWithKey:sectionKey];
        [dataSource addSection:section];
        for( NSString *rowKey in @[ @"one", @"two", @"three", @"four" ] ) {
            JSMStaticRow *row = [JSMStaticRow rowWithKey:rowKey];
            [section addRow:row];
        }
    }
    [dataSource addSection:[self simpleSection]];
    return dataSource;
}

- (JSMStaticSection *)simpleSection {
    JSMStaticSection *section = [JSMStaticSection sectionWithKey:@"simpleSection"];
    for( NSString *rowKey in @[ @"one", @"two" ] ) {
        JSMStaticRow *row = [JSMStaticRow rowWithKey:rowKey];
        [section addRow:row];
    }
    [section addRow:[self simpleRow]];
    for( NSString *rowKey in @[ @"three", @"four" ] ) {
        JSMStaticRow *row = [JSMStaticRow rowWithKey:rowKey];
        [section addRow:row];
    }
    return section;
}

- (JSMStaticRow *)simpleRow {
    return [JSMStaticRow rowWithKey:@"simpleRow"];
}

#pragma mark - Tests

- (void)testNewDataSource {
    JSMStaticDataSource *dataSource = [JSMStaticDataSource new];

    XCTAssertNotNil( dataSource, @"Datasource was not created." );
}

- (void)testDetectionOfSections {
    JSMStaticDataSource *dataSource = [self simpleDataSource];

    JSMStaticSection *section = [JSMStaticSection new];

    XCTAssertTrue( [dataSource containsSection:[self simpleSection]], @"Demonstration datasource should contain demonstration section." );
    XCTAssertFalse( [dataSource containsSection:section], @"Demonstration datasource should not contain section that has not been added." );

    XCTAssertNotNil( [dataSource sectionWithKey:@"simpleSection"], @"Section with key 'simpleSection' should be retrievable from data source." );
    XCTAssertNil( [dataSource sectionWithKey:@"quack"], @"Section with key 'quack' should not be retrievable from data source." );
}

- (void)testDetectionOfRows {
    JSMStaticSection *section = [self simpleSection];

    JSMStaticRow *row = [JSMStaticRow new];

    XCTAssertTrue( [section containsRow:[self simpleRow]], @"Demonstration section should contain demonstration row." );
    XCTAssertFalse( [section containsRow:row], @"Demonstration section should not contain section that has not been added." );

    XCTAssertNotNil( [section rowWithKey:@"simpleRow"], @"Row with key 'simpleRow' should be retrievable from section." );
    XCTAssertNil( [section rowWithKey:@"quack"], @"Row with key 'quack' should not be retrievable from section." );
}

- (void)testCreateSection {
    JSMStaticDataSource *dataSource = [JSMStaticDataSource new];
    JSMStaticSection *section = [dataSource createSection];

    XCTAssertNotNil( section, @"Section was not created." );
    XCTAssertEqualObjects( section.dataSource, dataSource, @"Section was not added to datasource." );
    XCTAssertTrue( [dataSource.sections containsObject:section], @"Section is not available in datasource sections array." );
}

- (void)testCreateRow {
    JSMStaticSection *section = [JSMStaticSection section];
    JSMStaticRow *row = [section createRow];

    XCTAssertNotNil( row, @"Row was not created." );
    XCTAssertEqualObjects( row.section, section, @"Row was not added to section." );
    XCTAssertTrue( [section.rows containsObject:row], @"Row is not available in section rows array." );
}

- (void)testInsertSection {
    NSString *key = @"example";
    NSUInteger index = 1;

    JSMStaticDataSource *dataSource = [self simpleDataSource];
    JSMStaticSection *section = [JSMStaticSection sectionWithKey:key];
    [dataSource insertSection:section atIndex:index];

    XCTAssertEqual( [dataSource indexForSection:section], index, @"Index for section as declared by the data source does not match the supplied index." );
    XCTAssertEqualObjects( [dataSource sectionAtIndex:index], section, @"Section was not inserted at supplied index." );
    XCTAssertEqualObjects( [dataSource sectionWithKey:key], section, @"Section is not retrievable with supplied key." );
}

- (void)testInsertRow {
    NSString *key = @"example";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];

    JSMStaticDataSource *dataSource = [self simpleDataSource];
    JSMStaticRow *row = [JSMStaticRow rowWithKey:key];
    [dataSource insertRow:row atIndexPath:indexPath];

    XCTAssertEqualObjects( [dataSource indexPathForRow:row], indexPath, @"Index path for row as declared by the data source does not match the supplied index path." );
    XCTAssertEqualObjects( [dataSource rowAtIndexPath:indexPath], row, @"Row was not inserted at supplied index path." );
    XCTAssertEqualObjects( [dataSource rowWithKey:key], row, @"Row is not retrievable with supplied key." );
}

@end
