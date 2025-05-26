//
//  ToDoViewController.h
//  final
//
//  Created by Macos on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property NSMutableArray<Task*> *highPriority;
@property NSMutableArray<Task*> *mediumPriority;
@property NSMutableArray<Task*> *lowPriority;

- (void)showAlert:(NSIndexPath*) indexPath tableView:(UITableView*)tableView;
@end

NS_ASSUME_NONNULL_END
