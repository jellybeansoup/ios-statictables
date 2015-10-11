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
#import "JSMStaticSection.h"
#import "JSMStaticRow.h"

@interface JSMStaticChange ()

+ (instancetype)deleteObject:(id)object fromIndex:(NSUInteger)index;

+ (instancetype)insertObject:(id)object atIndex:(NSUInteger)index;

+ (instancetype)moveObject:(id)object fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

+ (instancetype)refreshObject:(id)object atIndex:(NSUInteger)index;

@end

@implementation NSArray (StaticTables)

- (NSArray *)jst_arrayByRemovingObjectsInArray:(NSArray *)array {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ! [array containsObject:evaluatedObject];
    }]];
}

- (NSIndexSet *)jst_indexesOfObjectsInArray:(NSArray *)array {
    return [self indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [array containsObject:obj];
    }];
}

- (NSArray *)jst_longestCommonSubsequenceWithArray:(NSArray *)array {
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

- (NSArray<JSMStaticChange *> *)jst_changesRequiredToMatchArray:(NSArray *)array {
    // Nothing to process
    if( self.count == 0 && array.count == 0 ) return @[];

    // We're going to find all the differences
    NSMutableArray<JSMStaticChange *> *differences = [NSMutableArray array];

    // Deleted items
    NSArray *deletedObjects = [self jst_arrayByRemovingObjectsInArray:array];
    NSIndexSet *deletedIndexes = [self jst_indexesOfObjectsInArray:deletedObjects];
    [deletedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [differences addObject:[JSMStaticChange deleteObject:[self objectAtIndex:idx] fromIndex:idx]];
    }];

    // Inserted items
    NSArray *insertedObjects = [array jst_arrayByRemovingObjectsInArray:self];
    NSIndexSet *insertedIndexes = [array jst_indexesOfObjectsInArray:insertedObjects];
    [insertedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [differences addObject:[JSMStaticChange insertObject:[array objectAtIndex:idx] atIndex:idx]];
    }];

    // Updated items
    NSArray *stable = [self jst_longestCommonSubsequenceWithArray:array];
    [stable enumerateObjectsUsingBlock:^(id _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger index = [self indexOfObject:object];
        if( [object respondsToSelector:@selector(needsReload)] && [object needsReload] ) {
            [differences addObject:[JSMStaticChange refreshObject:object atIndex:index]];
        }
    }];

    // Moved items
    NSArray *modifiedNew = [array jst_arrayByRemovingObjectsInArray:insertedObjects];
    NSArray *unstable = [modifiedNew jst_arrayByRemovingObjectsInArray:stable];
    [unstable enumerateObjectsUsingBlock:^(id _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger oldIndex = [self indexOfObject:object];
        NSUInteger newIndex = [array indexOfObject:object];
        [differences addObject:[JSMStaticChange moveObject:object fromIndex:oldIndex toIndex:newIndex]];
    }];

    return differences.copy;
}

@end

@implementation JSMStaticChange

+ (instancetype)deleteObject:(id)object fromIndex:(NSUInteger)index {
    return [[self alloc] initWithObject:object fromIndex:index toIndex:NSNotFound];
}

+ (instancetype)insertObject:(id)object atIndex:(NSUInteger)index {
    return [[self alloc] initWithObject:object fromIndex:NSNotFound toIndex:index];
}

+ (instancetype)moveObject:(id)object fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    return [[self alloc] initWithObject:object fromIndex:fromIndex toIndex:toIndex];
}

+ (instancetype)refreshObject:(id)object atIndex:(NSUInteger)index {
    return [[self alloc] initWithObject:object fromIndex:index toIndex:index];
}

- (instancetype)initWithObject:(id)object fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if( ( self = [super init] ) ) {
        _object = object;
        _fromIndex = fromIndex;
        _toIndex = toIndex;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[JSMStaticChange allocWithZone:zone] initWithObject:self.object fromIndex:self.fromIndex toIndex:self.toIndex];
}

- (NSString *)description {
    if( self.toIndex == NSNotFound ) {
        return [NSString stringWithFormat:@"<%@Delete: %@; object=%@>",NSStringFromClass(self.class),@(self.fromIndex),self.object];
    }

    else if( self.fromIndex == NSNotFound ) {
        return [NSString stringWithFormat:@"<%@Insert: %@; object=%@>",NSStringFromClass(self.class),@(self.toIndex),self.object];
    }

    else if( self.toIndex == self.fromIndex ) {
        return [NSString stringWithFormat:@"<%@Update: %@; object=%@>",NSStringFromClass(self.class),@(self.toIndex),self.object];
    }

    else {
        return [NSString stringWithFormat:@"<%@Move: %@ -> %@; object=%@>",NSStringFromClass(self.class),@(self.fromIndex),@(self.toIndex),self.object];
    }
}

@end
