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
    svc.title = [sound valueForKeyPath:@"name"];
    svc.sound_info = sound;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"DisplaySound"]) {
                if ([segue.destinationViewController isKindOfClass:[SoundViewController class]]) {
                    [self prepareSoundViewController:segue.destinationViewController
                                      toDisplaySound:self.sounds[indexPath.row]];
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
