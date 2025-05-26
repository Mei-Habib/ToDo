//
//  ViewController.m
//  final
//
//  Created by Macos on 23/04/2025.
//

#import "ViewController.h"
#import "Task.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextView *dis;
@property NSUserDefaults *defult;
@property int statusNum;
@property int pirority;

@property (weak, nonatomic) IBOutlet UIDatePicker *myDate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegmant;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _defult=[NSUserDefaults standardUserDefaults];
    _statusNum=0;
    _myDate.minimumDate = [NSDate date];
//    _mySegmant.selectedSegmentTintColor = [UIColor blueColor];
    

    // Do any additional setup after loading the view.
}




- (IBAction)addTask:(id)sender {
    Task *t1 = [Task new];
    t1.name = _name.text;
    t1.dis = _dis.text;
    t1.priority = _pirority;
    t1.status = 0;
    t1.endDate=_myDate.date;
    if([t1.name isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid" message:@"You must to add Task title" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            nil;
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSData *savedData = [_defult objectForKey:@"tasks"];
        NSMutableArray *tasks;
        
        if (savedData != nil) {
            NSError *error;
            NSSet *classes = [NSSet setWithObjects:[NSArray class], [Task class], nil];
            tasks = [[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:savedData error:&error] mutableCopy];
            if (!tasks) tasks = [NSMutableArray new];
        } else {
            tasks = [NSMutableArray new];
        }
        
        // Add new task
        [tasks addObject:t1];
        
        // Save updated array
        NSError *error;
        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:tasks requiringSecureCoding:YES error:&error];
        [_defult setObject:archiveData forKey:@"tasks"];
        [_defult synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
        }
           
            
- (IBAction)addPriority:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
           case 0:
               _pirority=0;
               break;
           case 1:
            _pirority=1;
               break;
        case 2:
            _pirority=2;
            break;
       }
    
}

@end
