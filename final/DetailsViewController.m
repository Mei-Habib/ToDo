//
//  DetailsViewController.m
//  final
//
//  Created by Macos on 23/04/2025.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextView *dis;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *status;
@property NSUserDefaults *defultProgress;
@property NSUserDefaults *defultDone;
@property NSUserDefaults *defult;
@property (weak, nonatomic) IBOutlet UISegmentedControl *firstSeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *secSyeg;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [_status setEnabled:NO forSegmentAtIndex:0]; 
//    _firstSeg.selectedSegmentTintColor = [UIColor blueColor];
//    _secSyeg.selectedSegmentTintColor = [UIColor blueColor];
    _myDate.minimumDate= [NSDate date];


    _defultProgress=[NSUserDefaults standardUserDefaults];
    _defultDone=[NSUserDefaults standardUserDefaults];
    _defult=[NSUserDefaults standardUserDefaults];
    _name.text=_task.name;
    _dis.text=_task.dis;
    _myDate.date=_task.endDate;
    _priority.selectedSegmentIndex=_task.priority;
    _status.selectedSegmentIndex=_task.status;
    NSLog(@"%@",_task.name);
    printf("%d",_task.status);
    // Do any additional setup after loading the view.
    
    if(_fromDone){
        _secSyeg.enabled = NO;
        _firstSeg.enabled = NO;
        _name.enabled = NO;
        _myDate.enabled = NO;
    }
}

- (IBAction)edit:(id)sender {

        NSInteger oldStatus = _task.status;
        NSInteger newStatus = _status.selectedSegmentIndex;

        Task *newTask = [Task new];
        newTask.name = _name.text;
        newTask.dis = _dis.text;
        newTask.endDate = _myDate.date;
        newTask.priority = _priority.selectedSegmentIndex;
        newTask.status = newStatus;

        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

     
        NSString *oldKey = (oldStatus == 0) ? @"tasks" : (oldStatus == 1) ? @"ProgressTasks" : @"DoneTasks";
        NSData *oldData = [defaults objectForKey:oldKey];
        NSMutableArray *oldTasks;

        if (oldData != nil) {
            NSError *error;
            NSSet *classes = [NSSet setWithObjects:[NSArray class], [Task class], nil];
            oldTasks = [[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:oldData error:&error] mutableCopy];
        }
        if (!oldTasks) oldTasks = [NSMutableArray new];

        for (Task *t in oldTasks) {
            if ([t.name isEqualToString:_task.name]) {
                [oldTasks removeObject:t];
                break;
            }
        }

        NSError *error;
        NSData *updatedOldData = [NSKeyedArchiver archivedDataWithRootObject:oldTasks requiringSecureCoding:YES error:&error];
        [defaults setObject:updatedOldData forKey:oldKey];

    NSString *newKey = (newStatus == 0) ? @"tasks" : (newStatus == 1) ? @"ProgressTasks" : @"DoneTasks";
        NSData *newData = [defaults objectForKey:newKey];
        NSMutableArray *newTasks;

        if (newData != nil) {
            NSSet *classes = [NSSet setWithObjects:[NSArray class], [Task class], nil];
            newTasks = [[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:newData error:&error] mutableCopy];
        }
        if (!newTasks) newTasks = [NSMutableArray new];

        [newTasks addObject:newTask];

        NSData *updatedNewData = [NSKeyedArchiver archivedDataWithRootObject:newTasks requiringSecureCoding:YES error:&error];
        [defaults setObject:updatedNewData forKey:newKey];

        [defaults synchronize];

   
    [self.navigationController popViewControllerAnimated:YES];

   
}




@end
