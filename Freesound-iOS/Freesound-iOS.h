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
# define SOUND_URL @"sounds/%i/" // %@ -> sound id
# define SOUND_ANALYSIS_URL @"sounds/%i/analysis/" // %@ -> sound id
# define SOUND_SIMILAR_SOUNDS_URL @"sounds/%i/similar/" // %@ -> sound id
# define SOUND_COMMENTS_URL @"sounds/%i/comments/" // %@ -> sound id
# define PACK_URL @"packs/%i/" // %@ -> pack id
# define PACK_SOUNDS_URL @"packs/%i/sounds/" // %@ -> pack id
# define USER_URL @"users/%@/" // %@ -> username
# define USER_SOUNDS_URL @"users/%@/sounds/" // %@ -> username
# define USER_PACKS_URL @"users/%@/packs/" // %@ -> username
# define USER_BOOKMARK_CATEGORIES_URL @"users/%@/bookmark_categories/" // %@ -> username
# define USER_BOOKMARK_CATEGORY_SOUNDS_URL @"users/%@/bookmark_categories/%i/sounds/" // %@ -> username, %@ -> bookmark_category_id

@interface FreesoundFetcher : NSObject

// Search urls
+ (NSURL *)URLforTextSearchWithParameters:(NSDictionary *)parameters;
+ (NSURL *)URLforContentSearchWithParameters:(NSDictionary *)parameters;
+ (NSURL *)URLforCombinedSearchWithParameters:(NSDictionary *)parameters;

// Sound urls
+ (NSURL *)URLforSoundWithId:(NSInteger)sound_id;
+ (NSURL *)URLforAnalysisOfSoundWithSoundId:(NSInteger)sound_id;
+ (NSURL *)URLforSimilarSoundsOfSoundWithId:(NSInteger)sound_id;
+ (NSURL *)URLforCommentsOfSoundWithId:(NSInteger)sound_id;

// Pack urls
+ (NSURL *)URLforPackWithId:(NSInteger)pack_id;
+ (NSURL *)URLforSoundsOfPackWithId:(NSInteger)pack_id;

// User urls
+ (NSURL *)URLforUserWithUsername:(NSString *)username;
+ (NSURL *)URLforSoundsOfUserWithUsername:(NSString *)username;
+ (NSURL *)URLforPacksOfUserWithUsername:(NSString *)username;
+ (NSURL *)URLforBookmarkCategoriesOfUserWithUsername:(NSString *)username;
+ (NSURL *)URLforSoundsOfBookmarkCategory:(NSInteger)bookmark_category_id ofUserWithUsername:(NSString *)username;

// Pagination utils
+ (NSURL *)URLforNextPage:(NSDictionary *)results;
+ (NSURL *)URLforPreviousPage:(NSDictionary *)results;
+ (NSURL *)URLforMoreresults:(NSDictionary *)results;

// Other/utils
+ (NSURL *)prepareURL:(NSString *) url;
+ (NSDictionary *)fetchURL:(NSURL *)url;
+ (void)fetchURL:(NSURL *)url withCompletionHandler:(void(^)(NSDictionary *results))handler;
+ (void)fetchURL:(NSURL *)url withCompletionHandler:(void(^)(NSDictionary *results))handler onQueue:(dispatch_queue_t)queue;


@end
