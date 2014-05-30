//
//  SearchResultsTVC.h
//  FreesoundSampleApp
//
//  Created by Frederic Font Corbera on 22/05/14.
//  Copyright (c) 2014 Frederic Font Corbera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsTVC : UITableViewController

@property (nonatomic, strong) NSArray *sounds;
@property (strong, nonatomic) NSURL *urlToRetrieve;

@end
