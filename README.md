# StaticTables

A library for quickly creating programmatic tableviews for display of preferences, or even more dynamic content.

[![Build Status](https://travis-ci.org/jellybeansoup/ios-statictables.svg?branch=master)](https://travis-ci.org/jellybeansoup/ios-statictables)
[![Code Coverage](https://codecov.io/gh/jellybeansoup/ios-statictables/branch/master/graph/badge.svg)](https://codecov.io/gh/jellybeansoup/ios-statictables)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/StaticTables.svg)](https://cocoapods.org/pods/StaticTables)

## Installation

There are a couple of ways to include StaticTables in your Xcode project.

### Subproject

This method is demonstrated in the included example project (example/StaticTablesExample.xcodeproj).

1. Drag the `StaticTables.xcodeproj` file into your Project Navigator (⌘1) from the Finder. This should add StaticTables as a subproject of your own project (denoted by the fact that it appears as in a rectangle and you should be able to browse the project structure).

2. In your Project's target, under the Build Phases tab, add `libStaticTables` or `StaticTables` under 'Link Binary with Libraries'. The difference between these two items is that the former is a static library and the latter is a dynamic framework. Dynamic frameworks are not supported on iOS prior to iOS7, while static libraries are not supported by Swift.

3. While you're in the Build Phases tab, add `libStaticTables.a` or `StaticTables.framework` under 'Target Dependencies'. Choose the option that matches what you selected in the previous step.

4. If you're using the dynamic framework, you'll need to add it under 'Embed Frameworks' as well. This ensures that it's distributed as part of your app bundle. Alternatively, if you're using the static library, do a search for 'Header Search Paths' under the Build Settings tab of you Project's target. Add the path to the `/src/StaticTables/` folder of the StaticTables project. This should look something like `"$(SRCROOT)/Vendor/src/StaticTables/"`, replacing the `Vendor` with the relative path from your project to the StaticTables project.

5. While you're in Build Settings, search for 'Other Linker Flags'. In order to use the included categories on `UITableView`, you'll need to ensure this setting includes the `-ObjC` flag.

6. Build your project (⌘B). All going well you should get a 'Build Succeeded' notification. This signifies that you're ready to implement StaticTables in your project.

### CocoaPods

StaticTables can be installed *very* easily if you use [CocoaPods](http://cocoapods.org) with your projects. The podspec is included in the Github repository, and is also available through [cocoapods.org](http://cocoapods.org/?q=statictables).

Simply add the project to your `Podfile` by adding the line:

```ruby 
pod 'StaticTables'
```

And run `pod update` in terminal to update the pods you have included in your project.

You can also specify a version to include, such as 0.1.0:

```ruby
pod 'StaticTables', '0.1.0'
```

For more information on how to add projects using CocoaPods, read [their documentation on Podfiles](http://docs.cocoapods.org/podfile.html).

## Implementing StaticTables

At the top of the header file for the view controller you want to implement StaticTables in, include StaticTables:

```objc
#import "StaticTables.h"
```

The syntax for including the dynamic framework is a little different:

```objc
#import <StaticTables/StaticTables.h>
```

Implementing StaticTables can easily be done by simply subclassing `JSMStaticTableViewController` the same way you would `UITableViewController`. This class contains some default implementation, and you immediately begin building your initial data source in `viewDidLoad`.

```objc
- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Create an add a basic section
	JSMStaticSection *employees = [JSMStaticSection section];
	employees.headerText = @"Employees";
	[self.dataSource addSection:employees];
	
	// Now we just add a couple of rows
	JSMStaticRow *becky = [JSMStaticRow row];
	becky.text = @"Becky";
	becky.detailText = @"Ticketing";
	becky.style = UITableViewCellStyleSubtitle;
	[employees addRow:becky];
	
	JSMStaticRow *jason = [JSMStaticRow row];
	jason.text = @"Jason";
	jason.detailText = @"Ticketing";
	jason.style = UITableViewCellStyleSubtitle;
	[employees addRow:jason];
}
```

If `JSMStaticTableViewController` doesn't fit your needs, you can set up `JSMStaticDataSource` as the data source for any instance of `UITableView`, which gives you greater flexibility and control.

```objc
- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Create and insert the tableview
	UITableView *tableView = [[UITableView alloc] initWithStyle:UITableViewStyleGrouped];
	[self.view addSubview:tableView];
	
	// Create the data source instance
	JSMStaticDataSource *dataSource = [JSMStaticDataSource new];
	tableView.dataSource = dataSource;
	
	// Create an add a basic section
	JSMStaticSection *employees = [JSMStaticSection section];
	employees.headerText = @"Employees";
	[dataSource addSection:employees];

	...
}
```

Once the initial data is loaded, you can use the included category for `UITableView` to add, move and delete rows from the data source, with automatic animation applied to them. This is particularly useful for simple table view structures, such as preference screens that have sections or rows that respond to the user's input.

```objc
[tableView performUpdates:^{
	[tableView addSection:newSection withRowAnimation:UITableViewRowAnimationAutomatic];
} withCompletion:^{
	NSLog(@"Oh look, the table view section has finished animating into place.");
}];
```

For more extensive details on what methods are available, take a look at the included example project (example/StaticTablesExample.xcodeproj), or the documentation, which can be built from the header files using [appledoc](http://gentlebytes.com/appledoc/) (there is a preconfigured target in the main project).

## Why is this project named StaticTables, when it's clearly not really static at all?

The project was originally designed as an alternative to creating static table views in storyboards, so that I could construct the settings views for [GIFwrapped](http://gifwrapped.co) without having to wrestle with the default methods of writing table views programmatically.

Obviously it's come a long way since then, and honestly, I'm way too lazy to rename it.

## Released under the BSD License

Copyright © 2014 Daniel Farrelly

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

*	Redistributions of source code must retain the above copyright notice, this list
	of conditions and the following disclaimer.
*	Redistributions in binary form must reproduce the above copyright notice, this
	list of conditions and the following disclaimer in the documentation and/or
	other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
