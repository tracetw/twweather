#import "TWBasicViewController.h"

@interface TWBasicTableViewController : TWBasicViewController <UITableViewDataSource, UITableViewDelegate>
- (instancetype)initWithStyle:(UITableViewStyle)inStyle;
@property (retain, nonatomic) UITableView *tableView;
@end
