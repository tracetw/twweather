#import "TWBasicViewController.h"

@interface TWBasicTableViewController : TWBasicViewController <UITableViewDataSource, UITableViewDelegate>
- (instancetype)initWithStyle:(UITableViewStyle)inStyle;
@property (strong, nonatomic) UITableView *tableView;
@end
