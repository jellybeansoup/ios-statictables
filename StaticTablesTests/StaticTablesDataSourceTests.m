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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "StaticTables.h"

@interface StaticTablesDataSourceTests : XCTestCase

@end

@implementation StaticTablesDataSourceTests

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
    return dataSource;
}

#pragma mark - Tests

- (void)testNewDataSource {
    JSMStaticDataSource *dataSource = [JSMStaticDataSource new];

    XCTAssertNotNil( dataSource, @"Datasource was not created." );
}

- (void)testNewSection {
    JSMStaticSection *section = [JSMStaticSection section];

    XCTAssertNotNil( section, @"Section was not created." );
}

- (void)testNewSectionWithKey {
    NSString *key = @"example";
    JSMStaticSection *sectionWithKey = [JSMStaticSection sectionWithKey:key];

    XCTAssertNotNil( sectionWithKey, @"Section was not created with key." );
    XCTAssertEqualObjects( sectionWithKey.key, key, @"Section was not given key correctly." );
}

- (void)testNewRow {
    JSMStaticRow *row = [JSMStaticRow row];

    XCTAssertNotNil( row, @"Row was not created." );
}

- (void)testNewRowWithKey {
    NSString *key = @"example";
    JSMStaticRow *rowWithKey = [JSMStaticRow rowWithKey:key];

    XCTAssertNotNil( rowWithKey, @"Row was not created with key." );
    XCTAssertEqualObjects( rowWithKey.key, key, @"Row was not given key correctly." );
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
