//
//  NSManagedObjectContext+FetchedObjectFromURI.h
//  Tisk Task 4
//
//  Created by Jordan Zucker on 12/20/11.
//  Copyright (c) 2011 University of Illinois. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (FetchedObjectFromURI)

- (NSManagedObject *) objectWithURI:(NSURL *)uri;


@end
