//
//  QuickFetch.m
//  QuickFetch
//
//  Created by Daniel Child on 3/20/09.
//  Copyright 2009 EideticVisions LLC. All rights reserved.
//

#import "QuickFetch.h"


@implementation NSManagedObjectContext (QuickFetch)

// returns the number of entities of a certain type
- (NSUInteger) quickCount: (NSString *) entityName
{
    NSArray *allObjects = [self fetchAll: entityName];
    NSUInteger numObjects = [allObjects count];
    return numObjects;
}

// returns the number of entities of a certain type matching the predicate
- (NSUInteger) quickCount: (NSString *) entityName
            withPredicate: (NSPredicate *) predicate
{
    NSArray *allObjects = [self quickFetch: entityName withPredicate: predicate];
    NSUInteger numMatches = [allObjects count];
    return numMatches;
}

/*********************************************************************************
 ** deleteAllObjectsOfType
 **
 ** Deletes all the objects in the managed object context of type specified
 **********************************************************************************/
- (void) deleteAllObjectsOfType: (NSString *) entityName
{
    NSArray *allObjects = [self quickFetch: entityName withPredicate: nil];
    NSUInteger count = 0;
    for (id object in allObjects) {
        [self deleteObject: object];
        count++;
        if (count%200 == 0) {
            [self save: nil];
            NSLog(@"Deleted another 200 objects of type %@\n", entityName);
        }
    }
    [self save: nil];
    
    // NEW APPROACH
    /* DOES NOT WORK YET
     NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName: entityName];
     NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest: request];
     
     NSError *deleteError = nil;
     [myPersistentStoreCoordinator executeRequest:delete withContext:myContext error:&deleteError]; */
}

/*********************************************************************************
 ** fetchAll
 **
 ** Fetches all the objects in the managed object context of type specified
 **********************************************************************************/
- (NSArray *) fetchAll: (NSString *) entityName
{
    NSArray *allObjects = [self quickFetch: entityName withPredicate: nil];
    return allObjects;
}


/***********************************************************************************
 ** quickFetch: withPredicate:
 **
 ** Returns an array without sorting. Note that the predicate and entity should be
 ** correct. You should be able to adapt this within subclasses of NSManagedObject.
 ** For example,
 **
 ** fetchFantiWithPredicate:
 ** fetchKanjiWithPredicate:
 ** fetchJiantiWithPredicate:
 **
 ** so that the entities are wired in. This makes the whole process much more usable.
 ***********************************************************************************/
- (NSArray *) quickFetch: (NSString *) entityName
           withPredicate: (NSPredicate *) predicate
{
    NSEntityDescription *entity = [NSEntityDescription entityForName: entityName
                                              inManagedObjectContext: self];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: entity];
    [request setPredicate: predicate];
    
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest: request error: &error];
    
    if (error != nil)
    {
        [NSException raise: NSGenericException format: @""];
    }
    
    return results;
}

/***********************************************************************************
 ** quickFetch: withPredicate: andSortDescriptor:
 **
 ** Returns an array with sorting. Note that the predicate, entity, and sortDescriptors
 ** should be correct. You should be able to adapt this within subclasses of
 ** NSManagedObject. For example,
 **
 ** fetchFantiMatching: orderBy:
 ** fetchKanjiMatching: orderBy:
 ** fetchJiantiMatching: orderBy:
 **
 ** so that the entities are wired in. This makes the whole process much more usable.
 ***********************************************************************************/
- (NSArray *) quickFetch: (NSString *) entityName
           withPredicate: (NSPredicate *) predicate
       andSortDescriptor: (NSArray *) sortDescriptors
{
    NSEntityDescription *entity = [NSEntityDescription entityForName: entityName
                                              inManagedObjectContext: self];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: entity];
    [request setPredicate: predicate];
    [request setSortDescriptors: sortDescriptors];
    
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest: request error: &error];
    
    if (error != nil)
    {
        [NSException raise: NSGenericException format: @""];
    }
    return results;	
}

@end
