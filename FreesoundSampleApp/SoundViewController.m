//
//  SoundViewController.m
//  FreesoundSampleApp
//
//  Created by Frederic Font Corbera on 22/05/14.
//  Copyright (c) 2014 Frederic Font Corbera. All rights reserved.
//

#import "SoundViewController.h"
#import "SearchResultsTVC.h"
#import "Freesound-iOS.h"
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVPlayerItem.h>

@interface SoundViewController ()
@property (strong, nonatomic) AVPlayer *player;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextView *soundDescription;
@end


@implementation SoundViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator setHidden:NO];
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:NO];
    [self.timeLabel setText:@"00:00.000"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString *soundDescriptionString = [self.sound_info valueForKeyPath:@"description"];
    NSAttributedString *soundDescriptionAttributedString = [[NSAttributedString alloc] initWithData:[soundDescriptionString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                      documentAttributes:nil error:nil];
    self.soundDescription.attributedText = soundDescriptionAttributedString;
    NSString *url = [self.sound_info valueForKeyPath:@"previews.preview-hq-mp3"];
    dispatch_queue_t fetchQ = dispatch_queue_create("sound data", NULL);
    dispatch_async(fetchQ, ^{
        NSLog(@"Loading: %@", url);
        // Create AVPlayer and set up notifications
        AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
        self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        //[self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
        [self.player.currentItem addObserver:self forKeyPath:@"status" options:0 context:nil];
        
        
        // Load waveform
        [self loadImage];
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tabBarController setTitle:[self.sound_info objectForKey:@"name"]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self StopSound];
}

-(void)dealloc{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (object == self.player.currentItem && [keyPath isEqualToString:@"status"]) {
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.playButton setEnabled:YES];
            Float64 duration  =  CMTimeGetSeconds(self.player.currentItem.duration);
            [self.timeLabel setText:[NSString stringWithFormat:@"-%@",[self secondsToFormattedTimeString:duration]]];
        } else if (self.player.currentItem.status == AVPlayerStatusFailed) {
            NSLog(@"An error occurred while loading audio file into AVPlayer.");
        }
    }
}


#pragma mark - Play audio stuff

- (IBAction)PlaySound {
    if (self.player.status == AVPlayerStatusReadyToPlay && self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        if ([self.player rate] != 0.0){
            [self.player pause];
        }
        // Set playhead at beggining
        CMTime targetTime = CMTimeMakeWithSeconds(0.0f, NSEC_PER_SEC);
        [self.player seekToTime:targetTime];
        Float64 duration  = CMTimeGetSeconds(self.player.currentItem.duration);
        [self.timeLabel setText:[NSString stringWithFormat:@"-%@",[self secondsToFormattedTimeString:duration]]];
        [self PlaySoundHelper];
    } else {
        NSLog(@"AVPlayer not ready, could not play.");
    }
}

- (void)PlaySoundHelper {
    [self.player play];
    [self.playButton setEnabled:NO];
    [self.stopButton setEnabled:YES];
    CMTime duration = self.player.currentItem.duration;
    CMTime timeInterval = CMTimeMakeWithSeconds(0.07f, NSEC_PER_SEC);
    __weak UILabel *weakTimeLabel = self.timeLabel; // To prevent a retain cycle
    __weak id weakSelf = self; // To prevent a retain cycle
    [self.player addPeriodicTimeObserverForInterval:timeInterval queue:dispatch_get_main_queue() usingBlock:
     ^(CMTime time){
         Float64 dTotalSecondsFlt  = CMTimeGetSeconds(duration) - CMTimeGetSeconds(time);
         [weakTimeLabel setText:[NSString stringWithFormat:@"-%@",[weakSelf secondsToFormattedTimeString:dTotalSecondsFlt]]];
    }];
}

- (IBAction)StopSound {
    [self.player pause];
    // Set playhead at beggining
    CMTime targetTime = CMTimeMakeWithSeconds(0.0f, NSEC_PER_SEC);
    [self.player seekToTime:targetTime];
    Float64 duration  = CMTimeGetSeconds(self.player.currentItem.duration);
    [self.timeLabel setText:[NSString stringWithFormat:@"-%@",[self secondsToFormattedTimeString:duration]]];
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:YES];
}

-(void)audioDidFinishPlaying:(NSNotification *) notification {
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:YES];
    Float64 duration  = CMTimeGetSeconds(self.player.currentItem.duration);
    [self.timeLabel setText:[NSString stringWithFormat:@"-%@",[self secondsToFormattedTimeString:duration]]];
}


# pragma mark - Image stuff

-(void)loadImage
{
    NSURL *imgURL=[NSURL URLWithString:[self.sound_info valueForKeyPath:@"images.waveform_l"]];
    NSData *imgData=[NSData dataWithContentsOfURL:imgURL];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image.image = [UIImage imageWithData:imgData];
        if (imgData){
            [self.activityIndicator setHidden:YES];
        }
    });
}


# pragma mark - Utils

-(NSString *)secondsToFormattedTimeString:(Float64) timeInSeconds {
    NSUInteger dMinutes = floor((int)floor(timeInSeconds) % 3600 / 60);
    NSUInteger dSeconds = floor((int)floor(timeInSeconds) % 3600 % 60);
    NSUInteger dMilliSeconds = 1000 * (timeInSeconds - floor(timeInSeconds));
    return [NSString stringWithFormat:@"%02i:%02i.%.03i", dMinutes, dSeconds, dMilliSeconds];
}


# pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchSimilarSounds"]) {
        if ([segue.destinationViewController isKindOfClass:[SearchResultsTVC class]]) {
            SearchResultsTVC *tsvc = (SearchResultsTVC *)segue.destinationViewController;
            NSURL *url = [FreesoundFetcher URLforSimilarSoundsOfSoundWithId:[self.sound_info objectForKey:@"id"]];
            tsvc.urlToRetrieve = url;
        }
    }
}


@end








