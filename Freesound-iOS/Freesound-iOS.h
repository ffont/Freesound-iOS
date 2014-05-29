//
//  Freesound-iOS.h
//
//  Created by Frederic Font Corbera on 22/05/14.
//  Copyright (c) 2014 Frederic Font Corbera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FreesoundAPIKey.h"

# define FREESOUND_BASE_URL @"http://www.freesound.org/apiv2/"
# define TEXT_SEARCH_URL @"search/text/"

# define PreferredFormat @"json"


@interface FreesoundFetcher : NSObject

+ (NSURL *)URLforTextSearchWithSearchParameters:(NSDictionary *)parameters;

@end
