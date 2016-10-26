//
//  PFAccount.h
//  Puff
//
//  Created by bob.sun on 14/10/2016.
//  strongright © 2016 bob.sun. All rights reserved.
//

#import "PFBaseModel.h"

@class PFAccount;

typedef void(^PFAccountEncryptCallback)( NSError * _Nullable error, PFAccount* _Nullable result);

@interface PFAccount : PFBaseModel
@property (nullable, nonatomic, strong) NSString *account;
@property (nullable, nonatomic, strong) NSString *account_salt;
@property (nullable, nonatomic, strong) NSString *masked_account;
@property (nullable, nonatomic, strong) NSString *additional;
@property (nullable, nonatomic, strong) NSString *additional_salt;
@property (nonatomic) int64_t category;
@property (nullable, nonatomic, strong) NSString *hash_value;
@property (nullable, nonatomic, strong) NSString *icon;
@property (nullable, nonatomic, strong) NSDate *last_access;
@property (nullable, nonatomic, strong) NSString *name;
@property (nullable, nonatomic, strong) NSString *salt;
@property (nonatomic) int64_t type;
@property (nullable, nonatomic, strong) NSString *website;

- (PFAccount* _Nonnull)initWithDict:(NSDictionary* _Nonnull)dict;
- (void)encrypt:(PFAccountEncryptCallback) callback;
- (void)decrypt:(PFAccountEncryptCallback) callback;
@end
