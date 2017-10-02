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

#import "JSMStaticDelegate.h"

@interface JSMTableView ()

@property (nonatomic, strong, nullable) JSMStaticDelegate *staticDelegate;

@end

@implementation JSMStaticDelegate

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
	return [self.overrideDelegate conformsToProtocol:aProtocol] || [self.internalDelegate conformsToProtocol:aProtocol];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	if( self.overrideDelegate != nil && [self.overrideDelegate respondsToSelector:aSelector] ) {
		return true;
	}
	else if( self.internalDelegate != nil && [self.internalDelegate respondsToSelector:aSelector] ) {
		return true;
	}

	return false;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	if( self.overrideDelegate != nil && [self.overrideDelegate respondsToSelector:aSelector] ) {
		return [(NSObject *)self.overrideDelegate methodSignatureForSelector:aSelector];
	}
	else if( self.internalDelegate != nil && [self.internalDelegate respondsToSelector:aSelector] ) {
		return [(NSObject *)self.internalDelegate methodSignatureForSelector:aSelector];
	}

	[NSException raise:NSInvalidArgumentException format:@"%@ was unable to handle %@ because current delegates do not respond to it.", self, NSStringFromSelector(aSelector)];

	return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	NSMutableArray <id<UITableViewDelegate>> *delegates = [NSMutableArray arrayWithCapacity:2];

	if( self.overrideDelegate != nil && [self.overrideDelegate respondsToSelector:anInvocation.selector] ) {
		[delegates addObject:self.overrideDelegate];
	}

	if( self.internalDelegate != nil && [self.internalDelegate respondsToSelector:anInvocation.selector] ) {
		[delegates addObject:self.internalDelegate];
	}

	if( delegates.count == 0 ) {
		[super forwardInvocation:anInvocation];
	}
	else if( anInvocation.methodSignature.methodReturnLength > 0 ) {
		[anInvocation invokeWithTarget:delegates.firstObject];
	}
	else {
		for( id<UITableViewDelegate> delegate in delegates ) {
			[anInvocation invokeWithTarget:delegate];
		}
	}
}

@end

@implementation JSMTableView

- (JSMStaticDelegate *)staticDelegate {
	if( _staticDelegate == nil ) {
		_staticDelegate = [JSMStaticDelegate alloc];

		if( super.delegate == nil ) {
			// Do nothing
		}
		else if( [super.delegate isKindOfClass:[JSMStaticDelegate class]] ) {
			_staticDelegate.overrideDelegate = [(JSMStaticDelegate *)super.delegate overrideDelegate];
			_staticDelegate.internalDelegate = [(JSMStaticDelegate *)super.delegate internalDelegate];
		}
		else {
			_staticDelegate.overrideDelegate = super.delegate;
		}
	}

	return _staticDelegate;
}

- (id<UITableViewDelegate>)internalDelegate {
	if( super.delegate == nil ) {
		return nil;
	}

	return [(JSMStaticDelegate *)super.delegate internalDelegate];
}

- (void)setInternalDelegate:(id<UITableViewDelegate>)internalDelegate {
	if( internalDelegate == nil && self.staticDelegate.overrideDelegate == nil ) {
		self.staticDelegate = nil;
		super.delegate = nil;

		return;
	}

	JSMStaticDelegate *staticDelegate = self.staticDelegate;
	staticDelegate.internalDelegate = internalDelegate;

	super.delegate = (id<UITableViewDelegate>)staticDelegate;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
	if( delegate != nil && super.delegate == nil ) {
		super.delegate = delegate;

		return;
	}
	else if( delegate == nil && self.staticDelegate.internalDelegate == nil ) {
		self.staticDelegate = nil;
		super.delegate = nil;

		return;
	}

	JSMStaticDelegate *staticDelegate = self.staticDelegate;
	staticDelegate.overrideDelegate = delegate;

	super.delegate = (id<UITableViewDelegate>)staticDelegate;
}

@end
