//
//  PFCategoryManager.m
//  Puff
//
//  Created by bob.sun on 16/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFCategoryManager.h"
#import "_PFCategory+CoreDataClass.h"

@interface PFCategoryManager()
@property (strong) PFDBManager *dbManager;
@end

@implementation PFCategoryManager
+ (instancetype)sharedManager {
    static PFCategoryManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PFCategoryManager alloc] init];
        instance.dbManager = [[PFDBManager alloc] init];
//        instance.dbManager = [PFDBManager sharedManager];
    });
    return instance;
}

- (NSError*)saveCategory:(PFCategory*)category {
    NSManagedObjectContext *ctx = [_dbManager context];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityNamePFCategory inManagedObjectContext:ctx];
    [category managedObjectWithEntity:entity andContext:ctx];
    
    NSError *err;
    [ctx save:&err];
    return err;
}
- (NSError*)saveCategoryFromDict:(NSDictionary*)dict {
    return [self saveCategory:[[PFCategory alloc] initWithDict:dict]];
}

-(NSArray*)fetchAll {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:kEntityNamePFCategory];
    NSManagedObjectContext *ctx = [_dbManager context];
    NSError *err;
    NSAsynchronousFetchResult *result = [ctx executeRequest:req error:&err];
    if (err) {
        return nil;
    }
    return [PFCategory convertFromRaws:[result finalResult] toWrapped:[PFCategory class]];
}
-(NSArray*)fetchCategoryByType:(int64_t)typeId {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:kEntityNamePFCategory];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"type == %llu", typeId];
    [req setPredicate:filter];
    NSManagedObjectContext *ctx = [_dbManager context];
    NSError *err;
    NSAsynchronousFetchResult *result = [ctx executeRequest:req error:&err];
    if (err) {
        return nil;
    }
    
    return [PFCategory convertFromRaws:[result finalResult] toWrapped:[PFCategory class]];
}

- (PFCategory*)fetchCategoryById:(int64_t)identifier {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:kEntityNamePFCategory];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"identifier == %llu", identifier];
    [req setPredicate:filter];
    NSManagedObjectContext *ctx = [_dbManager context];
    NSError *err;
    NSAsynchronousFetchResult *result = [ctx executeRequest:req error:&err];
    if (err) {
        return nil;
    }
    
    return [[PFCategory convertFromRaws:[result finalResult] toWrapped:[PFCategory class]] firstObject];
}
@end
