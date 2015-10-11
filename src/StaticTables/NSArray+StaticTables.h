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

#import <Foundation/Foundation.h>

@class JSMStaticChange;

@interface NSArray<ObjectType> (StaticTables)

/// Determines the least number of changes (inserts, deletions, moves and updates) that need to be performed to the
/// receiver to match the given `array`.
///
/// @param array The array to compare the receiver to.
/// @return Collection of objects reflecting individual changes that need to be performed for the receiver to match the given array.
- (NSArray<JSMStaticChange *> *)jst_changesRequiredToMatchArray:(NSArray<ObjectType> *)array;

@end

/// Class defining a change when comparing two arrays.
@interface JSMStaticChange : NSObject <NSCopying>

/// The object involved in the change.
@property (nonatomic, readonly) id object;

/// The index the item is being removed from.
@property (nonatomic, readonly) NSUInteger fromIndex;

/// The index the item is being inserted at.
@property (nonatomic, readonly) NSUInteger toIndex;

@end
