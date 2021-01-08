

#import <Foundation/Foundation.h>

@interface Json : NSObject

-(void)getCakesFromAPI:(void (^)(NSMutableArray *responseDict))success failure:(void(^)(NSError* error))failure;
@end
