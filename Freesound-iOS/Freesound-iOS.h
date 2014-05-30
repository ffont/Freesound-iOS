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


@interface FreesoundFetcher : NSObject

// Search urls
+ (NSURL *)URLforTextSearchWithParameters:(NSDictionary *)parameters;
+ (NSURL *)URLforContentSearchWithParameters:(NSDictionary *)parameters;
+ (NSURL *)URLforCombinedSearchWithParameters:(NSDictionary *)parameters;

// Sound urls
+ (NSURL *)URLforSoundWithId:(NSInteger)sound_id;

// Pack urls
+ (NSURL *)URLforPackWithId:(NSInteger)pack_id;

// User urls
+ (NSURL *)URLforUserWithUsername:(NSString *)username;

// Other/utils
+ (NSDictionary *)fetchURL:(NSURL *)url;
+ (void)fetchURL:(NSURL *)url withCompletionHandler:(void(^)(NSDictionary *results))handler;
+ (void)fetchURL:(NSURL *)url withCompletionHandler:(void(^)(NSDictionary *results))handler onQueue:(dispatch_queue_t)queue;




@end
