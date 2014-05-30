//
//  SoundAnalysisViewController.m
//  FreesoundSampleApp
//
//  Created by Frederic Font Corbera on 30/05/14.
//  Copyright (c) 2014 Frederic Font Corbera. All rights reserved.
//

#import "SoundAnalysisViewController.h"
#import "Freesound-iOS.h"

@interface SoundAnalysisViewController ()
@property (weak, nonatomic) NSDictionary *sound_analysis_info;
@property (weak, nonatomic) IBOutlet UITextView *analysis_text;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation SoundAnalysisViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.analysis_text.text = @"";
    [self.activityIndicator setHidden:NO];

    NSURL *url = [FreesoundFetcher URLforAnalysisOfSoundWithSoundId:self.sound_id];
    [FreesoundFetcher fetchURL:url withCompletionHandler:^(NSDictionary *results){
        if (results){
            self.sound_analysis_info = results;
            [self.activityIndicator setHidden:YES];
            [self displaySoundAnalysisInfo];
        }
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tabBarController setTitle:[NSString stringWithFormat:@"Analysis for sound %@", self.sound_id]];
}

# pragma mark - Display user info helper

- (void)displaySoundAnalysisInfo
{
    self.analysis_text.text = [self.sound_analysis_info description];
}


@end
