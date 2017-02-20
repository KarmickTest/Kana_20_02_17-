//
//  TabBarController.m
//  Kana
//
//  Created by Karmick on 13/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()<UITabBarControllerDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [theTabBarController.viewControllers indexOfObject:viewController];
    NSLog(@"Tab index = %u ", (int)indexOfTab);
}

@end
