/***********************************************************************************
 **  QuickFetch.h
 **  QuickFetch
 **
 **  Created by Daniel Child on 3/20/09.
 **  Copyright 2009 EideticVisions LLC. All rights reserved.
 **
 **  This is a simpler version of code I found on the web. I decided to remove
 **  the error checking and to return an array. It would also be better to set
 **  a second method that returns sorted items.
 ***********************************************************************************/

#import <Cocoa/Cocoa.h>


@interface NSManagedObjectContext (QuickFetch)


// returns the number of entities of a certain type
- (NSUInteger) quickCount: (NSString *) entityName;

// returns the number of entities of a certain type matching the predicate
- (NSUInteger) quickCount: (NSString *) entityName
            withPredicate: (NSPredicate *) predicate;

// returns an array meeting the predicate criterion
- (NSArray *) quickFetch: (NSString *) entityName
           withPredicate: (NSPredicate *) predicate;

// (returns all the objects having the type of entity
- (NSArray *) fetchAll: (NSString *) entityName;

// returns a sorted array meeting the predicate and sort criteria
- (NSArray *) quickFetch: (NSString *) entityName
           withPredicate: (NSPredicate *) predicate
       andSortDescriptor: (NSArray *) sortDescriptors; // SHOULD FIX THIS SO DON'T NEED TO PASS THE ARRAY, HANDLE ARRAY INTERNALLY TO METHOD

// deletes all the entities of a certain type
- (void) deleteAllObjectsOfType: (NSString *) entityName;
@end
