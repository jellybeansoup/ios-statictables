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

@interface JSMStaticDelegateTests : XCTestCase <UITableViewDelegate>

@property (nonatomic) BOOL didCallVoidMethod;
@property (nonatomic) BOOL didCallNonVoidMethod;

@end

@interface JSMStaticDelegateViewController : JSMStaticTableViewController

@property (nonatomic) BOOL didCallVoidMethod;
@property (nonatomic) BOOL didCallNonVoidMethod;

@end

@implementation JSMStaticDelegateTests

- (void)setUp {
	self.didCallVoidMethod = NO;
	self.didCallNonVoidMethod = NO;
}

- (void)test_internalDelegate {
	JSMStaticDelegateViewController *viewController = [[JSMStaticDelegateViewController alloc] init];

	UITableView *tableView = viewController.tableView;
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

	[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
	XCTAssertTrue(viewController.didCallVoidMethod, @"Internal delegate should always be called for methods that return void.");

	NSIndexPath *returnedIndexPath = [tableView.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
	XCTAssertTrue(viewController.didCallNonVoidMethod, @"Internal delegate should be called for methods that don't return void when no override delegate exists.");
	XCTAssertEqual(returnedIndexPath.row, 123, @"Value returned from internal delegate should be returned when no override delegate exists.");
}

- (void)test_overrideDelegate {
	JSMStaticDelegateViewController *viewController = [[JSMStaticDelegateViewController alloc] init];
	viewController.tableView.delegate = self;

	UITableView *tableView = viewController.tableView;
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

	[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
	XCTAssertTrue(viewController.didCallVoidMethod, @"Internal delegate should always be called for methods that return void.");
	XCTAssertTrue(self.didCallVoidMethod, @"Override delegate should always be called for methods that return void.");

	NSIndexPath *returnedIndexPath1 = [tableView.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
	XCTAssertFalse(viewController.didCallNonVoidMethod, @"Internal delegate should not be called for methods that don't return void when an override delegate exists.");
	XCTAssertTrue(self.didCallNonVoidMethod, @"Override delegate should be called for methods that don't return void when one exists.");
	XCTAssertEqual(returnedIndexPath1.row, 456, @"Value returned from override delegate should be returned when one exists.");

	viewController.tableView.delegate = nil;

	[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
	XCTAssertTrue(viewController.didCallVoidMethod, @"Internal delegate should always be called for methods that return void.");

	NSIndexPath *returnedIndexPath2 = [tableView.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
	XCTAssertTrue(viewController.didCallNonVoidMethod, @"Internal delegate should be called for methods that don't return void when no override delegate exists.");
	XCTAssertEqual(returnedIndexPath2.row, 123, @"Value returned from internal delegate should be returned when no override delegate exists.");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.didCallVoidMethod = YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.didCallNonVoidMethod = YES;

	return [NSIndexPath indexPathForRow:456 inSection:0];
}

@end

@implementation JSMStaticDelegateViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
	self.didCallVoidMethod = NO;
	self.didCallNonVoidMethod = NO;

	return [super initWithStyle:style];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.didCallVoidMethod = YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.didCallNonVoidMethod = YES;

	return [NSIndexPath indexPathForRow:123 inSection:0];
}

@end
