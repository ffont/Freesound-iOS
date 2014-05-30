//
//  Freesound-iOS.m
//
//  Created by Frederic Font Corbera on 22/05/14.
//  Copyright (c) 2014 Frederic Font Corbera. All rights reserved.
//

#import "Freesound-iOS.h"

@implementation FreesoundFetcher


# pragma mark - Search resources

+ (NSURL *)URLforTextSearchWithParameters:(NSDictionary *)parameters
{
    //  "parameters" must be a dictionary with text search parameters as defined in Freesound API docummentation (www.freesound.org/docs/api/resources_apiv2.html#text-search)
    //  Both keys and values of the dictionary must be of the class NSString
    NSString *url = [NSString stringWithFormat:@"%@%@", TEXT_SEARCH_URL, [self serializeParameterDictionary:parameters]];
    return [self prepareURL:url];
}

+ (NSURL *)URLforContentSearchWithParameters:(NSDictionary *)parameters
{
    //  "parameters" must be a dictionary with content search parameters as defined in Freesound API docummentation (www.freesound.org/docs/api/resources_apiv2.html#content-search)
    //  Both keys and values of the dictionary must be of the class NSString
    NSString *url = [NSString stringWithFormat:@"%@%@", CONTENT_SEARCH_URL, [self serializeParameterDictionary:parameters]];
    return [self prepareURL:url];
}

+ (NSURL *)URLforCombinedSearchWithParameters:(NSDictionary *)parameters
{
    //  "parameters" must be a dictionary with combined search parameters as defined in Freesound API docummentation (www.freesound.org/docs/api/resources_apiv2.html#combined-search)
    //  Both keys and values of the dictionary must be of the class NSString
    NSString *url = [NSString stringWithFormat:@"%@%@", COMBINED_SEARCH_URL, [self serializeParameterDictionary:parameters]];
    return [self prepareURL:url];
}


# pragma mark - Sound resources

+ (NSURL *)URLforSoundWithId:(NSNumber *)sound_id
{
    NSString *url = [NSString stringWithFormat:SOUND_URL, sound_id];
    return [self prepareURL:url];
}

+ (NSURL *)URLforAnalysisOfSoundWithSoundId:(NSNumber *)sound_id
{
    NSString *url = [NSString stringWithFormat:SOUND_ANALYSIS_URL, sound_id];
    return [self prepareURL:url];
}

+ (NSURL *)URLforSimilarSoundsOfSoundWithId:(NSNumber *)sound_id
{
    NSString *url = [NSString stringWithFormat:SOUND_SIMILAR_SOUNDS_URL, sound_id];
    return [self prepareURL:url];
}

+ (NSURL *)URLforCommentsOfSoundWithId:(NSNumber *)sound_id
{
    NSString *url = [NSString stringWithFormat:SOUND_COMMENTS_URL, sound_id];
    return [self prepareURL:url];
}


# pragma mark - Pack resources

+ (NSURL *)URLforPackWithId:(NSNumber *)pack_id
{
    NSString *url = [NSString stringWithFormat:PACK_URL, pack_id];
    return [self prepareURL:url];
}

+ (NSURL *)URLforSoundsOfPackWithId:(NSNumber *)pack_id
{
    NSString *url = [NSString stringWithFormat:PACK_SOUNDS_URL, pack_id];
    return [self prepareURL:url];
}

# pragma mark - User resources

+ (NSURL *)URLforUserWithUsername:(NSString *)username
{
    NSString *url = [NSString stringWithFormat:USER_URL, username];
    return [self prepareURL:url];
}

+ (NSURL *)URLforSoundsOfUserWithUsername:(NSString *)username
{
    NSString *url = [NSString stringWithFormat:USER_SOUNDS_URL, username];
    return [self prepareURL:url];
}

+ (NSURL *)URLforPacksOfUserWithUsername:(NSString *)username
{
    NSString *url = [NSString stringWithFormat:USER_PACKS_URL, username];
    return [self prepareURL:url];
}

+ (NSURL *)URLforBookmarkCategoriesOfUserWithUsername:(NSString *)username
{
    NSString *url = [NSString stringWithFormat:USER_BOOKMARK_CATEGORIES_URL, username];
    return [self prepareURL:url];
}

+ (NSURL *)URLforSoundsOfBookmarkCategory:(NSInteger)bookmark_category_id ofUserWithUsername:(NSString *)username
{
    NSString *url = [NSString stringWithFormat:USER_BOOKMARK_CATEGORY_SOUNDS_URL, username, bookmark_category_id];
    return [self prepareURL:url];
}


# pragma mark - Pagination utils

+ (NSURL *)URLforNextPage:(NSDictionary *)results
{
    //  Takes the "next" field from "results" dictionary and returns it as a prepared NSURL
    //  Can be used in any paginated response (search results, sounds by user/pack, ...)
    return [self prepareURL:results[@"next"]];
    
}

+ (NSURL *)URLforPreviousPage:(NSDictionary *)results
{
    //  Takes the "previous" field from "results" dictionary and returns it as a prepared NSURL
    //  Can be used in any paginated response (search results, sounds by user/pack, ...)
    return [self prepareURL:results[@"previous"]];
}

+ (NSURL *)URLforMoreresults:(NSDictionary *)results
{
    //  Takes the "more" field from "results" dictionary and returns it as a prepared NSURL
    //  Only applies to combined search results (http://www.freesound.org/docs/api/resources_apiv2.html#combined-search)
    return [self prepareURL:results[@"more"]];
}


# pragma mark - Other/utils functions

+ (NSURL *)prepareURL:(NSString *) url
{
    //  Add base url, "token" parameter, "format" parameter and encodes "url"
    return [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@&token=%@&format=json", FREESOUND_BASE_URL, url, FreesoundAPIKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)serializeParameterDictionary:(NSDictionary *) parameters
{
    //  Serializes the keys and values of an NSDictionary by converting them into a string of url parameters (&key1=value1&key2=value2...)
    //  Keys and values are only added to the serialized string if they are NSStrings
    NSString *serialized_parameters = @"";
    for(id key in parameters){
        if ([key isKindOfClass:[NSString class]] && [[parameters objectForKey:key] isKindOfClass:[NSString class]]){
            serialized_parameters = [serialized_parameters stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, [parameters objectForKey:key]]];
        }
    }
    return serialized_parameters;
}

+ (NSDictionary *)fetchURL:(NSURL *)url
{
    //  Takes a NSURL, fetches the json result and returns it as an NSDictionary
    //  NOTE: this function performs the fetching in the main queue, thus it is going to block your UI. You probably don't want to use this funciton ;)
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    if (jsonResults){
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                options:0
                                                                  error:NULL];
        return results;
    }
    return nil;
}

+ (void)fetchURL:(NSURL *)url withCompletionHandler:(void(^)(NSDictionary *results))handler
{
    //  Takes a NSURL and fetches the json result
    //  Fetching is performed in a "freesound fetcher" queue, thus not blocking your main thread and UI
    //  On completion, the handler block passed as a parameter is executed in the main queue (dispatch_get_main_queue())
    dispatch_queue_t fetchQ = dispatch_queue_create("freesound fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        if (jsonResults){
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                    options:0
                                                                      error:NULL];
            dispatch_async(dispatch_get_main_queue(), ^{handler(result);});
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{handler(nil);});
        }
    });
}

+ (void)fetchURL:(NSURL *)url withCompletionHandler:(void(^)(NSDictionary *results))handler onQueue:(dispatch_queue_t)queue;
{
    //  Takes a NSURL and fetches the json result
    //  Fetching is performed in a "freesound fetcher" queue, thus not blocking your main thread and UI
    //  On completion, the handler block passed as a parameter is executed in the queue passed as parameter
    dispatch_queue_t fetchQ = dispatch_queue_create("freesound fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        if (jsonResults){
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                   options:0
                                                                     error:NULL];
            dispatch_async(queue, ^{handler(result);});
        } else {
            dispatch_async(queue, ^{handler(nil);});
        }
    });
}


@end