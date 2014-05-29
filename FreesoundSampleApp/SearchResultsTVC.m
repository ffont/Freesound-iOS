//
//  FreesoundSoundsTVC.m
//  FreesoundFetchTest
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
    NSLog(@"%@", [NSString stringWithFormat:@"Query: %@", [self queryTerms]]);
    [self fetchSounds];
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

- (void)fetchSounds
{
    [self.refreshControl beginRefreshing];
    NSDictionary *search_parameters = @{
        @"query" : self.queryTerms,
        @"fields": @"name,username,description,previews,images",
        @"group_by_pack": @"1",
        @"sort": @"created_desc",
        @"page_size": @"50",
    };
    
    NSURL *url = [FreesoundFetcher URLforTextSearchWithSearchParameters:search_parameters];
    NSLog(@"Fetching freesound url: %@", [url absoluteString]);
    dispatch_queue_t fetchQ = dispatch_queue_create("freesound fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        if (jsonResults){
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                    options:0
                                                                      error:NULL];
            NSArray *sounds = results[@"results"];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Got results!");
                [self.refreshControl endRefreshing];
                self.sounds = sounds;
            });
        } else {
            NSLog(@"No data could be fetched form Freesound");
        }
    });
}


@end
