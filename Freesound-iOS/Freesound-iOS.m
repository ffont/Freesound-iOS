//
//  Freesound-iOS.m
//
//  Created by Frederic Font Corbera on 22/05/14.
//  Copyright (c) 2014 Frederic Font Corbera. All rights reserved.
//

#import "Freesound-iOS.h"

@implementation FreesoundFetcher


# pragma mark - Add key and encode helper

+ (NSURL *)addBaseUrlAndApiKeyAndEncodeURL:(NSString *) url
{
    return [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@&token=%@", FREESOUND_BASE_URL, url, FreesoundAPIKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}


# pragma mark - Text Search

+ (NSURL *)URLforTextSearchWithQuery:(NSString *)query
{
    NSString *url = [NSString stringWithFormat:@"%@?query=%@&format=json&fields=name,username,description,previews,images&group_by_pack=1&sort=created_desc&page_size=50", TEXT_SEARCH_URL, query];
    return [self addBaseUrlAndApiKeyAndEncodeURL:url];
}


@end