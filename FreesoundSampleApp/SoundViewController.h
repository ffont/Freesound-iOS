//
//  SoundViewController.h
//  FreesoundFetchTest
//
//  Created by Frederic Font Corbera on 22/05/14.
//  Copyright (c) 2014 Frederic Font Corbera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) NSDictionary *sound_info;

@end
