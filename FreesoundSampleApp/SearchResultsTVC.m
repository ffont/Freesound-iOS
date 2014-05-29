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

// prepares the given ImageViewController to show the given photo
// used either when segueing to an ImageViewController
//   or when our UISplitViewController's Detail view controller is an ImageViewController

- (void)prepareSoundViewController:(SoundViewController *)svc toDisplaySound:(NSDictionary *)sound
{
    svc.title = [sound valueForKeyPath:@"name"];
    svc.sound_info = sound;
}

// In a story board-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        // find out which row in which section we're seguing from
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            // found it ... are we doing the Display Photo segue?
            if ([segue.identifier isEqualToString:@"DisplaySound"]) {
                // yes ... is the destination an ImageViewController?
                if ([segue.destinationViewController isKindOfClass:[SoundViewController class]]) {
                    // yes ... then we know how to prepare for that segue!
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
    NSURL *url = [FreesoundFetcher URLforTextSearchWithQuery:[self queryTerms]];
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
