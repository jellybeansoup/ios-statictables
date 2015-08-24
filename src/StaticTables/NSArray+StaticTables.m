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

#import "NSArray+StaticTables.h"

@implementation NSArray (StaticTables)

- (NSArray *)jsm_longestCommonSubsequenceWithArray:(NSArray *)array {
    NSUInteger x = self.count;
    NSUInteger y = array.count;
    NSMutableArray<NSMutableArray<NSNumber *> *> *lens = [NSMutableArray arrayWithCapacity:x + 1];
    for( NSUInteger i = 0; i < x + 1; i++ ) {
        NSMutableArray<NSNumber *> *subarray = [NSMutableArray arrayWithCapacity:y + 1];
        for( NSUInteger j = 0; j < y + 1; j++ ) {
            [subarray insertObject:@(0) atIndex:j];
        }
        [lens insertObject:subarray atIndex:i];
    }
    NSMutableArray *result = [NSMutableArray array];

    for( NSUInteger i = 0; i < x; i++ ) {
        for( NSUInteger j = 0; j < y; j++ ) {
            if( [self[i] isEqual:array[j]] ) {
                lens[i + 1][j + 1] = @(lens[i][j].unsignedIntegerValue + 1);
            } else {
                lens[i + 1][j + 1] = @(MAX(lens[i + 1][j].unsignedIntegerValue, lens[i][j + 1].unsignedIntegerValue));
            }
        }
    }

    while( x != 0 && y != 0 ) {
        if( [lens[x][y] isEqualToNumber:lens[x - 1][y]] ) {
            --x;
        }
        else if( [lens[x][y] isEqualToNumber:lens[x][y - 1]] ) {
            --y;
        }
        else {
            [result insertObject:self[x - 1] atIndex:0];
            --x;
            --y;
        }
    }

    return result;
}

- (void)jsm_compareToArray:(NSArray *)array usingBlock:(void(^)(id object, NSUInteger fromIndex, NSUInteger toIndex))differences {
    NSArray *lcs = [self jsm_longestCommonSubsequenceWithArray:array];

    NSUInteger left_i = 0;
    NSUInteger right_i = 0;

    NSUInteger totalOffset = 0;

    NSMutableArray *moved = [NSMutableArray array];

    for( id<NSObject> commonElement in lcs ) {
        NSUInteger leftOffset = 0;
        NSUInteger rightOffset = 0;

        // find index of el in left
        while( true ) {
            if( [self[left_i] isEqual:commonElement] ) {
                break;
            }
            else {
                left_i++;
                leftOffset++;
            }
        }

        // find index of el in right
        while( true ) {
            if( [array[right_i] isEqual:commonElement] ) {
                break;
            } else {
                right_i++;
                rightOffset++;
            }
        }

        // if offsets differ, add to list of changes
        if( rightOffset > leftOffset ) {
            NSUInteger length = rightOffset - leftOffset;
            NSUInteger pos = left_i + totalOffset;
            for( NSUInteger i = 0; i < length; i++ ) {
                id object = [array objectAtIndex:pos + i];
                NSUInteger rpos = [self indexOfObject:object];
                if( rpos != NSNotFound ) {
                    [moved addObject:object];
                    differences( object, rpos, pos + i );
                }
                else {
                    differences( object, NSNotFound, pos + i );
                }
            }
            //totalOffset += length
        }
        else if( leftOffset > rightOffset ) {
            NSUInteger length = leftOffset - rightOffset;
            NSUInteger pos = left_i - length + totalOffset;
            for( NSUInteger i = 0; i < length; i++ ) {
                id object = [self objectAtIndex:pos + i];
                if( ! [moved containsObject:object] ) {
                    differences( object, pos + i, NSNotFound );
                }
            }
            //totalOffset -= length
        }

        // start search with next element
        left_i++;
        right_i++;
    }

    // elements after last common element
    NSUInteger afterLastInLeft = self.count - left_i;
    NSUInteger afterLastInRight = array.count - right_i;
    if( afterLastInRight > afterLastInLeft ) {
        NSUInteger length = afterLastInRight - afterLastInLeft;
        NSUInteger pos = left_i + totalOffset;
        for( NSUInteger i = 0; i < length; i++ ) {
            id object = [array objectAtIndex:pos + i];
            NSUInteger rpos = [self indexOfObject:object];
            if( rpos != NSNotFound ) {
                [moved addObject:object];
                differences( object, rpos, pos + i );
            }
            else {
                differences( object, NSNotFound, pos + i );
            }
        }
    }
    else if( afterLastInLeft > afterLastInRight ) {
        NSUInteger length = afterLastInLeft - afterLastInRight;
        NSUInteger pos = left_i + totalOffset;
        for( NSUInteger i = 0; i < length; i++ ) {
            id object = [self objectAtIndex:pos + i];
            if( ! [moved containsObject:object] ) {
                differences( object, pos + i, NSNotFound );
            }
        }
    }
}

@end
