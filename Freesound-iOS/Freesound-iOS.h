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
# define CONTENT_SEARCH_URL @"search/content/"
# define COMBINED_SEARCH_URL @"search/combined/"
# define USER_URL @"users/%@/" // %@ -> username
# define SOUND_URL @"sounds/%@/" // %@ -> sound id
# define PACK_URL @"packs/%@/" // %@ -> pack id

# define PreferredFormat @"json"


@interface FreesoundFetcher : NSObject

+ (NSURL *)URLforTextSearchWithParameters:(NSDictionary *)parameters;
+ (NSURL *)URLforContentSearchWithParameters:(NSDictionary *)parameters;
+ (NSURL *)URLforCombinedSearchWithParameters:(NSDictionary *)parameters;

+ (NSURL *)URLforSoundWithId:(NSInteger)sound_id;

+ (NSURL *)URLforPackWithId:(NSInteger)pack_id;

+ (NSURL *)URLforUserWithUsername:(NSString *)username;

@end
