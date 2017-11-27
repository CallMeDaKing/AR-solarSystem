//
//  ViewController.m
//  AR-SolarSystem
//
//  Created by 龙行天下 on 2017/8/8.
//  Copyright © 2017年 龙行天下. All rights reserved.
//

#import "ViewController.h"
#import "SCNviewControllerViewController.h"

@interface ViewController ()

@end

    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)sender:(id)sender {
    
    SCNviewControllerViewController *vc = [[SCNviewControllerViewController alloc]init];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


@end
