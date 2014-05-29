//
//  FreesoundSampleAppViewController.m
//  FreesoundSampleApp
//
//  Created by Frederic Font Corbera on 29/05/14.
//  Copyright (c) 2014 Frederic Font Corbera. All rights reserved.
//

#import "FreesoundSampleAppViewController.h"
#import "SearchResultsTVC.h"

@interface FreesoundSampleAppViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputBox;
@end

@implementation FreesoundSampleAppViewController


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"SearchSounds"]) {
        if ([self.inputBox.text length] == 0) {
            // Cancel segue if input box terms is empty
            return NO;
        }
    }
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchSounds"]) {
        if ([segue.destinationViewController isKindOfClass:[SearchResultsTVC class]]) {
            SearchResultsTVC *tsvc = (SearchResultsTVC *)segue.destinationViewController;
            NSString *query = [NSString stringWithFormat:@"%@", self.inputBox.text];
            tsvc.queryTerms = query;
        }
    }
}


@end
