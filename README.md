#StaticTables

A library for quickly creating programmatic tableviews for display of preferences, or even more dynamic content.

##Installation

There are a couple of ways to include StaticTables in your Xcode project.

###Subproject

This method is demonstrated in the included example project (example/StaticTablesExample.xcodeproj).

1. Drag the `StaticTables.xcodeproj` file into your Project Navigator (⌘1) from the Finder. This should add StaticTables as a subproject of your own project (denoted by the fact that it appears as in a rectangle and you should be able to browse the project structure).

2. In your Project's target, under the Build Phases tab, add `libStaticTables.a` under 'Link Binary with Libraries'.

3. While you're in the Build Phases tab, add `libStaticTables.a` under 'Target Dependencies'.

4. Under the Build Settings tab of you Project's target, do a search for 'Header Search Paths'. Add the path to the `/src/StaticTables/` folder of the StaticTables project. This should look something like `"$(SRCROOT)/../src/StaticTables/"`, replacing the `..` with the relative path from your project to the StaticTables project.

5. While you're in Build Settings, search for 'Other Linker Flags'. In order to use the included categories on `UITableView`, you'll need to ensure this setting includes the `-ObjC` flag.

6. Build your project (⌘B). All going well you should get a 'Build Succeeded' notification. This signifies that you're ready to implement StaticTables in your project.

###Cocoapods

StaticTables can be installed *very* easily if you use [Cocoapods](http://cocoapods.org) with your projects. The podspec is included in the Github repository, and is also available through [cocoapods.org](http://cocoapods.org/?q=statictables).

Simply add the project to your `Podfile` by adding the line:

```ruby 
pod 'StaticTables'
```

And run `pod update` in terminal to update the pods you have included in your project.

You can also specify a version to include, such as 0.1.0:

```ruby
pod 'StaticTables', '0.1.0'
```

For more information on how to add projects using Cocoapods, read [their documentation on Podfiles](http://docs.cocoapods.org/podfile.html).

##Implementing StaticTables

At the top of the header file for the view controller you want to implement StaticTables in, include StaticTables:

```objc
#import "StaticTables.h"
```

More instructions to come.

##Released under the BSD License

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
