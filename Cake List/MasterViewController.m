

#import "MasterViewController.h"
#import "CakeCell.h"

@interface MasterViewController ()
@property (strong, nonatomic) NSArray<Cake *>* cakes;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCakesFromAPI];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cakes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CakeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CakeCell" forIndexPath:indexPath];
        
        cell.cakeImageView.image = nil;
        cell.titleLabel.text =  self.cakes[indexPath.row].title;
        cell.descriptionLabel.text =  self.cakes[indexPath.row].cakeDescription;
    
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   
                   // retrive image on global queue
                   NSURL *aURL = [NSURL URLWithString:self.cakes[indexPath.row].imageURL];
                    NSData *data = [NSData dataWithContentsOfURL:aURL];
                   
                   UIImage *image = [UIImage imageWithData:data];

                   dispatch_async(dispatch_get_main_queue(), ^{

                       CakeCell * cell = (CakeCell *)[tableView cellForRowAtIndexPath:indexPath];
                     // assign cell image on main thread, should really use SDWebImage library.
                       if (data == nil) {
                           cell.cakeImageView.image = [UIImage imageNamed:@"Image-Unavailable.jpg"];
                       } else {
                           cell.cakeImageView.image = image;
                       }
                       
                   });
               });

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)getCakesFromAPI {
    Json *json =[[Json alloc]init];
    self.tableView.hidden = YES;
    
    [json getCakesFromAPI:^(NSMutableArray * responseDict) {
        self.cakes = [responseDict copy];
        dispatch_async(dispatch_get_main_queue(), ^{
         
            [self.tableView reloadData];
            self.tableView.hidden = NO;
        });
        
    } failure:^(NSError *error) {
        NSLog(@"Error");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.hidden = YES;
        });
        
    }];
    
    json = nil;
}

@end
