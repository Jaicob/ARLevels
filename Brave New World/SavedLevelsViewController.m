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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width / 1.5, self.view.frame.size.height/1.5) style:UITableViewStylePlain];
    self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, CGRectGetMaxY(self.tableView.frame), self.tableView.frame.size.width/2, 50)];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneButton setBackgroundColor:[UIColor blueColor]];
    [self.doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.doneButton];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.savedLevelsArray = [[NSArray alloc] init];
    
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
    if(!self.matchmaking){
        GameSceneViewController *gameSceneController = [[GameSceneViewController alloc] init];
        NSLog(@"Objectdict:%@", [self.savedLevelsArray objectAtIndex:indexPath.row]);
        gameSceneController.objectInfoDictionary = [self.savedLevelsArray objectAtIndex:indexPath.row];
        [self presentViewController:gameSceneController animated:NO completion:nil];
    }else{
//        ViewController *viewController = [[ViewController alloc] init];
//        viewController.multiplayerObjectDictionary = [self.savedLevelsArray objectAtIndex:indexPath.row];
//        [viewController startGame];
        GameSceneViewController *gameSceneController = [[GameSceneViewController alloc] initWithNibName:nil bundle:nil];
        gameSceneController.objectInfoDictionary = [self.savedLevelsArray objectAtIndex:indexPath.row];
        [self presentViewController:gameSceneController animated:NO completion:nil];

    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



-(void)done{
    [self dismissViewControllerAnimated:NO completion:nil];
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
