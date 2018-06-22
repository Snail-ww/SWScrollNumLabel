//
//  ViewController.m
//  SWScrollNumLabel
//
//  Created by Snail on 2018/5/17.
//  Copyright © 2018年 Snail. All rights reserved.
//

#import "ViewController.h"
#import "SWScrollNumLabel.h"

@interface ViewController ()
@property (nonatomic, strong) SWScrollNumLabel *label;
@property (nonatomic, strong) SWScrollNumLabel *label2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label = [[SWScrollNumLabel alloc] initWithFont:[UIFont systemFontOfSize:40] textColor:[UIColor redColor]];
    self.label.frame = CGRectMake(100, 50, 100, 30);
    [self .view addSubview:self.label];
    [self.label setNumText:@"0" animation:NO];
    
    
    self.label2 = [[SWScrollNumLabel alloc] init];
    self.label2.frame = CGRectMake(100, 100, 100, 5);
    [self.label2 setNumText:@"0" animation:NO];
    self.label2.font = [UIFont systemFontOfSize:20];
    self.label2.textColor = [UIColor cyanColor];
    [self .view addSubview:self.label2];
    

    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)addRandomNumber:(UIButton *)sender {
    [self.label addCount:arc4random()%100];
    [self.label2 addCount:arc4random()%1000];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
