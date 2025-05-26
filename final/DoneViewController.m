//
//  DoneViewController.m
//  final
//
//  Created by Macos on 23/04/2025.
//

#import "DoneViewController.h"
#import "ViewController.h"
#import "CustomDoneTableViewCell.h"
#import "DetailsViewController.h"


@interface DoneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property NSMutableArray<Task*> *arr;
//@property NSUserDefaults *defult;
@property NSUserDefaults *defultDone;
@property Task *ref;
@property int proirity ;
@property int sectionsNum;
@property BOOL isSorted;


@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *sort = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(toggleSort)];
    self.navigationItem.rightBarButtonItem = sort;
        self.navigationItem.title= @"Done";
    // Do any additional setup after loading the view.
    _myTable.delegate=self;
    _myTable.dataSource=self;
    _defultDone=[NSUserDefaults standardUserDefaults];
    NSData *savedData = [_defultDone objectForKey:@"DoneTasks"];
    if (savedData != nil) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [Task class], nil];
        _arr = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:savedData error:&error];
    }
    _isSorted=NO;
    [_myTable reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _sectionsNum=3;
    _highPriority = [NSMutableArray new];
    _mediumPriority = [NSMutableArray new];
    _lowPriority = [NSMutableArray new];
    
    _defultDone = [NSUserDefaults standardUserDefaults];
    NSData *savedData = [_defultDone objectForKey:@"DoneTasks"];
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!_isSorted) return nil;
    return section == 2 ? @"High Priority" : section == 1 ? @"Medium Priority" : @"Low Priority";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return _isSorted? 3:1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSorted) {
        switch (section) {
            case 0: return _lowPriority.count;
            case 1: return _mediumPriority.count;
            case 2: return _highPriority.count;
        }
    }
    return _arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomDoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doneCell"];
    if (_isSorted) {
        switch (indexPath.section) {
            case 0:
                _ref = _lowPriority[indexPath.row];
                cell.image.image = [UIImage imageNamed:@"0"];
                break;
            case 1:
                _ref = _mediumPriority[indexPath.row];
                cell.image.image = [UIImage imageNamed:@"1"];
                break;
            case 2:
                _ref = _highPriority[indexPath.row];
                cell.image.image = [UIImage imageNamed:@"2"];
                break;
        }
    } else {
        _ref = _arr[indexPath.row];
        NSString *imageName = [NSString stringWithFormat:@"%d", _ref.priority];
        cell.image.image = [UIImage imageNamed:imageName];
    }

    cell.myLable.text = _ref.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showAlert:indexPath tableView:tableView];
    
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Task *selectedTask;

    if (_isSorted) {
        switch (indexPath.section) {
            case 0:
                selectedTask = _lowPriority[indexPath.row];
                break;
            case 1:
                selectedTask = _mediumPriority[indexPath.row];
                break;
            case 2:
                selectedTask = _highPriority[indexPath.row];
                break;
            default:
                return;
        }
    } else {
        selectedTask = _arr[indexPath.row];
    }

    DetailsViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    SVC.task = selectedTask;
    SVC.fromDone = YES;
    [self.navigationController pushViewController:SVC animated:YES];
}

- (void)toggleSort {
    _isSorted = !_isSorted;

    if (_isSorted) {
    
        _highPriority = [NSMutableArray new];
        _mediumPriority = [NSMutableArray new];
        _lowPriority = [NSMutableArray new];

        for (Task *task in _arr) {
            if (task.priority == 2) {
                [_highPriority addObject:task];
            } else if (task.priority == 1) {
                [_mediumPriority addObject:task];
            } else {
                [_lowPriority addObject:task];
            }
        }

      self.navigationItem.rightBarButtonItem.title = @"Unsort";
    } else {

        self.navigationItem.rightBarButtonItem.title = @"Sort";
    }

    [_myTable reloadData];
}

- (void)showAlert:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task" message:@"Are you sure you want to delete it?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        Task *taskToDelete;

        if (self->_isSorted) {
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
        } else {
            taskToDelete = self->_arr[indexPath.row];
            [self->_arr removeObjectAtIndex:indexPath.row];
        }

   
        NSMutableArray *updatedTasks = [NSMutableArray new];

        if (self->_isSorted) {
            [updatedTasks addObjectsFromArray:self->_highPriority];
            [updatedTasks addObjectsFromArray:self->_mediumPriority];
            [updatedTasks addObjectsFromArray:self->_lowPriority];
        } else {
            [updatedTasks addObjectsFromArray:self->_arr];
        }

        NSError *error;
        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:updatedTasks requiringSecureCoding:YES error:&error];
        if (!error) {
            [self->_defultDone setObject:archiveData forKey:@"DoneTasks"];
            [self->_defultDone synchronize];
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
