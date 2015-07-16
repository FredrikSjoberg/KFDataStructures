/*
 MIT License
 
 Copyright (c) 2014 Fredrik Sjöberg
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "KFTreeMap.h"

#pragma mark -
#pragma mark - TreeMap
#pragma mark - Private
@interface KFTreeMap ()

@property (nonatomic, strong) NSMutableSet *roots;
@property (nonatomic, strong) NSMutableSet *members;

@end


#pragma mark -
#pragma mark - TreeLeaf
#pragma mark - Implementation
@implementation KFTreeMap

#pragma mark - Init
-(id) init
{
    if ((self = [super init])) {
        _roots = [[NSMutableSet alloc] init];
        _members = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark -
-(void) addRootForObject:(id)rootObject
{
    if (![self containsRootWithObject:rootObject]) {
        KFTreeLeaf *leaf = [[KFTreeLeaf alloc] initWithObject:rootObject];
        [[self roots] addObject:leaf];
        [[self members] addObject:leaf];
    }
}

#pragma mark -
-(void) growBranchForObject:(id)branchObject withObject:(id)object
{
    if (![self containsLeafWithObject:object]) {
        KFTreeLeaf *leaf = [self getLeafForObject:branchObject];
        if (leaf) {
            KFTreeLeaf *newLeaf = [[KFTreeLeaf alloc] initWithObject:object parentLeaf:leaf];
            [leaf addChildLeaf:newLeaf];
            [[self members] addObject:newLeaf];
        }
    }
}

-(NSArray *) getRootBranchForObject:(id)object
{
    KFTreeLeaf *leaf = [self getLeafForObject:object];
    if (leaf) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        [list addObject:leaf];
        
        KFTreeLeaf *parent = leaf.parent;
        while (parent) {
            [list insertObject:parent atIndex:0];
            
            parent = parent.parent;
        }
        return [NSArray arrayWithArray:list];
    }
    // Object not associated with a Leaf.
    return [NSArray array];
}

-(NSUInteger) numberOfRoots
{
    return [[self roots] count];
}

-(NSUInteger) numberOfLeaves
{
    return [[self members] count];
}

#pragma mark -
-(KFTreeLeaf *) getLeafForObject:(id)object
{
    for (KFTreeLeaf *leaf in self.members) {
        if ([leaf object] == object) {
            return leaf;
        }
    }
    return nil;
}

-(BOOL) containsRootWithObject:(id)object
{
    for (KFTreeLeaf *leaf in self.roots) {
        if ([leaf object] == object) {
            return YES;
        }
    }
    return NO;
}

-(BOOL) containsLeafWithObject:(id)object
{
    for (KFTreeLeaf *leaf in self.members) {
        if ([leaf object] == object) {
            return YES;
        }
    }
    return NO;
}

@end



#pragma mark -
#pragma mark - TreeLeaf
#pragma mark - Private
@interface KFTreeLeaf ()

@property (nonatomic, strong, readwrite) id object;
@property (nonatomic, weak, readwrite) KFTreeLeaf *parent;
@property (nonatomic, strong) NSMutableSet *children;

@end

#pragma mark -
#pragma mark - TreeLeaf
#pragma mark - Implementation
@implementation KFTreeLeaf

-(id) initWithObject:(id)object
{
    if ((self = [super init])) {
        _object = object;
        _parent = nil;
        _children = [[NSMutableSet alloc] init];
    }
    return self;
}

-(id) initWithObject:(id)object parentLeaf:(KFTreeLeaf *)leaf
{
    if ((self = [self initWithObject:object])) {
        _parent = leaf;
    }
    return self;
}

-(void) addChildLeaf:(KFTreeLeaf *)leaf
{
    [[self children] addObject:leaf];
}

-(BOOL) hasChildLeaves
{
    return ([[self children] count] == 0 ? NO : YES);
}

@end