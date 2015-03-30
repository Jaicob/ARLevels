//
//  SavedLevelsViewController.m
//  Brave New World
//
//  Created by Justin Lennox on 3/30/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import "SavedLevelsViewController.h"

@interface SavedLevelsViewController ()

@end

@implementation SavedLevelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, self.view.frame.size.height-40) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.savedLevelsArray = [[NSArray alloc] init];
    [self.view addSubview:self.tableView];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"savedLevels"])
    {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedLevels"];
        self.savedLevelsArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.savedLevelsArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if(self.savedLevelsArray.count > 0){
        NSMutableDictionary *savedDict = [[NSMutableDictionary alloc] init];
        savedDict = [self.savedLevelsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [savedDict objectForKey:@"levelTitle"];
       // cell.detailTextLabel.text = [self.messageTimesArray objectAtIndex:indexPath.row];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GameSceneViewController *gameSceneController = [[GameSceneViewController alloc] init];
    NSLog(@"Objectdict:%@", [self.savedLevelsArray objectAtIndex:indexPath.row]);
    gameSceneController.objectInfoDictionary = [self.savedLevelsArray objectAtIndex:indexPath.row];
    [self presentViewController:gameSceneController animated:NO completion:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
