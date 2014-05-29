//
//  Freesound-iOS.m
//
//  Created by Frederic Font Corbera on 22/05/14.
//  Copyright (c) 2014 Frederic Font Corbera. All rights reserved.
//

#import "Freesound-iOS.h"

@implementation FreesoundFetcher

+ (NSURL *)URLforTextSearchWithQuery:(NSString *)query
{
    NSString *url = [NSString stringWithFormat:@"%@search/text/?query=%@&token=%@&format=json&fields=name,username,description,previews,images&group_by_pack=1&sort=created_desc&page_size=50", FREESOUND_BASE_URL, query, FreesoundAPIKey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:url];
}

@end
