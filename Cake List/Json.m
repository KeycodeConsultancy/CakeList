#import "Json.h"
#import "Cake.h"
#import "Constants.h"

@implementation Json

-(void)getCakesFromAPI:(void (^)(NSMutableArray *responseDict))success failure:(void(^)(NSError* error))failure{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:CAKE_JSON_API];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (error || [httpResponse statusCode]!=200) {
            failure(error);
        }
        else {
            NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            Cake *cake = nil;
            NSMutableArray *cakes = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < [json count]; i++) {
                cake  = [[Cake alloc]init];
                cake.title = [json valueForKey:@"title"][i];
                cake.imageURL = [json valueForKey:@"image"][i];
                cake.cakeDescription = [json valueForKey:@"desc"][i];
                [cakes addObject:cake];
                cake = nil;
            }
            
            success(cakes);
            cakes = nil;
        }
    }];
    [dataTask resume];
}

@end
