//
//  FirstViewController.h
//  sciener
//
//  Created by wan on 13-1-21.
//  Copyright (c) 2013年 wan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tab0ViewController : UIViewController<UIAlertViewDelegate,UITableViewDelegate>
{

    
    
}

@property(nonatomic,retain) IBOutlet UITableView* customTableView;

-(void)rightAction:(id)sender;

-(void)getData;

-(IBAction)gotoSciener:(id)sender;

@end
