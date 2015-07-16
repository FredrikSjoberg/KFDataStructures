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

/*
 * Created by Fredrik Sjöberg on 2014-04-19.
 *
 * A set of simple classes designed to create and keep track of individual data members
 * and how they relate in a tree structure.
 *
 * It is possible to add any kind of object when building the tree.
 * Data members are required to be unique.
 * 
 */

#import <Foundation/Foundation.h>

@class KFTreeLeaf;

#pragma mark -
#pragma mark - TreeMap
#pragma mark - Interface
@interface KFTreeMap : NSObject


#pragma mark -
-(void) addRootForObject:(id)rootObject;

#pragma mark -
/*
 Grows "branch" by one step with associated object
 */
-(void) growBranchForObject:(id)branchObject withObject:(id)object;

/*
 Returns the Branch of KFTreeLeafs with the rootLeaf first.
 If object has no leaf, returns empty array.
 */
-(NSArray *) getRootBranchForObject:(id)object;
-(NSUInteger) numberOfRoots;
-(NSUInteger) numberOfLeaves;

#pragma mark -
-(BOOL) containsRootWithObject:(id)object;
-(BOOL) containsLeafWithObject:(id)object;

@end


#pragma mark -
#pragma mark - TreeLeaf
#pragma mark - Interface
@interface KFTreeLeaf : NSObject

@property (nonatomic, strong, readonly) id object;
@property (nonatomic, weak, readonly) KFTreeLeaf *parent;


#pragma mark - Init
-(id) initWithObject:(id)object;
-(id) initWithObject:(id)object parentLeaf:(KFTreeLeaf *)leaf;

-(void) addChildLeaf:(KFTreeLeaf *)leaf;
-(BOOL) hasChildLeaves;

@end
