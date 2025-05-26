//
//  ToDoViewController.m
//  final
//
//  Created by Macos on 23/04/2025.
//

#import "ToDoViewController.h"
#import "ViewController.h"
#import "CustomToDoTableViewCell.h"
#import "DetailsViewController.h"

@interface ToDoViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property NSMutableArray<Task*> *arr;
@property NSUserDefaults *defult;
@property Task *ref;
@property int proirity ;
@property int sectionsNum;
@property NSMutableArray<Task*> *filteredTasks;
@property BOOL isSearching;

@end

@implementation ToDoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _sectionsNum=3;
        _highPriority = [NSMutableArray new];
        _mediumPriority = [NSMutableArray new];
        _lowPriority = [NSMutableArray new];
    
    _defult = [NSUserDefaults standardUserDefaults];
    NSData *savedData = [_defult objectForKey:@"tasks"];
    if (savedData != nil) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [Task class], nil];
        _arr = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:savedData error:&error];
        for (Task *task in _arr) {
            if (task.priority ==2) {
                       [_highPriority addObject:task];
                   } else if (task.priority==1) {
                       [_mediumPriority addObject:task];
                   } else {
                       [_lowPriority addObject:task];
                   }
               }
    }

    [_myTable reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(NavToAdd)];
    self.navigationItem.rightBarButtonItem = add;
    self.navigationItem.title= @"ToDo";

    // Do any additional setup after loading the view.
    
    _myTable.delegate=self;
    _myTable.dataSource=self;
    _search.delegate = self;
    _filteredTasks = [NSMutableArray new];
    _isSearching = NO;

    _defult=[NSUserDefaults standardUserDefaults];
    NSData *savedData = [_defult objectForKey:@"tasks"];
    if (savedData != nil) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [Task class], nil];
        _arr = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:savedData error:&error];
    }
    [_myTable reloadData];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _isSearching ? @"Search Results" : (section == 2 ? @"High Priority" : section == 1 ? @"Medium Priority" : @"Low Priority");
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return _isSearching?1: 3;
}
- (void)NavToAdd {
    ViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addTask"];
    SVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:SVC animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _isSearching ? _filteredTasks.count : (section == 0 ? _lowPriority.count : section == 1 ? _mediumPriority.count : _highPriority.count);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoCell"];
    Task *task;

    if (_isSearching) {
        task = _filteredTasks[indexPath.row];
    } else {
        switch (indexPath.section) {
            case 0: task = _lowPriority[indexPath.row]; break;
            case 1: task = _mediumPriority[indexPath.row]; break;
            default: task = _highPriority[indexPath.row]; break;
        }
    }

    cell.myLable.text = task.name;
    cell.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", task.priority]];
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showAlert:indexPath tableView:tableView];
    
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *selectedTask;

    if (_isSearching) {
        selectedTask = _filteredTasks[indexPath.row];
    } else {
        switch (indexPath.section) {
            case 0: selectedTask = _lowPriority[indexPath.row]; break;
            case 1: selectedTask = _mediumPriority[indexPath.row]; break;
            case 2: selectedTask = _highPriority[indexPath.row]; break;
            default: return;
        }
    }

    DetailsViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    SVC.task = selectedTask;
    [self.navigationController pushViewController:SVC animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        _isSearching = NO;
    } else {
        _isSearching = YES;
        [_filteredTasks removeAllObjects];
        
        for (Task *task in _arr) {
            if ([task.name.lowercaseString containsString:searchText.lowercaseString]) {
                [_filteredTasks addObject:task];
            }
        }
    }
    [_myTable reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _isSearching = NO;
    [searchBar resignFirstResponder];
    [_myTable reloadData];
}


- (void)showAlert:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task" message:@"Are you sure you want to delete it?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        Task *taskToDelete;
        switch (indexPath.section) {
            case 2:
                taskToDelete = self->_highPriority[indexPath.row];
                [self->_highPriority removeObjectAtIndex:indexPath.row];
                break;
            case 1:
                taskToDelete = self->_mediumPriority[indexPath.row];
                [self->_mediumPriority removeObjectAtIndex:indexPath.row];
                break;
            case 0:
                taskToDelete = self->_lowPriority[indexPath.row];
                [self->_lowPriority removeObjectAtIndex:indexPath.row];
                break;
        }
    
        NSMutableArray *updatedTasks = [NSMutableArray new];
        [updatedTasks addObjectsFromArray:self->_highPriority];
        [updatedTasks addObjectsFromArray:self->_mediumPriority];
        [updatedTasks addObjectsFromArray:self->_lowPriority];
                
        NSError *error;
        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:updatedTasks requiringSecureCoding:YES error:&error];
        if (!error) {
            [self->_defult setObject:archiveData forKey:@"tasks"];
            [self->_defult synchronize];
        }
                
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    }];
    
    
    [alert addAction:cancel];
    [alert addAction:delete];
    [self presentViewController:alert animated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
