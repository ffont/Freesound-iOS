//
//  SearchResultsTVC.m
//  FreesoundSampleApp
//
//  Created by Frederic Font Corbera on 22/05/14.
//  Copyright (c) 2014 Frederic Font Corbera. All rights reserved.
//

#import "SearchResultsTVC.h"
#import "Freesound-iOS.h"
#import "SoundViewController.h"
#import "UserViewController.h"
#import "SoundAnalysisViewController.h"

@implementation SearchResultsTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    self.navigationItem.titleView = activityIndicator;
    [self retrieveSounds];
}


- (void)setSounds:(NSArray *)sounds
{
    _sounds = sounds;
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sounds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundCell" forIndexPath:indexPath];
    
    NSDictionary *sound = self.sounds[indexPath.row];
    cell.textLabel.text = sound[@"name"];
    cell.detailTextLabel.text = sound[@"username"];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareSoundViewController:(SoundViewController *)svc toDisplaySound:(NSDictionary *)sound
{
    svc.sound_info = sound;
}

- (void)prepareUserViewController:(UserViewController *)uvc toDisplayUserWithUsername:(NSString *)username
{
    //  Here we do not pass user information because we only have the username
    //  Rest of information will be fetched when the view is accessed
    uvc.username = username;
}

- (void)prepareSoundAnalysisViewController:(SoundAnalysisViewController *)savc toDisplaySoundWithId:(NSNumber *)sound_id
{
    //  Here we do not pass full sound information because we only need the id to retrieve analysis
    savc.sound_id = sound_id;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"DisplaySound"]) {
                if ([segue.destinationViewController isKindOfClass:[UITabBarController class]]) {
                    UITabBarController* tbc = [segue destinationViewController];
                    [self prepareSoundViewController:[[tbc customizableViewControllers] objectAtIndex:0]
                                      toDisplaySound:self.sounds[indexPath.row]];
                    [self prepareUserViewController:[[tbc customizableViewControllers] objectAtIndex:1]
                          toDisplayUserWithUsername:[self.sounds[indexPath.row] objectForKey:@"username"]];
                    [self prepareSoundAnalysisViewController:[[tbc customizableViewControllers] objectAtIndex:2]
                                        toDisplaySoundWithId:[self.sounds[indexPath.row] objectForKey:@"id"]];
                }
            }
        }
    }
}


# pragma mark - Fetch sounds

- (void)retrieveSounds
{
    NSLog(@"Fetching freesound url: %@", [self.urlToRetrieve absoluteString]);
    [FreesoundFetcher fetchURL:self.urlToRetrieve withCompletionHandler:^(NSDictionary *results){
        self.navigationItem.titleView = nil;
        self.sounds = results[@"results"];
    }];
}


@end
