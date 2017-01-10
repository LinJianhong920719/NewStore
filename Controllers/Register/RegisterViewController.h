//
//  RegisterViewController.h
//  NewStore
//
//  Created by edz on 17/1/10.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

- (IBAction)loginBtn:(id)sender;

@end
